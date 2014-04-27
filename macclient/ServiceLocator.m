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
#import "TestConnection.h"

static NSDictionary* s_fooDict;
static IcwsClient* s_icwsClient;
static CallService* s_callService;
static StatusService* s_statusService;
static TestConnection* s_connectionService;
static OtherSessionService* s_otherSessionService;
static DirectoryService* s_directoryService;

@implementation ServiceLocator

+(OtherSessionService*) getOtherSessionService{
    if (s_statusService == nil)
    {
        s_otherSessionService = [[OtherSessionService alloc] initWithIcwsClient:[self getIcwsClient]];
    }
    
    return s_otherSessionService;
}

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
        s_otherSessionService = [[OtherSessionService alloc] initWithIcwsClient:[self getIcwsClient]];
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

+(TestConnection*) getConnectionService{
    if (s_connectionService == nil)
    {
        s_connectionService = [[TestConnection alloc] initWithIcwsClient:[self getIcwsClient]];
    }
    
    return s_connectionService;
}

+(QueueService*) getQueueService
{
    QueueService* queue =  [[QueueService alloc] initMyInteractionsQueue:[self getIcwsClient] isConnected:[[self getConnectionService] isConnected] withUser:[[self getConnectionService] userId]];

    return queue;
}

+(DirectoryService*) getDirectoryService{
    if (s_directoryService == nil)
    {
        s_directoryService = [[DirectoryService alloc] initWithIcwsClient:[self getIcwsClient]];
    }
    
    return s_directoryService;
}

@end

