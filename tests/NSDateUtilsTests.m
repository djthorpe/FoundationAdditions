
#import <Foundation/Foundation.h>
#import "NSDate+Formatting.h"
#import "NSDate+HTTPUtils.h"

int main(int argc, const char * argv[]) {
	@autoreleasepool {
		NSDate* now = [NSDate date];
		NSLog(@"Date = %@",now);
		NSLog(@"ISO8601 = %@",[now descriptionISO8601]);
		NSLog(@"RFC822 = %@",[now descriptionRFC822]);
		
		NSString* nowHTTPString = [now HTTPString];
		
		NSLog(@"HTTPString = %@",nowHTTPString);
		NSLog(@"Date from HTTPString = %@",[NSDate dateWithHTTPString:nowHTTPString]);
	}

    return 0;
}

