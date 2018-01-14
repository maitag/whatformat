package;

import formats.Magic;
/**
 * ...
 * by Sylvio Sell - Rostock 2018
 * 
 * detect fileformat by magic number
 */

class WhatFormat
{
	public var maxHeaderLength(default, null):Int;
	public var proceed(default, null):Bool; // false ->  no more checks available
	public var found(default, null):Bool;   // true  ->  filetype recognized
	public var format(default, null):String;
	public var description(default, null):String;
	
	var numbers:Array< Array<Null<Int>> >;
	var formats:Array<String>;
	var descriptions:Array<String>;
	
	public function new(?checkOnly:Array<String> = null)
	{
		if (checkOnly == null) checkOnly = [for (m in Magic.Numbers) m[1]]; // ^~ `All`? ;)

		// sort from readable Magic.Numbers into own array
		numbers = new Array();
		formats = new Array();
		descriptions = new Array();
		
		maxHeaderLength = 0;
		for ( m in Magic.Numbers)
		{
			if (checkOnly.indexOf(m[1]) > -1) // for all formats that should be detected
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
		proceed = true;
		found = false;
		foundAtPos = null;
		format = null;
		description = null;
		position = 0;
		matchedIndices = [for(i in 0...numbers.length) i]; // All
	}

	public inline function checkNextByte(byte:Int):Void
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
				proceed = false;
				if (foundAtPos != null) {
					found = true;
					format      = formats[foundAtPos];
					description = descriptions[foundAtPos];
				}
			}
			else {
				matchedIndices = indices;
				position++;
			}
		}
	}	
}