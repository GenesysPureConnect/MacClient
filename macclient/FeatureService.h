//
//  FeatureService.h
//  MacClient
//
//  Created by Glinski, Kevin on 8/3/14.
//  Copyright (c) 2014 Interactive Intelligence. All rights reserved.
//

#import "IcwsServiceBase.h"

@interface FeatureService : IcwsServiceBase

-(bool) hasDirectoryFeature;
-(bool) hasFeature:(NSString*) feature;
@end
