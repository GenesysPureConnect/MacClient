//
//  StatusBarService.h
//  macclient
//
//  Created by Glinski, Kevin on 2/22/14.
//  Copyright (c) 2014 ININ. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "IcwsServiceBase.h"
#import "IcwsClient.h"
#import "StatusService.h"
#import "StatusControllerBase.h"
#import "OtherSessionService.h"

@interface StatusBarController : StatusControllerBase 

@property (strong, nonatomic) NSStatusItem *rootStatusItem;
-(void) setOtherSessionService:(OtherSessionService*)sessionService;

- (void)activateStatusMenu;
- (void)setStatus:(id)sender;
- (void)exit:(id)sender;

@end

