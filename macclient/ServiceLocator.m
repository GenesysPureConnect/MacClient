//
//  ServiceLocator.m
//  macclient
//
//  Created by Glinski, Kevin on 2/26/14.
//  Copyright (c) 2014 ININ. All rights reserved.
//

#import "ServiceLocator.h"
#import "CallService.h"
#import "QueueService.h"
#import "ConnectionService.h"

static NSDictionary* s_fooDict;
static IcwsClient* s_icwsClient;
static CallService* s_callService;
static StatusService* s_statusService;
static ConnectionService* s_connectionService;

@implementation ServiceLocator

+(IcwsClient*) getIcwsClient{
    if(s_icwsClient == nil)
    {
        s_icwsClient = [[IcwsClient alloc] init];
    }
    return s_icwsClient;
}

+(StatusService*) getStatusService
{
    if (s_statusService == nil)
    {
        s_statusService = [[StatusService alloc] initWithIcwsClient:[self getIcwsClient]];
    }
    
    return s_statusService;
}

+(CallService*) getCallService
{
    if (s_callService == nil)
    {
        s_callService = [[CallService alloc] initWithIcwsClient:[self getIcwsClient]];
    }
    
    return s_callService;
}

+(ConnectionService*) getConnectionService{
    if (s_connectionService == nil)
    {
        s_connectionService = [[ConnectionService alloc] initWithIcwsClient:[self getIcwsClient]];
    }
    
    return s_connectionService;
}

+(QueueService*) getQueueService
{
    QueueService* queue =  [[QueueService alloc] initMyInteractionsQueue:[self getIcwsClient] isConnected:[[self getConnectionService] isConnected] withUser:[[self getConnectionService] userId]];

    return queue;
}

                            

@end

