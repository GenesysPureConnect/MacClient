//
//  Interaction.h
//  CIC Mac Client
//
//  Created by Glinski, Kevin on 2/27/14.
//  Copyright (c) 2014 Interactive Intelligence. All rights reserved.
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.
//

#import <Foundation/Foundation.h>

typedef enum {
    Call,
    Chat,
    Email,
    GenericObject,
    WorkItem,
    Unknown
} InteractionType;

@interface Interaction : NSObject

@property NSString* interactionId;
@property NSString* remoteName;
@property NSString* remoteId;
@property NSString* callState;
@property NSDate* initiationTime;
@property NSString* callStateDescription;
@property NSString* conferenceId;
@property NSInteger muted;
@property InteractionType interactionType;

-(id) initWithId:(NSString*)interactionId;
-(void) setAttributes:(NSDictionary*) data;
-(BOOL) isConnected;
-(BOOL) isAlerting;
-(BOOL) isDisconnected;
-(BOOL) isHeld;
-(BOOL) isMuted;
-(BOOL) isRecording;
-(BOOL) canPickup;
-(BOOL) canDisconnet;
-(BOOL) canHold;
-(BOOL) canMute;
-(BOOL) canRecord;

-(NSString*) formattedDurationString;
-(NSImage*) image;
-(BOOL) isConference;


@end

