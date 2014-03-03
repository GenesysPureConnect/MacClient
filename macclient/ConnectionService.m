//
//  ConnectionService.m
//  macclient
//
//  Created by Glinski, Kevin on 2/23/14.
//  Copyright (c) 2014 ININ. All rights reserved.
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

- (void) connect:(NSString*) userName withPassword:(NSString*)password toServer:(NSString*)server
{
    self.isConnected = FALSE;
    NSDictionary *connectionProperties = @{
                                           @"userID" : userName,
                                           @"password" : password,
                                           @"__type" : @"urn:inin.com:connection:icAuthConnectionRequestSettings",
                                           @"applicationName" : @"Mac Client",
                                           };

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
            connectResponse = [self attemptConnection:serverList[index] withData:connectionProperties ];
            statusCode =  connectResponse[@"statusCode"];
            index++;
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
            [self sendConnectionStateChanged :true toServer:self.serverUrl withDetails:self.connectionDetails];
        }
    }

}

-(void) disconnect:(NSString*) details{
     self.isConnected = FALSE;
    self.userId = @"";
    self.serverUrl = @"";
    self.connectionDetails = details;
    
    [self sendConnectionStateChanged :false toServer:self.serverUrl withDetails:self.connectionDetails];
}


@end
