package formats;

/**
 * by Sylvio Sell - Rostock 2018
 * 
 * headers and filename-endings
 * feel free to add more ;)
 */

class Magic
{
	// Formats that can be detected by parsing header
	// translated from -> https://en.wikipedia.org/wiki/List_of_file_signatures
	static public var Numbers:Array<Array<String>> = [
		// header signature                     format  description
		
		// binary
		['7F 45 4C 46',                         'elf',  'Executable and Linkable Format' ],
		['4D 5A',                               'exe',  'DOS MZ executable file format' ],
		['6d 73 61 00',                         'wasm', 'WebAssembly binary format' ],
		['43 57 53',                            'swf',  'Shockwave Flash' ],
		['46 57 53',                            'swf',  'Shockwave Flash' ],
		
		// document
		['7B 5C 72 74 66 31',                   'rtf',  'Rich Text Format' ],
		['38 42 50 53',                         'psd',  'Adobe Photoshop document' ],
		['25 21 50 53',                         'ps',   'PostScript document' ],
		['25 50 44 46',                         'pdf',  'PDF document' ],
		['41 47 44 33',                         'fh8',  'FreeHand 8 document' ],
		['D0 CF 11 E0 A1 B1 1A E1',             'doc',  'Microsoft Office document' ],
		
		// pack
		['50 4B 03 04',                         'zip',  'zip and formats based on it' ],
		['50 4B 05 06',                         'zip',  'zip and formats based on it (empty archive)' ],
		['50 4B 07 08',                         'zip',  'zip and formats based on it (spanned archive)' ],
		['42 5A 68',                            'bz2',  'Compressed file using Bzip2 algorithm' ],
		['4C 5A 49 50',                         'lz',   'Compressed file using Lzip algorithm' ],
		['52 61 72 21 1A 07 00',                'rar',  'RAR archive version 1.5' ],
		['52 61 72 21 1A 07 01 00',             'rar',  'RAR archive version 5.0' ],
		['78 61 72 21',                         'xar',  'eXtensible ARchive format' ],
		['37 7A BC AF 27 1C',                   '7z',   '7-Zip format' ],
		['1F 8B',                               'gz',   'GZIP format' ],
		['78 01',                               'zlib', 'zlib (no compression/low)' ],
		['78 9C',                               'zlib', 'zlib (default compression)' ],
		['78 DA',                               'zlib', 'zlib (best compression)' ],
		
		// image		                               
		['00 00 01 00',                         'ico',  'ICO - for desktop icons' ],
		['76 2F 31 01',                         'exr',  'OpenEXR multilayer image format' ],
		['47 49 46 38 37 61',                   'gif',  'Graphics Interchange Format' ],
		['89 50 4E 47 0D 0A 1A 0A',             'png',  'Portable Network Graphics' ],
		['FF D8 FF DB',                         'jpg',  'JPEG raw image format' ],
		['FF D8 FF E0 ?? ?? 4A 46 49 46 00 01', 'jpg',  'JPEG JFIF image format' ],
		['FF D8 FF E1 ?? ?? 45 78 69 66 00 00', 'jpg',  'JPEG Exif image format' ],
		['49 49 2A 00',                         'tif',  'Tagged image little endian format' ],
		['4D 4D 00 2A',                         'tif',  'Tagged image big endian format' ],
		['42 4D',                               'bmp',  'BMP image format' ],
		['46 4C 49 46',                         'flif', 'Free Lossless Image Format' ],
		['52 49 46 46 ?? ?? ?? ?? 57 45 42 50', 'webp', 'Google WebP image format' ],
		
		// audio
		['52 49 46 46 ?? ?? ?? ?? 57 41 56 45', 'wav',  'Waveform audio format' ],
		['66 4C 61 43',                         'flac', 'Free Lossless Audio Codec' ],
		
		// midi
		['4D 54 68 64',                         'mid',  'MIDI sound file' ],
		
		// video
		['00 00 01 B3',                         'mpg',  'MPEG-1 video and MPEG-2 video' ],
		['00 00 01 BA',                         'mpg',  'MPEG Program Stream' ],
		
		// media
		['4F 67 67 53',                         'ogg',  'Ogg Vorbis Codec compressed media container format' ],
		['52 49 46 46 ?? ?? ?? ?? 41 56 49 20', 'avi',  'Audio Video Interleave video format' ],
		['49 44 33',                            'mp3',  'MP3 file with an ID3v2 container' ],
		['FF FB',                               'mp3',  'MPEG-1 Layer 3 file without an ID3 tag or with an ID3v1 tag' ],
		['1A 45 DF A3',                         'mkv',  'Matroska media container, including WebM' ],
		
		// font                                       
		['77 4F 46 46',                         'woff', 'WOFF File Format 1.0' ],
		['77 4F 46 32',                         'woff2','WOFF File Format 2.0' ],
		
		// text
		['EF BB BF',                            'txt',  'UTF-8 encoded Unicode' ],
		['FF FE',                               'txt',  '16-bit Unicode little-endian' ],
		['FF FE 00 00',                         'txt',  '32-bit Unicode little-endian' ],		
		
		// feel free to add more
	];
	
