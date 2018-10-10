/* ContactsViewController.m
 *
 * Copyright (C) 2012  Belledonne Comunications, Grenoble, France
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
 */

#import "PhoneMainView.h"
#import <AddressBook/ABPerson.h>

@implementation ContactSelection

static ContactSelectionMode sSelectionMode = ContactSelectionModeNone;
static NSString *sAddAddress = nil;
static NSString *sSipFilter = nil;
static BOOL sEnableEmailFilter = FALSE;
static NSString *sNameOrEmailFilter;

+ (void)setSelectionMode:(ContactSelectionMode)selectionMode {
    sSelectionMode = selectionMode;
}

+ (ContactSelectionMode)getSelectionMode {
    return sSelectionMode;
}

+ (void)setAddAddress:(NSString *)address {
    sAddAddress = address;
}

+ (NSString *)getAddAddress {
    return sAddAddress;
}

+ (void)setSipFilter:(NSString *)domain {
    sSipFilter = domain;
}

+ (NSString *)getSipFilter {
    return sSipFilter;
}

+ (void)enableEmailFilter:(BOOL)enable {
    sEnableEmailFilter = enable;
}

+ (BOOL)emailFilterEnabled {
    return sEnableEmailFilter;
}

+ (void)setNameOrEmailFilter:(NSString *)fuzzyName {
    sNameOrEmailFilter = fuzzyName;
}

+ (NSString *)getNameOrEmailFilter {
    return sNameOrEmailFilter;
}

@end

@implementation ContactsListView

@synthesize tableController;
@synthesize allButton;
@synthesize linphoneButton;
@synthesize addButton;

typedef enum { ContactsAll, ContactsLinphone, ContactsMAX } ContactsCategory;

#pragma mark - UICompositeViewDelegate Functions

static UICompositeViewDescription *compositeDescription = nil;

+ (UICompositeViewDescription *)compositeViewDescription {
    if (compositeDescription == nil) {//TabBarView.class
        compositeDescription = [[UICompositeViewDescription alloc] init:self.class
                                                              statusBar:nil//StatusBarView.class
                                                                 tabBar:nil
                                                               sideMenu:SideMenuView.class
                                                             fullscreen:false
                                                         isLeftFragment:YES
                                                           fragmentWith:ContactDetailsView.class];
    }
    return compositeDescription;
}

- (UICompositeViewDescription *)compositeViewDescription {
    return self.class.compositeViewDescription;
}

#pragma mark - ViewController Functions

- (void)viewDidLoad {
    [super viewDidLoad];
    

    tableController.tableView.accessibilityIdentifier = @"Contacts table";
    //[self changeView:ContactsAll];
    /*if ([tableController totalNumberOfItems] == 0) {
     [self changeView:ContactsAll];
     }*/
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboards)];
    
    [tap setDelegate:self];
    [self.view addGestureRecognizer:tap];
    
    if (!_searchBar.text.length) {
        // [self searchBar:_searchBar textDidChange:@""];
        [self.tableController removeAllContacts];
        [ContactSelection setNameOrEmailFilter:nil];
    }
    // [super viewWillAppear:animated];
    if (selectedmoderaza.length) {
        _segmentSwitch.selectedSegmentIndex=1;
    }
    else
        _segmentSwitch.selectedSegmentIndex=0;
    _searchBar.showsCancelButton = (_searchBar.text.length > 0);
    
    
    if (tableController.isEditing) {
        tableController.editing = NO;
    }
    //[RAZA_APPDELEGATE
    LinphoneAppDelegate *tlk=[[LinphoneAppDelegate alloc]init];
    [tlk RazauserCount:nil];
    [self refreshButtons];
}

- (void)viewWillAppear:(BOOL)animated {
    
    CAGradientLayer *gradient = [BackgroundLayer navHeaderGradient];
    gradient.frame = self.headerView.bounds;
    gradient.startPoint = CGPointMake(0.0, 0.0);
    gradient.endPoint = CGPointMake(0.0, 1.0);
    gradient.locations = @[@0.0,@1.0];
    [self.headerView.layer insertSublayer:gradient atIndex:0];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatemessegesecounter:) name:@"messegedatecounter" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(missedcallcounter:) name:@"missedcallcounter" object:nil];
    
    int total= [LinphoneManager unreadMessageCount];
    [self updatechatreadunreadcounter:total];
    stringMissedbadge= [[Razauser SharedInstance]getmissed];
    [self updatechatrecent:stringMissedbadge];
    
    //    if (!_searchBar.text.length) {
    //       // [self searchBar:_searchBar textDidChange:@""];
    //        [self.tableController removeAllContacts];
    //        [ContactSelection setNameOrEmailFilter:nil];
    //    }
    //	[super viewWillAppear:animated];
    //    if (selectedmoderaza.length) {
    //        _segmentSwitch.selectedSegmentIndex=1;
    //    }
    //    else
    //        _segmentSwitch.selectedSegmentIndex=0;
    //	_searchBar.showsCancelButton = (_searchBar.text.length > 0);
    //
    //	if (tableController.isEditing) {
    //		tableController.editing = NO;
    //	}
    //	[self refreshButtons];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (![FastAddressBook isAuthorized]) {
        UIAlertController *errView = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Address book", nil)
                                                                         message:NSLocalizedString(@"You must authorize the application to have access to address book.\n"
                                                                                                   "Toggle the application in Settings > Privacy > Contacts",
                                                                                                   nil)
                                                                  preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Continue", nil)
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [errView addAction:defaultAction];
        [self presentViewController:errView animated:YES completion:nil];
        [PhoneMainView.instance popCurrentView];
    }
}

