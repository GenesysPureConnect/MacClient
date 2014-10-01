//
//  CallHistoryController.h
//  MacClient
//
//  Created by Glinski, Kevin on 9/29/14.
//  Copyright (c) 2014 Interactive Intelligence. All rights reserved.
//

@interface CallHistoryController : NSViewController <NSTableViewDataSource, NSTableViewDelegate>
@property (weak) IBOutlet NSView *mainView;
@property (weak) IBOutlet NSTableView *tableOutlet;

- (void)doubleClick:(id)nid;
-(void)reloadTable: (NSTimer *)theTimer;
@end
