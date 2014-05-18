//
//  DateUtil.m
//  MacClient
//
//  Created by Glinski, Kevin on 5/14/14.
//  Copyright (c) 2014 Interactive Intelligence. All rights reserved.
//

#import "DateUtil.h"

@implementation DateUtil
static DateUtil* s_instance= NULL;

+(NSDate*) getDateFromString:(NSString*)dateString{
    
    //This is overly complicated, but I couldn't come up with an easier way -kpg
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [dateFormatter setDateFormat:@"yyyyMMdd HHmmss"];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    
    NSString *shortString =[dateString substringToIndex:15];
    shortString = [shortString stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    NSDate* date = [dateFormatter dateFromString:shortString];
    
    return date;
}


+(NSString*) getFormattedDurationString:(NSDate*) fromDate
{
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
                                                              fromDate:fromDate
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
@end
