//
//  StatusService.h
//  macclient
//
//  Created by Glinski, Kevin on 2/23/14.
//  Copyright (c) 2014 ININ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IcwsServiceBase.h"

@interface StatusService : IcwsServiceBase
@property NSDate* lastStatusChange;

-(void) onCurrentStatusChanged: (NSNotification *)notification;
- (void) onAllStatusesChanged: (NSNotification*) data;
- (void) onAvailableStatusesChanged: (NSNotification*) data;
-(void) notifyAvailableStatusList;
- (NSDictionary*) getAvailableStatuses;
- (void) setStatus:(NSString*)statusId;
@end
