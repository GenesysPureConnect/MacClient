//
//  FeatureService.m
//  MacClient
//
//  Created by Glinski, Kevin on 8/3/14.
//  Copyright (c) 2014 Interactive Intelligence. All rights reserved.
//

#import "FeatureService.h"

@implementation FeatureService

NSArray* _featureList;

- (void) connectionUp
{
    _featureList = [[self icwsClient] getAsDictionary:@"/connection/features"][@"featureInfoList"];
}

- (bool) hasDirectoryFeature{
    return [self hasFeature:@"directories"];
}

-(bool) hasFeature:(NSString*) feature{
    for(int i=0; i< _featureList.count; i++){
        NSDictionary* featureData = (NSDictionary*)_featureList[i];
        if(featureData[@"featureId"] == feature){
            return true;
        }
    }
    
    return false;
}

@end
