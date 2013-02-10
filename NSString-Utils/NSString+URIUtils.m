
#import "NSString+URIUtils.h"

@implementation NSString (URIUtils)

-(NSString* )stringByEscapingForURI {	
	return [self stringByEscapingForURIWithSet:nil];
}

-(NSString* )stringByEscapingForURIWithSet:(NSCharacterSet* )theSet {	
	NSScanner* theScanner = [NSScanner scannerWithString:self];
	NSString* theString = nil;
	NSMutableString* theResult = [NSMutableString stringWithCapacity:([self length] * 2)];	
	[theScanner setCharactersToBeSkipped:nil];
	if(theSet==nil) {
		theSet = [NSCharacterSet characterSetWithCharactersInString:@";/?:@&=+$,{} "];		
	}		
	while([theScanner isAtEnd] == NO) {
		if([theScanner scanUpToCharactersFromSet:theSet intoString:&theString]) {			
			[theResult appendString:theString];
			if([theScanner scanCharactersFromSet:theSet intoString:&theString]) {
				unsigned int i = 0;
				for(; i < [theString length]; i++) {
					unichar theChar = [theString characterAtIndex:i];
					if(theChar==' ') {
						[theResult appendString:@"+"];												
					} else if(theChar=='/') {
						[theResult appendString:@"/"];																		
					} else {
						[theResult appendFormat:@"%%%02X",theChar];						
					}
				}
			}
		} else {
			if([theScanner scanCharactersFromSet:theSet intoString:&theString]) {
				unsigned int i = 0;
				for(; i < [theString length]; i++) {
					unichar theChar = [theString characterAtIndex:i];
					if(theChar==' ') {
						[theResult appendString:@"+"];												
					} else {
						[theResult appendFormat:@"%%%02X",theChar];						
					}
				}
			}
		}
	}
	return theResult;
}

@end
