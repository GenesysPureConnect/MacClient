//
//  ConnectionService.h
//  macclient
//
//  Created by Glinski, Kevin on 2/23/14.
//  Copyright (c) 2014 ININ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IcwsServiceBase.h"

@interface ConnectionService : IcwsServiceBase
@property NSString *userId;
@property NSString *serverUrl;
@property bool isConnected;
@property NSString *connectionDetails;

- (int) attemptConnection :(NSString*)server withData:(NSDictionary*)data getResult:(NSDictionary*)results getResponse:(NSHTTPURLResponse*)response;

- (void) connect:(NSString*) userName withPassword:(NSString*)password toServer:(NSString*)server;

-(void) sendConnectionStateChanged: (bool) isConnected toServer:(NSString*) serverUrl withDetails:(NSString*) details;
-(void) disconnect:(NSString*) details;
@end
