//
//  AutoConnectService.h
//  CIC Mac Client
//
//  Created by Glinski, Kevin on 3/4/14.
//  Copyright (c) 2014 Interactive Intelligence. All rights reserved.
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.
//

#import "ConnectionDependantBaseClass.h"
#import "Reachability.h"
#import "ConnectionService.h"

// This service uses the reachability api and will automatically issue
// a connect when the cic server is available on the network.
// This could happen when a VPN is established and the Mac is now
// on the same network as the CIC server
@interface AutoConnectService :ConnectionDependantBaseClass

- (id) initWithConnectionService:(ConnectionService*) connectionService;
- (void) reachabilityChanged: (NSNotification *)notification ;
- (NSString *)stringFromStatus:(NetworkStatus) status ;
@end
