/* HistoryViewController.m
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

#import "HistoryListView.h"
#import "PhoneMainView.h"
#import "LinphoneUI/UIHistoryCell.h"

@implementation HistoryListView

typedef enum _HistoryView { History_All, History_Missed, History_MAX } HistoryView;

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
                                                           fragmentWith:HistoryDetailsView.class];
    }
    return compositeDescription;
}

- (UICompositeViewDescription *)compositeViewDescription {
    return self.class.compositeViewDescription;
}

#pragma mark - ViewController Functions

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    CAGradientLayer *gradient = [BackgroundLayer navHeaderGradient];
    gradient.frame = self.headerView.bounds;
    gradient.startPoint = CGPointMake(0.0, 0.0);
    gradient.endPoint = CGPointMake(0.0, 1.0);
    gradient.locations = @[@0.0,@1.0];
    [self.headerView.layer insertSublayer:gradient atIndex:0];

    
    if ([_tableController isEditing]) {
        [_tableController setEditing:FALSE animated:FALSE];
    }
    [self changeView:History_All];
    [self onEditionChangeClick:nil];
    
    // Reset missed call
    linphone_core_reset_missed_calls_count(LC);
    // Fake event
    [NSNotificationCenter.defaultCenter postNotificationName:kLinphoneCallUpdate object:self];
    
    //        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(makeacallparamhistory:) name:@"makeacallviaRazaouthistoryparam" object:nil];
    [[Razauser SharedInstance]setmissed:NO];
    [self setupcalltypelist];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatemessegesecounter:) name:@"messegedatecounter" object:nil];
    int total= [LinphoneManager unreadMessageCount];
    [self updatechatreadunreadcounter:total];
    
}

- (void) viewWillDisappear:(BOOL)animated {
    // [[Razauser SharedInstance]setmissed:NO];
    self.view = NULL;
    
}

#pragma mark -

- (void)changeView:(HistoryView)view {
    CGRect frame = _selectedButtonImage.frame;
    if (view == History_All) {
        frame.origin.x = _allButton.frame.origin.x;
        _allButton.selected = TRUE;
        [_tableController setMissedFilter:FALSE];
        _missedButton.selected = FALSE;
    } else {
        frame.origin.x = _missedButton.frame.origin.x;
        _missedButton.selected = TRUE;
        [_tableController setMissedFilter:TRUE];
        _allButton.selected = FALSE;
    }
    _selectedButtonImage.frame = frame;
}

#pragma m ~ark - Action Functions

- (IBAction)onAllClick:(id)event {
    [self changeView:History_All];
}

- (IBAction)onMissedClick:(id)event {
    [self changeView:History_Missed];
}

- (IBAction)onDeleteClick:(id)event {
    NSString *msg = [NSString stringWithFormat:NSLocalizedString(@"Do you want to delete selected logs?", nil)];
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

- (IBAction)segmentSwitchAction:(id)sender {
    UISegmentedControl *segmentedControl = (UISegmentedControl *) sender;
    NSInteger selectedSegment = segmentedControl.selectedSegmentIndex;
    
    if (selectedSegment == 0){
        [_tableController setMissedFilter:FALSE];
        
    }
    else{
        [_tableController setMissedFilter:TRUE];
        
    }
    
}

- (IBAction)onEditionChangeClick:(id)sender {
    _allButton.hidden = _missedButton.hidden = _selectedButtonImage.hidden = self.tableController.isEditing;
}

- (IBAction)btnbackClicked:(id)sender {
    [[LinphoneManager instance] lpConfigSetInt:YES forKey:@"animations_preference"];
    // [PhoneMainView.instance changeCurrentView:DialerView.compositeViewDescription];
    UICompositeView *cvc = PhoneMainView.instance.mainViewController;
    [cvc hideSideMenu:(cvc.sideMenuView.frame.origin.x == 0)];
}
-(void)makeCall{
    [self chkforsim];
    
    // UIWindow* window = [UIApplication sharedApplication].keyWindow;
    actionsheet = [[UIView alloc] initWithFrame:self.view.bounds];//window.bounds
    actionsheet.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.8];
    actionsheet.tag=4;
    actionsheet.userInteractionEnabled = YES;
    UIView *ContainerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 310, 320)];
    [actionsheet addSubview:ContainerView];
    ContainerView.center=actionsheet.center;
    ContainerView.layer.cornerRadius=7;
    ContainerView.layer.masksToBounds=YES;
    ContainerView.backgroundColor=[UIColor whiteColor];
    
    UILabel *button2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 310, 50)];
    button2.backgroundColor = [UIColor colorWithRed:3/255.0 green:103/255.0 blue:222/255.0  alpha:1];
    button2.text=@"Select Options";
    button2.textColor = [UIColor whiteColor];
    button2.textAlignment = NSTextAlignmentCenter;
    [ContainerView addSubview:button2];
    UIView *row11 = [[UIView alloc]initWithFrame:CGRectMake(0, 50, 310, 300)];
    // actionsheet.layer.cornerRadius = 8.0f;
    //actionsheet.layer.masksToBounds = YES;
    row11.backgroundColor = [UIColor clearColor];
    row11.layer.borderWidth = 1.0f;
    row11.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [ContainerView addSubview:row11];
    
    // [TODO:ios update]
    UIView *row12 = [[UIView alloc]initWithFrame:CGRectMake(0, 270, 310, 1)];
    row12.backgroundColor = [UIColor colorWithRed:36 green:60 blue:128 alpha:1];
    row12.layer.borderWidth = 1.0f;
    row12.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [ContainerView addSubview:row12];
    
    UIView *borderView = [[UIView alloc]initWithFrame:CGRectMake(55, 115, 200, 60)];
    borderView.layer.borderColor=[UIColor colorWithRed:247.0/255.0f green:247.0/255.0f blue:247.0/255.0f alpha:1.0f].CGColor;
    borderView.layer.borderWidth=2.0f;
    borderView.layer.cornerRadius=borderView.frame.size.height/2.0;
    borderView.layer.masksToBounds=YES;
    [row11 addSubview:borderView];
    
    UILabel *audioLbl = [[UILabel alloc]initWithFrame:CGRectMake(10, 115, 40, 60)];
    audioLbl.textColor=[UIColor colorWithRed:128.0/255.0f green:128.0/255.0f blue:128.0/255.0f alpha:0.3f];
    audioLbl.text=@"FREE AUDIO";
    audioLbl.numberOfLines=2;
    audioLbl.textAlignment=NSTextAlignmentCenter;
    audioLbl.font=[UIFont fontWithName:@"SourceSansPro-Bold" size:14];
    [row11 addSubview:audioLbl];
    
    UILabel *videoLbl = [[UILabel alloc]initWithFrame:CGRectMake(260, 115, 40, 60)];
    videoLbl.textColor=[UIColor colorWithRed:128.0/255.0f green:128.0/255.0f blue:128.0/255.0f alpha:0.3f];
    videoLbl.text=@"FREE VIDEO";
    videoLbl.numberOfLines=2;
    videoLbl.textAlignment=NSTextAlignmentCenter;
    videoLbl.font=[UIFont fontWithName:@"SourceSansPro-Bold" size:14];
    [row11 addSubview:videoLbl];
    
    UILabel *razaoutLbl = [[UILabel alloc]initWithFrame:CGRectMake(55, 185, 200, 20)];
    razaoutLbl.textColor=[UIColor colorWithRed:128.0/255.0f green:128.0/255.0f blue:128.0/255.0f alpha:0.3f];
    razaoutLbl.text=@"RAZA MINUTES CALL";
    razaoutLbl.textAlignment=NSTextAlignmentCenter;
    razaoutLbl.font=[UIFont fontWithName:@"SourceSansPro-Bold" size:14];
    [row11 addSubview:razaoutLbl];
    
    UIButton *row11btn = [[UIButton alloc]initWithFrame:CGRectMake(75, 125, 40 , 40)];
    row11btn.backgroundColor =  [UIColor clearColor];
    [row11btn setImage:[UIImage imageNamed:@"call.png"] forState:UIControlStateNormal];
    //[row11btn setImage:[UIImage imageNamed:@"n_free_call.png"] forState:UIControlStateHighlighted];//n_free_call_hover.png
    [row11btn addTarget:self action:@selector(callMadeViaVOIP) forControlEvents:UIControlEventTouchUpInside];
    
    [row11 addSubview:row11btn];
    
    //    UILabel *row11lbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 84, 101, 20)];
    //    row11lbl.backgroundColor =  [UIColor clearColor];
    //    row11lbl.text=@"Free call";
    //    row11lbl.textAlignment = NSTextAlignmentCenter;
    //    [row11 addSubview:row11lbl];
    
    UIButton *row12btn = [[UIButton alloc]initWithFrame:CGRectMake(195, 125, 40, 40)];
    row12btn.backgroundColor =  [UIColor clearColor];
    [row12btn setImage:[UIImage imageNamed:@"video_chat.png"] forState:UIControlStateNormal];
    //[row12btn setImage:[UIImage imageNamed:@"pon_video_call_hover.png"] forState:UIControlStateHighlighted];
    
    
    [row12btn addTarget:self action:@selector(videocall:) forControlEvents:UIControlEventTouchUpInside];
    
    [row11 addSubview:row12btn];
    
    //    UILabel *row12lbl = [[UILabel alloc]initWithFrame:CGRectMake(100, 84, 101, 20)];
    //    row12lbl.backgroundColor =  [UIColor clearColor];
    //    row12lbl.text=@"Video Call";
    //    row12lbl.textAlignment = NSTextAlignmentCenter;
    //    [row11 addSubview:row12lbl];
    
    UIButton *row13btn = [[UIButton alloc]initWithFrame:CGRectMake(123, 12, 70, 85)];
    row13btn.backgroundColor =  [UIColor clearColor];
    [row13btn setImage:[UIImage imageNamed:@"speech-chatIcon.png"] forState:UIControlStateNormal];
    // [row13btn setImage:[UIImage imageNamed:@"n_cheat.png"] forState:UIControlStateHighlighted];//n_cheat_hover.png
    [row13btn addTarget:self action:@selector(chatViewLoad) forControlEvents:UIControlEventTouchUpInside];
    [row11 addSubview:row13btn];
    
    
    UIButton *row14btn = [[UIButton alloc]initWithFrame:CGRectMake(69, 115, 70, 85)];
    row14btn.backgroundColor =  [UIColor clearColor];
    [row14btn setImage:[UIImage imageNamed:@"n_carrier.png"] forState:UIControlStateNormal];
    [row14btn setImage:[UIImage imageNamed:@"n_carrier_hover.png"] forState:UIControlStateHighlighted];
    
    [row14btn addTarget:self action:@selector(callMadeViaCarrier) forControlEvents:UIControlEventTouchUpInside];
    //[row11 addSubview:row14btn];
    
    
    //UIButton *row15btn = [[UIButton alloc]initWithFrame:CGRectMake(167, 120, 70, 85)];
    UIButton *row15btn = [[UIButton alloc]initWithFrame:CGRectMake(123, 115, 61, 61)];
    row15btn.backgroundColor =  [UIColor clearColor];
    [row15btn setImage:[UIImage imageNamed:@"raza_call.png"] forState:UIControlStateNormal];
    // [row15btn setImage:[UIImage imageNamed:@"n_raza_out_hover.png"] forState:UIControlStateHighlighted];
    //[row15btn addTarget:self action:@selector(callRazaout) forControlEvents:UIControlEventTouchUpInside];
    [self mainofirst:row15btn];
    [row11 addSubview:row15btn];
    

    UIButton *button5 = [[UIButton alloc]initWithFrame:CGRectMake(105, 220, 100, 50)];
    button5.backgroundColor = [UIColor whiteColor];//102 171 255
    
    [button5 setTitleColor:[UIColor colorWithRed:36/255.0f green:60/255.0f blue:128/255.0f alpha:1.0] forState:UIControlStateNormal];
    [button5 setTitle:@"Cancel" forState:UIControlStateNormal];
    [button5 addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    [row11 addSubview:button5];
    [self.view addSubview:actionsheet];
    
    
    
    
    
    CGRect newFrameSize;
    if (iPhone4Or5oriPad==4) {
        newFrameSize = CGRectMake(10, 40, 300, 500);
    } else if (iPhone4Or5oriPad==5) {
        newFrameSize = CGRectMake(10, 130, 300, 500);
    }
    [UIView beginAnimations:nil context:NULL];
    
    [UIView commitAnimations];
    
    
}
-(void)chatViewLoad
{
    [self removeviewfromsubview];
    [self makechat:callingphone];
}
- (void)videocall:(id)sender {
    selectedmoderazavideooraodio=@"videocall";
    [self removeviewfromsubview];
    [LinphoneManager.instance call:Calledaddess andmodeVideoAudio:TRUE];
}
-(void)chkforsim
{
    CTTelephonyNetworkInfo* info = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier* carrier = info.subscriberCellularProvider;
    
    if(carrier.mobileNetworkCode == nil || [carrier.mobileNetworkCode isEqualToString:@""])
    {
        chkforsimcard=@"not found";
    }
    
    
}
-(void)mainofirst:(UIButton *)mainbuttontorazaout
{
    /*===================Implimented====================**/
    // [mainbuttontorazaout addTarget:self action:@selector(callRazaout) forControlEvents:UIControlEventTouchUpInside];
    Raza_calltype_class *clkclass=[[Raza_calltype_class alloc]init];
    NSString *strreturntype=[clkclass passaccordingnetwork:datafornetwork networktype:chkforsimcard chkforsimvle:checkfor_availablenetwork];
    // NSLog(@"88888%@",strreturntype);
    if ([strreturntype isEqual:@"callRazaout"]) {
        [mainbuttontorazaout addTarget:self action:@selector(callRazaout) forControlEvents:UIControlEventTouchUpInside];
    }
    else if([strreturntype isEqual:@"callMadeViaCarrier"])
    {
        [mainbuttontorazaout addTarget:self action:@selector(callMadeViaCarrier) forControlEvents:UIControlEventTouchUpInside];
    }
    else if([strreturntype isEqual:@"showalertofsimcard"])
    {
        [mainbuttontorazaout addTarget:self action:@selector(showalertofsimcard) forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Warning!"
                                                          message:@"please select atlease single carrier from setting"
                                                         delegate:self
                                                cancelButtonTitle:nil
                                                otherButtonTitles:@"ok",nil];
        
        [message show];
    }
}
-(void)callRazaout{
    
    [self removeviewfromsubview];
    RazaTempratureObject *baseobj=[[RazaTempratureObject alloc]init];
    [baseobj checkvalforTemp:callingphone callback:^(NSDictionary *result) {
        [[Razauser SharedInstance]HideWaiting];
        [Razauser SharedInstance].tempdict=result;
        NSLog(@"%@", [Razauser SharedInstance].tempdict);
        [LinphoneManager.instance call:Calledaddess andmodeVideoAudio:FALSE];
    }];
    //  [LinphoneManager.instance call:Calledaddess andmodeVideoAudio:FALSE];
    //[self makeAudioCallWithRemoteParty:selectedCallNumber andSipStack:[mSipService getSipStack]];
    userMode=@"Raza Out";
    
    
}
-(void)removeviewfromsubview
{
    self.navigationController.navigationBar.alpha=1;
    for (UITabBarItem *tmpTabBarItem in [[self.tabBarController tabBar] items])
        [tmpTabBarItem setEnabled:YES];
    self.navigationController.navigationBar.userInteractionEnabled = YES;
    // [backview removeFromSuperview];
    //[actionsheet removeFromSuperview];
    // actionsheet = nil;
    // backview=nil;
    NSArray *subViewArray = [self.view subviews];
    for (id obj in subViewArray)
    { UIView *baseview=obj;
        if (baseview.tag==4) {
            [obj removeFromSuperview];
        }
        
    }
    
}
-(void)showalertofsimcard
{
    [self removeviewfromsubview];
    if ([chkforsimcard isEqual:@"not found"])
    {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Warning!"
                                                          message:@"No sim card detected"
                                                         delegate:self
                                                cancelButtonTitle:nil
                                                otherButtonTitles:@"ok",nil];
        
        [message show];
    }
    else
    {
        NSString *str;
        if ([checkfor_availablenetwork isEqual:@"3"])
        {
            str=@"Wi-Fi not available.Please turn it on from your phone’s settings";
        }
        else if([checkfor_availablenetwork isEqual:@"1"])
        {
            str=@"Please turn off Wi-Fi to be able to make a call using your data plan";
        }
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Warning!"
                                                          message:[NSString stringWithFormat:@"%@",str]
                                                         delegate:self
                                                cancelButtonTitle:nil
                                                otherButtonTitles:@"ok",nil];
        
        [message show];
    }
    
}
- (void)makeacallparamhistorytest:(NSDictionary *)notif
{
    
    NSDictionary *razaobject=notif;
    callingphone=[razaobject objectForKey:@"PHONE"];
    
    NSData *newData = [razaobject objectForKey:@"RAZAADDRESS"];
    [newData getBytes:&Calledaddess];
    
    BOOL isuser=[[razaobject objectForKey:@"RAZAUSER"]boolValue];
    if (isuser){
        [self checkWiFiAndData];
        [self makeCall];
    }else{
        [Razauser SharedInstance].callModeType=@"RAZA MINUTES CALL";
        [[Razauser SharedInstance]ShowWaitingshort:@"Connecting Call..." andtime:20.0];
        
        [self chkforsim];
        [self mainofirstTOdirectcall:nil];
    }
}
-(void)checkWiFiAndData{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    NetworkStatus status = [reachability currentReachabilityStatus];
    if (status == ReachableViaWiFi){
        [Razauser SharedInstance].callModeType=@"WIFI CALL";
    }
    else if (status == ReachableViaWWAN){
        [Razauser SharedInstance].callModeType=@"DATA CALL";
    }
}


