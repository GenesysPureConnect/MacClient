//
//  QueueItemView.h
//  CIC Mac Client
//
//  Created by Glinski, Kevin on 4/24/14.
//  Copyright (c) 2014 Interactive Intelligence. All rights reserved.
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.

#import <Cocoa/Cocoa.h>

@interface QueueItemView : NSTableCellView
@property (strong) IBOutlet NSTextField *number;
@property (strong) IBOutlet NSTextField *timeInStatus;
@property (strong) IBOutlet NSTextField *callId;
@property (strong) IBOutlet NSTextField *stateString;
@end