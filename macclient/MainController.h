//
//  ClientController.h
//  macclient
//
//  Created by Glinski, Kevin on 2/24/14.
//  Copyright (c) 2014 ININ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MainController : NSObject
@property (weak) IBOutlet NSView *mainView;
@property (strong) NSViewController *currentViewController;
@property (weak) IBOutlet NSMenuItem *logOutMenuItem;

-(void) setupServices;
-(void) connectionStateChanged: (NSNotification *)notification;
-(void) showClientDialog;
-(void) showLoginDialog;
-(void) setView:(NSViewController*) controller;
-(IBAction)showPreferences:(id)sender;
-(IBAction)logOut:(id)sender;
-(void)closeThisWindow: (id) sender;

@end
