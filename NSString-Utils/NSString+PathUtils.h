
#import <Foundation/Foundation.h>

@interface NSString (PathUtils) 
-(NSString* )stringWithSubstitute:(NSString* )subs forCharactersFromSet:(NSCharacterSet *)set;
-(NSString* )stringByNormalizingPath;

@end
