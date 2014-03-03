//
//  Interaction.m
//  CIC Mac Client
//
//  Created by Glinski, Kevin on 2/27/14.
//  Copyright (c) 2014 Interactive Intelligence. All rights reserved.
//

#import "Interaction.h"
#import "constants.h"

@implementation Interaction
NSInteger _capabilities;

-(id) initWithId:(NSString*)interactionId
{
    self = [self init];
    _interactionId = interactionId;
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
       
   //     NSLog(@"There are %@ %@'s in stock", inventory[key], key);
    }
}
-(BOOL) isHeld
{
    return [_callState isEqualToString:@"H"];
}
-(BOOL) isConnected{ return [_callState isEqualToString:@"C"];}
-(BOOL) isDisconnected{
    return [_callState isEqualToString:@"I"] || [_callState isEqualToString:@"E"];
}

-(BOOL) isMuted{return _muted;}
-(BOOL) canPickup
{
    return (_capabilities & 4 )>0 && ![self isConnected];
}
-(BOOL) canDisconnet{return (_capabilities & 2 )>0;}
-(BOOL) canHold
{
    BOOL hold = (_capabilities & 256 ) > 0 ;
    return hold || [self isHeld];
}
-(BOOL) canMute{return (_capabilities & 32 )>0;}

@end

//@property NSDate* initiationTime;
//@property NSString* callStateDescription;
//@property NSString* conferenceParent;