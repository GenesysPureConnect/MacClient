//
//  ClientController.h
//  macclient
//
//  Created by Glinski, Kevin on 2/24/14.
//  Copyright (c) 2014 ININ. All rights reserved.
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.

#import <Foundation/Foundation.h>

@interface MainController : NSObject
@property (weak) IBOutlet NSView *mainView;
@property (weak) IBOutlet NSWindow *window;
@property (strong) NSViewController *currentViewController;
@property (weak) IBOutlet NSMenuItem *logOutMenuItem;
@property (weak) IBOutlet NSMenuItem *chanceStationMenuItem;
@property (weak) IBOutlet NSToolbar *toolbar;

- (IBAction)changeStationClick:(id)sender;

-(void) setupServices;
-(void) connectionStateChanged: (NSNotification *)notification;
-(void) showInteractionsDialog;
-(void) showLoginDialog;
-(void) setView:(NSViewController*) controller;
-(IBAction)showPreferences:(id)sender;
-(IBAction)logOut:(id)sender;
-(void)closeThisWindow: (id) sender;
-(NSView *) viewForTag:(int)tag;
@end