	// general descriptions of Formats detected by Filename
	static public var specialEndings:Array<Array<String>> = [
		// format  description
		['txt',  'ASCII Text Format' ],
		['jpg',  'JPEG image format' ],
		// feel free to add more
	];
	
	// Subtypes of Formats detected by Filename
	static public var Subtypes:Map<String, Array<Array<String>>> = [
		// format
		'txt' => [    // subtype, description
			['md',  'Markdown Format' ],
			['pl',  'Perl sourcecode' ],
			['hx',  'Haxe sourcecode' ],
			['c',   'C sourcecode' ],	
			['cc',  'C++ sourcecode' ],	
			['js',  'Javascript sourcecode' ],	
		],
		'ogg' => [
			['oga', 'Ogg Vorbis audio'],
			['ogv', 'Ogg Vorbis video'],
			['ogx', 'Ogg Vorbis application'],
		],
		// TODO:
		/*
		'zip' => [
			['jar', ''],
			['aar', ''],
			['apk', ''],
			['odt', ''],
			['ods', ''],
			['odp', ''],
			['docx',''],
			['xlsx',''],
			['pptx',''],
			['vsdx',''],
		],
		'mkv' => [
			['mka', ''],
			['mks', ''],
			['mk3d',''],
			['webm',''],
		]
		'doc' => [
			['xls', ''],
			['ppt', '' ],
			['msg', ''],
		],
		*/
	];
	
	static public var Aliases:Map<String,Array<String>> = [
		'cc'  => ['C', 'cpp', 'cxx'],
		'oga' => ['spx'],
		'jpg' => ['jpeg'],
		'tif' => ['tiff'],
		'bmp' => ['dib'],
		'mpg' => ['mpeg'],
		'mid' => ['midi'],
	];
	
	static public function resolveFromSubtype(format:String):String {
		for (fnew in Magic.Subtypes.keys()) {
			for (subtype in Magic.Subtypes.get(fnew)) {
				if (subtype[0] == format) return (fnew);
			}
		}
		return format;
	}
	
	static public function resolveFromAlias(format:String):String {
		for (fnew in Magic.Aliases.keys()) {
			for (alias in Magic.Aliases.get(fnew)) {
				if (alias.toLowerCase() == alias) format = format.toLowerCase(); // for cc (Gnu C)
				if (alias == format) {
					return (fnew);
				}
			}
		}
		return format;
	}

	static public function getDescription(format:String):String {
		for (m in Magic.specialEndings) if (m[0] == format) return m[1];
		for (m in Magic.Numbers) if (m[1] == format) return m[2]; // if there is doubles -> return first
		return null;
	}
	
	static public function getSubtypeDescription(format:String):String {
		for (fnew in Magic.Subtypes.keys()) {
			for (subtype in Magic.Subtypes.get(fnew)) {
				if (subtype[0] == format) return (subtype[1]);
			}
		}
		return null;
	}
	
}