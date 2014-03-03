//
//  ConnectionDependantBaseClass.h
//  macclient
//
//  Created by Glinski, Kevin on 2/24/14.
//  Copyright (c) 2014 ININ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConnectionDependantBaseClass : NSObject

@property BOOL connectionIsUp;

@property NSString *userId;
@property NSString *serverUrl;

-(void) connectionStateChanged: (NSNotification *)notification;
- (void) connectionUp;
- (void) connectionDown;
@end
