
#import <Foundation/Foundation.h>

@interface NSData (HashUtils)

-(NSData* )md5Digest;
-(NSData* )sha1Digest;
-(NSString* )md5Hash;
-(NSString* )sha1Hash;
-(NSString *)encodeBase64;
-(NSString *)encodeBase64WithNewlines:(BOOL)encodeWithNewlines;

@end