- (void) viewWillDisappear:(BOOL)animated {
    //self.view = NULL;
    //[self.tableController removeAllContacts];
}

#pragma mark -
- (IBAction)segmentSwitchAction:(id)sender {
    UISegmentedControl *segmentedControl = (UISegmentedControl *) sender;
    NSInteger selectedSegment = segmentedControl.selectedSegmentIndex;
    [[Razauser SharedInstance]ShowWaiting:nil];
    if (selectedSegment == 0) {
        
        // LinphoneAppDelegate *tlk=[[LinphoneAppDelegate alloc]init];
        // [tlk RazauserCount:nil];
        selectedmoderaza=nil;
        //toggle the correct view to be visible
        moderazauserornot=nil;
        
        [ContactSelection setSipFilter:nil];
        [ContactSelection enableEmailFilter:FALSE];
        
        //[tableController loadData];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [tableController loadData];
        });
    }
    else{
        LinphoneAppDelegate *tlk=[[LinphoneAppDelegate alloc]init];
        [tlk RazauserCount:nil];
        selectedmoderaza=@"rjuser";
        moderazauserornot=@"rjuser";
        [ContactSelection setSipFilter:LinphoneManager.instance.contactFilter];
        [ContactSelection enableEmailFilter:FALSE];
        // [tableController loadData];
        
        //toggle the correct view to be visible
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [tableController loadData];
        });
    }
}
- (void)changeView:(ContactsCategory)view {
    [[Razauser SharedInstance]ShowWaitingshort:nil andtime:10.0];
    CGRect frame = _selectedButtonImage.frame;
    if (view == ContactsAll) {// && !allButton.selected
        moderazauserornot=nil;
        frame.origin.x = allButton.frame.origin.x;
        [ContactSelection setSipFilter:nil];
        [ContactSelection enableEmailFilter:FALSE];
        allButton.selected = TRUE;
        linphoneButton.selected = FALSE;
        // [[Razauser SharedInstance]ShowWaiting:nil];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            
            [tableController loadData];
        });
    } else if (view == ContactsLinphone ) {//&& !linphoneButton.selected
        moderazauserornot=@"rjuser";
        frame.origin.x = linphoneButton.frame.origin.x;
        [ContactSelection setSipFilter:LinphoneManager.instance.contactFilter];
        [ContactSelection enableEmailFilter:FALSE];
        linphoneButton.selected = TRUE;
        allButton.selected = FALSE;
        // [[Razauser SharedInstance]ShowWaiting:nil];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [tableController loadData];
        });
    }
    _selectedButtonImage.frame = frame;
}

- (void)refreshButtons {
    [addButton setHidden:FALSE];
    [self changeView:[ContactSelection getSipFilter] ? ContactsLinphone : ContactsAll];
}

#pragma mark - Action Functions

- (IBAction)onAllClick:(id)event {
    [self changeView:ContactsAll];
}

- (IBAction)onLinphoneClick:(id)event {
    [self changeView:ContactsLinphone];
}

- (IBAction)onAddContactClick:(id)event {
    ContactDetailsView *view = VIEW(ContactDetailsView);
    [PhoneMainView.instance changeCurrentView:view.compositeViewDescription];
    
    if ([ContactSelection getAddAddress] == nil) {
        [view newContact];
    } else {
        [view newContact:[ContactSelection getAddAddress]];
    }
}

- (IBAction)onDeleteClick:(id)sender {
    NSString *msg = [NSString stringWithFormat:NSLocalizedString(@"Do you want to delete selected contacts?", nil)];
    [UIConfirmationDialog ShowWithMessage:msg
                            cancelMessage:nil
                           confirmMessage:nil
                            onCancelClick:^() {
                                [self onEditionChangeClick:nil];
                            }
                      onConfirmationClick:^() {
                          [tableController removeSelectionUsing:nil];
                          [tableController loadData];
                          [self onEditionChangeClick:nil];
                      }];
}

