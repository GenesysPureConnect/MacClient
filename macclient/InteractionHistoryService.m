//
//  InteractionHistoryService.m
//  MacClient
//
//  Created by Glinski, Kevin on 9/30/14.
//  Copyright (c) 2014 Interactive Intelligence. All rights reserved.
//

#import "InteractionHistoryService.h"
#import "InteractionHistoryItem.h"
#import "constants.h"

@implementation InteractionHistoryService
NSMutableArray* _interactionHistory;

-(id) init{
    self = [super init ];
    
    NSData *serialized = [[NSUserDefaults standardUserDefaults] objectForKey:kInteractionHistory];
    _interactionHistory = [NSKeyedUnarchiver unarchiveObjectWithData:serialized];
    
    return self;
}

-(void) addInteraction: (Interaction*) interaction{
    if(_interactionHistory == NULL){
        _interactionHistory = [[NSMutableArray alloc] init];
    }
    
    NSString* newId = [interaction interactionId];
    
    InteractionHistoryItem *history = [[InteractionHistoryItem alloc] initFromInteraction:interaction];
    
    bool wasFound = false;
    
    for (int i=((int)[_interactionHistory count] - 1); i>=0; i--){
        NSString* oldId = [_interactionHistory[i] interactionId];
        if([oldId isEqualToString: newId]){
            [_interactionHistory removeObjectAtIndex:i];
            [_interactionHistory insertObject:history atIndex:i];
            wasFound = true;
        }
    }
    
    if([_interactionHistory count] >= 25){
        [_interactionHistory removeLastObject];
    }
    
    if(!wasFound){
        [_interactionHistory insertObject: history atIndex:0 ];
    }
    
    NSData *serialized = [NSKeyedArchiver archivedDataWithRootObject:_interactionHistory];
    [[NSUserDefaults standardUserDefaults] setObject:serialized forKey:kInteractionHistory];
}

-(unsigned long) historyCount{
    
    if(_interactionHistory == NULL){
        return 0;
    }
    
    return [_interactionHistory count];
}

-(InteractionHistoryItem*) getItemAt:(unsigned long) index{
    if(_interactionHistory == NULL){
        return NULL;
    }
    
    return _interactionHistory [index];
}

@end
