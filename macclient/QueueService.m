//
//  QueueService.m
//  CIC Mac Client
//
//  Created by Glinski, Kevin on 2/27/14.
//  Copyright (c) 2014 Interactive Intelligence. All rights reserved.
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.
//

#import "QueueService.h"
#import "Interaction.h"
#import "constants.h"

@implementation QueueService
NSString *_subscriptionId;
IcwsClient* _icwsClient;
NSMutableDictionary* _queueMap;

-(id) initMyInteractionsQueue:(IcwsClient*) icwsClient isConnected:(BOOL)isConnected withUser:(NSString*) user;
{
    self = [super initWithIcwsClient:icwsClient];
    _icwsClient = icwsClient;
    _queueMap = [[NSMutableDictionary alloc] init];
    CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
    _subscriptionId = (__bridge_transfer NSString *)CFUUIDCreateString(kCFAllocatorDefault, uuid);
    CFRelease(uuid);
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(onQueueContentsChanged:)
     name: @"urn:inin.com:queues:queueContentsMessage"
     object:nil];
    
    if(isConnected)
    {
        self.userId = user;
        [self connectionUp];
    }
    
    return self;
}

-(void) connectionUp{
    
    [_queueMap removeAllObjects];
    
    NSDictionary* data = @{@"queueIds":@[@{@"queueType":@"1", @"queueName":[self userId]}],
                           @"attributeNames":@[kAttributeState, kAttributeRemoteName, kAttributeRemoteNumber,
                                               kAttributeCallStateString,
                                               kAttributeCapabilities,
                                               kAttributeMuted,
                                               kAttributeInitiationTime,
                                               kAttributeConferenceId]};
                                           
    [_icwsClient put:[NSString stringWithFormat:@"/messaging/subscriptions/queues/%@", _subscriptionId] withData:data];
};

- (void) onQueueContentsChanged: (NSNotification*) data;
{
    @try
    {
        
        NSDictionary* queueInfo = [data userInfo];
    
        if(![_subscriptionId isEqualToString: queueInfo[@"subscriptionId"]]){
            return;
        }
    
        NSArray* interactionsAdded = queueInfo[@"interactionsAdded"] ;
        if(interactionsAdded != NULL)
        {
            for(int x=0; x<[interactionsAdded count];x++)
            {
                NSDictionary* interactionData = interactionsAdded[x];
                
                if(![[interactionData allKeys] containsObject:@"conferenceParentId"] || [interactionData[@"conferenceParentId"] isEqualToString:@""])
                {
                    Interaction* interaction = [[Interaction alloc] initWithId:interactionData[@"interactionId"]];
                    [interaction setAttributes:interactionData[@"attributes"]];
        
                    if([interaction interactionType] == Call){
                        [_queueMap setObject:interaction forKey:interactionData[@"interactionId"]];
                    }
                }
            }
        }
    
        NSArray* interactionsChanged = queueInfo[@"interactionsChanged"] ;
    
        if(interactionsChanged != NULL)
        {
            for(int x=0; x<[interactionsChanged count];x++)
            {
                NSDictionary* interactionData = interactionsChanged[x];
                Interaction* interaction = _queueMap[interactionData[@"interactionId"]];
                if(interaction != NULL){
                    [interaction setAttributes:interactionData[@"attributes"]];
                }
               
            }
        }
    
        NSArray* interactionsRemoved = queueInfo[@"interactionsRemoved"] ;
    
        if(interactionsRemoved != NULL)
        {
            for(int x=0; x<[interactionsRemoved count];x++)
            {
                NSString* callId = interactionsRemoved[x];
                [_queueMap removeObjectForKey:callId];
            }
        }

        [self setValue:[_queueMap allValues] forKey:@"queueList"];

    }
    @catch ( NSException *e ) {
           // NSLog(type);
    }
    
}

-(NSString*) getActionUrl:(NSString*)action forInteraction:(NSString*) interactionId
{
    return [NSString stringWithFormat:@"/interactions/%@/%@", interactionId, action];
}

-(void) muteInteraction:(Interaction*) interaction muteOn:(BOOL)muteOn
{
    NSString* on = muteOn ? @"1" : @"0";
    [_icwsClient post:[self getActionUrl:@"mute" forInteraction:[interaction interactionId]] withData:@{@"on":on}];
}
-(void) holdInteraction:(Interaction*) interaction holdOn:(BOOL)holdOn
{
    NSString* on = holdOn ? @"1" : @"0";
    [_icwsClient post:[self getActionUrl:@"hold" forInteraction:[interaction interactionId]] withData:@{@"on":on}];
}
-(void) pickupInteraction:(Interaction*) interaction
{
        [_icwsClient post:[self getActionUrl:@"pickup" forInteraction:[interaction interactionId]] withData:@{}];
}
-(void) disconnectInteraction:(Interaction*) interaction
{
        [_icwsClient post:[self getActionUrl:@"disconnect" forInteraction:[interaction interactionId]] withData:@{}];
}

-(void) conferenceInteractions:(Interaction*) firstInteraction withSecond:(Interaction*) secondInteraction{
    [_icwsClient post:@"/interactions/conferences" withData:@{@"interactions":@[firstInteraction.interactionId, secondInteraction.interactionId]}];

}
-(void) addToConference:(Interaction*) interaction toConference:(Interaction*) conferenceInteraction{
    [_icwsClient post:[NSString stringWithFormat:@"/interactions/conferences/%@", conferenceInteraction.interactionId] withData:@{@"interactions":@[interaction.interactionId]}];
}

@end
