//
//  ServiceLocator.h
//  macclient
//
//  Created by Glinski, Kevin on 2/26/14.
//  Copyright (c) 2014 ININ. All rights reserved.
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.
//

#import <Foundation/Foundation.h>
#import "IcwsClient.h"
#import "StatusService.h"
#import "CallService.h"
#import "QueueService.h"
#import "ConnectionService.h"
#import "OtherSessionService.h"
#import "TestConnection.h"
#import "DirectoryService.h"
#import "InteractionHistoryService.h"

//Simple Service locator to get instances of different services.
@interface ServiceLocator : NSObject
+(IcwsClient*) getIcwsClient;
+(StatusService*) getStatusService;
+(CallService*) getCallService;
+(QueueService*) getMyInteractionsQueueService;
+(TestConnection*) getConnectionService;
+(OtherSessionService*) getOtherSessionService;
+(DirectoryService*) getDirectoryService;
+(InteractionHistoryService*) getInteractionHistoryService;
@end
