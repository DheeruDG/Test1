//
//  RazaAutoCountryVC.m
//  Raza
//
//  Created by Praveen S on 11/17/13.
//  Copyright (c) 2013 Raza. All rights reserved.
//

#import "RazaAutoCountryVC.h"
#import "RazaDataModel.h"
#import "RazaServiceManager.h"
#import "RazaAutoCountryCell.h"
#import "RazaCountryToModel.h"

@interface RazaAutoCountryVC ()

@end

@implementation RazaAutoCountryVC
static NSString *CellIdentifier = @"CountryCell";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.searchCountryList = [NSMutableArray array];
        self.countryList = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    _searchMode = NO;
    
    [super viewDidLoad];
    
    [self.autoCountryTableView registerClass: [RazaAutoCountryCell class] forCellReuseIdentifier:CellIdentifier];
   // [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:36 green:60 blue:128 alpha:1]];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    CAGradientLayer *gradient = [BackgroundLayer navHeaderGradient];
    gradient.frame = self.headerView.bounds;
    gradient.startPoint = CGPointMake(0.0, 0.0);
    gradient.endPoint = CGPointMake(0.0, 1.0);
    gradient.locations = @[@0.0,@1.0];
    [self.headerView.layer insertSublayer:gradient atIndex:0];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTable:) name:rViewRatesCountryNotif object:nil];
    
    if ([RazaDataModel sharedInstance].countryToList &&
        [[RazaDataModel sharedInstance].countryToList count]) {
        
        [self loadCountryToData];
    }
    
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
   // UIImage *Image = [UIImage imageNamed:@"Color.png"];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
  //  [[UINavigationBar appearance] setBackgroundImage:Image forBarMetrics:UIBarMetricsDefault];
}

-(void)viewWillDisappear:(BOOL)animated {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:rViewRatesCountryNotif object:nil];
}

#pragma mark -
#pragma mark UITableViewDelegate methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger noOfRow = _searchMode ? [self.searchCountryList count] : [self.countryList count];
    
    return noOfRow;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {    
    
    RazaAutoCountryCell *cell = (RazaAutoCountryCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (!cell)
    {
        cell = [[RazaAutoCountryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor colorWithRed:0.8f green:0.8f blue:0.8f alpha:1.0f];
    }
    RazaCountryToModel *countryModel = _searchMode ? [self.searchCountryList objectAtIndex:indexPath.row] : [self.countryList objectAtIndex:indexPath.row];

    cell.labelCountryName.text = countryModel.countryName;
    //cell.labelCountryName.textAlignment = NSTextAlignmentCenter;

    //cell.textLabel.text = countryModel.countryName;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self dismissViewControllerAnimated:YES completion:nil];
    
    RazaCountryToModel *countryModel = _searchMode ? [self.searchCountryList objectAtIndex:indexPath.row] : [self.countryList objectAtIndex:indexPath.row];
    
    [self.delegate updateCountryToTextField:countryModel];
}

#pragma mark -
#pragma mark Get Country methods

- (void)loadCountryToData {
	
    self.countryList = [RazaDataModel sharedInstance].countryToList;
}

-(void)searchCountry:(NSString *)searchValue {
    
    _searchMode = YES;
    [self.searchCountryList removeAllObjects];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.countryName CONTAINS[cd] %@",searchValue];
    self.searchCountryList = [NSMutableArray arrayWithArray:[self.countryList filteredArrayUsingPredicate:predicate]];
    
    [self.autoCountryTableView reloadData];
}

-(void)resetSearch {
    
    shouldBeginEditing = NO;
    [self.searchCountryList removeAllObjects];
    _searchMode = NO;
    [_searchCountryBar resignFirstResponder];
    [self.autoCountryTableView reloadData];
    
}

-(void)reloadTable:(id)sender {
    
    self.countryList = [RazaDataModel sharedInstance].countryToList;
    
    [self.autoCountryTableView reloadData];
}



#pragma mark -
#pragma mark UISearchBar delegate methods

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    _searchMode = YES;
}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    return YES;
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.text=@"";
    [self resetSearch];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    if ([searchText length]) {
        [self searchCountry:searchText];
    }
    
    if(![searchBar isFirstResponder]) {
        // user tapped the 'clear' button
        [self resetSearch];
    }
    else if ([searchText length] == 0) {
        [searchBar performSelector: @selector(resignFirstResponder)
                        withObject: nil
                        afterDelay: 0.1];
        [self resetSearch];
    }
}


- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)bar {
    // reset the shouldBeginEditing BOOL ivar to YES, but first take its value and use it to return it from the method call
    BOOL boolToReturn = shouldBeginEditing;
    shouldBeginEditing = YES;
    return boolToReturn;
}



-(void)sendData:(NSMutableArray *)result {
    if ([result count]) {
        self.countryList = result;
        [self.autoCountryTableView reloadData];
    }
    
}

- (IBAction)buttonDismiss:(id)sender {
   // [self dismissViewControllerAnimated:YES completion:nil];
  
    
    [self.delegate updateCountryToTextField:nil];
}
@end
