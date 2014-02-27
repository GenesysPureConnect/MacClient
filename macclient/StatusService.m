//
//  StatusService.m
//  macclient
//
//  Created by Glinski, Kevin on 2/23/14.
//  Copyright (c) 2014 ININ. All rights reserved.
//

#import "StatusService.h"
#import "constants.h"
#import "Status.h"

@implementation StatusService

NSMutableDictionary* _statusMap;
NSMutableArray* _availableStatuses;
NSString* _currentStatusId;
- (id) init
{
    self = [super init];
    
    _statusMap = [[NSMutableDictionary alloc] init];
    _availableStatuses = [[NSMutableArray alloc] init];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(onCurrentStatusChanged:)
     name: @"urn:inin.com:status:userStatusMessage"
     object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(onAllStatusesChanged:)
     name: @"urn:inin.com:status:statusMessagesMessage"
     object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(onAvailableStatusesChanged:)
     name: @"urn:inin.com:status:statusMessagesUserAccessMessage"
     object:nil];
    
    return self;
}

- (NSDictionary*) getAvailableStatuses{
    NSMutableDictionary* statuses = [[NSMutableDictionary alloc] init];
    for(int x=0; x<_availableStatuses.count; x++){
        NSString* statusId = _availableStatuses[x];
        if(_statusMap[statusId] != nil){
            [statuses setObject:_statusMap[statusId] forKey:statusId];
        }
    }
    
    return statuses;
}

-(void) notifyCurrentStatus{
    if(_statusMap[_currentStatusId] != nil){
        
        [[NSNotificationCenter defaultCenter]
         postNotificationName:kCurrentStatusChange
         object:self
         userInfo: @{@"status":_statusMap[_currentStatusId]} ] ;
        
    }

}

-(void) notifyAvailableStatusList{
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:kAvailableStatusesChanged
     object:self
     userInfo: [self getAvailableStatuses] ] ;
}


- (void) onAvailableStatusesChanged: (NSNotification*) data;
{
    NSDictionary* userInfo = [data userInfo];
    
    for(int x=0; x<[userInfo[@"statusMessagesUserAccessChanges"] count];x++)
    {
        NSDictionary* userStatuses =userInfo[@"statusMessagesUserAccessChanges"][0];
    //    if(userStatuses[@"userId"] == [self userId] )
        {
        
        NSArray* added = userStatuses[@"statusMessagesAdded"];
        [_availableStatuses addObjectsFromArray:added];
        
        NSArray* removed = userStatuses[@"statusMessagesRemoved"];
        
        for(int x=0; x<removed.count; x++)
        {
            [_availableStatuses removeObject:removed[x]];
        }
        
            [self notifyAvailableStatusList];
        }
    }
    
}

- (void) onAllStatusesChanged: (NSNotification*) data;
{
    NSDictionary* userInfo = [data userInfo];
    NSArray* added = userInfo[@"statusMessagesAdded"];
    
    for(int x=0; x<added.count; x++)
    {
        Status* newStatus =[[Status alloc] initFromDictionary:added[x] fromServer:[self serverUrl]];
        [_statusMap setObject:newStatus forKey:[newStatus id]];
    }
    
    NSArray* changed = userInfo[@"statusMessagesChanged"];
    
    for(int x=0; x<changed.count; x++)
    {
        Status* newStatus =[[Status alloc] initFromDictionary:changed[x] fromServer:[self serverUrl]];
        [_statusMap setObject:newStatus forKey:[newStatus id]];
    }
    
    NSArray* removed = userInfo[@"statusMessagesRemoved"];
    
    for(int x=0; x<removed.count; x++)
    {
        [_statusMap removeObjectForKey:removed[x]];
    }
    
    [self notifyAvailableStatusList];
    [self notifyCurrentStatus];
   
}

-(void) onCurrentStatusChanged: (NSNotification *)notification{
    
    NSDictionary* userInfo = [notification userInfo];
    NSArray* userList = userInfo[@"userStatusList"];
    
    for(int x=0; x<userList.count; x++)
    {
        _currentStatusId = userList[0][@"statusId"];
        
        [self notifyCurrentStatus];
    }
}

- (void) setStatus:(NSString*)statusId {
    NSDictionary *statusInfo = @{
                              @"statusId" : statusId
                              };
    NSString* url = [NSString stringWithFormat:@"/status/user-statuses/%@", [self userId]];
    [[self icwsClient] put:url withData:statusInfo];
}

- (void) connectionUp
{
    [[self icwsClient] put:@"/messaging/subscriptions/status/status-messages" withData:nil];
    
    
    NSDictionary *userIds = @{
                                           @"userIds" : @[ [self userId] ]
                                           };

    
    int result = [[self icwsClient] put:@"/messaging/subscriptions/status/status-messages-user-access" withData:userIds];
    
    result = [[self icwsClient] put:@"/messaging/subscriptions/status/user-statuses" withData:userIds];
}



@end
