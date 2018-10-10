//
//  RazaViewRatesController.m
//  Raza
//
//  Created by Praveen S on 11/21/13.
//  Copyright (c) 2013 Raza. All rights reserved.
//

#import "RazaViewRatesController.h"
#import "RazaDataModel.h"
#import "RazaRateCell.h"
#import "PhoneMainView.h"
//#import "RazaCreditCardController.h"

@interface RazaViewRatesController ()

@end

@implementation RazaViewRatesController

static NSString *CellIdentifier = @"RateCountryCell";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"View Rates" image:[UIImage imageNamed:@"view_rates.png"] tag:3];
        self.searchCountryList = [NSMutableArray array];
    }
    return self;
}

#pragma mark -
#pragma mark View methods

- (void)viewDidLoad{
    [super viewDidLoad];

    
    self.rateCountryTableView.separatorColor = [UIColor clearColor];
    [self.rateCountryTableView registerClass: [RazaRateCell class] forCellReuseIdentifier:CellIdentifier];
    self.rateCountryTableView.bounces = NO;
    shouldBeginEditing = YES;
    self.rateCountryTableView.sectionIndexBackgroundColor = [UIColor clearColor];
    self.rateCountryTableView.sectionIndexTrackingBackgroundColor = [UIColor clearColor];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    // [self navigatetosidebar];
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
    
    CAGradientLayer *gradient1 = [BackgroundLayer superViewGradient];
    gradient1.frame = self.topView.bounds;
    gradient1.startPoint = CGPointMake(0.0, 0.0);
    gradient1.endPoint = CGPointMake(0.0, 1.0);
    gradient1.locations = @[@0.7,@1.0];
    [self.topView.layer insertSublayer:gradient1 atIndex:0];
    
    if ([[Razauser SharedInstance] getsidebar].length){
        [Razauser SharedInstance].sideBarIndex=6;
    }else{
        [Razauser SharedInstance].sideBarIndex=4;
    }
    
    self.labelNoResult.hidden = YES;
    self.title = @"View Rates";
    self.countryList = [RazaDataModel sharedInstance].rateListByCountry;
    
    if ([RAZA_APPDELEGATE checkNetworkPriorRequest]) {
        
        if ([self.countryList count] < 1) {
            
            [self fetchCountryListByRates:@""];
        }
    }
    
    else {
        [RAZA_APPDELEGATE showMessage:REQUEST_WITHOUT_NETWORK withMode:MBProgressHUDModeText withDelay:1.5 withShortMessage:NO];
    }
    
    if ([self.countryList count]) {
        [self dataRecordsWithSectionKey:self.countryList];
        
        if (_searchMode) {
            [self searchCountry:_searchCountryBar.text];
        }
    }
}

- (void)fetchCountryListByRates:(NSString *)substring {
    
    [[RazaServiceManager sharedInstance] getCountryListByRates:substring];
    [RazaDataModel sharedInstance].delegate = self;
    
    [RAZA_APPDELEGATE showIndeterminateMessage:@"" withShortMessage:NO];
}

-(void)updateView {
    
    [RAZA_APPDELEGATE hideIndeterminateIndicator:YES];
    
    [self dataRecordsWithSectionKey:self.countryList];
    
}

-(void)dataRecordsWithSectionKey:(NSMutableArray *)countrylist {
    
    NSString* letter;
    _mData = [[NSMutableDictionary alloc] init];
    
    if ([countrylist count]) {
        for (RazaCountryModel *country in countrylist) {
            unichar setKey = [[country.countryName capitalizedString] characterAtIndex:0];
            if(setKey >='0' && setKey <='9')
            {
                letter = @"#";
            }
            else {
                letter = [NSString stringWithFormat:@"%c",setKey];
            }
            NSMutableArray* arr = [_mData objectForKey:letter];
            if (!arr) {
                arr = [[NSMutableArray alloc] init];
                [_mData setObject:arr forKey:letter];
            }
            [arr addObject:country];
        }
    }
    NSMutableArray* _keysections = [[NSMutableArray alloc] initWithArray:[_mData allKeys]];
    [_keysections sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    _sections = [NSArray arrayWithArray:_keysections];
    
    [self.rateCountryTableView reloadData];
}


#pragma mark -
#pragma mark UITableViewDelegate methods

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 20.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([[Razauser SharedInstance] getsidebar].length)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
        
        RazaCreditCardController *view = VIEW(RazaCreditCardController);
        view.isPushFromViewRates = YES;
        [PhoneMainView.instance changeCurrentView:view.compositeViewDescription];
    }
    /*
     ContactsListView *view = VIEW(ContactsListView);
     [PhoneMainView.instance popToView:view.compositeViewDescription];
     
     */
    
    //    RazaCreditCardController *creditVC = [[RazaCreditCardController alloc]initWithNibName:@"RazaCreditCardController" bundle:nil];
    //    creditVC.isPushFromViewRates = YES;
    
    //  self.tabBarController.selectedIndex = RECHARGE_TAB;
    
    // [self.navigationController pushViewController:creditVC animated:YES];
}

