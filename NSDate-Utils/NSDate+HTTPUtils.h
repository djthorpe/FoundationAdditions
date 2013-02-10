//
//  NSDate+HTTPUtils.h
//  WebServerFramework
//
//  Created by David Thorpe on 09/04/2007.
//  Copyright 2007 Some rights reserved, see LICENSE file. 
//

#import <Foundation/Foundation.h>

@interface NSDate (HTTPUtils)

/*!
    @method     
    @abstract   Returns an NSDate object from a HTTP date header
    @discussion This method parses dates according to the HTTP/1.1 specification
      document. It will return an NSDate object, or nil if the date could not
      be parsed. For more information about the HTTP/1.1 specification, search
      for RFC2616 or look on the www.w3.org website.
*/
+(NSDate* )dateWithHTTPString:(NSString* )theString;

/*!
    @method     
    @abstract   Returns the HTTP Date formatted string for an NSDate object
    @discussion This method returns a formatted string representing the instance
      date according to the HTTP/1.1 specification document. For more information 
      about the HTTP/1.1 specification, search for RFC2616 or look on the
      www.w3.org website.
*/
-(NSString* )HTTPString;

@end
