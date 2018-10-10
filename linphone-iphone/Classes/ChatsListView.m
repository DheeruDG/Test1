/* ChatViewController.m
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

#import "ChatsListView.h"
#import "PhoneMainView.h"

#import "ChatConversationCreateView.h"
@implementation ChatsListView

#pragma mark - ViewController Functions

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(textReceivedEvent:)
                                               name:kLinphoneMessageReceived
                                             object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(callUpdateEvent:)
                                               name:kLinphoneCallUpdate
                                             object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(checkChatData)
                                               name:@"CHATDELETED"
                                             object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(missedcallcounter:) name:@"missedcallcounter" object:nil];
    
    stringMissedbadge= [[Razauser SharedInstance]getmissed];
    [self updatechatrecent:stringMissedbadge];
    
    [_backToCallButton update];
    [self setEditing:NO];
    //[self settitleview:nil andrightbar:nil];
    CAGradientLayer *gradient = [BackgroundLayer navHeaderGradient];
    gradient.frame = self.headerView.bounds;
    gradient.startPoint = CGPointMake(0.0, 0.0);
    gradient.endPoint = CGPointMake(0.0, 1.0);
    gradient.locations = @[@0.0,@1.0];
    [self.headerView.layer insertSublayer:gradient atIndex:0];
    [self checkChatData];
    
}
-(void)checkChatData{
    if (_tableController.loadDataCount==0) {
        [self performSelector:@selector(onAddClick:) withObject:nil afterDelay:0.0000];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [NSNotificationCenter.defaultCenter removeObserver:self name:kLinphoneMessageReceived object:nil];
    self.view = NULL;
}

#pragma mark - Event Functions

- (void)textReceivedEvent:(NSNotification *)notif {
    [_tableController loadData];
}

- (void)callUpdateEvent:(NSNotification *)notif {
    [_backToCallButton update];
}

#pragma mark - UICompositeViewDelegate Functions

static UICompositeViewDescription *compositeDescription = nil;

+ (UICompositeViewDescription *)compositeViewDescription {
    if (compositeDescription == nil) {
        compositeDescription = [[UICompositeViewDescription alloc] init:self.class
                                                              statusBar:nil
                                                                 tabBar:nil
                                                               sideMenu:SideMenuView.class
                                                             fullscreen:false
                                                         isLeftFragment:YES
                                                           fragmentWith:ChatConversationCreateView.class];
    }
    return compositeDescription;
}

- (UICompositeViewDescription *)compositeViewDescription {
    return self.class.compositeViewDescription;
}

#pragma mark - Action Functions

- (IBAction)onAddClick:(id)event {
    [[LinphoneManager instance] lpConfigSetInt:YES forKey:@"animations_preference"];
    [PhoneMainView.instance changeCurrentView:ChatConversationCreateView.compositeViewDescription];
}

- (IBAction)onEditionChangeClick:(id)sender {
    _addButton.hidden = self.tableController.isEditing;
    [_backToCallButton update];
}

- (IBAction)onDeleteClick:(id)sender {
    NSString *msg =
    [NSString stringWithFormat:NSLocalizedString(@"Do you want to delete selected conversations?", nil)];
    [UIConfirmationDialog ShowWithMessage:msg
                            cancelMessage:nil
                           confirmMessage:nil
                            onCancelClick:^() {
                                [self onEditionChangeClick:nil];
                            }
                      onConfirmationClick:^() {
                          [_tableController removeSelectionUsing:nil];
                          [_tableController loadData];
                          [self onEditionChangeClick:nil];
                      }];
}

- (IBAction)backtodialClicked:(id)sender {
    [self previousecall];
}
-(void)settitleview:(NSString*)nameof andrightbar:(UIBarButtonItem*)rightbarbtn
{
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 44.0)];
    // UINavigationItem *titleItem = [[UINavigationItem alloc] initWithTitle:@"MyNavBar"];
    UINavigationItem *titleItem = [[UINavigationItem alloc] init];
    
    
    
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"arrow_btn.png"]
                                                                         style:UIBarButtonItemStylePlain target:self action:@selector(previousecall)];
    
    titleItem.leftBarButtonItem = revealButtonItem;
    if (rightbarbtn) {
        titleItem.rightBarButtonItem = rightbarbtn;
    }
    navBar.items = @[titleItem];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    // [[UINavigationBar appearance] setBackgroundColor:[UIColor redColor]];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed: @"header_bg.png"]
                                       forBarMetrics:UIBarMetricsDefault];
    [self.view addSubview:navBar];
    
    
    
}
-(void)previousecall
{
    [[LinphoneManager instance] lpConfigSetInt:YES forKey:@"animations_preference"];
    // DialerView *view = VIEW(DialerView);
    // [PhoneMainView.instance popToView:view.compositeViewDescription];
    UICompositeView *cvc = PhoneMainView.instance.mainViewController;
    [cvc hideSideMenu:(cvc.sideMenuView.frame.origin.x == 0)];
}

- (IBAction)btnDialPadClicked:(id)sender {
    [[LinphoneManager instance] lpConfigSetInt:NO forKey:@"animations_preference"];
    [PhoneMainView.instance changeCurrentView:DialerView.compositeViewDescription];
}

- (IBAction)btnContactClicked:(id)sender {
    [ContactSelection setAddAddress:nil];
    [ContactSelection enableEmailFilter:FALSE];
    [ContactSelection setNameOrEmailFilter:nil];
    [[LinphoneManager instance] lpConfigSetInt:NO forKey:@"animations_preference"];
    [PhoneMainView.instance changeCurrentView:ContactsListView.compositeViewDescription];
}

- (IBAction)btnrecentClicked:(id)sender {
    [[LinphoneManager instance] lpConfigSetInt:NO forKey:@"animations_preference"];
    [PhoneMainView.instance changeCurrentView:HistoryListView.compositeViewDescription];
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

-(void)missedcallcounter:(NSNotification*)notify{
    int stringbadge=(int)[notify.object integerValue];
    stringbadge=stringbadge+ stringMissedbadge;
    if (stringbadge) {
        [self updatechatrecent:stringbadge];
    }
}

@end
