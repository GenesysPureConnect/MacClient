//
//  StatusController.m
//  macclient
//
//  Created by Glinski, Kevin on 2/26/14.
//  Copyright (c) 2014 ININ. All rights reserved.
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.

#import "StatusController.h"
#import "ServiceLocator.h"
#import "DateUtil.h"

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
    
    NSString* durationString = [DateUtil getFormattedDurationString:_lastStatusChange];
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
    
    _lastStatusChange = [_statusService lastStatusChange];
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
