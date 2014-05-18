//
//  Status.h
//  macclient
//
//  Created by Glinski, Kevin on 2/23/14.
//  Copyright (c) 2014 ININ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Status : NSObject
    @property NSString *id;
    @property NSString *text;
    @property bool isUserSelectable;
    @property NSString *imageUrl;
@property NSDate *lastStatusChange;

- (id) initFromDictionary:(NSDictionary *)statusData fromServer:(NSString*)url;
- (NSComparisonResult)compare:(Status *)otherObject;
@end
