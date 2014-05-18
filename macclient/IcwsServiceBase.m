//
//  IcwsServiceBase.m
//  macclient
//
//  Created by Glinski, Kevin on 2/23/14.
//  Copyright (c) 2014 ININ. All rights reserved.
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.

#import "IcwsServiceBase.h"
#import "constants.h"

@implementation IcwsServiceBase


- (id) initWithIcwsClient:(IcwsClient *)client
{
    self = [self init];
    if (self) {
        _icwsClient= client;
    }
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(connectionStateChanged:)
     name: kConnectionStateChangedEvent
     object:nil];
    
    return self;
}

@end
