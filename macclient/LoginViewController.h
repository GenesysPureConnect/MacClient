//
//  LoginViewController.h
//  macclient
//
//  Created by Glinski, Kevin on 2/25/14.
//  Copyright (c) 2014 ININ. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ConnectionService.h"
#import "ConnectionService.h"

@interface LoginViewController : NSViewController
@property (weak) ConnectionService* connectionService;
@property (weak) IBOutlet NSTextField *userNameField;
@property (weak) IBOutlet NSSecureTextField *passwordField;

@property (weak) IBOutlet NSButton *connectButton;
- (IBAction)doConnect:(id)sender;

@property (weak) IBOutlet NSTextField *server;

@end
