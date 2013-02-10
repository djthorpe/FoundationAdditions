
#import "NSDate+HTTPUtils.h"

@interface HTTPUtilsPrivate : NSObject {
  NSDictionary* m_theWeekdays;
  NSDictionary* m_theMonths;
}

+(HTTPUtilsPrivate* )sharedObject;
-(NSDictionary* )weekdays;
-(NSDictionary* )months;

@end

@implementation HTTPUtilsPrivate

-(id)init {
  self = [super init];
  if(self) {
    m_theWeekdays = [[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[NSNumber numberWithUnsignedInt:0],[NSNumber numberWithUnsignedInt:0],[NSNumber numberWithUnsignedInt:1],[NSNumber numberWithUnsignedInt:1],[NSNumber numberWithUnsignedInt:2],[NSNumber numberWithUnsignedInt:2],[NSNumber numberWithUnsignedInt:3],[NSNumber numberWithUnsignedInt:3],[NSNumber numberWithUnsignedInt:4],[NSNumber numberWithUnsignedInt:4],[NSNumber numberWithUnsignedInt:5],[NSNumber numberWithUnsignedInt:5],[NSNumber numberWithUnsignedInt:6],[NSNumber numberWithUnsignedInt:6],nil]
                                              forKeys:[NSArray arrayWithObjects:@"sun",@"sunday",@"mon",@"monday",@"tue",@"tuesday",@"wed",@"wednesday",@"thu",@"thursday",@"fri",@"friday",@"sat",@"saturday",nil]] retain];  
    m_theMonths = [[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[NSNumber numberWithUnsignedInt:1],[NSNumber numberWithUnsignedInt:1],[NSNumber numberWithUnsignedInt:2],[NSNumber numberWithUnsignedInt:2],[NSNumber numberWithUnsignedInt:3],[NSNumber numberWithUnsignedInt:3],[NSNumber numberWithUnsignedInt:4],[NSNumber numberWithUnsignedInt:4],[NSNumber numberWithUnsignedInt:5],[NSNumber numberWithUnsignedInt:6],[NSNumber numberWithUnsignedInt:6],[NSNumber numberWithUnsignedInt:7],[NSNumber numberWithUnsignedInt:7],[NSNumber numberWithUnsignedInt:8],[NSNumber numberWithUnsignedInt:8],[NSNumber numberWithUnsignedInt:9],[NSNumber numberWithUnsignedInt:9],[NSNumber numberWithUnsignedInt:10],[NSNumber numberWithUnsignedInt:10],[NSNumber numberWithUnsignedInt:11],[NSNumber numberWithUnsignedInt:11],[NSNumber numberWithUnsignedInt:12],[NSNumber numberWithUnsignedInt:12],nil]
                                            forKeys:[NSArray arrayWithObjects:@"jan",@"january",@"feb",@"february",@"mar",@"march",@"apr",@"april",@"may",@"jun",@"june",@"jul",@"july",@"aug",@"august",@"sep",@"september",@"oct",@"october",@"nov",@"november",@"dec",@"december",nil]] retain];
  }  
  return self;  
}

-(void)dealloc {
  [m_theWeekdays release];
  [m_theMonths release];
  [super dealloc];
}

+(HTTPUtilsPrivate* )sharedObject {
  static HTTPUtilsPrivate* object;  
	if(object==nil) {
		object = [[HTTPUtilsPrivate alloc] init];
	}
	return object;
}

-(NSDictionary* )weekdays {
  return m_theWeekdays;
}

-(NSDictionary* )months {
  return m_theMonths;
}

@end

@implementation NSDate (HTTPUtils)

+(int)timeZoneSecondsForValue:(NSString* )theValue {
  if([theValue length] != 4) return -1;
  // split off the first two digits
  NSNumber* theHours = [NSDecimalNumber decimalNumberWithString:[theValue substringToIndex:2]];
  NSNumber* theMinutes = [NSDecimalNumber decimalNumberWithString:[theValue substringFromIndex:2]];
  // validate the values
  if(theHours==nil) return -1;
  if(theMinutes==nil) return -1;
  if([theHours unsignedIntValue] >= 24) return -1;
  if([theMinutes unsignedIntValue] >= 60) return -1;
  // return the seconds
  return ([theHours unsignedIntValue] * 3600) + ([theMinutes unsignedIntValue] * 60);
}

