//
//  ChangeStationController.m
//  MacClient
//
//  Created by Glinski, Kevin on 5/17/14.
//  Copyright (c) 2014 Interactive Intelligence. All rights reserved.
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.
//

#import "ChangeStationController.h"
#import "constants.h"
#import "ConnectionService.h"
#import "ServiceLocator.h"

@implementation ChangeStationController

ConnectionService *_connectionService;
NSMutableArray* _workstationHistory;

-(void) awakeFromNib{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    [_stationType selectItemWithTag:[prefs integerForKey:kWorkstationType]];
    [_Station setStringValue:[prefs stringForKey:kWorkstationName]];
    
    _workstationHistory = [[NSMutableArray alloc] initWithArray: [prefs arrayForKey:kWorkstationHistory]];
    if(_workstationHistory == NULL){
        _workstationHistory = [[NSMutableArray alloc] init];
    }
    [_Station removeAllItems];
    [_Station addItemsWithObjectValues:_workstationHistory];
    

    
    
    _connectionService = [ServiceLocator getConnectionService];
    
}
- (IBAction)CancelButtonClick:(id)sender {
    [_changeStationWindow close];
}

- (IBAction)OkButtonClick:(id)sender {
    
    BOOL result = FALSE;
    
    if ([_stationType selectedTag] == 1){
        result = [_connectionService setWorkstation:[_Station stringValue]];
    }
    else if([_stationType selectedTag] == 2){
        result = [_connectionService setRemoteNumber:[_Station stringValue]];
    }
    
    if(!result)
    {
        [_errorTextField setStringValue:@"Unable to set station"];
    }
    else{
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        
        [prefs setInteger:[_stationType selectedTag] forKey:kWorkstationType];
        [prefs setObject:[_Station stringValue] forKey:kWorkstationName];
        
        if(_workstationHistory != NULL)
        {
            NSString* workstation = [_Station stringValue];
            
            if(workstation != NULL && ![_workstationHistory containsObject:workstation]){
                [_workstationHistory insertObject:workstation atIndex:0];
                
                if([_workstationHistory count] > 5)
                {
                    [_workstationHistory removeLastObject];
                }
            }
            [prefs setObject:_workstationHistory forKey:kWorkstationHistory];
        }

        
        [prefs synchronize];
        
        [_changeStationWindow close];
    }

   
}
@end
