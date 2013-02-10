
#import "NSFileManager+PathUtils.h"

@implementation NSFileManager (PathUtils)

-(NSString* )_rootPath:(NSArray* )thePathComponents {
	unsigned int i = 0;
	NSMutableArray* theRootPath = [NSMutableArray arrayWithCapacity:[thePathComponents count]];
	for(; i < [thePathComponents count]; i++) {
		NSString* theComponent = [thePathComponents objectAtIndex:i];
		[theRootPath addObject:theComponent];
		if([theComponent isEqual:@"."] && i > 0) {
			return [NSString pathWithComponents:theRootPath];
		}
	}
	return @"/";
}

////////////////////////////////////////////////////////////////////////////////

-(BOOL)createDirectorySegmentsAtPath:(NSString *)path attributes:(NSDictionary *)attributes {
	NSArray* pathComponents = [path pathComponents];
	NSString* theRootPath = [self _rootPath:pathComponents];
	// traverse the path
	unsigned int i = 0;
	NSMutableArray* theCurrentPath = [NSMutableArray arrayWithCapacity:[pathComponents count]];
	for(; i < [pathComponents count]; i++) {
		[theCurrentPath addObject:[pathComponents objectAtIndex:i]];
		NSString* theCursor = [NSString pathWithComponents:theCurrentPath];
		if([theCursor length] <= [theRootPath length]) continue;
		// check to see if this directory exists
		BOOL isDirectory = NO;
		if([self fileExistsAtPath:theCursor isDirectory:&isDirectory]) {
			// if not a directory, then error has occured!
			if(isDirectory==NO) {
				NSLog(@"Path %@ is not a directory path",theCursor);
				return NO;
			}
			// or else continue
			continue;
		}
		// make the directory as necessary
		if([self createDirectoryAtPath:theCursor attributes:attributes]==NO) {
			NSLog(@"Path %@ cannot be created",theCursor);
			return NO;			
		}
	}	
	return YES;
}

////////////////////////////////////////////////////////////////////////////////

-(BOOL)removeEmptyDirectorySegmentsAtPath:(NSString *)path {
	// TODO: needs implemented
	return NO;
}

-(BOOL)removeFilesAtPath:(NSString *)path olderThan:(NSDate* )theDate {
  // enumerate files within a particular path
  NSDirectoryEnumerator* theEnumerator = [self enumeratorAtPath:path];
  NSString* theFilename = nil;
  while(theFilename = [theEnumerator nextObject]) {
    NSString* theFileType = [[theEnumerator fileAttributes] objectForKey:NSFileType];
    NSDate* theModificationDate = [[theEnumerator fileAttributes] objectForKey:NSFileModificationDate];
    if([theFileType isEqual:NSFileTypeRegular] && [theModificationDate compare:theDate]==NSOrderedAscending) {
      BOOL isSuccess = [[NSFileManager defaultManager] removeFileAtPath:[path stringByAppendingPathComponent:theFilename] handler:nil];
      if(isSuccess==NO) {
        NSLog(@"Path %@ cannot be removed",[path stringByAppendingPathComponent:theFilename]);
        return NO;
      }
    }
  }  
  return YES;
}

////////////////////////////////////////////////////////////////////////////////
// returns a temporary filename for a path. the temporary file will reside on
// the same volume as the path. the path must exist.

-(NSString* )_pathForPath:(NSString* )thePath ofType:(OSType)thePathType {
  // turn into FSRef
  FSRef outRef;
  OSStatus err = FSPathMakeRef((const UInt8 *)[thePath fileSystemRepresentation], &outRef, NULL);
  if(err != noErr) {
    return nil;
  }
  // turn into FSSpec
  FSSpec outSpec;
  err = FSGetCatalogInfo(&outRef,kFSCatInfoNone,NULL,NULL,&outSpec,NULL);
  if(err != noErr) {
    return nil;
  }
  // determine the trash folder
  FSRef foundRef;
  err = FSFindFolder(outSpec.vRefNum, kTrashFolderType,kDontCreateFolder,&foundRef);
  if(err != noErr) {
    return nil;
  }    
  // turn folder reference back to cocoa-land
  CFURLRef foundURL = CFURLCreateFromFSRef(kCFAllocatorDefault,&foundRef);
  if(foundURL==NULL) {
    return nil;
  }
  CFStringRef foundString = CFURLCopyFileSystemPath(foundURL, kCFURLPOSIXPathStyle);
  if(foundString==NULL) {
    CFRelease(foundURL);
    return nil;
  }
  CFRelease(foundURL);
  return [(NSString* )foundString autorelease];
}

-(NSString* )_temporaryPathForPathOnSameVolume:(NSString *)thePath {
  NSString* theTemporaryPath = [self _pathForPath:thePath ofType:kTemporaryFolderType];
  if(theTemporaryPath==nil) {
    theTemporaryPath = [self _pathForPath:thePath ofType:kTrashFolderType];
  }
  return theTemporaryPath;
}

-(NSString* )temporaryFileForPathOnSameVolume:(NSString *)thePath {
  // if the path does not exist, try removing the last path component
  NSString* theTemporaryFolder = nil;
  if([self fileExistsAtPath:thePath]==NO) {
    theTemporaryFolder = [self _temporaryPathForPathOnSameVolume:[thePath stringByDeletingLastPathComponent]];
  } else {
    theTemporaryFolder = [self _temporaryPathForPathOnSameVolume:thePath];
  }
  if(theTemporaryFolder==nil) {
    return nil;    
  }
  return [theTemporaryFolder stringByAppendingPathComponent:[[NSProcessInfo processInfo] globallyUniqueString]];
}

@end