+(NSDate* )dateWithHTTPString:(NSString* )theString {
  NSScanner* theScanner = [NSScanner scannerWithString:[theString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
  NSDictionary* theWeekdays = [[HTTPUtilsPrivate sharedObject] weekdays];
  NSDictionary* theMonths = [[HTTPUtilsPrivate sharedObject] months];
  NSString* theValue = nil;
  NSNumber* theWeekday = nil;
  NSNumber* theYear = nil;
  NSNumber* theMonth = nil;
  NSNumber* theDayOfMonth = nil;
  NSNumber* theHour = nil;
  NSNumber* theMinute = nil;
  NSNumber* theSecond = nil;
  NSTimeZone* theTimeZone = nil;
  unsigned theState = 0;
  while([theScanner isAtEnd]==NO) {
    switch(theState) {      
      case 0:
        // scan the weekday
        if([theScanner scanCharactersFromSet:[NSCharacterSet letterCharacterSet] intoString:&theValue]==NO) {
          return nil;
        }        
        // test the weekday
        if((theWeekday = [theWeekdays objectForKey:[theValue lowercaseString]])==nil) {
          return nil;
        }
        // optional comma
        [theScanner scanString:@"," intoString:nil];
        // state becomes '1'
        theState = 1;
        break;
      case 1:
        // scan either the month (letters) or day of monday (numeric)
        if([theScanner scanCharactersFromSet:[NSCharacterSet letterCharacterSet] intoString:&theValue]==YES) {
          theState = 2;
        } else if([theScanner scanCharactersFromSet:[NSCharacterSet decimalDigitCharacterSet] intoString:&theValue]==YES) {
          theState = 8;
        } else {
          return nil;
        }
        break;
      case 2:
        // test the month
        if((theMonth = [theMonths objectForKey:[theValue lowercaseString]])==nil) {
          return nil;
        }
        theState = 3;
        break;
      case 3:
        // test the day of month
        if([theScanner scanCharactersFromSet:[NSCharacterSet decimalDigitCharacterSet] intoString:&theValue]==NO) {          
          return nil;
        }        
        if((theDayOfMonth = [NSDecimalNumber decimalNumberWithString:theValue])==nil) {
          return nil;
        }
        if([theDayOfMonth unsignedIntValue]==0 || [theDayOfMonth unsignedIntValue] > 31) {
          return nil;
        }
        theState = 4;
        break;
      case 4:
        // scan for hour
        if([theScanner scanCharactersFromSet:[NSCharacterSet decimalDigitCharacterSet] intoString:&theValue]==NO) {          
          return nil;
        }
        if((theHour = [NSDecimalNumber decimalNumberWithString:theValue])==nil) {
          return nil;
        }
        if([theHour unsignedIntValue] >= 24) {
          return nil;
        }
        // scan for colon
        if([theScanner scanString:@":" intoString:nil]==NO) {
          return nil;
        }
        theState = 5;
        break;
      case 5:
        // scan for minute
        if([theScanner scanCharactersFromSet:[NSCharacterSet decimalDigitCharacterSet] intoString:&theValue]==NO) {          
          return nil;
        }
        if((theMinute = [NSDecimalNumber decimalNumberWithString:theValue])==nil) {
          return nil;
        }
        if([theMinute unsignedIntValue] >= 60) {
          return nil;
        }
        // scan for colon
        if([theScanner scanString:@":" intoString:nil]==NO) {
          return nil;
        }
        theState = 6;
        break;
      case 6:
        // scan for second
        if([theScanner scanCharactersFromSet:[NSCharacterSet decimalDigitCharacterSet] intoString:&theValue]==NO) {          
          return nil;
        }
        if((theSecond = [NSDecimalNumber decimalNumberWithString:theValue])==nil) {
          return nil;
        }
        if([theSecond unsignedIntValue] >= 60) {
          return nil;
        }
        theState = 7;
        break;
      case 7:
        // scan for year
        if([theScanner scanCharactersFromSet:[NSCharacterSet decimalDigitCharacterSet] intoString:&theValue]==NO) {          
          return nil;
        }
        if((theYear = [NSDecimalNumber decimalNumberWithString:theValue])==nil) {
          return nil;
        }
        if([theYear unsignedIntValue] < 50) {
          // 49 => 2049
          theYear = [NSNumber numberWithUnsignedInt:([theYear unsignedIntValue] + 2000)];
        } else if([theYear unsignedIntValue] < 100) {
          // 94 => 1994
          theYear = [NSNumber numberWithUnsignedInt:([theYear unsignedIntValue] + 1900)];
        }
        if([theYear unsignedIntValue] < 1900 || [theYear unsignedIntValue] > 3000) {
          // no years can be below 1900 or above 3000
          return nil;
        }
        // we assume timezone is GMT
        theTimeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
        theState = 99;
        break;
      case 8:
        // test the day of month
        if((theDayOfMonth = [NSDecimalNumber decimalNumberWithString:theValue])==nil) {
          return nil;
        }
        if([theDayOfMonth unsignedIntValue]==0 || [theDayOfMonth unsignedIntValue] > 31) {
          return nil;
        }
        // scan for optional dash
        [theScanner scanString:@"-" intoString:nil];
        theState = 9;
        break;
      case 9:
        // scan for month
        if([theScanner scanCharactersFromSet:[NSCharacterSet letterCharacterSet] intoString:&theValue]==NO) {
          return nil;
        }
        if((theMonth = [theMonths objectForKey:[theValue lowercaseString]])==nil) {
          return nil;
        }
        // scan for optional dash
        [theScanner scanString:@"-" intoString:nil];
        theState = 10;
        break;
      case 10:
        // scan for year
        if([theScanner scanCharactersFromSet:[NSCharacterSet decimalDigitCharacterSet] intoString:&theValue]==NO) {          
          return nil;
        }
        if((theYear = [NSDecimalNumber decimalNumberWithString:theValue])==nil) {
          return nil;
        }
        if([theYear unsignedIntValue] < 50) {
          // 49 => 2049
          theYear = [NSNumber numberWithUnsignedInt:([theYear unsignedIntValue] + 2000)];
        } else if([theYear unsignedIntValue] < 100) {
          // 94 => 1994
          theYear = [NSNumber numberWithUnsignedInt:([theYear unsignedIntValue] + 1900)];
        }
        if([theYear unsignedIntValue] < 1900 || [theYear unsignedIntValue] > 3000) {
          // no years can be below 1900 or above 3000
          return nil;
        }
        theState = 11;
        break;
      case 11:
        // scan for hour
        if([theScanner scanCharactersFromSet:[NSCharacterSet decimalDigitCharacterSet] intoString:&theValue]==NO) {          
          return nil;
        }
        if((theHour = [NSDecimalNumber decimalNumberWithString:theValue])==nil) {
          return nil;
        }
        if([theHour unsignedIntValue] >= 24) {
          return nil;
        }
        // scan for colon
        if([theScanner scanString:@":" intoString:nil]==NO) {
          return nil;
        }
        theState = 12;
        break;
      case 12:
        // scan for minute
        if([theScanner scanCharactersFromSet:[NSCharacterSet decimalDigitCharacterSet] intoString:&theValue]==NO) {          
          return nil;
        }
        if((theMinute = [NSDecimalNumber decimalNumberWithString:theValue])==nil) {
          return nil;
        }
        if([theMinute unsignedIntValue] >= 60) {
          return nil;
        }
        // scan for colon
        if([theScanner scanString:@":" intoString:nil]==NO) {
          return nil;
        }
        theState = 13;
        break;
      case 13:
        // scan for second
        if([theScanner scanCharactersFromSet:[NSCharacterSet decimalDigitCharacterSet] intoString:&theValue]==NO) {          
          return nil;
        }
        if((theSecond = [NSDecimalNumber decimalNumberWithString:theValue])==nil) {
          return nil;
        }
        if([theSecond unsignedIntValue] >= 60) {
          return nil;
        }
        theState = 14;
        break;
      case 14:
        // scan for GMT, plus or minus sign, or other kind of timezone
        if([theScanner scanCharactersFromSet:[NSCharacterSet letterCharacterSet] intoString:&theValue]==YES) {
          theTimeZone = [NSTimeZone timeZoneWithAbbreviation:theValue];
          if(theTimeZone==nil) {
            return nil;
          }
        } else if([theScanner scanString:@"+" intoString:&theValue]==YES) {
          if([theScanner scanCharactersFromSet:[NSCharacterSet decimalDigitCharacterSet] intoString:&theValue]==NO) { 
            return nil;
          }
          int theSeconds = [self timeZoneSecondsForValue:theValue];
          if(theSeconds < 0) return nil;
          theTimeZone = [NSTimeZone timeZoneForSecondsFromGMT:theSeconds];
        } else if([theScanner scanString:@"-" intoString:&theValue]==YES) {
          if([theScanner scanCharactersFromSet:[NSCharacterSet decimalDigitCharacterSet] intoString:&theValue]==NO) { 
            return nil;
          }
          int theSeconds = [self timeZoneSecondsForValue:theValue];
          if(theSeconds < 0) return nil;
          theTimeZone = [NSTimeZone timeZoneForSecondsFromGMT:(-theSeconds)];
        } else {
          return nil;
        }
        theState = 99;
        break;
      case 99:
        // we should have a valid date here, but there are extra things on the
        // scanning line we shouldn't have, so return error
        return nil;
    }
  }  
  
  return [NSCalendarDate dateWithYear:[theYear unsignedIntValue] month:[theMonth unsignedIntValue] day:[theDayOfMonth unsignedIntValue] hour:[theHour unsignedIntValue] minute:[theMinute unsignedIntValue] second:[theSecond unsignedIntValue] timeZone:theTimeZone];
}

-(NSString* )HTTPString {
  return [self descriptionWithCalendarFormat:@"%a, %d %b %Y %H:%M:%S %Z" timeZone:[NSTimeZone timeZoneForSecondsFromGMT:0] locale:nil];
}

@end
