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

-(void) awakeFromNib{
    [self setStatusService:[ServiceLocator getStatusService]];
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
            
            //[menu addItem:newItem];
            
            
             [_statuses addObject:status];
             
            //[menu addItemWithTitle:[status text] action:@selector(changeStatus:) keyEquivalent:@""];
            [_statusButton addItemWithTitle:[status text]];
            
        }
    }
    
}
- (void) currentStatusChanged:(Status*) status{
   
    for(int x =0; x<_statuses.count; x++)
    {
        Status* checkStatus = _statuses[x];
 //       NSLog(checkStatus.id);
        if( [checkStatus id] == [status id]){
            [_statusButton selectItemAtIndex:x ];
            [_statusButton display];
        }
    }
    
    
    NSImage* statusImage = [[NSImage alloc] initWithContentsOfURL:[NSURL URLWithString:[status imageUrl]]];
    NSSize newSize;
    newSize.width=24;
    newSize.height=24;
    
    [_statusImage setImage:[self imageResize:statusImage newSize:newSize]];
    [_timeInStatus setStringValue:[status text]];
}


- (IBAction)changeStatus:(id)sender {
    NSMenuItem* menuItem = (NSMenuItem*)sender;
    int index = (int)[menuItem tag];
    Status* status = _statuses[index];
    
    [_statusService setStatus:[status id]];
}
@end
