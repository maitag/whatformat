# WhatFormat
pure [haxe](https://haxe.org)-library to detect fileformat by [Magick Numbers](https://en.wikipedia.org/wiki/Magic_number_(programming)).  


## Installation
<!---
```
haxelib install whatformat
```

or use the latest developement version from github:--->
```
haxelib git whatformat https://github.com/maitag/whatformat.git
```



## Documentation

Start with an instance of WhatFormat:

```
var wtf = new WhatFormat();

// or define what formats to check only:
// var wtf = new WhatFormat(['png', 'jpg', 'gif']); 
```




To check the Bytes of a loaded File:

```
var bytes:Bytes = File.getBytes(filename);
if ( wtf.checkHeaderBytes(bytes).found ) trace('format: ${wtf.format} - ${wtf.description}');

```




For streams or special purpose you can check format __while loading__,  
to easy __stop__ loading if no fileformat can be detected by header:

```
var file:FileInput = File.read(filename);
var wtf:WhatFormat = new WhatFormat();
try {
	do {
		var byte:Int = file.readByte();
		// ... store it into Bytes or do whatever with
		
		wtf.checkNextByte(byte); // check next Byte in header (if formatcheck is in proceed)
	}
	while ( wtf.proceed || wtf.found); // stop reading if no format found
}
catch( ex:haxe.io.Eof ) {}

if (wtf.found) trace( 'format: ${wtf.format} - ${wtf.description}');
else trace("can't detect fileformat");

file.close();
```




You can also check the ending of a filename:

```
if (wtf.checkFilenameEnding(filename).found) {
	trace('format detected by filename ending:\n');
	trace('format: ${wtf.format} - ${wtf.description}');
	trace('subtype: ${wtf.format} - ${wtf.subtypeDescription}');
}
```



or combine both methods:

```
var wtf:WhatFormat = new WhatFormat();

// detect by filename
if (wtf.checkFilenameEnding(filename).byName.found)
	trace('format detected by filename ending:\n', wtf.byName);

var input:Bytes;
var cache:BytesOutput = new BytesOutput();
var file:FileInput = File.read(filename);
var byte:Int;
try {
	do {
		byte = file.readByte();
		cache.writeByte(byte);
	}
	while ( wtf.checkNextByte(byte) || wtf.found); // do not stop if something found byName or byHeader
}
catch( ex:haxe.io.Eof ) {}
file.close();

// detected by header
if (wtf.byHeader.found) trace('format detected by parsing header:\n', wtf.byHeader);

// detected by byHeader or byName
if (wtf.found) {
	input = cache.getBytes();
	trace('format of $filename found.');
	trace('filesize: ${input.length}');
	trace('format: ${wtf.format} - ${wtf.description}');
	if (wtf.subtype != null) trace('subtype:${wtf.subtype} - ${wtf.subtypeDescription}');
}
else trace("can't detect fileformat");
```

For another check with same instance of wtf  
you can reset the detected results to default values:
```
wtf.byHeader();    // resets wtf.byHeader and set defaults for wtf.checkNextByte()
wtf.byNameReset(); // resets wtf.byName
wtf.reset();       // resets both
```



## Supported Formats

Look here: [src/formats/Magic.hx](https://github.com/maitag/whatformat/blob/master/src/formats/Magic.hx)  
  
Feel free to commit new formats that needs a `wtf-check`;)  


## Todo

- check subtypes headers (container-formats, streams)
- add more formats