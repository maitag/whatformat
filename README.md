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

Start with an instanz of WhatFormat:
```
var wtf = new WhatFormat();

// or define what formats to check only:
// var wtf = new WhatFormat(['png', 'jpg', 'gif']); 
```
<!---
To check the Bytes of a loaded File:
```


```
--->
For streams or special purpose you can check format __while loading__,  
to easy stop __loading__ if an unknown fileformat is detected:
```
var file:FileInput = File.read(fname);
var wtf:WhatFormat = new WhatFormat();
try
{
	do
	{
		var byte:Int = file.readByte(); // store it into Bytes or do whatever with
		// ...
		wtf.checkNextByte(byte); // check next Byte in header (if formatcheck is in proceed)
	}
	while ( wtf.proceed || wtf.found); // stop reading if no format found
}
catch( ex:haxe.io.Eof ) {}

if (wtf.found) trace( 'format: ${wtf.format} - ${wtf.description}');
else trace("what the f... format is?");

file.close();
```

<!---
## Supported Formats

look/edit here: src/formats/Magic.hx  

Feel free to commit new formats that needs a `wtf-check`;)  
--->

## Todo

- check subtypes (container-formats, streams)
