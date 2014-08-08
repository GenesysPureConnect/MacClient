//
//  QueueController.h
//  CIC Mac Client
//
//  Created by Glinski, Kevin on 3/1/14.
//  Copyright (c) 2014 Interactive Intelligence. All rights reserved.
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.

#import <Foundation/Foundation.h>
#import "Interaction.h"

@interface QueueController : NSObject <NSTableViewDataSource, NSTableViewDelegate>

@property (weak) IBOutlet NSButton *pickupButton;
@property (weak) IBOutlet NSButton *disconnectButton;
@property (weak) IBOutlet NSButton *holdButton;
@property (weak) IBOutlet NSButton *muteButton;
@property (weak) IBOutlet NSButton *recordButton;
@property (weak) IBOutlet NSButton *voicemailButton;
@property (weak) IBOutlet NSTableView *queueTable;
@property (weak) IBOutlet NSPopUpButton *conferenceButton;

- (IBAction)pickupClick:(id)sender;
- (IBAction)disconnectClick:(id)sender;
- (IBAction)holdClick:(id)sender;
- (IBAction)sendToVoicemailClick:(id)sender;
- (IBAction)muteClick:(id)sender;
- (IBAction)recordClick:(id)sender;

- (IBAction)selectCall:(id)sender ;
-(void) setCallControlButtonState:(Interaction*)interaction;

- (BOOL)tableView:(NSTableView *)tv
writeRowsWithIndexes:(NSIndexSet *)rowIndexes
     toPasteboard:(NSPasteboard*)pboard;

- (NSDragOperation)tableView:(NSTableView*)tv
                validateDrop:(id )info
                 proposedRow:(NSInteger)row
       proposedDropOperation:(NSTableViewDropOperation)op;

- (BOOL)tableView:(NSTableView *)aTableView
       acceptDrop:(id )info
              row:(NSInteger)row
    dropOperation:(NSTableViewDropOperation)operation;

@end
