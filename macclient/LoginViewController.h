//
//  LoginViewController.h
//  macclient
//
//  Created by Glinski, Kevin on 2/25/14.
//  Copyright (c) 2014 ININ. All rights reserved.
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.

#import <Cocoa/Cocoa.h>
#import "ConnectionService.h"
#import "ConnectionService.h"

@interface LoginViewController : NSViewController
@property (weak) ConnectionService* connectionService;
@property (weak) IBOutlet NSTextField *userNameField;
@property (weak) IBOutlet NSSecureTextField *passwordField;
@property (weak) IBOutlet NSTextField *errorLabel;
@property (weak) IBOutlet NSButton *rememberPassword;
@property (weak) IBOutlet NSButton *autoLogIn;
@property (weak) IBOutlet NSTextFieldCell *workstationLabel;
@property (weak) IBOutlet NSComboBox *workstationField;
@property (weak) IBOutlet NSPopUpButton *workstationType;
@property (weak) IBOutlet NSProgressIndicator *connectIndicator;

@property (weak) IBOutlet NSButton *connectButton;
- (IBAction)doConnect:(id)sender;
-(void) doConnectOnBackgroundThread:(id) object;
- (IBAction)workstationTypeChange:(id)sender;
-(void)loadSavedData;

@property (weak) IBOutlet NSTextField *server;
- (IBAction)rememberPasswordChecked:(id)sender;

-(void) connectionStateChanged: (NSNotification *)notification;
- (void) stopConnectIndicator:(id)data;

- (void)timerDoConnect:(NSTimer*)theTimer;
-(void) autologinIfNecessary;
@end
