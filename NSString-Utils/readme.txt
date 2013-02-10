
December 2005
David Thorpe
djt@mutablelogic.com

This file contains an extension for NSString which converts a CSV string into an array. ie,

#import "NSString+CSVUtils.h"

@implementation MyDocument

- (BOOL)loadDataRepresentation:(NSData* )data ofType:(NSString* )aType {
  if([aType isEqualToString:@"CSV"]==NO && [aType isEqualToString:@"csv"]==NO) {
    NSLog(@"Don't understand format: %@",aType);
    return NO;
  }
  
  NSString* theFile = [[NSString alloc] initWithData:data encoding:NSISOLatin1StringEncoding];  
  NSArray* theArray = [theFile arrayByImportingCSV];

  // etc

  return YES;
}

@end

Please use as you see fit - it's not very well tested so could probably do with a whole load of test cases.
