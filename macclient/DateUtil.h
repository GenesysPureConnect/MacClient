//
//  DateUtil.h
//  MacClient
//
//  Created by Glinski, Kevin on 5/14/14.
//  Copyright (c) 2014 Interactive Intelligence. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateUtil : NSObject

+(NSDate*) getDateFromString:(NSString*)dateString;
+(NSString*) getFormattedDurationString:(NSDate*) fromDate;

@end
