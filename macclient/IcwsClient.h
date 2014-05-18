//
//  IcwsClient.h
//  macclient
//
//  Created by Glinski, Kevin on 2/23/14.
//  Copyright (c) 2014 ININ. All rights reserved.
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.
//

#import <Foundation/Foundation.h>

// Wrapper around calling ICWS methods.
// This class simplifies making the requests by handling
// setting the session and cookie information
@interface IcwsClient : NSObject
-(void) setSessionInformation:(NSString*) sessionId withCookie:(NSString*)cookie withCsrfToken:(NSString*) csrfToken forServer:(NSString*) server;

-(id) get:(NSString*) url;
-(NSDictionary*) getAsDictionary:(NSString*) url;
-(NSArray*) getAsArray:(NSString*) url;

-(int) post:(NSString*) url withData:(NSDictionary*)data;
-(NSDictionary*) postWithResponseData:(NSString*) url withData:(NSDictionary*)data;
-(int) put:(NSString*) url withData:(NSDictionary*)data;

@end
