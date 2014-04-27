//
//  AutoConnectService.m
//  CIC Mac Client
//
//  Created by Glinski, Kevin on 3/4/14.
//  Copyright (c) 2014 Interactive Intelligence. All rights reserved.
//

#import "AutoConnectService.h"
#import "constants.h"
#import "ServiceLocator.h"

@implementation AutoConnectService

Reachability *reach = NULL;
ConnectionService* _connectionService;

- (id) initWithConnectionService:(ConnectionService*) connectionService
{
    self = [super init];
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(reachabilityChanged:)
                                                 name: kReachabilityChangedNotification
                                               object: nil];
    
    return self;
}

- (void) connectionUp
{
    if(reach != NULL)
    {
        [reach stopNotifier];
    }
    
    reach =
    [Reachability reachabilityWithHostName: [self serverUrl]];
    [reach startNotifier];
}

-(void) doConnect
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    
    NSInteger autoLogin =[prefs integerForKey:kAutoLogIn];
    NSInteger rememberPassword =[prefs integerForKey:kRememberPassword];

    if(autoLogin == NSOnState && rememberPassword == NSOnState)
    {
        
        
        NSString *user = [prefs stringForKey:kUserName];
        NSString *password = [prefs stringForKey:kPassword];
        NSString *server = [prefs stringForKey:kServer];
        
        NSInteger workstationType = [prefs integerForKey:kWorkstationType];
        NSString* workstation = [prefs stringForKey:kWorkstationName];
        
        
        [_connectionService connect:user withPassword:password toServer:server];
        
        
        if(_connectionService.isConnected && workstationType > 0)
        {
            bool result = [_connectionService setWorkstation:workstation];
            if(!result)
            {
                [_connectionService disconnect:@"Unable to set station"];
            }
            else{
                [ServiceLocator getOtherSessionService].stationName = workstation;
            }
        }

        
    }

    
    
    
   
}

- (void) reachabilityChanged: (NSNotification *)notification {
    Reachability *reach = [notification object];
    if( [reach isKindOfClass: [Reachability class]]) {
        NetworkStatus status = [reach currentReachabilityStatus];
       
        NSLog(@"%@" ,[self stringFromStatus:status]);
        
        if(status == NotReachable)
        {
            [_connectionService disconnect:@"Unable to reach server"];
        }
        else if(![self connectionIsUp])
        {
            [self doConnect];
        }
    }
}

- (NSString *)stringFromStatus:(NetworkStatus) status {
    
    NSString *string;
    switch(status) {
        case NotReachable:
            string = @"Not Reachable";
            break;
        case ReachableViaWiFi:
            string = @"Reachable via WiFi";
            break;
        case ReachableViaWWAN:
            string = @"Reachable via WWAN";
            break;
        default:
            string = @"Unknown";
            break;
    }
    return string;
}

@end
