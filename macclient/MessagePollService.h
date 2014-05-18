//
//  MessagePollService.h
//  macclient
//
//  Created by Glinski, Kevin on 2/24/14.
//  Copyright (c) 2014 ININ. All rights reserved.
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.
//

#import <Foundation/Foundation.h>
#import "IcwsServiceBase.h"
#import "ConnectionService.h"


//Class to get messages from CIC and then delegate them out to the services that are listening
// for the message type.
@interface MessagePollService : IcwsServiceBase
@property (strong) ConnectionService *connectionService;
-(void)processMessage:(NSTimer*)aTimer;
- (id) initWithIcwsClient:(IcwsClient *)client andConnectionService:(ConnectionService*)connectionService;

@end
