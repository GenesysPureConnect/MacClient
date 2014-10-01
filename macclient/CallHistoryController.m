//
//  CallHistoryController.m
//  MacClient
//
//  Created by Glinski, Kevin on 9/29/14.
//  Copyright (c) 2014 Interactive Intelligence. All rights reserved.
//

#import "CallHistoryController.h"
#import "ServiceLocator.h"
#import "InteractionHistoryService.h"

@implementation CallHistoryController
BOOL isCallHistoryInitialized = NO;
InteractionHistoryService* _historyService;
NSTimer* _refreshTimer;

-(void) awakeFromNib{
    
    if(isCallHistoryInitialized == NO)
    {
        _historyService = [ServiceLocator getInteractionHistoryService];
       isCallHistoryInitialized = YES;
        [_tableOutlet setTarget:self];
        [_tableOutlet setDoubleAction:@selector(doubleClick: )];
        _refreshTimer =  [NSTimer scheduledTimerWithTimeInterval: 2 target:self selector:@selector(reloadTable:) userInfo:nil repeats:YES];
    }
    
}


-(void)reloadTable: (NSTimer *)theTimer {
    [_tableOutlet reloadData];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    return self;
}

-(NSInteger) numberOfRowsInTableView:(NSTableView *)tableView{
    return [_historyService historyCount];
}


- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    
    NSTableCellView *result = [tableView makeViewWithIdentifier:tableColumn.identifier owner:self];
    
    InteractionHistoryItem* interaction = [_historyService getItemAt:row];
    
    NSString* value = NULL;
    if([[tableColumn identifier]  isEqual: @"date"]){
        value = [NSDateFormatter localizedStringFromDate: [interaction initiationTime]
                                       dateStyle:NSDateFormatterShortStyle
                                       timeStyle:NSDateFormatterShortStyle];
    }
    else if([[tableColumn identifier]  isEqual: @"name"]){
        value = [interaction remoteName];
    }
    else if([[tableColumn identifier]  isEqual: @"number"]){
        value = [interaction remoteId];
    }
    else{
        value = @"";
    }
    
    result.textField.stringValue = value;
    
    return result;
}

- (void)doubleClick:(id)nid
{
    NSInteger rowNumber = [_tableOutlet clickedRow];
    
    NSString* phoneNumber = [[_historyService getItemAt:rowNumber] remoteId];
    
    CallService* callService = [ServiceLocator getCallService];
    [callService placeCall:phoneNumber];

    
}

@end
