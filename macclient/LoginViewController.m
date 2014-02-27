//
//  LoginViewController.m
//  macclient
//
//  Created by Glinski, Kevin on 2/25/14.
//  Copyright (c) 2014 ININ. All rights reserved.
//

#import "LoginViewController.h"
#import "ServiceLocator.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}


- (IBAction)doConnect:(id)sender {
    [_connectionService connect:[_userNameField stringValue] withPassword:[_passwordField stringValue] toServer:[_server stringValue]];
}
@end
