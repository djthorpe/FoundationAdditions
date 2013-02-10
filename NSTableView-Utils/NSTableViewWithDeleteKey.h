
#import <Cocoa/Cocoa.h>

@interface NSTableViewWithDeleteKey : NSTableView {

}

@end

@interface NSObject (NSTableViewWithDeleteKeyDelegate)
-(void)tableView:(NSTableView* )theTableView deleteKeyPressedOnRow:(int)rowIndex;
@end

