//
//  InteractionHistoryItem.h
//  MacClient
//
//  Created by Glinski, Kevin on 9/30/14.
//  Copyright (c) 2014 Interactive Intelligence. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Interaction.h"

@interface InteractionHistoryItem : NSObject <NSCoding>

@property NSString* interactionId;
@property NSString* remoteName;
@property NSString* remoteId;
@property NSDate* initiationTime;

-(id) initFromInteraction:(Interaction*)interaction;

@end
