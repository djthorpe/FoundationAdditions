
#import "NSString+PathUtils.h"

@implementation NSString (PathUtils)

-(NSString* )stringWithSubstitute:(NSString* )subs forCharactersFromSet:(NSCharacterSet *)set {
  NSRange r = [self rangeOfCharacterFromSet:set];
  if (r.location == NSNotFound) return self;
  NSMutableString *newString = [self mutableCopy];
  do
  {
    [newString replaceCharactersInRange:r withString:subs];
    r = [newString rangeOfCharacterFromSet:set];
  } while(r.location != NSNotFound);
  return newString;
}

-(NSString* )stringByNormalizingPath {
  NSCharacterSet* theSetOfIllegalCharacters = [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ01234567890_-./"] invertedSet];

  // if path begins with two backward slashes, then windows mode
  if([self length] >= 3 & [self hasPrefix:@"\\\\"]) {
    // we are in windows mode, chop first two characters and add forward slash
    NSMutableString* theString = [self mutableCopy];
    [theString deleteCharactersInRange:NSMakeRange(0,1)];
    [theString replaceOccurrencesOfString:@"\\" withString:@"/" options:0 range:NSMakeRange(0,[theString length])];
    return [[theString stringWithSubstitute:@"_" forCharactersFromSet:theSetOfIllegalCharacters] stringByStandardizingPath];
  }
  
  if([self length] >= 3 & [self hasPrefix:@"//"]) {
    // we are in windows mode (but with forward slashes) chop first character
    NSMutableString* theString = [self mutableCopy];
    [theString deleteCharactersInRange:NSMakeRange(0,1)];
    return [[self stringWithSubstitute:@"_" forCharactersFromSet:theSetOfIllegalCharacters] stringByStandardizingPath];
  }
  
  if([self length] >= 4) {
    // in windows mode with c:\ style
    NSString* theDrive = [self substringWithRange:NSMakeRange(1,2)];
    if([theDrive isEqual:@":\\"]) {
      NSMutableString* theString = [self mutableCopy];
      [theString deleteCharactersInRange:NSMakeRange(0,2)];
      [theString replaceOccurrencesOfString:@"\\" withString:@"/" options:0 range:NSMakeRange(0,[theString length])];
      return [[theString stringWithSubstitute:@"_" forCharactersFromSet:theSetOfIllegalCharacters] stringByStandardizingPath];
    }
    if([theDrive isEqual:@":/"]) {
      NSMutableString* theString = [self mutableCopy];
      [theString deleteCharactersInRange:NSMakeRange(0,2)];
      return [[theString stringWithSubstitute:@"_" forCharactersFromSet:theSetOfIllegalCharacters] stringByStandardizingPath];
    }
  }
  
  // we assume we're in unix mode, so replace each individual path component
  return [[self stringWithSubstitute:@"_" forCharactersFromSet:theSetOfIllegalCharacters] stringByStandardizingPath];
}
@end
