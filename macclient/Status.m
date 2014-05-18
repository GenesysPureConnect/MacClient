//
//  Status.m
//  macclient
//
//  Created by Glinski, Kevin on 2/23/14.
//  Copyright (c) 2014 ININ. All rights reserved.
//

#import "Status.h"
#import "constants.h"
#import "DateUtil.h"

@implementation Status

- (id) initFromDictionary:(NSDictionary *)statusData fromServer:(NSString*)url
{
    
     self = [super init ];
    _id = statusData[@"statusId"];
    _text = statusData[@"messageText"];
    _isUserSelectable = [[statusData objectForKey:@"isSelectableStatus"] integerValue] == 1;
    _imageUrl = [NSString stringWithFormat:kUrlImageFormat, url , statusData[@"iconUri"]];
    
    _lastStatusChange = [DateUtil getDateFromString:statusData[@"statusChanged"]];
    return self;
    
}

- (NSComparisonResult)compare:(Status *)otherObject {
    return [self.text compare:otherObject.text];
}
@end
