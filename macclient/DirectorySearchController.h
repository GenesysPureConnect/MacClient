//
//  DirectorySearchController.h
//  CIC Mac Client
//
//  Created by Glinski, Kevin on 4/25/14.
//  Copyright (c) 2014 Interactive Intelligence. All rights reserved.
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.

#import <Foundation/Foundation.h>

@interface DirectorySearchController : NSObject <NSTableViewDataSource, NSTableViewDelegate>
@property (weak) IBOutlet NSSearchField *directorySearch;
- (IBAction)performSearch:(id)sender;
@property (weak) IBOutlet NSTableView *searchResultsTable;
@property (weak) IBOutlet NSScrollView *tableParent;
@property (weak) IBOutlet NSBox *directoryContactBox;
- (IBAction)closeDirectoryContact:(id)sender;
@property (weak) IBOutlet NSButton *directoryContactCloseButton;
- (IBAction)directorySearchContectSelected:(id)sender;
@property (weak) IBOutlet NSView *mainView;



- (IBAction)onWorkButtonClicked:(id)sender;
- (IBAction)onMobileButtonClicked:(id)sender;
- (IBAction)onHomeButtonClicked:(id)sender;
@property (weak) IBOutlet NSImageView *statusImage;
@property (weak) IBOutlet NSTextField *statusLabel;
@property (weak) IBOutlet NSImageView *onPhoneImage;
@property (weak) IBOutlet NSImageView *loggedInImage;
@property (weak) IBOutlet NSTextField *contactName;
@property (weak) IBOutlet NSTextField *contactDepartment;
@property (weak) IBOutlet NSButton *workButton;
@property (weak) IBOutlet NSButton *mobileButton;
@property (weak) IBOutlet NSButton *homeButton;

@end
