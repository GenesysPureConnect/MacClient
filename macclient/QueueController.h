//
//  QueueController.h
//  CIC Mac Client
//
//  Created by Glinski, Kevin on 3/1/14.
//  Copyright (c) 2014 Interactive Intelligence. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Interaction.h"

@interface QueueController : NSObject <NSTableViewDataSource>

@property (weak) IBOutlet NSButton *pickupButton;
@property (weak) IBOutlet NSButton *disconnectButton;
@property (weak) IBOutlet NSButton *holdButton;
@property (weak) IBOutlet NSButton *muteButton;
@property (weak) IBOutlet NSTableView *queueTable;

- (IBAction)pickupClick:(id)sender;
- (IBAction)disconnectClick:(id)sender;
- (IBAction)holdClick:(id)sender;
- (IBAction)muteClick:(id)sender;

- (IBAction)selectCall:(id)sender ;
-(void) setCallControlButtonState:(Interaction*)interaction;
@end
