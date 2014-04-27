//
//  DirectorySearchController.m
//  CIC Mac Client
//
//  Created by Glinski, Kevin on 4/25/14.
//  Copyright (c) 2014 Interactive Intelligence. All rights reserved.
//

#import "DirectorySearchController.h"
#import "ServiceLocator.h"
#import "StatusService.h"
#import "status.h"
#import "CallService.h"

const long kResultHeight=21;

@implementation DirectorySearchController

DirectoryService* _directoryService;
StatusService* _statusService;
CallService* _callService;

NSArray* _searchResults;
BOOL _isDirectoryInitialized = NO;

-(void) awakeFromNib{
    if(_isDirectoryInitialized == NO)
    {
        _directoryService = [ServiceLocator getDirectoryService];
        _statusService = [ServiceLocator getStatusService];
        _callService = [ServiceLocator getCallService];
        
        _isDirectoryInitialized = YES;
        
        [_tableParent setHidden: YES];
        [_directoryContactBox setHidden:YES];
        
        [_onPhoneImage setToolTip:@"On the Phone"];
        [_loggedInImage setToolTip:@"Logged In"];
        
    }
}

- (IBAction)performSearch:(id)sender {
    
    NSLog(@"perform search on %@", [_directorySearch stringValue]);
    _searchResults = [_directoryService lookupUsersByNameOrDepartment:[_directorySearch stringValue]];
    
    [_tableParent setHidden:_searchResults.count == 0];
    
    [_searchResultsTable reloadData];
    
    float height = (kResultHeight * _searchResults.count * 1.1);
    
    if(_searchResults.count > 7){
        height = (7 * kResultHeight) + 10;
    }
    
    
    NSRect size = _tableParent.frame;
    size.size.height = height;
    _tableParent.frame = size;
}


-(NSInteger) numberOfRowsInTableView:(NSTableView *)tableView{
    return _searchResults.count;
}


- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    
    NSTableCellView *result = [tableView makeViewWithIdentifier:tableColumn.identifier owner:self];
    
    NSDictionary* user =_searchResults[row];
    
    result.textField.stringValue = user[@"displayName"];
    
    return result;
}


- (IBAction)closeDirectoryContact:(id)sender {
    [_directoryContactBox setHidden:YES];
    [_tableParent setHidden:_searchResults.count == 0];
    
}
- (IBAction)directorySearchContectSelected:(id)sender {
    [_directoryContactBox setHidden:NO];
    [_tableParent setHidden:YES];
    
    NSDictionary* contact = _searchResults[[_searchResultsTable selectedRow]];
    
    _contactName.stringValue = contact[@"displayName"];
    
    if([[contact allKeys] containsObject:@"department"] )
    {
        _contactDepartment.stringValue = contact[@"department"];
    }
    else{
        _contactDepartment.stringValue = @"";
    }
    
    [_workButton setHidden: ![[contact allKeys] containsObject:@"extension"]];
    
    [_mobileButton setHidden: ![[contact allKeys] containsObject:@"mobilePhone"]];
    
    [_homeButton setHidden: ![[contact allKeys] containsObject:@"homePhone"]];
    
    
    NSDictionary* userStatus = [_statusService getStatus:contact[@"statusURI"]];
    
    BOOL onPhone = (BOOL)userStatus[@"onPhone"];
    BOOL loggedIn = (BOOL)userStatus[@"loggedIn"];
    
    [_onPhoneImage setHidden: !onPhone ];
    
    [_loggedInImage setHidden: !loggedIn ];
    
    NSString* statusId = userStatus[@"statusId"];
    
    Status* statusDetails = [_statusService getStatusDetails:statusId];
    
    _statusLabel.stringValue = statusDetails.text;
    [_statusImage setImage:[[NSImage alloc] initWithContentsOfURL:[NSURL URLWithString:statusDetails.imageUrl]]];
    
}
- (IBAction)onWorkButtonClicked:(id)sender {
    NSDictionary* contact = _searchResults[[_searchResultsTable selectedRow]];
    
    [_callService placeCall:contact[@"extension"]];
    
    [_directoryContactBox setHidden:YES];
    [_tableParent setHidden:YES];
    
    _directorySearch.stringValue = @"";
    
}

- (IBAction)onMobileButtonClicked:(id)sender {
    
    NSDictionary* contact = _searchResults[[_searchResultsTable selectedRow]];
    
    [_callService placeCall:contact[@"mobilePhone"][@"dialString"]];
    
    [_directoryContactBox setHidden:YES];
    [_tableParent setHidden:YES];
    
    _directorySearch.stringValue = @"";
}

- (IBAction)onHomeButtonClicked:(id)sender {
    NSDictionary* contact = _searchResults[[_searchResultsTable selectedRow]];
    
    [_callService placeCall:contact[@"homePhone"][@"dialString"]];
    
    [_directoryContactBox setHidden:YES];
    [_tableParent setHidden:YES];
    
    _directorySearch.stringValue = @"";
    
}
@end