//- (void)makeacallparamhistory:(NSNotification *)notif
//{
////    NSDictionary *razaobject=notif.object;
////    callingphone=[razaobject objectForKey:@"PHONE"];
////   
////     NSData *newData = [razaobject objectForKey:@"RAZAADDRESS"];
////     [newData getBytes:&Calledaddess];
////    
////    BOOL isuser=[[razaobject objectForKey:@"RAZAUSER"]boolValue];
////    if (isuser)
////    [self makeCall];
////    else
////    {
////    [self chkforsim];
////    [self mainofirstTOdirectcall:nil];
////    }
//    
//}
-(void)cancel{
    
    [self removeviewfromsubview];
}
-(void)setupcalltypelist
{
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //1
    NSString *documentsDirectory = [paths objectAtIndex:0]; //2
    pathfornetwork = [documentsDirectory stringByAppendingPathComponent:@"network_update.plist"]; //3
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath: pathfornetwork]) //4
    {
        NSString *bundle = [[NSBundle mainBundle] pathForResource:@"network_update" ofType:@"plist"]; //5
        
        [fileManager copyItemAtPath:bundle toPath: pathfornetwork error:&error]; //6
    }
    
    
    datafornetwork = [[NSMutableDictionary alloc] initWithContentsOfFile: pathfornetwork];
    [self checkofnetworktype];
    
    CHECKGLOBALNETWORK=[[globalnetworkclass alloc]init];
}
-(void)checkofnetworktype
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    
    NetworkStatus status = [reachability currentReachabilityStatus];
    
    if(status == NotReachable)
    {
        //No internet
        checkfor_availablenetwork=@"0";
    }
    else if (status == ReachableViaWiFi)
    {
        checkfor_availablenetwork=@"1";
    }
    else if (status == ReachableViaWWAN)
    {
        checkfor_availablenetwork=@"3";
    }
    
}
/*------------minuts based call---------*/
-(void)callMadeViaCarrier {
    
    selectedmoderazavideooraodio=nil;
    [self removeviewfromsubview];
    [[Razauser SharedInstance]ShowWaiting:nil];
    NSString *selectedCallNumber=callingphone;
    NSString *localSetAccessNumber = [RAZA_USERDEFAULTS objectForKey:@"accessnumber"];
    
    if (!localSetAccessNumber || IS_EMPTY(localSetAccessNumber)) {
        [[Razauser SharedInstance]HideWaiting];
        [RAZA_APPDELEGATE showAlertWithMessage:ERROR_NO_ACCESS_NUMBER_TO_DIAL withTitle:@"Access number!" withCancelTitle:@"Ok"];
    }
    else {
        
        [self sendDestination:selectedCallNumber withAccessNumber:localSetAccessNumber];
    }
    
}
-(void)sendDestination:(NSString*)number withAccessNumber:(NSString *)accessnumber {
    
    number = [number stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSString *userpin = [[RAZA_USERDEFAULTS objectForKey:@"logininfo"] objectForKey:LOGIN_RESPONSE_PIN];
    
    BOOL network = [RAZA_APPDELEGATE checkNetworkPriorRequest];
    
    if (network) {
        
        if (userpin && [userpin length]) {
            //addCallToDatabase
            [[Razauser SharedInstance]addCallToDatabase:@"OUTGOING" andsender:number];
            [[RazaServiceManager sharedInstance] requestToSetDestinationWithPin:userpin withAccessNo:accessnumber withPhoneNo:number withDelegate:self];
            
        } else {
            [[Razauser SharedInstance]HideWaiting];
            [RAZA_APPDELEGATE showAlertWithMessage:ERROR_NO_USER_PIN withTitle:@"" withCancelTitle:@"Ok"];
        }
        
    } else {
        [[Razauser SharedInstance]HideWaiting];
        [RAZA_APPDELEGATE showAlertWithMessage:NETWORK_UNAVAILABLE withTitle:@"" withCancelTitle:@"Dismiss"];
    }
    
}
-(void)receivedDataFromService:(NSDictionary *)info withResponseType:(NSString *)responseType {
    [[Razauser SharedInstance]HideWaiting];
    if( ([[info objectForKey:@"status"] isEqualToString:@"1"]) && ([[info objectForKey:@"accessno"] length]) ) {
        
        NSString *accessnumber = [info objectForKey:@"accessno"];
        
        if (!accessnumber ||
            [accessnumber isEqualToString:@"null"] ||
            IS_EMPTY(accessnumber)) {
            
            //[RAZA_APPDELEGATE showMessage:ERROR_NO_ACCESS_NUMBER withMode:MBProgressHUDModeText withDelay:2 withShortMessage:NO];
            //            [RAZA_APPDELEGATE showAlertWithMessage:ERROR_NO_ACCESS_NUMBER_TO_DIAL withTitle:alertTitle withCancelTitle:@"Ok"];
        }
        else {
            DialerView *addressBkVC = [[DialerView alloc]init];
            
            [addressBkVC buildContactDetails:accessnumber];
            if ([[Razauser SharedInstance]chkforsimGlobal]) {
                
                if (!(callingphone.length>10)) {
                    [Razauser SharedInstance].modeofview=@"no";
                    NSString *test =[@"tel:" stringByAppendingString:accessnumber];//[@"tel:" stringByAppendingString:[NSString stringWithFormat:@"001%@",accessnumber]];
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:test]];
                }
                else
                {
                    //-----Old Concept for Tel:-----------
                    
                    //                   [Razauser SharedInstance].modeofview=@"no";
                    //                NSString *test =[@"tel:" stringByAppendingString:accessnumber];//[@"tel:" stringByAppendingString:[NSString stringWithFormat:@"001%@",accessnumber]];
                    //                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:test]];
                    
                    
                    //-----new Concept for Tel:-----------
                    RazaTempratureObject *baseobj=[[RazaTempratureObject alloc]init];
                    [baseobj checkvalforTemp:callingphone callback:^(NSDictionary *result) {
                        
                        [Razauser SharedInstance].tempdict=result;
                        NSLog(@"%@", [Razauser SharedInstance].tempdict);
                        
                        [[LinphoneManager instance] lpConfigSetInt:YES forKey:@"animations_preference"];
                        CallOutgoingView *view = VIEW(CallOutgoingView);
                        
                        view.delegateforminuts=self;
                        view.phoneNumber=callingphone;//@"+919716432545";//
                        view.Accessnumber=accessnumber;
                        [PhoneMainView.instance changeCurrentView:view.compositeViewDescription];
                        
                    }];
                }
                
                
            }
            else
                [RAZA_APPDELEGATE showAlertWithMessage:REQUEST_WITHOUT_SIM withTitle:nil
                                       withCancelTitle:@"Ok"];
            
            
        }
    }
    else {
        
        //[RAZA_APPDELEGATE showMessage:[info objectForKey:@"error"] withMode:MBProgressHUDModeText withDelay:1 withShortMessage:NO];
        [RAZA_APPDELEGATE showAlertWithMessage:[info objectForKey:@"error"] withTitle:@"Access number!" withCancelTitle:@"Ok"];
    }
    
}
-(void)mainofirstTOdirectcall:(NSString *)mainbuttontorazaout
{
    /*===================Implimented====================**/
    // [mainbuttontorazaout addTarget:self action:@selector(callRazaout) forControlEvents:UIControlEventTouchUpInside];
    Raza_calltype_class *clkclass=[[Raza_calltype_class alloc]init];
    NSString *strreturntype=[clkclass passaccordingnetwork:datafornetwork networktype:chkforsimcard chkforsimvle:checkfor_availablenetwork];
    NSLog(@"88888%@",strreturntype);
    
    if ([strreturntype isEqual:@"callRazaout"]) {
        [self callRazaout];
        // [mainbuttontorazaout addTarget:self action:@selector(callRazaout) forControlEvents:UIControlEventTouchUpInside];
    }
    else if([strreturntype isEqual:@"callMadeViaCarrier"])
    {
        [[Razauser SharedInstance]HideWaiting];
        
        [self callMadeViaCarrier];
        //[mainbuttontorazaout addTarget:self action:@selector(callMadeViaCarrier) forControlEvents:UIControlEventTouchUpInside];
    }
    else if([strreturntype isEqual:@"showalertofsimcard"])
    {
        [[Razauser SharedInstance]HideWaiting];
        
        //[mainbuttontorazaout addTarget:self action:@selector(showalertofsimcard) forControlEvents:UIControlEventTouchUpInside];
        [self showalertofsimcard];
    }
    else
    {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Warning!"
                                                          message:@"please select atlease single carrier from setting"
                                                         delegate:self
                                                cancelButtonTitle:nil
                                                otherButtonTitles:@"ok",nil];
        
        [message show];
    }
}

