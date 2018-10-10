//
//  SideMenuTableViewController.m
//  linphone
//
//  Created by Gautier Pelloux-Prayer on 28/07/15.
//
//

#import "SideMenuTableView.h"
#import "Utils.h"

#import "PhoneMainView.h"
#import "StatusBarView.h"
#import "ShopView.h"
#import "LinphoneManager.h"

@implementation SideMenuEntry

- (id)initWithTitle:(NSString *)atitle tapBlock:(SideMenuEntryBlock)tapBlock {
    if ((self = [super init])) {
        title = atitle;
        onTapBlock = tapBlock;
    }
    return self;
}

@end

@implementation SideMenuTableView
@synthesize sidebarimagename;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // remove separators between empty items, cf
    // http://stackoverflow.com/questions/1633966/can-i-force-a-uitableview-to-hide-the-separator-between-empty-cells
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    UINib *celnib = [UINib nibWithNibName:@"RazaSidebarTableViewCell" bundle:nil];
    
    [self.tableView registerNib:celnib forCellReuseIdentifier:@"RazaSidebarTableViewCellId"];
    //    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    //    nameofsidebar=[[NSArray alloc]initWithObjects:@"Home",/*@"Recents",@"Chat",*/@"Recharge",@"Call Type",@"Reward Points",@"Purchase History",@"Call Detail",@"View Rates",@"More",nil];//@"Access Numbers"
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self settidebar];
    //    dispatch_async(dispatch_get_main_queue(), ^{
    //        //update UI in main thread.
    //        [self.tableView reloadData];
    //    });
    
    
    //	[_sideMenuEntries
    //		addObject:[[SideMenuEntry alloc] initWithTitle:NSLocalizedString(@"Assistant", nil)
    //											  tapBlock:^() {
    //												[PhoneMainView.instance
    //													changeCurrentView:AssistantView.compositeViewDescription];
    //											  }]];
    //	BOOL mustLink = ([LinphoneManager.instance lpConfigIntForKey:@"must_link_account_time"] > 0);
    //	if (mustLink) {
    //		[_sideMenuEntries
    //			addObject:[[SideMenuEntry alloc] initWithTitle:NSLocalizedString(@"Link my account", nil)
    //												  tapBlock:^() {
    //													[PhoneMainView.instance
    //														changeCurrentView:AssistantLinkView.compositeViewDescription];
    //												  }]];
    //	}
    /*
     RazaAccessNumberVC
     Raza_network_setting
     RazaRewardPointVC
     RazaPurchaseHistoryVC
     RazaCallDetailsVC
     RazaViewRatesController
     SETTING
     */
    
    
    //	InAppProductsManager *iapm = LinphoneManager.instance.iapManager;
    //	if (iapm.enabled){
    //		[_sideMenuEntries
    //			addObject:[[SideMenuEntry alloc] initWithTitle:NSLocalizedString(@"Shop", nil)
    //												  tapBlock:^() {
    //													[PhoneMainView.instance
    //														changeCurrentView:ShopView.compositeViewDescription];
    //												  }]];
    //	}
    //	[_sideMenuEntries addObject:[[SideMenuEntry alloc] initWithTitle:NSLocalizedString(@"About", nil)
    //															tapBlock:^() {
    //															  [PhoneMainView.instance
    //																  changeCurrentView:AboutView.compositeViewDescription];
    //
    //															}]];
}
-(void)settidebar
{
    
    if ([[Razauser SharedInstance] getsidebar].length)
        sidebarimagename=[[NSMutableArray alloc]initWithObjects:@"mdialpad",/*@"mrecents",@"mchat",*/@"mrecharge",@"mcalltype",@"mreward",@"mpurchase",@"mcalldetails",@"mrate",@"msettings",@"msupport",@"noimg",nil];
    else
        sidebarimagename=[[NSMutableArray alloc]initWithObjects:@"mdialpad",/*@"mrecents",@"mchat",*/@"mcalltype",@"mreward",@"mcalldetails",@"mrate",@"msettings",@"msupport",@"noimg",nil];
    _sideMenuEntries = [[NSMutableArray alloc] init];
    [_sideMenuEntries
     addObject:[[SideMenuEntry alloc] initWithTitle:NSLocalizedString(@"Home", nil)
                                           tapBlock:^() {
                                               [PhoneMainView.instance
                                                changeCurrentView:DialerView.compositeViewDescription];
                                           }]];
    if ([[Razauser SharedInstance] getsidebar].length) {
        [_sideMenuEntries
         addObject:[[SideMenuEntry alloc] initWithTitle:NSLocalizedString(@"Recharge", nil)
                                               tapBlock:^() {
                                                   [PhoneMainView.instance
                                                    changeCurrentView:RazaCreditCardController.compositeViewDescription];
                                               }]];
    }
    
    [_sideMenuEntries
     addObject:[[SideMenuEntry alloc] initWithTitle:NSLocalizedString(@"Call types", nil)
                                           tapBlock:^() {
                                               [PhoneMainView.instance
                                                changeCurrentView:Raza_network_setting.compositeViewDescription];
                                           }]];
    
    
    [_sideMenuEntries
     addObject:[[SideMenuEntry alloc] initWithTitle:NSLocalizedString(@"Reward points", nil)
                                           tapBlock:^() {
                                               [PhoneMainView.instance
                                                changeCurrentView:RazaRewardPointVC.compositeViewDescription];
                                           }]];
    if ([[Razauser SharedInstance] getsidebar].length) {
        [_sideMenuEntries
         addObject:[[SideMenuEntry alloc] initWithTitle:NSLocalizedString(@"Purchase history", nil)
                                               tapBlock:^() {
                                                   [PhoneMainView.instance
                                                    changeCurrentView:RazaPurchaseHistoryVC.compositeViewDescription];
                                               }]];
    }
    
    [_sideMenuEntries
     addObject:[[SideMenuEntry alloc] initWithTitle:NSLocalizedString(@"Call history", nil)
                                           tapBlock:^() {
                                               [PhoneMainView.instance
                                                changeCurrentView:RazaCallDetailsVC.compositeViewDescription];
                                           }]];
    
    [_sideMenuEntries
     addObject:[[SideMenuEntry alloc] initWithTitle:NSLocalizedString(@"Country rates", nil)
                                           tapBlock:^() {
                                               [PhoneMainView.instance
                                                changeCurrentView:RazaViewRatesController.compositeViewDescription];
                                           }]];
    
    [_sideMenuEntries
     addObject:[[SideMenuEntry alloc] initWithTitle:NSLocalizedString(@"Settings", nil)
                                           tapBlock:^() {
                                               [PhoneMainView.instance
                                                changeCurrentView:RazaSettingsViewController.compositeViewDescription];
                                           }]];
    [_sideMenuEntries
     addObject:[[SideMenuEntry alloc] initWithTitle:NSLocalizedString(@"Support", nil)
                                           tapBlock:^() {
                                               [PhoneMainView.instance
                                                changeCurrentView:RazaTermsViewController.compositeViewDescription];
                                           }]];
    
    [_sideMenuEntries
     addObject:[[SideMenuEntry alloc] initWithTitle:NSLocalizedString(@"", nil)
                                           tapBlock:^() {
                                               [PhoneMainView.instance
                                                changeCurrentView:RazaLoginViewController.compositeViewDescription];
                                           }]];
}
#pragma mark - Table View Controller
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        BOOL hasDefault = (linphone_core_get_default_proxy_config(LC) != NULL);
        // default account is shown in the header already
        size_t count = bctbx_list_size(linphone_core_get_proxy_config_list(LC));
        return MAX(0, (int)count - (hasDefault ? 1 : 0));
    } else {
        
        return [_sideMenuEntries count];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([[Razauser SharedInstance] getsidebar].length) {
        if (indexPath.row==9)
            return 100;
        else
            return 42.5f;
    }
    else{
        if (indexPath.row==7)
            return 100;
        else
            return 42.5f;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    if (indexPath.section == 0) {
        // do not display default account here, it is already in header view
        int idx =
        linphone_core_get_default_proxy_config(LC)
        ? bctbx_list_index(linphone_core_get_proxy_config_list(LC), linphone_core_get_default_proxy_config(LC))
        : HUGE_VAL;
        LinphoneProxyConfig *proxy = bctbx_list_nth_data(linphone_core_get_proxy_config_list(LC),
                                                         (int)indexPath.row + (idx <= indexPath.row ? 1 : 0));
        if (proxy) {
            cell.textLabel.text = [NSString stringWithUTF8String:linphone_proxy_config_get_identity(proxy)];
            cell.imageView.image = [StatusBarView imageForState:linphone_proxy_config_get_state(proxy)];
        } else {
            LOGE(@"Invalid index requested, no proxy for row %d", indexPath.row);
        }
        cell.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        cell.textLabel.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        cell.imageView.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"color_G.png"]];
        cell=cell;
    } else {
        
        static NSString *CellIdentifier = @"RazaSidebarTableViewCellId";
        RazaSidebarTableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        if (indexPath.row==[Razauser SharedInstance].sideBarIndex) {
            cell1.sideLineLbl.hidden=NO;
            cell1.upperView.hidden=YES;
        }else{
            cell1.upperView.hidden=NO;
            cell1.sideLineLbl.hidden=YES;
        }
        
        if ([[Razauser SharedInstance] getsidebar].length) {
            if (indexPath.row==9){
                cell1.upperView.hidden=YES;
                cell1.sideLineLbl.hidden=YES;
                cell1.btnsignout.hidden=NO;
            }else{
                cell1.btnsignout.hidden=YES;
            }
        }
        else{
            if (indexPath.row==7){
                cell1.upperView.hidden=YES;
                cell1.sideLineLbl.hidden=YES;
                cell1.btnsignout.hidden=NO;
            }else{
                cell1.btnsignout.hidden=YES;
            }
        }
        CAGradientLayer *gradient = [BackgroundLayer linearGradient];
        gradient.frame = cell1.btnsignout.bounds;
        gradient.startPoint = CGPointMake(0.0,0.0);
        gradient.endPoint = CGPointMake(1.0,0.0);
        [cell1.btnsignout.layer insertSublayer:gradient atIndex:0];
        cell1.lblname.hidden=NO;
        
        [cell1.btnsignout addTarget:self action:@selector(signoutraza) forControlEvents:UIControlEventTouchUpInside];
        SideMenuEntry *entry = [_sideMenuEntries objectAtIndex:indexPath.row];
        NSLog(@"found---%@",entry->title);
        cell1.lblname.text=entry->title;
        cell1.img.image=[UIImage imageNamed:[sidebarimagename objectAtIndex:indexPath.row]];
        cell=cell1;
        //cell.textLabel.text = entry->title;
    }
    return cell;
}
-(void)signoutraza{
    if (LC!=NULL) {
        
        
        LinphoneProxyConfig *default_proxy = linphone_core_get_default_proxy_config(LC);
        if (default_proxy) {
            
            int stat=   linphone_proxy_config_get_state(default_proxy);
            LinphoneCall *call = linphone_core_get_current_call(LC);
            if (stat==LinphoneRegistrationOk&&!call) {
                
                NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
                [prefs removeObjectForKey:@"LOGIN"];
                /*------for remove-----*/
                [[Razauser SharedInstance]ShowWaitingshort:nil andtime:2.0];
                LinphoneCoreSettingsStore *settingsStore;
                settingsStore=[[LinphoneCoreSettingsStore alloc]init];
                [settingsStore removeAccount];
                
                SettingsView *view = VIEW(SettingsView);
                [view recomputeAccountLabelsAndSync];
                
                /*-------switch----------*/
                int val;
                if ([[Razauser SharedInstance] getsidebar].length)
                    val=9;
                else
                    val=7;
                
                SideMenuEntry *entry = [_sideMenuEntries objectAtIndex:val];
                LOGI(@"Entry %@ has been tapped", entry->title);
                if (entry->onTapBlock == nil) {
                    LOGF(@"Entry %@ has no onTapBlock!", entry->title);
                } else {
                    entry->onTapBlock();
                }
                
                [PhoneMainView.instance.mainViewController hideSideMenu:YES];
                [self performSelector:@selector(signoutmsgraza) withObject:self afterDelay:3.0];
            }
            else
                [RAZA_APPDELEGATE showAlertWithMessage:@"" withTitle:RAZAnocoonect withCancelTitle:@"Ok"];
        }
        else
            [RAZA_APPDELEGATE showAlertWithMessage:@"" withTitle:RAZAnouser withCancelTitle:@"Ok"];
    }
    else
        [RAZA_APPDELEGATE showAlertWithMessage:@"" withTitle:RAZAnocoonect withCancelTitle:@"Ok"];
}
-(void)signoutmsgraza{
    [RAZA_USERDEFAULTS  removeObjectForKey:@"logininfo"];
    [RAZA_APPDELEGATE showAlertWithMessage:@"" withTitle:RAZALOGGEDOUT withCancelTitle:@"Ok"];
}
static UICompositeView * extracted() {
    return PhoneMainView.instance.mainViewController;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (indexPath.section == 0) {
        //[PhoneMainView.instance changeCurrentView:SettingsView.compositeViewDescription];
    } else {
        [Razauser SharedInstance].sideBarIndex=(int)indexPath.row;
        
        int val;
        if ([[Razauser SharedInstance] getsidebar].length)
            val=9;
        else
            val=7;
        
        if (indexPath.row!=val) {
            SideMenuEntry *entry = [_sideMenuEntries objectAtIndex:indexPath.row];
            if ([entry->title isEqualToString:@"Recharge"]) {
                RazaCreditCardController *view=VIEW(RazaCreditCardController);
                [view clear];
            }
            LOGI(@"Entry %@ has been tapped", entry->title);
            if (entry->onTapBlock == nil) {
                LOGF(@"Entry %@ has no onTapBlock!", entry->title);
            } else {
                entry->onTapBlock();
            }
            [extracted() hideSideMenu:YES];
        }
    }
}



@end
