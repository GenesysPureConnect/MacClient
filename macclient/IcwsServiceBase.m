//
//  IcwsServiceBase.m
//  macclient
//
//  Created by Glinski, Kevin on 2/23/14.
//  Copyright (c) 2014 ININ. All rights reserved.
//

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
