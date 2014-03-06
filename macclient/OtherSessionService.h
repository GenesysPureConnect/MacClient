//
//  OtherSessionService.h
//  CIC Mac Client
//
//  Created by Glinski, Kevin on 3/3/14.
//  Copyright (c) 2014 Interactive Intelligence. All rights reserved.
//

#import "IcwsServiceBase.h"

@interface OtherSessionService : IcwsServiceBase
@property NSString* stationName;
- (void) onSessionChanged: (NSNotification*) data;
@end
