//
//  InteractionHistoryService.h
//  MacClient
//
//  Created by Glinski, Kevin on 9/30/14.
//  Copyright (c) 2014 Interactive Intelligence. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Interaction.h"
#import "InteractionHistoryItem.h"

@interface InteractionHistoryService : NSObject

-(void) addInteraction: (Interaction*) interaction;

-(unsigned long) historyCount;
-(InteractionHistoryItem*) getItemAt:(unsigned long) index;
@end
