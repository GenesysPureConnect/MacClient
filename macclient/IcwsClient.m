//
//  IcwsClient.m
//  macclient
//
//  Created by Glinski, Kevin on 2/23/14.
//  Copyright (c) 2014 ININ. All rights reserved.
//

#import "IcwsClient.h"
#import "constants.h"

@implementation IcwsClient
NSString *_sessionId;
NSString *_cookie;
NSString* _csrfToken;
NSString* _server;

-(void) setSessionInformation:(NSString*) sessionId withCookie:(NSString*)cookie withCsrfToken:(NSString*) csrfToken forServer:(NSString*) server
{
    _sessionId = sessionId;
    _cookie = cookie;
    _csrfToken = csrfToken;
    _server = server;
}

-(NSMutableURLRequest *) createRequest: (NSString*) url
{
    return [self createRequest: url withData:nil];
}

-(NSMutableURLRequest*) createRequest: (NSString*) url withData:(NSDictionary*) data
{
    NSString* fullUrl = [NSString stringWithFormat:kUrlRequestBaseFormat, _server,_sessionId,url];
    
    // Create the URL to make the rest call.
    NSURL *restURL = [NSURL URLWithString:fullUrl];
    
    NSMutableURLRequest *restRequest = [NSMutableURLRequest requestWithURL:restURL];
    
    NSError* error = nil;
    
    [restRequest setValue:_cookie forHTTPHeaderField:@"Cookie"];
    [restRequest setValue:_csrfToken forHTTPHeaderField:@"ININ-ICWS-CSRF-Token"];
    
    if(data != nil)
    {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
        [restRequest setHTTPBody:jsonData];
    }
    
    return restRequest;
}

-(id) get:(NSString*) url
{
    @try
    {
        NSMutableURLRequest* restRequest = [self createRequest:url];
    
        NSError* error = nil;
        NSHTTPURLResponse* response;
    
        NSData* result = [NSURLConnection sendSynchronousRequest:restRequest  returningResponse:&response error:&error];
        int statusCode = (int)[response statusCode];
   
        if(statusCode != 200){
            [NSException raise:@"Error getting data" format:@"%d", statusCode];
            return [[NSDictionary alloc] init];
        }
        id object = [NSJSONSerialization
                 JSONObjectWithData:result
                 options:0
                 error:&error];
    
   
        return object;
    }
    @catch (NSException *exception)
    {
        // Print exception information
        NSLog( @"NSException caught during get" );
        NSLog( @"Name: %@", exception.name);
        NSLog( @"Reason: %@", exception.reason );
        @throw exception;
    }
}

-(NSDictionary*) getAsDictionary:(NSString*) url
{
    id object = [self get:url];
    if([object isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *results = object;
        return results;
    }
    return [[NSDictionary alloc] init];
}

-(NSArray*) getAsArray:(NSString*) url
{
    
    id object = [self get:url];
    if([object isKindOfClass:[NSArray class]])
    {
        NSArray *results = object;
        return results;
    }
    return [[NSArray alloc] init];
}

-(int) post:(NSString*) url withData:(NSDictionary*)data
{
    int statusCode = 0;
    NSError* error = nil;
    @try
    {
        NSMutableURLRequest* restRequest = [self createRequest:url withData:data];
        [restRequest setHTTPMethod:@"POST"];
        
        
        NSHTTPURLResponse* response;
        
        [NSURLConnection sendSynchronousRequest:restRequest  returningResponse:&response error:&error];
        if (error) {
            NSLog(@"Error in POST %@ %@", url, [error userInfo]);
        }
        statusCode = (int)[response statusCode];
        return statusCode;
    }
    @catch (NSException *exception)
    {
        
        // Print exception information
        NSLog( @"NSException caught during POST %@" ,url );
        NSLog( @"Name: %@", exception.name);
        NSLog( @"Reason: %@", exception.reason );
        
        return statusCode;
    }
}


-(int) put:(NSString*) url withData:(NSDictionary*)data
{
    int statusCode = 0;
    NSError* error = nil;
    @try
    {
        NSMutableURLRequest* restRequest = [self createRequest:url withData:data];
        [restRequest setHTTPMethod:@"PUT"];
    
       
        NSHTTPURLResponse* response;
    
        [NSURLConnection sendSynchronousRequest:restRequest  returningResponse:&response error:&error];
        if (error) {
            NSLog(@"Error in PUT %@ %@", url, [error userInfo]);
        }
        statusCode = (int)[response statusCode];
        return statusCode;
    }
    @catch (NSException *exception)
    {
        // Print exception information
        NSLog( @"NSException caught during put %@" ,url );
        NSLog( @"Name: %@", exception.name);
        NSLog( @"Reason: %@", exception.reason );
        
        return statusCode;
    }
}



@end
