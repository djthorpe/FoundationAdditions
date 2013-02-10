
#import <Foundation/Foundation.h>

@interface NSWorkspace (MimetypeAdditions)

-(NSString* )mimeTypeForFile:(NSString* )thePathname;
-(NSDictionary* )pdfPropertiesForFile:(NSString* )thePathname;
-(NSDictionary* )quickTimePropertiesForFile:(NSString* )thePathname;

@end
