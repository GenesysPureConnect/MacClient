//
//  DirectoryService.h
//  CIC Mac Client
//
//  Created by Glinski, Kevin on 4/25/14.
//  Copyright (c) 2014 Interactive Intelligence. All rights reserved.
//

#import "IcwsServiceBase.h"

@interface DirectoryService : IcwsServiceBase

-(NSArray*) lookupUsersByNameOrDepartment:(NSString*) searchText;

@end
