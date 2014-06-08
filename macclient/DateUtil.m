//
//  DateUtil.m
//  MacClient
//
//  Created by Glinski, Kevin on 5/14/14.
//  Copyright (c) 2014 Interactive Intelligence. All rights reserved.
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.

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
    NSString *durationString;
    
    if([durationComponents hour] < 24)
    {
        durationString = [NSString stringWithFormat:
                          @"%ld:%02ld:%02ld",
                          (long)[durationComponents hour],
                          (long)[durationComponents minute],
                          (long)[durationComponents second]];
    }
    else
    {
        NSInteger days = [durationComponents hour] / 24;
        NSInteger hours = [durationComponents hour] % 24;
        
        if(days == 1)
        {
            
            durationString = [NSString stringWithFormat:
                              @"1 day %ld:%02ld:%02ld",
                              (long)hours,
                              (long)[durationComponents minute],
                              (long)[durationComponents second]];
        }
        else
        {
            durationString = [NSString stringWithFormat:
                              @"%ld days %ld:%02ld:%02ld",
                              (long)days,
                              (long)hours,
                              (long)[durationComponents minute],
                              (long)[durationComponents second]];
        }
    }
    
    return durationString;
    
    
}
@end
