//
//  CallService.m
//  macclient
//
//  Created by Glinski, Kevin on 2/27/14.
//  Copyright (c) 2014 ININ. All rights reserved.
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.
//

#import "CallService.h"

@implementation CallService
-(void) placeCall:(NSString*)number
{
    NSDictionary *callInfo = @{
                                 @"__type" : @"urn:inin.com:interactions:createCallParameters",
                                 @"target": number
                                 
                                 };
    [[self icwsClient] post:@"/interactions" withData:callInfo];
}

@end
