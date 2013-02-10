//
//  NSString+URIUtils.h
//  Flow
//
//  Created by David Thorpe on 26/01/2006.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (URIUtils) 

-(NSString* )stringByEscapingForURI;
-(NSString* )stringByEscapingForURIWithSet:(NSCharacterSet* )theSet;

@end
