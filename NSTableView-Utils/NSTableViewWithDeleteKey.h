//
//  NSTableViewWithDeleteKey.h
//  Fluxo
//
//  Created by David Thorpe on 20/03/2007.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSTableViewWithDeleteKey : NSTableView {

}

@end

@interface NSObject (NSTableViewWithDeleteKeyDelegate)
-(void)tableView:(NSTableView* )theTableView deleteKeyPressedOnRow:(int)rowIndex;
@end

