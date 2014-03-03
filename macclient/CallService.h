//
//  CallService.h
//  macclient
//
//  Created by Glinski, Kevin on 2/27/14.
//  Copyright (c) 2014 ININ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IcwsServiceBase.h"

@interface CallService : IcwsServiceBase
-(void) placeCall:(NSString*)number;
@end
