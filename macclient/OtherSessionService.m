//
//  OtherSessionService.m
//  CIC Mac Client
//
//  Created by Glinski, Kevin on 3/3/14.
//  Copyright (c) 2014 Interactive Intelligence. All rights reserved.
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.
//

#import "OtherSessionService.h"

@implementation OtherSessionService

- (id) init
{
    self = [super init];
    
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(onSessionChanged:)
     name: @"urn:inin.com:session:sessionsMessage"
     object:nil];

    return self;
}


- (void) onSessionChanged: (NSNotification*) data
{
    NSDictionary* sessionInfoList = [data userInfo];
    
    for(int x=0; x<[sessionInfoList[@"sessionsRemoved"] count];x++)
    {
        NSDictionary* sessionInfo =sessionInfoList[@"sessionsRemoved"][x];
        if([[sessionInfo[@"userId"][@"id"] lowercaseString] isEqualToString:[[self userId] lowercaseString]])
        {
            if([sessionInfo[@"stationId"][@"id"] isEqualToString:[self stationName]])
            {
                NSString* value = @"";
                [self setValue:value forKey:@"stationName"];
                NSLog(@"Station cleared");
            }
        }
    }
    
    for(int x=0; x<[sessionInfoList[@"sessionsAdded"] count];x++)
    {
        NSDictionary* sessionInfo =sessionInfoList[@"sessionsAdded"][x];

        if([[sessionInfo[@"userId"][@"id"] lowercaseString] isEqualToString:[[self userId] lowercaseString]])
        {
            NSString* stationId = sessionInfo[@"stationId"][@"id"];
            if(![stationId isEqualToString:@""] && ![stationId isEqualToString:@"STATIONLESS"])
            {
                NSLog(@"Found user logged into a station");
                [self setValue:sessionInfo[@"stationId"][@"id"] forKey:@"stationName"];
                
            }
        }
    }
}



- (void) connectionUp
{
    NSString* value = @"";
    [self setValue:value forKey:@"stationName"];
    
    NSDictionary *userIds = @{
                              @"userIds" : @[ [self userId] ]
                              };
    
    [[self icwsClient] put:@"/messaging/subscriptions/session/sessions-users" withData:userIds];
   
}




@end
