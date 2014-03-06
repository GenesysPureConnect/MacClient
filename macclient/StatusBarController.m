//
//  StatusBarService.m
//  macclient
//
//  Created by Glinski, Kevin on 2/22/14.
//  Copyright (c) 2014 ININ. All rights reserved.
//

#import "StatusBarController.h"
#import "constants.h"
#import "Status.h"
#import "OtherSessionService.h"

@implementation StatusBarController

NSMutableArray *_statuses;
StatusService* _statusService;
OtherSessionService *_otherSessionService = NULL;

-(void) setStatusService:(StatusService*)statusService{
    _statusService = statusService;
    [super setStatusService:statusService];
    [self activateStatusMenu];
}

-(void) setOtherSessionService:(OtherSessionService*)sessionService{
    _otherSessionService = sessionService;
    [_otherSessionService addObserver:self forKeyPath:@"stationName" options:NSKeyValueObservingOptionNew context:NULL];
    
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"stationName"])
    {
        NSString* newStation = [change objectForKey:NSKeyValueChangeNewKey];
        if(newStation.length > 0)
        {
            _rootStatusItem.title = @"";
        }
        else
        {
            NSDictionary *titleAttributes = [NSDictionary dictionaryWithObject:[NSColor redColor] forKey:NSForegroundColorAttributeName];
            NSAttributedString* redTitle = [[NSAttributedString alloc] initWithString:@"No Station" attributes:titleAttributes];
            
            [_rootStatusItem setAttributedTitle:redTitle];
        }
    }
}


- (void)activateStatusMenu
{
    _rootStatusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    
    _rootStatusItem.title = @"";
    
    NSBundle *bundle = [NSBundle mainBundle];
    _rootStatusItem.image = [[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"warning" ofType:@"png"]];
    _rootStatusItem.highlightMode = YES;
    
    NSMenu *menu = [[NSMenu alloc] init];
  
    [[menu addItemWithTitle:@"Exit" action:@selector(exit:) keyEquivalent:@""] setTarget:self];
    _rootStatusItem.menu = menu;
}


- (void)statusListChanged:(NSArray*)statusList{
    NSMenu* menu = _rootStatusItem.menu;
    [menu removeAllItems];
    
    _statuses = [[NSMutableArray alloc] init];
    for(int x=0; x<[statusList count]; x++){
        
        Status* status = statusList[x];
        
        if([status isUserSelectable])
        {
            NSMenuItem* newItem;
            newItem = [[NSMenuItem alloc]
                       initWithTitle:[status text]
                       action:@selector(setStatus:)
                       keyEquivalent:@""];
            
            NSImage* statusImage = [[NSImage alloc] initWithContentsOfURL:[NSURL URLWithString:[status imageUrl]]];
            NSSize newSize;
            newSize.width=16;
            newSize.height=16;
            
            [newItem setImage: [self imageResize:statusImage newSize:newSize]];
            [newItem setTarget:self];
            [newItem setTag:[_statuses count]];
            [menu addItem:newItem];
            [_statuses addObject:status];
        }
    }
    
    [menu addItem:[NSMenuItem separatorItem]]; // A thin grey line
    [[menu addItemWithTitle:@"Exit" action:@selector(exit:) keyEquivalent:@""] setTarget:self];
}

- (void) currentStatusChanged:(Status*) status{
    // _rootStatusItem.title = [status text];
    _rootStatusItem.toolTip = [status text];
    NSImage* statusImage = [[NSImage alloc] initWithContentsOfURL:[NSURL URLWithString:[status imageUrl]]];
    NSSize newSize;
    newSize.width=16;
    newSize.height=16;
    
    _rootStatusItem.image = [self imageResize:statusImage newSize:newSize];
}

- (void)setStatus:(id)sender
{
    NSMenuItem* menuItem = (NSMenuItem*)sender;
    int index = (int)[menuItem tag];
    Status* status = _statuses[index];
    
    [_statusService setStatus:[status id]];
    
}

- (void)exit:(id)sender
{
    [[NSApplication sharedApplication] terminate:nil];
}

- (void) connectionUp
{
        NSBundle *bundle = [NSBundle mainBundle];
    NSImage* statusImage = [[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"appointment-recurring" ofType:@"png"]];
    
    NSSize newSize;
    newSize.width=16;
    newSize.height=16;
    
    _rootStatusItem.image = [self imageResize:statusImage newSize:newSize];
    _rootStatusItem.toolTip = @"";
    
}
- (void) connectionDown{
    NSBundle *bundle = [NSBundle mainBundle];
    _rootStatusItem.image = [[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"warning" ofType:@"png"]];
    _rootStatusItem.toolTip = @"Disconnected";
    
    NSMenu* menu = _rootStatusItem.menu;
    [menu removeAllItems];
    
}

@end