- (IBAction)onEditionChangeClick:(id)sender {
    allButton.hidden = linphoneButton.hidden = _selectedButtonImage.hidden = addButton.hidden =
    self.tableController.isEditing;
}

- (IBAction)btnbackclicked:(id)sender {
    //selectedmoderaza=nil
    [[LinphoneManager instance] lpConfigSetInt:YES forKey:@"animations_preference"];
    // [PhoneMainView.instance changeCurrentView:DialerView.compositeViewDescription];
    UICompositeView *cvc = PhoneMainView.instance.mainViewController;
    [cvc hideSideMenu:(cvc.sideMenuView.frame.origin.x == 0)];
    
}

- (void)searchBarautosearchButtonClicked:(UISearchBar *)searchBar {
    //	searchBar.text = @"";
    //	//[self searchBar:searchBar textDidChange:@""];
    //    [self.tableController removeAllContacts];
    //     [ContactSelection setNameOrEmailFilter:nil];
    //    [self refreshButtons];
    [ContactSelection setNameOrEmailFilter:searchBar.text];
    if (searchBar.text.length) {
        [self doRemoteQueryforrazauser];
    }
    else
    {
        [self doRemoteQueryforall];
        [searchBar resignFirstResponder];
    }
    
    
    
    //
    //    if (moderazauserornot.length) {
    //        [ContactSelection setSipFilter:LinphoneManager.instance.contactFilter];
    //        [ContactSelection enableEmailFilter:FALSE];
    //        [tableController loadData];
    //    }
    //    else
    //    {
    //        [ContactSelection setSipFilter:nil];
    //        [ContactSelection enableEmailFilter:FALSE];
    //         [tableController loadData];
    //    }
    // moderazauserornot=@"rjuser";
    
    
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    //	searchBar.text = @"";
    //	//[self searchBar:searchBar textDidChange:@""];
    //    [self.tableController removeAllContacts];
    //     [ContactSelection setNameOrEmailFilter:nil];
    //    [self refreshButtons];
    searchBar.text=@"";
    [ContactSelection setNameOrEmailFilter:searchBar.text];
    if (searchBar.text.length) {
        [self doRemoteQueryforrazauser];
    }
    else
    {
        [self doRemoteQueryforall];
        [searchBar resignFirstResponder];
    }
    
    
    
    //
    //    if (moderazauserornot.length) {
    //        [ContactSelection setSipFilter:LinphoneManager.instance.contactFilter];
    //        [ContactSelection enableEmailFilter:FALSE];
    //        [tableController loadData];
    //    }
    //    else
    //    {
    //        [ContactSelection setSipFilter:nil];
    //        [ContactSelection enableEmailFilter:FALSE];
    //         [tableController loadData];
    //    }
    // moderazauserornot=@"rjuser";
    
    
}



- (void)dismissKeyboards {
    if ([self.searchBar isFirstResponder]){
        [self.searchBar resignFirstResponder];
    }
}

#pragma mark - searchBar delegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    // display searchtext in UPPERCASE
    // searchBar.text = [searchText uppercaseString];
    //	[ContactSelection setNameOrEmailFilter:searchText];
    //    if (searchText.length == 0) {
    //
    //           dispatch_async(dispatch_get_main_queue(), ^(){
    //               [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(doRemoteQueryforall) object:nil];
    //               // start a new one in 0.3 seconds
    //               [self performSelector:@selector(doRemoteQueryforall) withObject:nil afterDelay:0.3];
    //           });
    //        //[tableController loadData];
    //        //  });
    //
    //
    //
    //        //[tableController loadData];
    //    } else {
    //        dispatch_async(dispatch_get_main_queue(), ^(){
    //
    //        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(doRemoteQueryforrazauser) object:nil];
    //        // start a new one in 0.3 seconds
    //        [self performSelector:@selector(doRemoteQueryforrazauser) withObject:nil afterDelay:0.3];
    //
    //
    //
    //       // [tableController loadSearchedData];
    //       });
    //
    //    }
    
    //if([searchText length] == 0) {
    // [self searchBarCancelButtonClicked:searchBar];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(searchBarautosearchButtonClicked:) object:searchBar];
    [self performSelector:@selector(searchBarautosearchButtonClicked:) withObject:searchBar afterDelay:0.5];
    //}
}
-(void)doRemoteQueryforall
{
    // [[Razauser SharedInstance]ShowWaiting:nil];
    [tableController loadData];
}
-(void)doRemoteQueryforrazauser
{
    //[[Razauser SharedInstance]ShowWaiting:nil];
    [tableController loadSearchedData];
    
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:FALSE animated:TRUE];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:TRUE animated:TRUE];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    [ContactSelection setNameOrEmailFilter:searchBar.text];
    if (searchBar.text.length == 0) {
        [self doRemoteQueryforall];
        //dispatch_async(dispatch_get_main_queue(), ^(){
        // [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(doRemoteQueryforall) object:nil];
        // start a new one in 0.3 seconds
        //[self performSelector:@selector(doRemoteQueryforall) withObject:nil afterDelay:0.3];
        // });
        //[tableController loadData];
        //  });
        
        
        
        //[tableController loadData];
    } else {
        //dispatch_async(dispatch_get_main_queue(), ^(){
        
        //[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(doRemoteQueryforrazauser) object:nil];
        // start a new one in 0.3 seconds
        //  [self performSelector:@selector(doRemoteQueryforrazauser) withObject:nil afterDelay:0.3];
        [self doRemoteQueryforrazauser];
        
        
        // [tableController loadSearchedData];
        // });
        
    }
}

