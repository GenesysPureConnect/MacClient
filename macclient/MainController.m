//
//  ClientController.m
//  macclient
//
//  Created by Glinski, Kevin on 2/24/14.
//  Copyright (c) 2014 ININ. All rights reserved.
//

#import "MainController.h"
#import "ConnectionService.h"
#import "StatusService.h"
#import "MessagePollService.h"
#import "StatusBarController.h"
#import "LoginViewController.h"
#import "constants.h"
#import "ClientViewController.h"
#import "ServiceLocator.h"

@implementation MainController

MessagePollService* _pollService;
StatusBarController * _statusBarController;
StatusService *_statusService;
ConnectionService *_connectionService;


-(void) awakeFromNib{
    [self setupServices];
    [self showLoginDialog];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(connectionStateChanged:)
     name: kConnectionStateChangedEvent
     object:nil];

}

-(void) showLoginDialog{
    if ([_currentViewController isKindOfClass:[LoginViewController class]])
    {
        return;
    }
    
    LoginViewController* c = [[LoginViewController alloc]initWithNibName:@"LoginView" bundle:nil];
    c.connectionService = _connectionService;
    [self setView:c];
}

-(void) showClientDialog{
    if ([_currentViewController isKindOfClass:[ClientViewController class]])
    {
        return;
    }
    
    
    ClientViewController* c = [[ClientViewController alloc]initWithNibName:@"ClientView" bundle:nil];
    [self setView:c];
    
}

-(void) setView:(NSViewController*) controller{
    
    @try {
        
        [[_currentViewController view ]removeFromSuperview ];
        
        self.currentViewController = controller;
        
        [_mainView addSubview:[_currentViewController view]];
//        [[_mainView window] setContentSize:_currentViewController.view.bounds.size ];
   //     [[_mainView window] setContentView:_currentViewController.view];
    }
    @catch (NSException *exception) {
        NSLog(exception);
    }
   
  
}

-(void) connectionStateChanged: (NSNotification *)notification{
    NSDictionary* params = [notification userInfo];
    
    if([params[@"isConnected"]  isEqual: @"true"]){
        [self showClientDialog ];
    }
    else{
        [self showLoginDialog ];
    }
}


-(void) setupServices{
    
    IcwsClient* client = [ServiceLocator getIcwsClient];
    
    _statusService = [ServiceLocator getStatusService];
    
    _statusBarController = [[StatusBarController alloc]init];
    [_statusBarController setStatusService:_statusService];
    
    
    _connectionService = [[ConnectionService alloc] initWithIcwsClient:client];
    
    _pollService = [[MessagePollService alloc] initWithIcwsClient:client andConnectionService:(ConnectionService*)_connectionService];
    

}
@end
