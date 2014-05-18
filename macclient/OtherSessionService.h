//
//  OtherSessionService.h
//  CIC Mac Client
//
//  Created by Glinski, Kevin on 3/3/14.
//  Copyright (c) 2014 Interactive Intelligence. All rights reserved.
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.
//

#import "IcwsServiceBase.h"

// This service is used to watch to see if the user is logged into another session
// it can use that information to warn if the user is not logged into a station.
@interface OtherSessionService : IcwsServiceBase
@property NSString* stationName;
- (void) onSessionChanged: (NSNotification*) data;
@end
