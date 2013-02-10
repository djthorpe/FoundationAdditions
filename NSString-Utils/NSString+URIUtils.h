
#import <Foundation/Foundation.h>

@interface NSString (URIUtils) 

-(NSString* )stringByEscapingForURI;
-(NSString* )stringByEscapingForURIWithSet:(NSCharacterSet* )theSet;

@end
