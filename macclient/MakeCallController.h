//
//  MakeCallController.h
//  macclient
//
//  Created by Glinski, Kevin on 2/27/14.
//  Copyright (c) 2014 ININ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MakeCallController : NSObject
@property (weak) IBOutlet NSTextField *phoneNumberTextBox;
@property (weak) IBOutlet NSButton *makeCallButton;

- (IBAction)makeCallButtonClick:(id)sender;

@end
