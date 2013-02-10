//
//  NSDate+Formatting.m
//  Fluxo
//
//  Created by David Thorpe on 21/06/2007.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "NSDate+Formatting.h"

@implementation NSDate (Formatting)

// ISO8601 from here: http://www.w3.org/TR/NOTE-datetime
-(NSString* )descriptionISO8601 {
	NSString* theString1 = [self descriptionWithCalendarFormat:@"%Y-%m-%dT%H:%M:%S" timeZone:nil locale:nil];
	NSString* theString2 = [self descriptionWithCalendarFormat:@"%z" timeZone:nil locale:nil];
	// format is like: 2007-06-19T11060+0100, munge so format is like: 2007-06-19T11060+01:00
	if(([theString2 hasPrefix:@"+"] || [theString2 hasPrefix:@"-"]) && [theString2 length]==5) {
		return [NSString stringWithFormat:@"%@%@:%@",theString1,[theString2 substringToIndex:3],[theString2 substringFromIndex:3]];
	} else {
		return [NSString stringWithFormat:@"%@Z",theString1];		
	}	
}

-(NSString* )descriptionRFC822 {
	return [self descriptionWithCalendarFormat:@"%a, %d %b %Y %H:%M:%S %z" timeZone:nil locale:nil];
}

@end
