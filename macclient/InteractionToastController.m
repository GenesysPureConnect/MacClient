//
//  InteractionToastController.m
//  CIC Mac Client
//
//  Created by Glinski, Kevin on 5/2/14.
//  Copyright (c) 2014 Interactive Intelligence. All rights reserved.
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.
//


#import "InteractionToastController.h"

static int toastCount = 0;

@implementation InteractionToastController

int _toastId;
AlertingCallNotificationService* _alertingCallNotificationService;
Interaction* _interaction;

-(id) initWithWindowNibName:(NSString*) nib{
    self = [super initWithWindowNibName:nib];
    
    toastCount ++;
    _toastId = toastCount;
    
    [self setShouldCascadeWindows: NO];
    
    return self;
}

- (void)setup:(AlertingCallNotificationService*) notificationService forInteraction:(Interaction*) interaction
{
    _alertingCallNotificationService = notificationService;
    _interaction = interaction;
    
    NSPoint pos;
    
    NSScreen* currentScreen = [[self  toastWindow] screen];

    pos.x = [currentScreen visibleFrame].origin.x + [currentScreen visibleFrame].size.width - [[self toastWindow] frame].size.width - 15 ;
    pos.y = [currentScreen visibleFrame].origin.y + [currentScreen visibleFrame].size.height - ( _toastId * ([[self toastWindow] frame].size.height + 10))   ;

    [[self toastWindow] setFrameOrigin : pos];

    [[self toastWindow] setLevel:NSFloatingWindowLevel];
    
    [_remoteName setStringValue:[interaction remoteName]];
    [_remoteNumber setStringValue:[interaction remoteId]];
}


- (IBAction)onPickupClick:(id)sender {
    [_alertingCallNotificationService pickupCall:_interaction];
}

- (IBAction)onIgnoreClick:(id)sender {
    [_alertingCallNotificationService ignoreCall:_interaction];
}

-(void) closeWindow{
    toastCount--;
    [[self toastWindow] close];
   
    
}

@end
