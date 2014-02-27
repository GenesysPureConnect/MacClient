//
//  ininLoginController.h
//  macclient
//
//  Created by Glinski, Kevin on 1/23/14.
//  Copyright (c) 2014 ININ. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ininLoginController :  NSObject{
@private
    IBOutlet NSTextField *userNameField;
    IBOutlet NSTextField *passwordField;
    IBOutlet NSTextField *serverField;
    IBOutlet NSTextField *workstationField;
}

- (IBAction)onLogin:(id)sender;
@end
