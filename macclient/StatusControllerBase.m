//
//  StatusControllerBase.m
//  macclient
//
//  Created by Glinski, Kevin on 2/26/14.
//  Copyright (c) 2014 ININ. All rights reserved.
//

#import "StatusControllerBase.h"
#import "StatusService.h"
#import "constants.h"

@implementation StatusControllerBase
NSMutableArray *_statuses;
StatusService* _statusService;

-(void) setStatusService:(StatusService*)statusService{
    _statusService = statusService;
    
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(onCurrentStatusChanged:)
     name: kCurrentStatusChange
     object:_statusService];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(onAvailableStatusesChanged:)
     name: kAvailableStatusesChanged
     object:_statusService];
}



- (NSImage *)imageResize:(NSImage*)anImage newSize:(NSSize)newSize {
    NSImage *sourceImage = anImage;
    [sourceImage setScalesWhenResized:YES];
    
    // Report an error if the source isn't a valid image
    if (![sourceImage isValid])
    {
        NSLog(@"Invalid Image");
    } else
    {
        NSImage *smallImage = [[NSImage alloc] initWithSize: newSize];
        [smallImage lockFocus];
        [sourceImage setSize: newSize];
        [[NSGraphicsContext currentContext] setImageInterpolation:NSImageInterpolationHigh];
        [sourceImage drawAtPoint:NSZeroPoint fromRect:CGRectMake(0, 0, newSize.width, newSize.height) operation:NSCompositeCopy fraction:1.0];
        [smallImage unlockFocus];
        return smallImage;
    }
    return nil;
}


- (void)statusListChanged:(NSArray*)statusList{}
- (void) currentStatusChanged:(Status*) statusId{}


-(void) onAvailableStatusesChanged: (NSNotification *)notification{
     
    StatusService* statusService = [notification object];
    NSDictionary* statuses = [statusService getAvailableStatuses];
    
    NSArray* sortedStatuses = [[statuses allValues]  sortedArrayUsingSelector:@selector(compare:)];
    
    [self statusListChanged:sortedStatuses];
    
}

-(void) onCurrentStatusChanged: (NSNotification *)notification
{
    NSDictionary* userInfo = [notification userInfo];
    Status* status = (Status*)userInfo[@"status"];
    
    [self currentStatusChanged:status];
}



@end
