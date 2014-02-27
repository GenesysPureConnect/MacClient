//
//  StatusController.h
//  macclient
//
//  Created by Glinski, Kevin on 2/26/14.
//  Copyright (c) 2014 ININ. All rights reserved.
//

#import "StatusControllerBase.h"

@interface StatusController : StatusControllerBase
@property (weak) IBOutlet NSPopUpButton *statusButton;
- (IBAction)changeStatus:(id)sender;
@property (weak) IBOutlet NSImageView *statusImage;
@property (weak) IBOutlet NSTextField *timeInStatus;

@end
