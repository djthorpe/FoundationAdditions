//
//  NSData+HashUtils.h
//  DeliverySystem
//
//  Created by David Thorpe on 26/02/2006.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (HashUtils)

-(NSData* )md5Digest;
-(NSData* )sha1Digest;
-(NSString* )md5Hash;
-(NSString* )sha1Hash;
-(NSString *)encodeBase64;
-(NSString *)encodeBase64WithNewlines:(BOOL)encodeWithNewlines;

@end
