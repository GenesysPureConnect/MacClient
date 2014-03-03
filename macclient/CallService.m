//
//  CallService.m
//  macclient
//
//  Created by Glinski, Kevin on 2/27/14.
//  Copyright (c) 2014 ININ. All rights reserved.
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
