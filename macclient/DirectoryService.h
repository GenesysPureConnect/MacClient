//
//  DirectoryService.h
//  CIC Mac Client
//
//  Created by Glinski, Kevin on 4/25/14.
//  Copyright (c) 2014 Interactive Intelligence. All rights reserved.
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.
//

#import "IcwsServiceBase.h"

// does directory lookups
@interface DirectoryService : IcwsServiceBase

-(NSArray*) lookupUsersByNameOrDepartment:(NSString*) searchText;

@end
