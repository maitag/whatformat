package;

import formats.Magic;
import haxe.io.Bytes;
/**
 * ...
 * by Sylvio Sell - Rostock 2018
 * 
 * detect fileformat by magic number
 */

@:publicFields
class Result {
	var found:Bool = false;
	var format:String;
	var description:String;
	var subtype:String;
	var subtypeDescription:String;
	var reset:Void->Void;
	function new(reset) {this.reset = reset;}
}

class WhatFormat
{
	public var maxHeaderLength(default, null):Int;
	public var proceed(default, null):Bool; // false ->  no more checks available
	public var checkOnly:Array<String>; // check only this formats/endings
	
	public var found(get, null):Bool = false;
	inline function get_found():Bool return byHeader.found || byName.found;
	
	public var format(get, null):String;
	inline function get_format():String return select(byHeader.format, byName.format);
	
	public var description(get, null):String;
	inline function get_description():String return select(byHeader.description, byName.description);
	
	public var subtype(get, null):String;
	inline function get_subtype():String return select(byHeader.subtype, byName.subtype);
	
	public var subtypeDescription(get, null):String;
	inline function get_subtypeDescription():String return select(byHeader.subtypeDescription, byName.subtypeDescription);
	
	var preferHeader:Bool;
	function select(h:String, n:String):String {
		return (preferHeader && h != null) ? h : ((n != null) ? n:h);
	}
	
	// Results
	public var byHeader(default, null):Result;
	public var byName(default, null):Result;
	
	var numbers:Array< Array<Null<Int>> >;
	var formats:Array<String>;
	var descriptions:Array<String>;
	
	public function new(?checkOnly:Array<String> = null, ?preferHeader=true)
	{
		this.preferHeader = preferHeader;
		this.checkOnly = checkOnly;
		if (this.checkOnly == null) this.checkOnly = [for (m in Magic.Numbers) m[1]];
		else this.checkOnly = [for (m in this.checkOnly) Magic.resolveFromAlias(m)];

		// sort from readable Magic.Numbers into own array
		numbers = new Array();
		formats = new Array();
		descriptions = new Array();
		
		maxHeaderLength = 0;
		for ( m in Magic.Numbers)
		{
			if (this.checkOnly.indexOf(m[1]) > -1) // for all formats that should be detected
			{
				// sort hex-strings
				var n:Array<Null<Int>> = [ for (hexstr in m[0].split(' ')) Std.parseInt('0x' + hexstr) ];
				maxHeaderLength = Std.int(Math.max(n.length, maxHeaderLength));
				numbers.push(n);
				formats.push(m[1]);
				descriptions.push(m[2]);
			}
		}
		
		reset();
	}

	// --------------------------------------------------------------------------
	
	var position:Int; // check byte at position
	var foundAtPos:Null<Int>;
	var matchedIndices:Array<Int>; // holds possible indices for checkNextByte

	public inline function reset():Void
	{
		byHeaderReset();
		byNameReset();
	}
	
	function byHeaderReset():Void
	{
		byHeader = new Result(byHeaderReset);
		proceed = true;
		foundAtPos = null;
		position = 0;
		matchedIndices = [for(i in 0...numbers.length) i]; // All
	}

	function byNameReset():Void
	{
		byName = new Result(byNameReset);
	}

	public inline function checkNextByte(byte:Int):Bool
	{
		if (proceed) {
			
			var indices = new Array<Int>();
			
			for (i in matchedIndices) {
				if (numbers[i].length > position) {
					if (byte == numbers[i][position] || numbers[i][position] == null) {
						if (numbers[i].length-1 == position) foundAtPos = i;
						else indices.push(i);
					}
				}
			}
			
			if (indices.length == 0) {
				
				// TODO: parse subtype
				
				proceed = false;
				if (foundAtPos != null) {
					byHeader.found = true;
					byHeader.format      = formats[foundAtPos];
					byHeader.description = descriptions[foundAtPos];
				}
			}
			else {
				matchedIndices = indices;
				position++;
			}
		}
		return proceed;
	}
	
	public function checkHeaderBytes(bytes:Bytes):Result
	{
		if (position!=0) byHeaderReset();
		var pos:Int = 0;
		while (pos < bytes.length && checkNextByte(bytes.get(pos)))
			pos++;
		return byHeader;
	}

	static var ending:EReg = ~/\.([A-Z0-9]+)$/i;
	
	public function checkFilenameEnding(filename:String):Result
	{
		byNameReset();
		if (ending.match(filename))
		{
			var matched:String = ending.matched(1);
			var s:String = Magic.resolveFromAlias(matched);
			var f:String = Magic.resolveFromSubtype(s);
			if (checkOnly.indexOf(f) > -1 || checkOnly.indexOf(s) > -1)
			{
				byName.description = Magic.getDescription(f);
				if (byName.description != null) {
					byName.format = f;
					if (s != f) {
						byName.subtype = s;
						byName.subtypeDescription = Magic.getSubtypeDescription(s);
					}
					byName.found = true;
				}
			}
		}
		return byName;
	}
	
	public function aliases(format:String):Array<String>
	{
		return Magic.Aliases.get(format);
	}

}