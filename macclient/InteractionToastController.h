//
//  InteractionToastController.h
//  CIC Mac Client
//
//  Created by Glinski, Kevin on 5/2/14.
//  Copyright (c) 2014 Interactive Intelligence. All rights reserved.
//
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#import <Foundation/Foundation.h>
#import "AlertingCallNotificationService.h"
#import "Interaction.h"

@interface InteractionToastController : NSWindowController
@property (weak) IBOutlet NSTextField *remoteName;
@property (weak) IBOutlet NSTextField *remoteNumber;
@property (weak) IBOutlet NSButton *pickupButton;
@property (weak) IBOutlet NSButton *ignoreButton;

- (IBAction)onPickupClick:(id)sender;
- (IBAction)onIgnoreClick:(id)sender;

- (void)setup:(AlertingCallNotificationService*) notificationService forInteraction:(Interaction*) interaction;

-(void) closeWindow;

@property (unsafe_unretained) IBOutlet NSWindow *toastWindow;

@end
