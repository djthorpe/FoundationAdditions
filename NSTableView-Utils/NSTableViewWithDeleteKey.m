//
//  NSTableViewWithDeleteKey.m
//  Fluxo
//
//  Created by David Thorpe on 20/03/2007.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "NSTableViewWithDeleteKey.h"


@implementation NSTableViewWithDeleteKey
-(void)keyDown:(NSEvent* )theEvent {
	id obj = [self delegate];
	unichar firstChar = [[theEvent characters] characterAtIndex: 0];
	
	// if the user pressed delete and the delegate supports deleteKeyPressed
	if ( ( firstChar == NSDeleteFunctionKey ||
         firstChar == NSDeleteCharFunctionKey ||
         firstChar == NSDeleteCharacter) &&
       [obj respondsToSelector: @selector(tableView:deleteKeyPressedOnRow:)]) {
    [obj tableView:self deleteKeyPressedOnRow:[self selectedRow]];
	}
}
@end
