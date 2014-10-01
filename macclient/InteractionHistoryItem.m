//
//  InteractionHistoryItem.m
//  MacClient
//
//  Created by Glinski, Kevin on 9/30/14.
//  Copyright (c) 2014 Interactive Intelligence. All rights reserved.
//

#import "InteractionHistoryItem.h"

@implementation InteractionHistoryItem

-(id) initFromInteraction:(Interaction*)interaction
{
    self = [self init];
    
    self.interactionId = [interaction interactionId];
    self.initiationTime = [interaction initiationTime];
    self.remoteId = [interaction remoteId];
    self.remoteName = [interaction remoteName];
    
    return self;
    
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.interactionId forKey:@"interactionId"];
    [coder encodeObject:self.initiationTime forKey:@"initiationTime"];
    [coder encodeObject:self.remoteId forKey:@"remoteId"];
    [coder encodeObject:self.remoteName forKey:@"remoteName"];

}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super init];
    
    self.interactionId  = [coder decodeObjectForKey:@"interactionId"];
    self.initiationTime  = [coder decodeObjectForKey:@"initiationTime"];
    self.remoteId  = [coder decodeObjectForKey:@"remoteId"];
    self.remoteName  = [coder decodeObjectForKey:@"remoteName"];
    
    return self;
}

@end
