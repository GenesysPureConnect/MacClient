//
//  IcwsServiceBase.h
//  macclient
//
//  Created by Glinski, Kevin on 2/23/14.
//  Copyright (c) 2014 ININ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IcwsClient.h"
#import "ConnectionDependantBaseClass.h"

@interface IcwsServiceBase : ConnectionDependantBaseClass
@property (strong, nonatomic) IcwsClient *icwsClient;
- (id) initWithIcwsClient:(IcwsClient *)client;

@end