#pragma mark - GestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (![self.searchBar isFirstResponder]) {
        return NO;
    }
    return YES;
}

- (IBAction)btnDialPadClicked:(id)sender {
    [self searchBarCancelButtonClicked:_searchBar];
    [[LinphoneManager instance] lpConfigSetInt:NO forKey:@"animations_preference"];
    [PhoneMainView.instance changeCurrentView:DialerView.compositeViewDescription];
}
- (IBAction)btnChatClicked:(id)sender {
    [self searchBarCancelButtonClicked:_searchBar];
    [[LinphoneManager instance] lpConfigSetInt:NO forKey:@"animations_preference"];
    [PhoneMainView.instance changeCurrentView:ChatsListView.compositeViewDescription];
}
- (IBAction)btnrecentClicked:(id)sender {
    [self searchBarCancelButtonClicked:_searchBar];
    [[LinphoneManager instance] lpConfigSetInt:NO forKey:@"animations_preference"];
    [PhoneMainView.instance changeCurrentView:HistoryListView.compositeViewDescription];
}

-(void)updatechatreadunreadcounter:(int)total{
    
    int t = 0;
    NSDictionary *pushdict=[[Razauser SharedInstance]getPushrazaCounter];
    for (NSString* key in pushdict)
    {
        int value = [[pushdict objectForKey:key] intValue];
        t=t+value;
    }
    total=total+t;
    if (total){
        _lblcounterchat.layer.cornerRadius = _lblcounterchat.frame.size.width / 2;
        _lblcounterchat.clipsToBounds = YES;
        _lblcounterchat.hidden=NO;
        _lblcounterchat.text=[NSString stringWithFormat:@"%d",total];
        _unreadCountView.backgroundColor=[UIColor clearColor];
        [_unreadCountView startAnimating:YES];
    }else{
        _lblcounterchat.layer.cornerRadius = _lblcounterchat.frame.size.width / 2;
        _lblcounterchat.clipsToBounds = YES;
        _lblcounterchat.hidden=YES;
        _unreadCountView.backgroundColor=[UIColor clearColor];
        [_unreadCountView stopAnimating:YES];
    }
    
}
-(void)updatechatrecent:(int)total{
    
    if (total){
        _lblrecentcounter.layer.cornerRadius = _lblrecentcounter.frame.size.width / 2;
        _lblrecentcounter.clipsToBounds = YES;
        _lblrecentcounter.hidden=NO;
        
        _lblrecentcounter.text=[NSString stringWithFormat:@"%d",total];
        _unreadCountrecentView.backgroundColor=[UIColor clearColor];
        [_unreadCountrecentView startAnimating:YES];
    }else{
        _lblrecentcounter.layer.cornerRadius = _lblrecentcounter.frame.size.width / 2;
        _lblrecentcounter.clipsToBounds = YES;
        _lblrecentcounter.hidden=YES;
        _unreadCountrecentView.backgroundColor=[UIColor clearColor];
        [_unreadCountrecentView stopAnimating:YES];
    }
    
}
- (void)updatemessegesecounter:(NSNotification *)notif{
    //notif.object;
    int stringbadge=[LinphoneManager unreadMessageCount];//[notif.object integerValue];
    [self updatechatreadunreadcounter:stringbadge];
    
}
-(void)missedcallcounter:(NSNotification*)notify{
    int stringbadge=(int)[notify.object integerValue];
    stringbadge=stringbadge+ stringMissedbadge;
    if (stringbadge) {
        [self updatechatrecent:stringbadge];
    }
}

@end
