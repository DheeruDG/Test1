//
//  RazaCountryTableView.m
//  Raza
//
//  Created by Praveen S on 04/12/13.
//  Copyright (c) 2013 Raza. All rights reserved.
//

#import "RazaCountryTableView.h"

@implementation RazaCountryTableView

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
    NSString *pListPath = [[NSBundle mainBundle] pathForResource:@"CountryFrom" ofType:@"plist"];
    NSDictionary *infoDict = [[NSDictionary alloc] initWithContentsOfFile:pListPath];
    
    self.countryModel = [[RazaCountryToModel alloc]initWithJSON:infoDict];
}


#pragma mark -
#pragma mark UITableView delegate & datasource methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger noOfSection = 0;
    noOfSection = [self.countryModel.countryList count];
    
    return noOfSection;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger noOfRow = 0;
    //return [[[self.colorsDict allKeys] objectAtIndex:section] count];
    noOfRow = [[self.countryModel.countryInfo objectForKey:[self.countryModel.countryList objectAtIndex:section]] count];
    
    return noOfRow;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    
    static NSString *CellIdentifier = @"CountryCell";
    
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor colorWithRed:0.8f green:0.8f blue:0.8f alpha:1.0f];
    }
    // Configure the cell...
    
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    
    NSString *key = [self.countryModel.countryList objectAtIndex:indexPath.section];
    NSArray *cities = [self.countryModel.countryInfo objectForKey:key];
    cell.textLabel.text = [cities objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont fontWithName:@"Arial" size:16];
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    return nil;//[self.countryModel.countryList objectAtIndex:section];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    selectedRow = indexPath;
    
    NSString *key = [self.countryModel.countryList objectAtIndex:indexPath.section];
    NSArray *cities = [self.countryModel.countryInfo objectForKey:key];
    
    [self.countrydelegate selectedRowForCountry:[cities objectAtIndex:indexPath.row]];
}

@end
