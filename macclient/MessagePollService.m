//
//  MessagePollService.m
//  macclient
//
//  Created by Glinski, Kevin on 2/24/14.
//  Copyright (c) 2014 ININ. All rights reserved.
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.
//

#import "MessagePollService.h"

@implementation MessagePollService

NSTimer* _timer;


- (id) initWithIcwsClient:(IcwsClient *)client andConnectionService:(ConnectionService*)connectionService{
    self = [super initWithIcwsClient:client];
    
    _connectionService = connectionService;
    return self;
}
-(void)processMessage:(NSTimer*)aTimer
{
 //   NSLog(@"Getting Messages: %@", aTimer);
    
    NSString *type =@"";
    NSArray* data;
    
    @try {
        data = [[self icwsClient] getAsArray: @"/messaging/messages"];
    }
    @catch (NSException *exception) {
        [_connectionService disconnect:@""];

        return;
    }
    
    
    if([data count] > 0 ){
        for(int x=0; x< [data count]; x++)
        {
            @try {
                if([data[x] isKindOfClass:[NSDictionary class]])
                {
                    NSDictionary *message = data[x] ;
                    type = message[@"__type"];
                    
                    [[NSNotificationCenter defaultCenter]
                     postNotificationName:type
                     object:self
                     userInfo: message];

                }
            }
            @catch ( NSException *e ) {
                NSLog(@"error with message type %@" , type);
                NSLog(@"%@" ,data[x]);
                [_connectionService disconnect:@""];
            }
        }
    }
}

- (void) connectionUp
{
    if(_timer ==nil)
    {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self
                                            selector:@selector(processMessage:) userInfo:nil repeats:YES];
    }
}

- (void) connectionDown
{
    if(_timer != nil)
    {
        [_timer invalidate];
        _timer = nil;
    }
}
@end
