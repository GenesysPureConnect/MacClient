//
//  QueueItemView.h
//  CIC Mac Client
//
//  Created by Glinski, Kevin on 4/24/14.
//  Copyright (c) 2014 Interactive Intelligence. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface QueueItemView : NSTableCellView
@property (strong) IBOutlet NSTextField *number;
@property (strong) IBOutlet NSTextField *timeInStatus;
@property (strong) IBOutlet NSTextField *callId;
@property (strong) IBOutlet NSTextField *stateString;
@end