//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    
//    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
//    
//    UILabel *countryHeader = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 40)];
//    countryHeader.backgroundColor = [UIColor clearColor];
//    countryHeader.text= @"Country";
//    
//    UILabel *rateHeader = [[UILabel alloc] initWithFrame:CGRectMake(250, 0, 150, 40)];
//    rateHeader.backgroundColor = [UIColor clearColor];
//    rateHeader.text= @"¢/min";
//    
//    headerView.backgroundColor = UIColorFromRGBA(158, 187, 234, 1);
//    
//    [headerView addSubview:countryHeader];
//    [headerView addSubview:rateHeader];
//    
//    return headerView;
//
//}

#pragma mark -
#pragma mark UITableViewDataSource methods

-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    
    if (tableView == self.searchDisplayController.searchResultsTableView){
        return self.searchCountryList;
    }
    else{
        return _sections;
    }
}

-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    
    return index;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    //    NSInteger noOfRow = _searchMode ? [self.searchCountryList count] : [self.countryList count];
    //
    //    [self showMessageWithNoResult:noOfRow];
    
    NSInteger noOfRow = [[_mData objectForKey:[_sections objectAtIndex:section]] count];
    
    return noOfRow;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_sections count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RazaRateCell *cell = (RazaRateCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (!cell){
        cell = [[RazaRateCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    //  RazaCountryModel *countryModel = _searchMode ? [self.searchCountryList objectAtIndex:indexPath.row] : [self.countryList objectAtIndex:indexPath.row];
    
    NSString *sectionName = [_sections objectAtIndex:indexPath.section];
    
    RazaCountryModel *countryModel = [[_mData objectForKey:sectionName] objectAtIndex:indexPath.row];
    cell.labelCountryName.text = countryModel.countryName;
    float priceInFloat = [countryModel.price floatValue];
    NSString *currencyType = @" ¢";
    NSString *priceInString = [NSString stringWithFormat:@"%0.1f", priceInFloat];
    NSString *cellValue = [priceInString stringByAppendingString:currencyType];
    if (priceInFloat >= 100.0) {
        priceInFloat = priceInFloat * 0.01;
        currencyType = @"$";
        priceInString = [NSString stringWithFormat:@"%0.2f", priceInFloat];
        cellValue = [currencyType stringByAppendingString:priceInString];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.labelRate.text = cellValue;
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    return [_sections objectAtIndex:section];
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    // Background color
    view.tintColor = [UIColor whiteColor];
    // Text Color
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:OxfordBlueColor];
    
}

#pragma mark -
#pragma mark Search country methods

-(void)searchCountry:(NSString *)searchValue {
    
    _searchMode = YES;
    [self.searchCountryList removeAllObjects];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.countryName BEGINSWITH[cd] %@",searchValue];
    self.searchCountryList = [NSMutableArray arrayWithArray:[self.countryList filteredArrayUsingPredicate:predicate]];
    
    [self dataRecordsWithSectionKey:self.searchCountryList];
    
    [self.rateCountryTableView reloadData];
}

-(void)resetSearch {
    
    shouldBeginEditing = NO;
    [self.searchCountryList removeAllObjects];
    _searchMode = NO;
    _searchCountryBar.text = @"";
    [_searchCountryBar resignFirstResponder];
    [self dataRecordsWithSectionKey:self.countryList];
    [self.rateCountryTableView reloadData];
    
}

-(void)showMessageWithNoResult:(int)resultcount {
    
    self.labelNoResult.hidden = (resultcount <= 0) ? NO : YES;
    self.rateCountryTableView.hidden = (resultcount <= 0) ? YES : NO;
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
    [self resetSearch];
    self.tableTopConst.constant=0;
    self.searchBtn.hidden=NO;
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

-(void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [RazaDataModel sharedInstance].delegate = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
}
static UICompositeViewDescription *compositeDescription = nil;

+ (UICompositeViewDescription *)compositeViewDescription {
    if (compositeDescription == nil) {
        compositeDescription = [[UICompositeViewDescription alloc] init:self.class
                                                              statusBar:nil//StatusBarView.class
                                                                 tabBar:nil
                                                               sideMenu:SideMenuView.class
                                                             fullscreen:false
                                                         isLeftFragment:YES
                                                           fragmentWith:nil];
        compositeDescription.darkBackground = true;
    }
    return compositeDescription;
}
- (UICompositeViewDescription *)compositeViewDescription {
    return self.class.compositeViewDescription;
}
- (IBAction)btnMenuClicked:(id)sender {
    self.tableTopConst.constant=0;
    self.searchBtn.hidden=NO;
    [_searchCountryBar resignFirstResponder];

    UICompositeView *cvc = PhoneMainView.instance.mainViewController;
    [cvc hideSideMenu:(cvc.sideMenuView.frame.origin.x == 0)];
}
- (IBAction)searchBtnAction:(id)sender {
    self.tableTopConst.constant=55;
    self.searchBtn.hidden=YES;
    [self performSelector:@selector(openKeyboard) withObject:nil afterDelay:0.30000];

}
-(void)openKeyboard{
    [_searchCountryBar becomeFirstResponder];
}

@end
