//
//  Interaction.h
//  CIC Mac Client
//
//  Created by Glinski, Kevin on 2/27/14.
//  Copyright (c) 2014 Interactive Intelligence. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Interaction : NSObject

@property NSString* interactionId;
@property NSString* remoteName;
@property NSString* remoteId;
@property NSString* callState;
@property NSDate* initiationTime;
@property NSString* callStateDescription;
@property NSString* conferenceParent;
@property NSInteger muted;

-(id) initWithId:(NSString*)interactionId;
-(void) setAttributes:(NSDictionary*) data;
-(BOOL) isConnected;
-(BOOL) isDisconnected;
-(BOOL) isHeld;
-(BOOL) isMuted;
-(BOOL) canPickup;
-(BOOL) canDisconnet;
-(BOOL) canHold;
-(BOOL) canMute;
-(NSString*) formattedDurationString;

@end
