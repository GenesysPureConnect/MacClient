//
//  ServiceLocator.m
//  macclient
//
//  Created by Glinski, Kevin on 2/26/14.
//  Copyright (c) 2014 ININ. All rights reserved.
//

#import "ServiceLocator.h"

static NSDictionary* s_fooDict;
static StatusService* s_statusService;
static IcwsClient* s_icwsClient;

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
@end

