//
//  ServiceLocator.h
//  macclient
//
//  Created by Glinski, Kevin on 2/26/14.
//  Copyright (c) 2014 ININ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IcwsClient.h"
#import "StatusService.h"
#import "CallService.h"
#import "QueueService.h"
#import "ConnectionService.h"

@interface ServiceLocator : NSObject
+(IcwsClient*) getIcwsClient;
+(StatusService*) getStatusService;
+(CallService*) getCallService;
+(QueueService*) getQueueService;
+(ConnectionService*) getConnectionService;
@end
