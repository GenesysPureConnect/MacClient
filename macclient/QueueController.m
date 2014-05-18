//
//  QueueController.m
//  CIC Mac Client
//
//  Created by Glinski, Kevin on 3/1/14.
//  Copyright (c) 2014 Interactive Intelligence. All rights reserved.
//

#import "QueueController.h"
#import "ServiceLocator.h"
#import "QueueService.h"
#import "Interaction.h"
#import "QueueItemView.h"

@implementation QueueController
QueueService* _queueService;
NSArray* _interactions;
Interaction* _currentInteraction;
NSTimer* _timer;

BOOL isInitialized = NO;

#define MyPrivateTableViewDataType @"MyPrivateTableViewDataType"


-(void) awakeFromNib{
    
    if(isInitialized == NO)
    {
        _queueService = [ServiceLocator getMyInteractionsQueueService];
        [_queueService addObserver:self forKeyPath:@"queueList" options:NSKeyValueObservingOptionNew context:NULL];
   
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self
                                            selector:@selector(updateInteractionTime:) userInfo:nil repeats:YES];
        
        [_queueTable registerForDraggedTypes: [NSArray arrayWithObject:MyPrivateTableViewDataType]];
        
        isInitialized = YES;
    }
    
}
-(void)updateInteractionTime:(NSTimer*)aTimer
{
    if(_interactions.count > 0 )
    {
        NSInteger row = [_queueTable selectedRow];
        [_queueTable reloadData];
        [_queueTable selectRowIndexes:[NSIndexSet indexSetWithIndex:row] byExtendingSelection:NO];
        
    }
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSArray* newContents = [change objectForKey:NSKeyValueChangeNewKey];
    _interactions = newContents;
 
    
    NSInteger row = [_queueTable selectedRow];
    [_queueTable reloadData];
    [_queueTable selectRowIndexes:[NSIndexSet indexSetWithIndex:row] byExtendingSelection:NO];
    
    if(_currentInteraction != NULL)
    {
        [self setCallControlButtonState:_currentInteraction];
    }
    
}

- (IBAction)pickupClick:(id)sender {
    [_queueService pickupInteraction:_currentInteraction];
}

- (IBAction)disconnectClick:(id)sender {
    [_queueService disconnectInteraction:_currentInteraction];
}

- (IBAction)holdClick:(id)sender {
    [_queueService holdInteraction:_currentInteraction holdOn:![_currentInteraction isHeld]];
}

- (IBAction)muteClick:(id)sender {
    [_queueService muteInteraction:_currentInteraction muteOn:![_currentInteraction isMuted]];

}

- (IBAction)selectCall:(id)sender {
    
    NSInteger row = [_queueTable selectedRow];
  
    if(_interactions.count < row){
        return;
    }
    
    Interaction* interaction = _interactions[row];
    
    [self setCallControlButtonState:interaction];

}

-(void) setCallControlButtonState:(Interaction*)interaction{
    [_pickupButton setEnabled: interaction.canPickup];
    [_disconnectButton setEnabled:interaction.canDisconnet];
    [_holdButton setEnabled:interaction.canHold];
    if(interaction.isHeld)
    {
        [_holdButton setState: NSOnState];
    }
    else
    {
        [_holdButton setState:NSOffState];
    }
    
    [_muteButton setEnabled:interaction.canMute];
    if(interaction.isMuted)
    {
        [_muteButton setState: NSOnState];
    }
    else
    {
        [_muteButton setState:NSOffState];
    }
    
    [_conferenceButton setState: _interactions.count > 0 ? NSOnState : NSOffState];
    
    
    _currentInteraction = interaction;
}

-(NSInteger) numberOfRowsInTableView:(NSTableView *)tableView{
    return _interactions.count;
}


- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    
    
    QueueItemView *result = [tableView makeViewWithIdentifier:tableColumn.identifier owner:self];
   
    Interaction* interaction = _interactions[row];

    if(interaction.isConference)
    {
        result.textField.stringValue = @"Conference";
    }
    else{
        result.textField.stringValue = [NSMutableString stringWithString: interaction.remoteName];
    }
    result.callId.stringValue = [NSMutableString stringWithString: interaction.interactionId];
    result.stateString.stringValue = [NSMutableString stringWithString: interaction.callStateDescription];
    result.number.stringValue = [NSMutableString stringWithString: interaction.remoteId];
    result.timeInStatus.stringValue =  [NSMutableString stringWithString: interaction.formattedDurationString];
    result.imageView.image = interaction.image;
    return result;
}


int _dragInteractionIndex = -1;

// drag operation stuff
- (BOOL)tableView:(NSTableView *)tv writeRowsWithIndexes:(NSIndexSet *)rowIndexes toPasteboard:(NSPasteboard*)pboard {
    // Copy the row numbers to the pasteboard.
    NSData *zNSIndexSetData =
    [NSKeyedArchiver archivedDataWithRootObject:rowIndexes];
    [pboard declareTypes:[NSArray arrayWithObject:MyPrivateTableViewDataType]
                   owner:self];
    [pboard setData:zNSIndexSetData forType:MyPrivateTableViewDataType];
    
    _dragInteractionIndex = (int)rowIndexes.firstIndex;
    
    Interaction* dragInteraction = _interactions[_dragInteractionIndex];
    
    if(dragInteraction.isConference){
        return NO;
    }
    
    return YES;
}

- (NSDragOperation)tableView:(NSTableView*)tv validateDrop:(id )info proposedRow:(NSInteger)row proposedDropOperation:(NSTableViewDropOperation)op {
    // Add code here to validate the drop
    
    return NSDragOperationEvery;
}

- (BOOL)tableView:(NSTableView *)aTableView
       acceptDrop:(id )info
              row:(NSInteger)row
    dropOperation:(NSTableViewDropOperation)operation {
    
    Interaction* dragInteraction = _interactions[_dragInteractionIndex];
    Interaction* dropInteraction = _interactions[row];
    
    _dragInteractionIndex = -1;
    
    if(dropInteraction.isConference){
        [_queueService addToConference:dragInteraction toConference:dropInteraction];
    }
    else{
        [_queueService conferenceInteractions:dragInteraction withSecond:dropInteraction];
    }
    
    
    return YES;
}

@end
