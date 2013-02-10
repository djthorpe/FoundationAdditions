FoundationAdditions
===================

Here's a random set of additions to the Foundation (and in some cases Cocoa)
framework classes. Some of these are old and out-of-date and likely implemented
better elsewhere, so your mileage will definately vary. Where the source code
is not copyright by me, I indicate this below and in each header file. For the
remainder, the license is described in the LICENSE.md file.

Any bugs or additions, please let me know!

- David Thorpe, February 2013


NSData+HashUtils
------------

If you use these, you will also be required to link to the OpenSSL library.

```objc
@interface NSData (HashUtils)
-(NSData* )md5Digest;
-(NSData* )sha1Digest;
-(NSString* )md5Hash;
-(NSString* )sha1Hash;
-(NSString *)encodeBase64;
-(NSString *)encodeBase64WithNewlines:(BOOL)encodeWithNewlines;
@end
```

NSDate+Formatting
-----------------

```objc
@interface NSDate (Formatting)
-(NSString* )descriptionISO8601;
-(NSString* )descriptionRFC822;
@end
```

NSDate+HTTPUtils
----------------

```objc
@interface NSDate (HTTPUtils)
+(NSDate* )dateWithHTTPString:(NSString* )theString;
-(NSString* )HTTPString;
@end
```


NSFileManager+PathUtils
-----------------------

```objc
@interface NSFileManager (PathUtils)
-(BOOL)createDirectorySegmentsAtPath:(NSString *)path attributes:(NSDictionary *)attributes;
-(BOOL)removeEmptyDirectorySegmentsAtPath:(NSString *)path;
-(BOOL)removeFilesAtPath:(NSString *)path olderThan:(NSDate* )theDate;
-(NSString* )temporaryFileForPathOnSameVolume:(NSString *)thePath;
@end
```

NSImage+MGCropExtensions
------------------------

Please note these routines are Copyright 2006 Magic Aubergine, rather than
David Thorpe.

```objc
@interface NSImage (MGCropExtensions)
-(NSImage *)imageToFitSize:(NSSize)size method:(MGImageResizingMethod)resizeMethod;
-(NSImage *)imageCroppedToFitSize:(NSSize)size;
-(NSImage *)imageScaledToFitSize:(NSSize)size;
@end
```


NSString+CSVUtils
-----------------

```objc
@interface NSString (CSVUtils) 
-(NSArray* )arrayByImportingCSV;
-(NSArray* )arrayByImportingSSV;
@end
```


NSString+PathUtils
-----------------

```objc
@interface NSString (PathUtils) 
-(NSString* )stringWithSubstitute:(NSString* )subs forCharactersFromSet:(NSCharacterSet *)set;
-(NSString* )stringByNormalizingPath;
@end
```


NSString+URIUtils
-----------------

```objc
@interface NSString (URIUtils)
-(NSString* )stringByEscapingForURI;
-(NSString* )stringByEscapingForURIWithSet:(NSCharacterSet* )theSet;
@end
```


NSString+XMLUtils
-----------------

Please note these routines are Copyright Buzz Anderson and are under a creative commons
license (as described in the header file).

```objc
@interface NSString (XMLUtils) 
-(NSString* )stringByUnescapingEntities:(NSDictionary *) entitiesDictionary;
-(NSString* )stringByEscapingEntities:(NSDictionary *) entitiesDictionary;
@end
```

NSWorkspace+MimetypeAdditions
-----------------------------

You will need to include the QTKit as a dependency if you wish to use these methods.

```objc
@interface NSWorkspace (MimetypeAdditions)
-(NSString* )mimeTypeForFile:(NSString* )thePathname;
-(NSDictionary* )pdfPropertiesForFile:(NSString* )thePathname;
-(NSDictionary* )quickTimePropertiesForFile:(NSString* )thePathname;
@end
```


NSXMLDocument+KMLUtils
----------------------

```objc
@interface NSXMLDocument (KMLUtils)
-(NSString* )KMLVersion;
-(NSString* )KMLName;
-(NSArray* )KMLFeatures;
@end
```

