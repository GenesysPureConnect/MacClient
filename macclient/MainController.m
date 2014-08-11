//
//  ClientController.m
//  macclient
//
//  Created by Glinski, Kevin on 2/24/14.
//  Copyright (c) 2014 ININ. All rights reserved.
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.

#import "MainController.h"
#import "ConnectionService.h"
#import "StatusService.h"
#import "MessagePollService.h"
#import "StatusBarController.h"
#import "LoginViewController.h"
#import "constants.h"
#import "ServiceLocator.h"
#import "QueueService.h"
#import "OtherSessionService.h"
#import "AutoConnectService.h"
#import "AlertingCallNotificationService.h"
#import "ChangeStationController.h"
#import "MyInteractionsController.h"
#import "DirectorySearchController.h"



@implementation MainController

MessagePollService* _pollService;
StatusBarController * _statusBarController;
StatusService *_statusService;
ConnectionService *_connectionService;
QueueService *_myQueue;
LoginViewController* _loginController;
MyInteractionsController *_myInteractionsController;
DirectorySearchController *_directorySearchController;
AutoConnectService *_autoConnectService;
AlertingCallNotificationService* _alertingCallNotificationService;

NSButton* closeButton;

-(void) awakeFromNib{
    [self setupServices];
    [self showLoginDialog];
    
    [[self toolbar] setVisible:NO];
    
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

-(NSRect) newFrameForNewContentView: (NSView*)view{
    NSWindow *window = [self window];
    NSRect newFrameRect = [window frameRectForContentRect:[view frame]];
    NSRect oldFrameRect = [window frame];
    NSSize newSize = newFrameRect.size;
    NSSize oldSize = oldFrameRect.size;
    
    NSRect frame = [[self window] frame];
    frame.size = newSize;
    frame.origin.y -= (newSize.height- oldSize.height);
    
    return frame;
}

-(IBAction) switchView:(id)sender{
    switch([sender tag]){
        case 0:
            [self showInteractionsDialog];
            break;
        case 1:
            [self showDirectoryDialog];
            break;
        default:
            [self showInteractionsDialog];
            break;
        
    }
}


-(void) showLoginDialog{
    if ([_currentViewController isKindOfClass:[LoginViewController class]])
    {
        return;
    }
   
    [[self toolbar] setVisible:NO];

    if(_loginController == NULL){
        _loginController = [[LoginViewController alloc]initWithNibName:@"LoginView" bundle:nil];
        [_loginController setConnectionService:_connectionService];
        [_mainView addSubview:[_loginController view]];
        [_loginController loadSavedData];
        [_loginController autologinIfNecessary];
    }
     [self setView: _loginController];

}

-(void) showDirectoryDialog{
    if ([_currentViewController isKindOfClass:[DirectorySearchController class]])
    {
        return;
    }

    if(_directorySearchController == NULL){
        
        _directorySearchController = [[DirectorySearchController alloc]initWithNibName:@"DirectoryView" bundle:nil];
    }
   
    [[self toolbar] setVisible:YES];
    
    [self setView: _directorySearchController];
    
    [self.toolbar setSelectedItemIdentifier:@"CompanyDirectory"];
}

-(void) showInteractionsDialog{
    if ([_currentViewController isKindOfClass:[MyInteractionsController class]])
    {
        return;
    }
    
    if(_myInteractionsController == NULL){
        
        _myInteractionsController = [[MyInteractionsController alloc]initWithNibName:@"InteractionsView" bundle:nil];
        
    }
    
    [[self toolbar] setVisible:YES];
    
    [self setView: _myInteractionsController];
    
    [self.toolbar setSelectedItemIdentifier:@"MyInteractions"];

}

-(void) setView:(NSViewController*) controller{
    [[[self window] contentView] addSubview:[controller view]];
    
    [[self window] setContentSize: [[controller view] frame].size];
    
    if(_currentViewController){
        [[_currentViewController view] removeFromSuperview];
    }
    [[[self window] contentView] setWantsLayer:YES];
    
    _currentViewController = controller;
    
}

-(void) connectionStateChanged: (NSNotification *)notification{
    NSDictionary* params = [notification userInfo];
    
    NSDockTile *tile = [[NSApplication sharedApplication] dockTile];
    
    if([params[@"isConnected"]  isEqual: @"true"]){
        [self showInteractionsDialog ];
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

ChangeStationController *changeStationController;

- (IBAction) changeStationClick:(id)sender{
     changeStationController = [[ChangeStationController alloc] initWithWindowNibName:@"ChangeStationWindow"];
    [changeStationController showWindow:self];
    [[changeStationController window] center];
}

@end
