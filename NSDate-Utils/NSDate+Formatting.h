//
//  NSDate+Formatting.h
//  Fluxo
//
//  Created by David Thorpe on 21/06/2007.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Formatting)
-(NSString* )descriptionISO8601;
-(NSString* )descriptionRFC822;
@end
