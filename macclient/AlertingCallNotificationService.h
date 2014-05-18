//
//  AlertingCallNotificationService.h
//  CIC Mac Client
//
//  Created by Glinski, Kevin on 4/28/14.
//  Copyright (c) 2014 Interactive Intelligence. All rights reserved.
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.
//

#import <Foundation/Foundation.h>
#import "ConnectionDependantBaseClass.h"
#import "Interaction.h"

// This service is responsible for the Ringing and toast when an
// alerting call is on the user's queue.
@interface AlertingCallNotificationService : ConnectionDependantBaseClass

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context;

-(void)ignoreCall:(Interaction*) interaction;
-(void)pickupCall:(Interaction*) interaction;

@end
