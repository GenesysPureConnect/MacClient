//
//  AutoConnectService.h
//  CIC Mac Client
//
//  Created by Glinski, Kevin on 3/4/14.
//  Copyright (c) 2014 Interactive Intelligence. All rights reserved.
//

#import "ConnectionDependantBaseClass.h"
#import "Reachability.h"
#import "ConnectionService.h"

@interface AutoConnectService :ConnectionDependantBaseClass

- (id) initWithConnectionService:(ConnectionService*) connectionService;
- (void) reachabilityChanged: (NSNotification *)notification ;
- (NSString *)stringFromStatus:(NetworkStatus) status ;
@end
