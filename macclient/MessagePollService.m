//
//  MessagePollService.m
//  macclient
//
//  Created by Glinski, Kevin on 2/24/14.
//  Copyright (c) 2014 ININ. All rights reserved.
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
    NSLog(@"Getting Messages: %@", aTimer);
    @try {
    
        NSArray* data = [[self icwsClient] getAsArray: @"/messaging/messages"];
  //  NSLog(data);
        if([data count] > 0 ){
            for(int x=0; x< [data count]; x++)
            {
                if([data[x] isKindOfClass:[NSDictionary class]])
                {
                    NSDictionary *message = data[x] ;
                    NSString *type = message[@"__type"];
                    
                    [[NSNotificationCenter defaultCenter]
                     postNotificationName:type
                     object:self
                     userInfo: message];

                }
            }
        }
    }
    
    @catch ( NSException *e ) {
        [_connectionService disconnect:@""];
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