-(void)makechat:(NSString*)phonenumber
{
    
    NSString  *callno=[NSString stringWithFormat:@"sip:%@@%@",phonenumber,MAINRAZASIPURL];
    
    //callno=[NSString stringWithFormat:@"sip:@%@",callno];
    /* LinphoneChatRoom *room = linphone_core_get_chat_room_from_uri(
     LC, ((NSString *)[_contacts.allKeys objectAtIndex:indexPath.row]).UTF8String);*/
    LinphoneChatRoom *room = linphone_core_get_chat_room_from_uri(
                                                                  LC, ((NSString *)callno).UTF8String);
    if (!room) {
        [PhoneMainView.instance popCurrentView];
        UIAlertController *errView = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Invalid address", nil)
                                                                         message:NSLocalizedString(@"Please specify the entire SIP address for the chat",
                                                                                                   nil)
                                                                  preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK"
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [errView addAction:defaultAction];
        [self presentViewController:errView animated:YES completion:nil];
    } else {
        [[LinphoneManager instance] lpConfigSetInt:YES forKey:@"animations_preference"];
        
        ChatConversationView *view = VIEW(ChatConversationView);
        [view setChatRoom:room];
        // [PhoneMainView.instance popCurrentView];
        [PhoneMainView.instance changeCurrentView:view.compositeViewDescription];
        // refresh list of chatrooms if we are using fragment
        if (IPAD) {
            ChatsListView *listView = VIEW(ChatsListView);
            [listView.tableController loadData];
        }
    }
}
/*normal delegate*------*/


