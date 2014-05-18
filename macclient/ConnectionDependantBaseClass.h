//
//  ConnectionDependantBaseClass.h
//  macclient
//
//  Created by Glinski, Kevin on 2/24/14.
//  Copyright (c) 2014 ININ. All rights reserved.
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.

#import <Foundation/Foundation.h>

//This is a simple base class with methods that are called with the
//CIC connection is established or lost
@interface ConnectionDependantBaseClass : NSObject

@property BOOL connectionIsUp;

@property NSString *userId;
@property NSString *serverUrl;

-(void) connectionStateChanged: (NSNotification *)notification;
- (void) connectionUp;
- (void) connectionDown;
@end
