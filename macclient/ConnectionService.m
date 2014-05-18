//
//  ConnectionService.m
//  macclient
//
//  Created by Glinski, Kevin on 2/23/14.
//  Copyright (c) 2014 ININ. All rights reserved.
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.
//

#import "ConnectionService.h"
#import "constants.h"

@implementation ConnectionService


-(void) sendConnectionStateChanged: (bool) isConnected toServer:(NSString*) serverUrl withDetails:(NSString*) details
{
    NSDictionary *connectionInfo = @{
                                     @"isConnected" : isConnected ? @"true": @"false" ,
                                     @"serverUrl" : serverUrl,
                                     @"details" : details,
                                     @"userId" : [self userId]
                                     };
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:kConnectionStateChangedEvent
     object:self
     userInfo: connectionInfo];
}

- (NSDictionary*) attemptConnection :(NSString*)server withData:(NSDictionary*)data
{
    NSString *restCallString = [NSString stringWithFormat:kUrlConnectBaseFormat, server , @"/connection"];
    
    // Create the URL to make the rest call.
    NSURL *restURL = [NSURL URLWithString:restCallString];
    NSMutableURLRequest *restRequest = [NSMutableURLRequest requestWithURL:restURL];
    
    NSError* error = nil;
    
    [restRequest setHTTPMethod:@"POST"];
    [restRequest setValue:@"en-us" forHTTPHeaderField:@"Accept-Language"];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    [restRequest setHTTPBody:jsonData];
    
    NSDictionary *results;
    NSHTTPURLResponse* response;
    
    NSData* result = [NSURLConnection sendSynchronousRequest:restRequest  returningResponse:&response error:&error];
    if(error != NULL)
    {
        self.userId = @"";
        NSString* errorDescription = [error userInfo][@"NSLocalizedDescription"];
        
        if(errorDescription == NULL || errorDescription.length == 0)
        {
            errorDescription = @"Unknown error connecting";
        }
        
        [self sendConnectionStateChanged :false toServer:@"" withDetails:errorDescription];
        return 0;
    }
    
    int statusCode = (int)[response statusCode];
    
    if(statusCode == 0)
    {
        self.userId = @"";
        [self sendConnectionStateChanged :false toServer:@"" withDetails:@"Unable to Contact Server"];
        return 0;
    }
    
    id object = [NSJSONSerialization
                 JSONObjectWithData:result
                 options:0
                 error:&error];
    
    if([object isKindOfClass:[NSDictionary class]])
    {
        results = object;
        
    }
    return @{@"statusCode":[NSNumber numberWithInt:statusCode],@"results":results,@"response":response};
}

-(NSDictionary*) getConnectionPropertiesObject:(NSString*) userName withPassword:(NSString*)password
{
    NSDictionary *connectionProperties = @{
                                           @"userID" : userName,
                                           @"password" : password,
                                           @"__type" : @"urn:inin.com:connection:icAuthConnectionRequestSettings",
                                           @"applicationName" : kAppName,
                                           };
    return connectionProperties;
}

- (void) connect:(NSString*) userName withPassword:(NSString*)password toServer:(NSString*)server
{
    self.isConnected = FALSE;
    NSDictionary *connectionProperties = [self getConnectionPropertiesObject: userName withPassword:password];

    NSDictionary *results;
    NSHTTPURLResponse* response;
    NSDictionary* connectResponse = [self attemptConnection:server withData:connectionProperties ];
    
    NSNumber* statusCode = connectResponse[@"statusCode"];
    
    if([statusCode intValue ] == 503)
    {
        results = connectResponse[@"results"];
        if(results==nil)
        {
            return;
        }
        //retry other servers
        NSArray* serverList = results[@"alternateHostList"];
        int index = 0;
        while ([statusCode intValue ]  == 503){
            server = serverList[index];
            connectResponse = [self attemptConnection:server withData:connectionProperties ];
            statusCode =  connectResponse[@"statusCode"];
            index++;
             results = connectResponse[@"results"];
        }
    }
    else
    {
        results = connectResponse[@"results"];
    }
    
    if(results != nil)
    {
        results = connectResponse[@"results"];
        response = connectResponse[@"response"];
        if([statusCode intValue ]  == 201){
            NSDictionary *headers = [response allHeaderFields];
            
            NSString* sessionId = results[@"sessionId"];
            NSString* cookie = headers[@"Set-Cookie"];
            NSString* csrfToken = results[@"csrfToken"];
            
            IcwsClient* client = [self icwsClient];
            [client setSessionInformation:sessionId withCookie:cookie withCsrfToken:csrfToken forServer:server];
            
            self.userId = userName;
            self.serverUrl = server;
            self.connectionDetails = @"";
             self.isConnected = TRUE;
            [self sendConnectionStateChanged :true toServer:self.serverUrl withDetails:self.connectionDetails];
        }
        else{
            self.connectionDetails = results[@"message"];
            NSLog(@"%@",  self.connectionDetails);
            [self sendConnectionStateChanged :false toServer:self.serverUrl withDetails:self.connectionDetails];
        }
    }

}
-(BOOL) setWorkstation:(NSString*)workstation
{
    NSDictionary* stationData = @{@"__type":@"urn:inin.com:connection:workstationSettings",
                                  @"supportedMediaTypes": @[@1],
                                  @"workstation":workstation};
                                  
    int statusCode = [[self icwsClient] put:@"/connection/station" withData:stationData];
    return statusCode == 200;
}

-(BOOL) setRemoteNumber:(NSString*)number
{
    NSDictionary* stationData = @{@"__type":@"urn:inin.com:connection:remoteNumberSettings",
                                  @"supportedMediaTypes": @[@1],
                                  @"remoteNumber":number};
    
    int statusCode = [[self icwsClient] put:@"/connection/station" withData:stationData];
    return statusCode == 200;
}

-(void) disconnect:(NSString*) details{
     self.isConnected = FALSE;
    self.userId = @"";
    self.serverUrl = @"";
    self.connectionDetails = details;
    
    [self sendConnectionStateChanged :false toServer:self.serverUrl withDetails:self.connectionDetails];
}


@end
