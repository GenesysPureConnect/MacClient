//
//  AlertingCallNotificationService.h
//  CIC Mac Client
//
//  Created by Glinski, Kevin on 4/28/14.
//  Copyright (c) 2014 Interactive Intelligence. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConnectionDependantBaseClass.h"
#import "Interaction.h"

@interface AlertingCallNotificationService : ConnectionDependantBaseClass

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context;

-(void)ignoreCall:(Interaction*) interaction;
-(void)pickupCall:(Interaction*) interaction;

@end
