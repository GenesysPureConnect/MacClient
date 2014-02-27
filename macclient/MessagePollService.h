//
//  MessagePollService.h
//  macclient
//
//  Created by Glinski, Kevin on 2/24/14.
//  Copyright (c) 2014 ININ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IcwsServiceBase.h"
#import "ConnectionService.h"

@interface MessagePollService : IcwsServiceBase
@property (strong) ConnectionService *connectionService;
-(void)processMessage:(NSTimer*)aTimer;
- (id) initWithIcwsClient:(IcwsClient *)client andConnectionService:(ConnectionService*)connectionService;

@end
