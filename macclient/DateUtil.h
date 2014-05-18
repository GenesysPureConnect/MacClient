//
//  DateUtil.h
//  MacClient
//
//  Created by Glinski, Kevin on 5/14/14.
//  Copyright (c) 2014 Interactive Intelligence. All rights reserved.
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.

#import <Foundation/Foundation.h>


//The DateUtil class has helper methods for converting strings to Dates and back
@interface DateUtil : NSObject

+(NSDate*) getDateFromString:(NSString*)dateString;
+(NSString*) getFormattedDurationString:(NSDate*) fromDate;

@end
