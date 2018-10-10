//
//  RazaStateListTableView.m
//  Raza
//
//  Created by Kongsberg on 04/12/13.
//  Copyright (c) 2013 Raza. All rights reserved.
//

#import "RazaStateListTableView.h"

@implementation RazaStateListTableView

static NSString *CellIdentifier = @"StateCell";

static NSString *alertTitle = @"State";

-(id)initWithFrame:(CGRect)frame withDelegate:(id <RazaStateTableViewDelegate>)statedelegate {
    
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    self.delegate = self;
    self.dataSource = self;
    self.statedelegate = statedelegate;
    self.separatorStyle = UITableViewCellSeparatorStyleSingleLine;

    [self registerClass: [UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
    
//    [self getStateList];
//    
//    [self reloadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getStateListWithSelectedCountry:)
                                                 name:@"GetStateNotification"
                                               object:nil];
    
    return self;
}

-(void)getStateList {
    
    NSString *pListPath = [[NSBundle mainBundle] pathForResource:@"StateList" ofType:@"plist"];
    
    if (pListPath && [pListPath length]) {
        _states = [[NSDictionary alloc] initWithContentsOfFile:pListPath];
        _keys = [_states allKeys];
        _keys = [_keys sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    }
    else {
        
        //[RAZA_APPDELEGATE showMessage:ERROR_NO_STATES withMode:MBProgressHUDModeText withDelay:1 withShortMessage:YES];
        [RAZA_APPDELEGATE showAlertWithMessage:ERROR_NO_STATES withTitle:alertTitle withCancelTitle:@"Ok"];
    }
}


-(void)getStateListWithSelectedCountry:(NSNotification *)notification {
    
    NSString *preSelectedCountryName, *preSelectedStateName, *preSelectedStateID;
    
    NSDictionary *notif = notification.object;
    
    if ([notification.object isKindOfClass:[RazaCountryFromModel class]]) {
        
        RazaCountryFromModel *countryFromModel = notification.object;
        preSelectedCountryName = countryFromModel.countryName;
    }
    else {
        
        preSelectedCountryName = [notif objectForKey:@"countryname"];
        preSelectedStateName = [notif objectForKey:@"statename"];
        preSelectedStateID = [notif objectForKey:@"stateid"];
    }
    
    NSString *pListPath = [[NSBundle mainBundle] pathForResource:@"StateList" ofType:@"plist"];
    
    if (pListPath && [pListPath length]) {
        
        NSDictionary *plistDict = [[NSDictionary alloc] initWithContentsOfFile:pListPath];
        _states = [plistDict objectForKey:preSelectedCountryName];
        
        _keys = [_states allKeys];
        _keys = [_keys sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        
         [self reloadData];
        
        NSString *defaultStateId = [preSelectedStateID length] ? preSelectedStateID : [_keys objectAtIndex:0];
        NSString *defaultStateTitle = [preSelectedStateName length] ? preSelectedStateName : [_states objectForKey:defaultStateId];
        
        if (!preSelectedStateID) {
            [self.statedelegate updateStateInfoAndShowStateList:defaultStateId withStateName:defaultStateTitle];
        }
        
    }
    else {
        
        //[RAZA_APPDELEGATE showMessage:ERROR_NO_STATES withMode:MBProgressHUDModeText withDelay:1 withShortMessage:YES];
        [RAZA_APPDELEGATE showAlertWithMessage:ERROR_NO_STATES withTitle:alertTitle withCancelTitle:@"Ok"];
    }
    
   
    
    //[[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -
#pragma mark UITableView delegate & datasource methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [[_states allKeys] count];
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
            
    UITableViewCell *cell;
   

    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        
    }
    cell.backgroundColor = [UIColor clearColor];
    // Configure the cell...
    cell.textLabel.textColor=[UIColor whiteColor];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.text = [_states objectForKey:[_keys objectAtIndex:indexPath.row]];
    cell.textLabel.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:18];

    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
            
    return nil;//[self.countryModel.countryList objectAtIndex:section];
}
        
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    checkforstate=@"statevalueclicked";
    NSString *keyWithValue = [_keys objectAtIndex:indexPath.row];
    NSString *selectedValue = [_states objectForKey:keyWithValue];
    
    [self.statedelegate selectedRowForState:selectedValue withKey:keyWithValue];
}

@end
