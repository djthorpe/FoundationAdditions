
#import <Foundation/Foundation.h>

@interface NSFileManager (PathUtils)
-(BOOL)createDirectorySegmentsAtPath:(NSString *)path attributes:(NSDictionary *)attributes;
-(BOOL)removeEmptyDirectorySegmentsAtPath:(NSString *)path;
-(BOOL)removeFilesAtPath:(NSString *)path olderThan:(NSDate* )theDate;
-(NSString* )temporaryFileForPathOnSameVolume:(NSString *)thePath;
@end
