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

@implementation QueueController
QueueService* _queueService;
NSArray* _interactions;
Interaction* _currentInteraction;

-(void) awakeFromNib{
    _queueService = [ServiceLocator getQueueService];
    [_queueService addObserver:self forKeyPath:@"queueList" options:NSKeyValueObservingOptionNew context:NULL];
    
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSArray* newContents = [change objectForKey:NSKeyValueChangeNewKey];
    _interactions = newContents;
    [_queueTable reloadData];
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
    
    NSMenuItem* selectedItem = sender;
    NSInteger tag =  selectedItem.tag;
    Interaction* interaction = _interactions[tag];
    
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
    
    _currentInteraction = interaction;
}

-(NSInteger) numberOfRowsInTableView:(NSTableView *)tableView{
    return _interactions.count;
}

-(id) tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    Interaction* interaction = _interactions[row];
    NSString *identifier = [tableColumn identifier];
    return [interaction valueForKey:identifier];
}

@end
