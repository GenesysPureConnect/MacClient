//
//  StatusControllerBase.h
//  macclient
//
//  Created by Glinski, Kevin on 2/26/14.
//  Copyright (c) 2014 ININ. All rights reserved.
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.

#import <Foundation/Foundation.h>
#import "ConnectionDependantBaseClass.h"
#import "StatusService.h"
#import "Status.h"


//StatusControllerBase is a base class that can be used for other status type controllers
@interface StatusControllerBase : ConnectionDependantBaseClass

-(void) onCurrentStatusChanged: (NSNotification *)notification;
-(void) onAvailableStatusesChanged: (NSNotification *)notification;
-(NSImage *)imageResize:(NSImage*)anImage newSize:(NSSize)newSize;
-(void) setStatusService:(StatusService*)statusService;
- (void)statusListChanged:(NSArray*)statusList;
- (void) currentStatusChanged:(Status*) status;

@end
