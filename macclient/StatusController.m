//
//  StatusController.m
//  macclient
//
//  Created by Glinski, Kevin on 2/26/14.
//  Copyright (c) 2014 ININ. All rights reserved.
//

#import "StatusController.h"
#import "ServiceLocator.h"

@implementation StatusController

NSMutableArray *_statuses;
StatusService* _statusService;
NSTimer *_timer;
NSDate *_lastStatusChange;
Status * _currentStatus;

-(void) awakeFromNib{
    [self setStatusService:[ServiceLocator getStatusService]];
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self
                                            selector:@selector(updateStatusTime:) userInfo:nil repeats:YES];
    
}

-(void)updateStatusTime:(NSTimer*)aTimer
{
    if(_lastStatusChange == NULL)
    {
        return;
    }
    
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
                                                              fromDate:_lastStatusChange
                                                                toDate:now
                                                               options:0];
    
    // Format this as desired for display to the user.
    NSString *durationString = [NSString stringWithFormat:
                                @"%d:%02d:%02d",
                                [durationComponents hour],
                                [durationComponents minute],
                                [durationComponents second]];
    [_timeInStatus setStringValue:durationString];
    

}

-(void) setStatusService:(StatusService*)statusService{
    _statusService = statusService;
    [super setStatusService:statusService];
    
}

- (void)statusListChanged:(NSArray*)statusList{
    NSMenu* menu = _statusButton.menu;
    [menu removeAllItems];
    [menu setAutoenablesItems:YES];
    
    _statuses = [[NSMutableArray alloc] init];
    for(int x=0; x<[statusList count]; x++){
        
        Status* status = statusList[x];
        
        if([status isUserSelectable])
        {
            
            NSMenuItem* newItem;
            newItem = [[NSMenuItem alloc]
                       initWithTitle:[status text]
                       action:@selector(changeStatus:)
                       keyEquivalent:@""];
            
            NSImage* statusImage = [[NSImage alloc] initWithContentsOfURL:[NSURL URLWithString:[status imageUrl]]];
            NSSize newSize;
            newSize.width=16;
            newSize.height=16;
            
            [newItem setImage: [self imageResize:statusImage newSize:newSize]];
            [newItem setTarget:self];
            [newItem setTag:[_statuses count]];
            [newItem setEnabled:true];
            
            [menu addItem:newItem];
            
            
            [_statuses addObject:status];
            
            if(_currentStatus != NULL && [status id] == [_currentStatus id]){
                [_statusButton selectItem: newItem];
            }
           // [_statusButton addItemWithTitle:[status text]];
            
        }
    }
    
}
- (void) currentStatusChanged:(Status*) status{
   
    _currentStatus = status;
    
    _lastStatusChange = [[NSDate alloc] init];
    [self updateStatusTime:NULL];
    
    for(int x =0; x<_statuses.count; x++)
    {
        Status* checkStatus = _statuses[x];
        if( [checkStatus id] == [_currentStatus id]){
            [_statusButton selectItemAtIndex:x ];
            [_statusButton display];
        }
    }
    
    
    NSImage* statusImage = [[NSImage alloc] initWithContentsOfURL:[NSURL URLWithString:[status imageUrl]]];
    NSSize newSize;
    newSize.width=24;
    newSize.height=24;
    
    [_statusImage setImage:[self imageResize:statusImage newSize:newSize]];
    [_statusMessage setStringValue:[status text]];
}


- (IBAction)changeStatus:(id)sender {
    NSMenuItem* menuItem = (NSMenuItem*)sender;
    int index = (int)[menuItem tag];
    Status* status = _statuses[index];
    
    [_statusService setStatus:[status id]];
}
@end
