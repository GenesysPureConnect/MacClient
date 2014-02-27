//
//  StatusControllerBase.h
//  macclient
//
//  Created by Glinski, Kevin on 2/26/14.
//  Copyright (c) 2014 ININ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConnectionDependantBaseClass.h"
#import "StatusService.h"
#import "Status.h"

@interface StatusControllerBase : ConnectionDependantBaseClass

-(id) initWithStatusService: (StatusService*) statusService;
-(void) onCurrentStatusChanged: (NSNotification *)notification;
-(void) onAvailableStatusesChanged: (NSNotification *)notification;
-(NSImage *)imageResize:(NSImage*)anImage newSize:(NSSize)newSize;
-(void)updateTimeInStatus:(NSTimer*)aTimer;
-(NSString*) getTimeInStatusString;
-(void) setStatusService:(StatusService*)statusService;

- (void)statusListChanged:(NSArray*)statusList;
- (void) currentStatusChanged:(Status*) status;

@end
