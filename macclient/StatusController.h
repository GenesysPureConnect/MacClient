//
//  StatusController.h
//  macclient
//
//  Created by Glinski, Kevin on 2/26/14.
//  Copyright (c) 2014 ININ. All rights reserved.
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.

#import "StatusControllerBase.h"

@interface StatusController : StatusControllerBase
@property (weak) IBOutlet NSPopUpButton *statusButton;
- (IBAction)changeStatus:(id)sender;
@property (weak) IBOutlet NSImageView *statusImage;
@property (weak) IBOutlet NSTextField *timeInStatus;
@property (weak) IBOutlet NSTextField *statusMessage;

@end
