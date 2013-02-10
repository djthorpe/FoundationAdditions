//
//  NSWorkspace+MimetypeAdditions.h
//  SomethinElse
//
//  Created by David Thorpe on 27/05/2006.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSWorkspace (MimetypeAdditions)

-(NSString* )mimeTypeForFile:(NSString* )thePathname;
-(NSDictionary* )pdfPropertiesForFile:(NSString* )thePathname;
-(NSDictionary* )quickTimePropertiesForFile:(NSString* )thePathname;

@end
