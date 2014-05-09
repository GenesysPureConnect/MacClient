//
//  Interaction.m
//  CIC Mac Client
//
//  Created by Glinski, Kevin on 2/27/14.
//  Copyright (c) 2014 Interactive Intelligence. All rights reserved.
//

#import "Interaction.h"
#import "constants.h"



static NSImage* DisconnectedCallImage = NULL;
static NSImage* ConnectedCallImage = NULL;
static NSImage* HeldCallImage = NULL;

@implementation Interaction
NSInteger _capabilities;
BOOL _isConference;

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
            //This is overly complicated, but I couldn't come up with an easier way -kpg
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
            [dateFormatter setDateFormat:@"yyyyMMdd HHmmss"];
            [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
            NSString *dateString = attributes[key];
            NSString *shortString =[dateString substringToIndex:dateString.length - 5];
            shortString = [shortString stringByReplacingOccurrencesOfString:@"T" withString:@" "];
            _initiationTime = [dateFormatter dateFromString:shortString];
            
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

-(BOOL) isMuted{return _muted;}
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
-(BOOL) canMute{return (_capabilities & 32 )>0;}


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
    
    NSDate *now = [NSDate date];
    
    // Get the system calendar. If you're positive it will be the
    // Gregorian, you could use the specific method for that.
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    
    // Specify which date components to get. This will get the hours,
    // minutes, and seconds, but you could do days, months, and so on
    // (as I believe iTunes does).
    NSUInteger unitFlags = NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    
    // Create an NSDateComponents object from these dates using the system calendar.
    NSDateComponents *durationComponents = [currentCalendar components:unitFlags
                                                              fromDate:_initiationTime
                                                                toDate:now
                                                               options:0];
    
    // Format this as desired for display to the user.
    NSString *durationString = [NSString stringWithFormat:
                                @"%ld:%02ld:%02ld",
                                (long)[durationComponents hour],
                                (long)[durationComponents minute], 
                                (long)[durationComponents second]];
    return durationString;

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



//@property NSDate* initiationTime;
//@property NSString* callStateDescription;
//@property NSString* conferenceParent;