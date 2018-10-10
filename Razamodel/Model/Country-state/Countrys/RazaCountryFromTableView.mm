//
//  RazaCountryFromTableView.m
//  Raza
//
//  Created by Praveen S on 04/12/13.
//  Copyright (c) 2013 Raza. All rights reserved.
//

#import "RazaCountryFromTableView.h"

@implementation RazaCountryFromTableView

-(id)initWithFrame:(CGRect)frame withDelegate:(id <RazaCountryTableViewDelegate>)countrydelegate {
    
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    self.delegate = self;
    self.dataSource = self;
    self.countrydelegate = countrydelegate;
    self.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    [self registerClass: [UITableViewCell class] forCellReuseIdentifier:@"CountryCell"];
    
    [self appCountryList];
    [self reloadData];
    
//    selectedRow = [NSIndexPath indexPathForRow:1 inSection:0];
//    [self selectRowAtIndexPath:selectedRow animated:YES scrollPosition:UITableViewScrollPositionTop];
//    self.backgroundColor = [UIColor clearColor];
    
    return self;
}


- (void)appCountryList {
    
    if ([[RazaDataModel sharedInstance].countryFromList count]) {
        records = [RazaDataModel sharedInstance].countryFromList;
    }
//    else {
//        
//        NSString *pListPath = [[NSBundle mainBundle] pathForResource:@"CountryFrom" ofType:@"plist"];
//        NSDictionary *infoDict = [[NSDictionary alloc] initWithContentsOfFile:pListPath];
//        
//        self.countryModel = [[RazaCountryFromModel alloc]initWithJSON:infoDict];
//    }
}


#pragma mark -
#pragma mark UITableView delegate & datasource methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger noOfRow = 0;
    
    noOfRow = [records count] - 1;
    
//    if (noOfRow == 0) {
//        
//        [[self.countryModel.countryInfo objectForKey:[self.countryModel.countryList objectAtIndex:section]] count];
//    }
    return noOfRow;
}

//#FIXME: Hide the U.K. country for the time being.

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // [TODO:ios update]
    tableView.separatorColor = [UIColor clearColor];

    UITableViewCell *cell;
    static NSString *CellIdentifier = @"CountryCell";
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
    cell.backgroundColor = [UIColor clearColor];
    // Configure the cell...
    
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    
    RazaCountryFromModel *countryFromModel = [records objectAtIndex:indexPath.row];
    
    if ([countryFromModel.countryName isEqualToString:@"U.K."]) {
        cell.textLabel.text = @"";
    }
    else {
        cell.textLabel.text = countryFromModel.countryName;
    }
    
    //NSString *key =  //[self.countryModel.countryList objectAtIndex:indexPath.section];
    //NSArray *cities = [self.countryModel.countryInfo objectForKey:key];
    cell.textLabel.textColor=[UIColor whiteColor];
    cell.textLabel.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:18];
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    return nil;//[self.countryModel.countryList objectAtIndex:section];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RazaCountryFromModel *countryFromModel = [records objectAtIndex:indexPath.row];
    
    [self.countrydelegate selectedRowForCountry:countryFromModel];
}

@end
