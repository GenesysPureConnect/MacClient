//
//  MakeCallController.m
//  macclient
//
//  Created by Glinski, Kevin on 2/27/14.
//  Copyright (c) 2014 ININ. All rights reserved.
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.

#import "MakeCallController.h"
#import "ServiceLocator.h"
#import "CallService.h"

@implementation MakeCallController

-(id) init{
    self = [super init];
    
    return self;
}

- (IBAction)numberFieldFinishedEditing:(id)sender {
    [self makeCall];
}

- (IBAction)makeCallButtonClick:(id)sender {
    [self makeCall];
}

-(void) makeCall
{
    NSString* phoneNumber = [_phoneNumberTextBox stringValue];
    if(phoneNumber.length == 0)
    {
        return;
    }
    
    CallService* callService = [ServiceLocator getCallService];
    [callService placeCall:phoneNumber];
    
    [_phoneNumberTextBox setStringValue:@""];

}



@end
