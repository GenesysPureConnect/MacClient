//
//  Interaction.m
//  CIC Mac Client
//
//  Created by Glinski, Kevin on 2/27/14.
//  Copyright (c) 2014 Interactive Intelligence. All rights reserved.
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.
//

#import "Interaction.h"
#import "constants.h"
#import "DateUtil.h"


static NSImage* DisconnectedCallImage = NULL;
static NSImage* ConnectedCallImage = NULL;
static NSImage* HeldCallImage = NULL;


@implementation Interaction
NSInteger _capabilities;
BOOL _isConference;
bool _isRecording= false;
NSString* _userName;
NSString* _recorders;

-(id) initWithId:(NSString*)interactionId
{
    self = [self init];
    _interactionId = interactionId;
    
    if(DisconnectedCallImage == NULL){
        NSBundle *bundle = [NSBundle mainBundle];
        DisconnectedCallImage = [[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"call-stop" ofType:@"png"]];
        ConnectedCallImage = [[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"call-start" ofType:@"png"]];
        HeldCallImage = [[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"media-playback-pause" ofType:@"png"]];
    }
    
    return self;
    
}
-(void) setAttributes:(NSDictionary*) attributes
{
    for (id key in attributes) {
        if([kAttributeRemoteName isEqualToString:key])
        {
            _remoteName = attributes[key];
        }
        else if([kAttributeRemoteNumber isEqualToString:key])
        {
            _remoteId = attributes[key];
        }
        else if([kAttributeState isEqualToString:key])
        {
            _callState = attributes[key];
        }
        else if([kAttributeCallStateString isEqualToString:key])
        {
            _callStateDescription = attributes[key];
        }
        else if([kAttributeCapabilities isEqualToString:key])
        {
            
            _capabilities = [attributes[key] intValue];
        }
        else if([kAttributeMuted isEqualToString:key])
        {
            _muted = [attributes[key] intValue] == 1;
        }
        else if([kAttributeConferenceId isEqualToString:key])
        {
            _isConference = ![attributes[key] isEqualToString:@""];
            
        }
        else if([kAttributeInitiationTime isEqualToString:key])
        {
            NSString *dateString = attributes[key];
            
            _initiationTime = [DateUtil getDateFromString:dateString];
        }
        else if ([kAttributeRecorders isEqualToString:key])
        {
         //   Eic_Recorders
            _recorders = attributes[key];
                          
            NSRange range = [attributes[key] rangeOfString:_userName options:NSCaseInsensitiveSearch];
            
            _recording = (range.location != NSNotFound);
        }
        else if ([kAttributeUserName isEqualToString:key])
        {
            _userName = attributes[key];
            
            NSRange range = [_recorders rangeOfString:_userName options:NSCaseInsensitiveSearch];
            _isRecording = (range.location != NSNotFound);
        }
        else if([kAttributeObjectType isEqualToString:key])
        {
            NSString *objectType = attributes[key];
            
            if([objectType isEqualToString:@"Call"]){
                _interactionType = Call;
            }
            else{
                _interactionType = Unknown;
            }
        }
       
    }
}
-(BOOL) isHeld
{
    return [_callState isEqualToString:@"H"];
}

-(BOOL) isAlerting
{
    return [_callState isEqualToString:@"A"];
}

-(BOOL) isConnected{ return [_callState isEqualToString:@"C"];}
-(BOOL) isDisconnected{
    return [_callState isEqualToString:@"I"] || [_callState isEqualToString:@"E"];
}

-(BOOL) isMuted{
    return _muted;
}
-(BOOL) canPickup
{
    return (_capabilities & 4 )>0 && ![self isConnected];
}
-(BOOL) canDisconnet{return (_capabilities & 2 )>0;}
-(BOOL) canHold
{
    BOOL hold = (_capabilities & 256 ) > 0 ;
    return hold || [self isHeld] || [self isConnected];
}
-(BOOL) canMute{
    return (_capabilities & 32 )>0;
}

-(BOOL) canRecord
{
    BOOL record = (_capabilities & 1024 ) > 0 ;
    return record || [self isConnected] || [self isHeld];
}

-(BOOL) canSendToVoicemail
{
    return ![self isDisconnected ];
}

-(BOOL) isRecording
{
    return _recording;
}

-(BOOL) isConference
{
    return _isConference;
}

-(NSString*) formattedDurationString
{
    if([self isDisconnected])
    {
        return @"";
    }
    
    return [DateUtil getFormattedDurationString:_initiationTime];
}

-(NSImage*) image
{
    if([self isDisconnected]){
        return DisconnectedCallImage;
    }
    else if([self isHeld]){
        return HeldCallImage;
    }
    
    return ConnectedCallImage;
}
@end