-(void)callMadeViaVOIP
{
    [self removeviewfromsubview];
    [LinphoneManager.instance call:Calledaddess andmodeVideoAudio:FALSE];
}

-(void)callMadeViaCarrierWithParam:(NSString *)remotedestnumber
{
    
}
-(void)MinutscallwithDelegateMethod:(NSString *)data
{
    if (data.length) {
        [Razauser SharedInstance].modeofview=@"no";
        NSString *test =[@"tel:" stringByAppendingString:data];//[@"tel:" stringByAppendingString:[NSString stringWithFormat:@"001%@",accessnumber]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:test]];
        
        
        //            CallOutgoingView *view = VIEW(CallOutgoingView);
        //        
        //            view.delegateforminuts=self;
        //            view.phoneNumber=@"+919716432545";
        //            [PhoneMainView.instance changeCurrentView:view.compositeViewDescription];
    }
    
}
- (IBAction)btnDialPadClicked:(id)sender {
    [[LinphoneManager instance] lpConfigSetInt:NO forKey:@"animations_preference"];
    [PhoneMainView.instance changeCurrentView:DialerView.compositeViewDescription];
    
}

- (IBAction)btnChatClicked:(id)sender {
    [[LinphoneManager instance] lpConfigSetInt:NO forKey:@"animations_preference"];
    [PhoneMainView.instance changeCurrentView:ChatsListView.compositeViewDescription];
}
- (IBAction)btnContactClicked:(id)sender {
    [[LinphoneManager instance] lpConfigSetInt:NO forKey:@"animations_preference"];
    [ContactSelection setAddAddress:nil];
    [ContactSelection enableEmailFilter:FALSE];
    [ContactSelection setNameOrEmailFilter:nil];
    
    [PhoneMainView.instance changeCurrentView:ContactsListView.compositeViewDescription];
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

- (void)updatemessegesecounter:(NSNotification *)notif{
    //notif.object;
    int stringbadge=[LinphoneManager unreadMessageCount];//[notif.object integerValue];
    [self updatechatreadunreadcounter:stringbadge];
    
}


@end
