//
//  ConnectionService.h
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
#import "IcwsServiceBase.h"

//Service that will establish the connection to CIC
@interface ConnectionService : IcwsServiceBase
@property NSString *userId;
@property NSString *serverUrl;
@property bool isConnected;
@property NSString *connectionDetails;

- (NSDictionary*) attemptConnection :(NSString*)server withData:(NSDictionary*)data;
-(void) connect:(NSString*) userName withPassword:(NSString*)password toServer:(NSString*)server;

-(NSDictionary*) getConnectionPropertiesObject:(NSString*) userName withPassword:(NSString*)password;

-(void) sendConnectionStateChanged: (bool) isConnected toServer:(NSString*) serverUrl withDetails:(NSString*) details;
-(void) disconnect:(NSString*) details;
-(BOOL) setWorkstation:(NSString*)workstation;
-(BOOL) setRemoteNumber:(NSString*)number;
@end
