//
//  QueueService.h
//  CIC Mac Client
//
//  Created by Glinski, Kevin on 2/27/14.
//  Copyright (c) 2014 Interactive Intelligence. All rights reserved.
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.
//

#import "IcwsServiceBase.h"
#import "Interaction.h"
@interface QueueService : IcwsServiceBase

-(id) initMyInteractionsQueue:(IcwsClient*) icwsClient isConnected:(BOOL)isConnected withUser:(NSString*) user;
- (void) onQueueContentsChanged: (NSNotification*) data;
@property NSArray* queueList;

-(NSString*) getActionUrl:(NSString*)action forInteraction:(NSString*) interactionId;
-(void) muteInteraction:(Interaction*) interaction  muteOn:(BOOL)muteOn;
-(void) holdInteraction:(Interaction*) interaction holdOn:(BOOL)holdOn;
-(void) pickupInteraction:(Interaction*) interaction;
-(void) recordInteraction:(Interaction*) interaction recordOn:(BOOL)recordOn;
-(void) disconnectInteraction:(Interaction*) interaction;
-(void) conferenceInteractions:(Interaction*) firstInteraction withSecond:(Interaction*) secondInteraction;
-(void) addToConference:(Interaction*) interaction toConference:(Interaction*) conferenceInteraction;
@end
