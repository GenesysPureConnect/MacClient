//
//  ChangeStationController.h
//  MacClient
//
//  Created by Glinski, Kevin on 5/17/14.
//  Copyright (c) 2014 Interactive Intelligence. All rights reserved.
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.
//

#import <Foundation/Foundation.h>

@interface ChangeStationController : NSWindowController
@property (weak) IBOutlet NSPopUpButton *stationType;
@property (weak) IBOutlet NSTextField *Station;
@property (unsafe_unretained) IBOutlet NSWindow *changeStationWindow;

@property (weak) IBOutlet NSButton *OkButton;
@property (weak) IBOutlet NSTextField *errorTextField;

- (IBAction)CancelButtonClick:(id)sender;
- (IBAction)OkButtonClick:(id)sender;

@end
