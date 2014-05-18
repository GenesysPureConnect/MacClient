//
//  AlertingCallNotificationService.m
//  CIC Mac Client
//
//  Created by Glinski, Kevin on 4/28/14.
//  Copyright (c) 2014 Interactive Intelligence. All rights reserved.
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.
//

#import "AlertingCallNotificationService.h"
#import "ServiceLocator.h"
#import "InteractionToastController.h"
#import "constants.h"


@implementation AlertingCallNotificationService

NSMutableArray* _alertingInteractions;
NSMutableDictionary* _toastMap;
QueueService* _queueService;
NSSound* _alertingSound;


- (void) connectionUp
{
    _queueService = [ServiceLocator getMyInteractionsQueueService];
    [_queueService addObserver:self forKeyPath:@"queueList" options:NSKeyValueObservingOptionNew context:NULL];
    
    _alertingInteractions  = [[NSMutableArray alloc] init];
    _toastMap = [[NSMutableDictionary alloc] init];
}

-(void)ignoreCall:(Interaction*) interaction{
    @try
    {
        if([_alertingInteractions containsObject:interaction.interactionId]){
            InteractionToastController* toast = (InteractionToastController*)_toastMap[interaction.interactionId];
        
            [toast closeWindow];
        
            [_toastMap removeObjectForKey: interaction.interactionId];
        
            [_alertingInteractions removeObject:interaction.interactionId ];
        }
    }
    @catch(NSException * exception){
        
    }
}

-(void)pickupCall:(Interaction*) interaction{
    [_queueService pickupInteraction:interaction];
}


-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSArray* interactions = [change objectForKey:NSKeyValueChangeNewKey];
    
    for(int x=0; x< interactions.count ; x++){
        Interaction* interaction = interactions[x];
        
        NSString* interactionId = [interaction interactionId];
        
        if([_alertingInteractions containsObject:interactionId] && ![interaction isAlerting ]){
            [self ignoreCall:interaction];
        }
        else if(![_alertingInteractions containsObject:interactionId] && [interaction isAlerting ]){
            InteractionToastController *controller  = [[InteractionToastController alloc] initWithWindowNibName:@"InteractionToastView"];
            [controller showWindow:nil];
            [[controller toastWindow] orderFrontRegardless];
            [controller setup:self forInteraction:interaction];
             
            [_toastMap setValue:controller forKey:interactionId];
            [_alertingInteractions addObject:interactionId];
        }
    }
    
    if(interactions.count ==0 && _alertingInteractions.count !=  0){
        
        for(int x=0; x< _alertingInteractions.count; x++){
            InteractionToastController* toast = (InteractionToastController*)_toastMap[_alertingInteractions[x]];
            [toast closeWindow];
        }
        
        [_alertingInteractions removeAllObjects];
        [_toastMap removeAllObjects];
    }
    
    
    if(_alertingSound == NULL && _alertingInteractions.count > 0)
    {
        _alertingSound = [[NSSound alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"RingCall" ofType:@"mp3"] byReference:NO];
        [_alertingSound play];
       
    }
    else if(_alertingSound != NULL && _alertingInteractions.count == 0)
    {
        [_alertingSound stop];
        _alertingSound = NULL;
    }
    
}
@end
