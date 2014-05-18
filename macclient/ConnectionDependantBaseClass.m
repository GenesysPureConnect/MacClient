//
//  ConnectionDependantBaseClass.m
//  macclient
//
//  Created by Glinski, Kevin on 2/24/14.
//  Copyright (c) 2014 ININ. All rights reserved.
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.

#import "ConnectionDependantBaseClass.h"
#import "constants.h"

@implementation ConnectionDependantBaseClass

- (id) init
{
    self = [super init];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(connectionStateChanged:)
     name: kConnectionStateChangedEvent
     object:nil];
    
    return self;
}


- (void) connectionUp{ }
- (void) connectionDown{}

-(void) connectionStateChanged: (NSNotification *)notification{
    NSDictionary* params = [notification userInfo];
    
    _serverUrl = params[@"serverUrl"];
    _userId = params[@"userId"];

    if([params[@"isConnected"]  isEqual: @"true"]){
        self.connectionIsUp = true;
        [self connectionUp];
    }
    else{
        self.connectionIsUp = false;
        
        [self connectionDown ];
    }
}

@end
