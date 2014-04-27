//
//  DirectoryService.m
//  CIC Mac Client
//
//  Created by Glinski, Kevin on 4/25/14.
//  Copyright (c) 2014 Interactive Intelligence. All rights reserved.
//

#import "DirectoryService.h"

@implementation DirectoryService
-(NSArray*) lookupUsersByNameOrDepartment:(NSString*) searchText
{
    
    if(searchText.length == 0)
    {
        return @[];
    }
    
    NSDictionary* results = [[self icwsClient] postWithResponseData: @"/directories/lookup-entries" withData:@{
                                                                      @"lookupEntryTypes": @[@1],
                                                                      @"lookupEntryProperties": @[@1,@2,@3,@4],
                                                                      @"lookupComparisonType": @3,
                                                                      @"lookupString" : searchText,
                                                                      @"maxEntries": @15
                                                                }];
    
    return results[@"lookupEntriesList"];
    

}
@end
