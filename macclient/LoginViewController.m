//
//  LoginViewController.m
//  macclient
//
//  Created by Glinski, Kevin on 2/25/14.
//  Copyright (c) 2014 ININ. All rights reserved.
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.


#import "LoginViewController.h"
#import "ServiceLocator.h"
#import "constants.h"
@interface LoginViewController ()

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    
        NSDictionary* defaults=@{kUserName:@"",
                                 kPassword:@"",
                                 kServer:@"",
                                 kWorkstationName:@"",
                                 kWorkstationType:@1,
                                 kAutoLogIn:@0,
                                 kRememberPassword:@0};
        [[NSUserDefaults standardUserDefaults] registerDefaults:defaults];
        
        [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(connectionStateChanged:)
         name: kConnectionStateChangedEvent
         object:nil];
    }
    
   
    return self;
    
}

-(void)loadSavedData{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [_userNameField setStringValue:[prefs stringForKey:kUserName]];
    [_passwordField setStringValue:[prefs stringForKey:kPassword]];
    [_server setStringValue:[prefs stringForKey:kServer]];
    
    NSInteger autoLogin =[prefs integerForKey:kAutoLogIn];
    [_autoLogIn setState:autoLogin];
    
    NSInteger rememberPassword =[prefs integerForKey:kRememberPassword];
    [_rememberPassword setState:rememberPassword];
    
    if(rememberPassword == 1)
    {
        [_autoLogIn setEnabled:true ];
    }
    
    if([_autoLogIn isEnabled] && [_autoLogIn state] == NSOnState)
    {
        [NSTimer scheduledTimerWithTimeInterval:0.50
                                         target:self
                                       selector:@selector(timerDoConnect:)
                                       userInfo:nil
                                        repeats:NO];
       
    }
    
    [_workstationType selectItemWithTag:[prefs integerForKey:kWorkstationType]];
    [self workstationTypeChange:_workstationType];
    [_workstationField setStringValue:[prefs stringForKey:kWorkstationName]];
     
}

- (void)timerDoConnect:(NSTimer*)theTimer
{
#if !DEBUG
     [self doConnect:self];
#endif
}

- (IBAction)rememberPasswordChecked:(id)sender
{
    BOOL canRememberPassword = [sender state]== NSOnState;
    [_autoLogIn setEnabled:canRememberPassword];
}

- (IBAction)doConnect:(id)sender {
   // [self performSelectorInBackground:@selector(doConnectOnBackgroundThread:) withObject:self];
    [self doConnectOnBackgroundThread:self];
}

-(void) doConnectOnBackgroundThread:(id) object{
        
    [[self connectIndicator] startAnimation:self];
    [[self connectButton] setEnabled:false];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:[_userNameField stringValue] forKey:kUserName];
    NSInteger rememberPW =[_rememberPassword state];
    if(rememberPW == NSOnState)
    {
        [prefs setObject:[_passwordField stringValue] forKey:kPassword];
    }
    else
    {
        [prefs setObject:@"" forKey:kPassword];
    }
    
    [prefs setObject:[_server stringValue] forKey:kServer];
    
    [prefs setInteger:[_rememberPassword state] forKey: kRememberPassword];
    [prefs setInteger:[_autoLogIn state] forKey: kAutoLogIn];
    [prefs setInteger:[_workstationType selectedTag] forKey:kWorkstationType];
    [prefs setObject:[_workstationField stringValue] forKey:kWorkstationName];
    [prefs synchronize];

    [_connectionService connect:[_userNameField stringValue] withPassword:[_passwordField stringValue] toServer:[_server stringValue]];
   
    
    if(_connectionService.isConnected && [_workstationType selectedTag] > 0)
    {
        bool result = false;
        if ([_workstationType selectedTag] == 1){
            result = [_connectionService setWorkstation:[_workstationField stringValue]];
        }
        else if([_workstationType selectedTag] == 2){
            result = [_connectionService setRemoteNumber:[_workstationField stringValue]];
        }
        
        
        if(!result)
        {
            [_connectionService disconnect:@"Unable to set station"];
        }
        else{
            [ServiceLocator getOtherSessionService].stationName = [_workstationField stringValue];
        }
    }
    
     [self performSelectorOnMainThread:@selector(stopConnectIndicator:)
                           withObject:self
                        waitUntilDone:YES];


}


- (void) stopConnectIndicator:(id)data
{
    [[self connectButton] setEnabled:true];
    [[self connectIndicator] stopAnimation:self];
    
    
}

- (IBAction)workstationTypeChange:(id)sender {
    NSPopUpButton* btn = sender;
    if([btn selectedTag] == 0 )
    {
        [_workstationField setEnabled:false];
    }
    else
    {
        [_workstationField setEnabled:true];
    }
}


-(void) connectionStateChanged: (NSNotification *)notification{
    NSDictionary* params = [notification userInfo];
    
    if([params[@"details"]  isEqual: @"true"]){
        [_errorLabel setStringValue:params[@""] ];
        
    }
    else{
        [_errorLabel setStringValue:params[@"details"] ];
        
    }
}
@end
