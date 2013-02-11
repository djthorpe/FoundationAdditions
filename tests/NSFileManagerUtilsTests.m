
#import <Foundation/Foundation.h>
#import "NSFileManager+PathUtils.h"

int main(int argc, const char * argv[]) {
	@autoreleasepool {
		NSFileManager* filemanager = [NSFileManager defaultManager];
		NSString* rootPath = @"/tmp";
		
		NSLog(@"Path = %@",rootPath);
		NSLog(@"Temporary file on same volume = %@",[filemanager temporaryFileForPathOnSameVolume:rootPath]);
		
		/*
		-(BOOL)createDirectorySegmentsAtPath:(NSString *)path attributes:(NSDictionary *)attributes;
		-(BOOL)removeEmptyDirectorySegmentsAtPath:(NSString *)path;
		-(BOOL)removeFilesAtPath:(NSString *)path olderThan:(NSDate* )theDate;
		-(NSString* )temporaryFileForPathOnSameVolume:(NSString *)thePath;
		*/
	}
	return 0;
}

