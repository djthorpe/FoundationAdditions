
#import <QTKit/QTKit.h>
#import <Quartz/Quartz.h>
#import "NSWorkspace+MimetypeAdditions.h"

@implementation NSWorkspace (MimetypeAdditions)

+(NSString* )mimeTypeForFileType:(NSString* )theFileType {
  NSString* theFilename = [[NSBundle mainBundle] pathForResource:@"mimetypes" ofType:@"plist"];
  NSDictionary* theMimeTypes = [NSDictionary dictionaryWithContentsOfFile:theFilename];
  return [theMimeTypes objectForKey:theFileType];
}

-(NSString* )mimeTypeForFile:(NSString* )thePathname {
  NSString* theApplication = nil;
  NSString* theFileType = nil;
  BOOL gotFileType = [self getInfoForFile:thePathname application:&theApplication type:&theFileType];
  if(gotFileType) {      
    // look filetype up
    NSString* theMimeType = [NSWorkspace mimeTypeForFileType:theFileType];
    if(theMimeType) {
      return theMimeType;
    }
  }
  // return default mimetype
  return @"application/octet-stream";
}

-(NSDictionary* )pdfPropertiesForFile:(NSString* )thePathname {
	// try and load using PDFKit
	PDFDocument* theDocument = [[PDFDocument alloc] initWithURL:[NSURL fileURLWithPath:thePathname]];
	if(theDocument==nil) return nil;

	// make dictionaries
	NSDictionary* theAttributes = [theDocument documentAttributes];
	NSMutableDictionary* theDictionary = [NSMutableDictionary dictionary];
	// add number of pages
	[theDictionary setObject:[NSNumber numberWithUnsignedInt:[theDocument pageCount]] forKey:@"pdf-pages"];
	// add other fields
	NSEnumerator* theEnumerator = [theAttributes keyEnumerator];
	NSObject* theKey = nil;
	while(theKey = [theEnumerator nextObject]) {
		NSObject* theValue = [theAttributes objectForKey:theKey];
		if(theValue==nil) continue;		
		// TODO: we can't use the apple constants for PDF attributes
		//       because of a bug in their frameworks
		if([theKey isEqual:@"Title"]) {
			[theDictionary setObject:theValue forKey:@"pdf-title"];
			continue;
		}
		if([theKey isEqual:@"Author"]) {
			[theDictionary setObject:theValue forKey:@"pdf-author"];
			continue;
		}
		if([theKey isEqual:@"Subject"]) {
			[theDictionary setObject:theValue forKey:@"pdf-subject"];
			continue;
		}
		if([theKey isEqual:@"Creator"]) {
			[theDictionary setObject:theValue forKey:@"pdf-creator"];
			continue;
		}
		if([theKey isEqual:@"Producer"]) {
			[theDictionary setObject:theValue forKey:@"pdf-producer"];
			continue;
		}
		if([theKey isEqual:@"Keywords"]) {
			[theDictionary setObject:theValue forKey:@"pdf-keywords"];
			continue;
		}
		if([theKey isEqual:@"CreationDate"]) {
			[theDictionary setObject:theValue forKey:@"pdf-created"];
			continue;
		}
		if([theKey isEqual:@"ModDate"]) {
			[theDictionary setObject:theValue forKey:@"pdf-modified"];
			continue;
		}
	}
	return theDictionary;
}

-(NSDictionary* )quickTimePropertiesForFile:(NSString* )thePathname {
  // try to load using quicktime
  if([QTMovie canInitWithFile:thePathname]==nil) {
    return nil;
  }
  NSError* theError = nil;
  QTMovie* theMovie = [QTMovie movieWithFile:thePathname error:&theError];
  if(theError || theMovie==nil) {
    return nil;    
  }
  NSDictionary* theDictionary = [theMovie movieAttributes];
  NSMutableDictionary* theOutputDictionary = [NSMutableDictionary dictionary];

  // get copyright
  NSString* theCopyrightString = [theDictionary valueForKey:QTMovieCopyrightAttribute];
  if(theCopyrightString && [theCopyrightString isKindOfClass:[NSString class]]) {
    [theOutputDictionary setValue:theCopyrightString forKey:@"copyright"];    
  }
  // get creation time
  NSDate* theCreationTime  = [theDictionary valueForKey:QTMovieCreationTimeAttribute];
  if(theCreationTime && [theCreationTime isKindOfClass:[NSDate class]]) {
    [theOutputDictionary setValue:[theCreationTime description] forKey:@"QTMovieCreationTimeAttribute"];        
  }
  // get modified time
  NSDate* theModifiedTime  = [theDictionary valueForKey:QTMovieModificationTimeAttribute];
  if(theModifiedTime && [theModifiedTime  isKindOfClass:[NSDate class]]) {
    [theOutputDictionary setValue:[theModifiedTime description] forKey:@"QTMovieModificationTimeAttribute"];        
  }
  // get current size
  NSValue* theCurrentSize = [theDictionary valueForKey:QTMovieCurrentSizeAttribute];
  if(theCurrentSize && [theCurrentSize isKindOfClass:[NSValue class]]) {
    NSSize theSize = [theCurrentSize sizeValue];
    if(theSize.width > 0 && theSize.height > 0) {
      [theOutputDictionary setValue:[NSString stringWithFormat:@"%g",theSize.width] forKey:@"image-width"];     
      [theOutputDictionary setValue:[NSString stringWithFormat:@"%g",theSize.height] forKey:@"image-height"];
    }
  }
  // get movie duration
  NSValue* theDuration = [theDictionary valueForKey:QTMovieDurationAttribute];
  if(theDuration && [theDuration isKindOfClass:[NSValue class]]) {
    QTTime theDuration2 = [theDuration QTTimeValue];
    [theOutputDictionary setValue:QTStringFromTime(theDuration2) forKey:@"QTMovieDurationAttribute"];
    NSTimeInterval theTimeInterval;
    if(QTGetTimeInterval(theDuration2,&theTimeInterval)) {
      [theOutputDictionary setValue:[NSString stringWithFormat:@"%g",(double)theTimeInterval] forKey:@"media-duration"];
    }
  }
  return theOutputDictionary;
}

@end
