//
//  IcwsClient.h
//  macclient
//
//  Created by Glinski, Kevin on 2/23/14.
//  Copyright (c) 2014 ININ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IcwsClient : NSObject
-(void) setSessionInformation:(NSString*) sessionId withCookie:(NSString*)cookie withCsrfToken:(NSString*) csrfToken forServer:(NSString*) server;

-(id) get:(NSString*) url;
-(NSDictionary*) getAsDictionary:(NSString*) url;
-(NSArray*) getAsArray:(NSString*) url;

-(int) post:(NSString*) url withData:(NSDictionary*)data;
-(NSDictionary*) postWithResponseData:(NSString*) url withData:(NSDictionary*)data;
-(int) put:(NSString*) url withData:(NSDictionary*)data;

@end
