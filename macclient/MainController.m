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
#import "QueueService.h"
#import "OtherSessionService.h"
#import "AutoConnectService.h"
#import "AlertingCallNotificationService.h"

@implementation MainController

MessagePollService* _pollService;
StatusBarController * _statusBarController;
StatusService *_statusService;
ConnectionService *_connectionService;
QueueService *_myQueue;
LoginViewController* _loginController;
ClientViewController *_clientViewController;
AutoConnectService *_autoConnectService;
AlertingCallNotificationService* _alertingCallNotificationService;

NSButton* closeButton;

-(void) awakeFromNib{
    [self setupServices];
    [self showLoginDialog];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(connectionStateChanged:)
     name: kConnectionStateChangedEvent
     object:nil];

    closeButton = [[_mainView window] standardWindowButton:NSWindowCloseButton];
    [closeButton setTarget:self];
    [closeButton setAction:@selector(closeThisWindow:)];

    
    NSDockTile *tile = [[NSApplication sharedApplication] dockTile];
    [tile setBadgeLabel:@"X"];
}

-(void)closeThisWindow: (id) sender {
  //  [[_mainView window] miniaturize:];
}

-(void) showLoginDialog{
    if ([_currentViewController isKindOfClass:[LoginViewController class]])
    {
        return;
    }
   
    if(_loginController == NULL){
        _loginController = [[LoginViewController alloc]initWithNibName:@"LoginView" bundle:nil];
        [_loginController setConnectionService:_connectionService];
        [_mainView addSubview:[_loginController view]];
        [_loginController loadSavedData];
    }
    
    [[_clientViewController view] setHidden:true];
 
    [self setView: _loginController];

}

-(void) showClientDialog{
    if ([_currentViewController isKindOfClass:[ClientViewController class]])
    {
        return;
    }

    if(_clientViewController == NULL){
        
        _clientViewController = [[ClientViewController alloc]initWithNibName:@"ClientView" bundle:nil];
        [_mainView addSubview:[_clientViewController view]];
        
    }
    [[_loginController view] setHidden:true];
   
    [self setView: _clientViewController];
}

-(void) setView:(NSViewController*) controller{
    
    @try {
        NSSize size = controller.view.bounds.size;
        size.height = size.height + 20;
        [[_mainView window] setContentSize: size];
       // controller.view.frame = CGRectMake(0, 40, controller.view.frame.size.width, controller.view.frame.size.height);
        [[controller view] setHidden:false];
        _currentViewController = controller;
    }
    @catch (NSException *exception) {
        //NSLog(exception);
    }
}

-(void) connectionStateChanged: (NSNotification *)notification{
    NSDictionary* params = [notification userInfo];
    
    NSDockTile *tile = [[NSApplication sharedApplication] dockTile];
    
    if([params[@"isConnected"]  isEqual: @"true"]){
        [self showClientDialog ];
        [tile setBadgeLabel:NULL];
    }
    else{
        [self showLoginDialog ];
        [tile setBadgeLabel:@"X"];
    }
}


-(void) setupServices{
    
    IcwsClient* client = [ServiceLocator getIcwsClient];
    
    _statusService = [ServiceLocator getStatusService];
    
    _statusBarController = [[StatusBarController alloc]init];
    [_statusBarController setOtherSessionService:[ServiceLocator getOtherSessionService]];
    [_statusBarController setStatusService:_statusService];
    
    
    _connectionService = [ServiceLocator getConnectionService];
    
    _pollService = [[MessagePollService alloc] initWithIcwsClient:client andConnectionService:(ConnectionService*)_connectionService];
    
    _autoConnectService = [[AutoConnectService alloc] initWithConnectionService:_connectionService];
    
    _alertingCallNotificationService = [[AlertingCallNotificationService alloc] init];

}

- (IBAction)showPreferences:(id)sender
{
    
}
- (IBAction)logOut:(id)sender{
    [self showLoginDialog];
    [_connectionService disconnect:@""];
    
}
@end
