//
//  ininAppDelegate.m
//  macclient
//
//  Created by Glinski, Kevin on 1/23/14.
//  Copyright (c) 2014 ININ. All rights reserved.
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.
//

#import "ininAppDelegate.h"
#import "CallService.h"
#import "ServiceLocator.h"
#import "AlertingCallNotificationService.h"
#import "InteractionToastController.h"
#import <Sparkle/Sparkle.h>

@implementation ininAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    
    NSAppleEventManager *em = [NSAppleEventManager sharedAppleEventManager];
    [em
     setEventHandler:self
     andSelector:@selector(getUrl:withReplyEvent:)
     forEventClass:kInternetEventClass
     andEventID:kAEGetURL];
    
}
- (void)getUrl:(NSAppleEventDescriptor *)event withReplyEvent:(NSAppleEventDescriptor *)replyEvent
{
    // Get the URL
    NSString *urlStr = [[event paramDescriptorForKeyword:keyDirectObject]
                        stringValue];
    
    urlStr = [urlStr stringByReplacingOccurrencesOfString:@"callto:" withString: @""];
    urlStr = [urlStr stringByReplacingOccurrencesOfString:@"tel:" withString: @""];
    
    CallService* callService = [ServiceLocator getCallService];
    [callService placeCall:urlStr];
    
}

-(void) applicationWillFinishLaunching:(NSNotification *)notification{
    
}
    

@end
