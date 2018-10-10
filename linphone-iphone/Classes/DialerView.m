/* DialerViewController.h
 *
 * Copyright (C) 2009  Belledonne Comunications, Grenoble, France
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

#import <AVFoundation/AVAudioSession.h>
#import <AudioToolbox/AudioToolbox.h>

#import "LinphoneManager.h"
#import "PhoneMainView.h"

@implementation DialerView

#pragma mark - UICompositeViewDelegate Functions

static UICompositeViewDescription *compositeDescription = nil;

+ (UICompositeViewDescription *)compositeViewDescription {
    //TabBarView.class
    if (compositeDescription == nil) {//StatusBarView.class
        compositeDescription = [[UICompositeViewDescription alloc] init:self.class
                                                              statusBar:nil
                                                                 tabBar:nil////TabBarView.class//
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

#pragma mark - ViewController Functions
@synthesize viewwindow,btnofcheckbox;
- (void)viewWillAppear:(BOOL)animated {
    
    _lblcountry.delegate=self;
    _lblcountry.dataSource=self;
    
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    [RAZA_USERDEFAULTS setObject:@"LOGIN" forKey:@"LOGIN"];
    
    [[LinphoneManager instance] lpConfigSetInt:YES forKey:@"animations_preference"];
    [Razauser SharedInstance].sideBarIndex=0;
    CAGradientLayer *gradient = [BackgroundLayer navHeaderGradient];
    gradient.frame = self.headerView.bounds;
    gradient.startPoint = CGPointMake(0.0, 0.0);
    gradient.endPoint = CGPointMake(0.0, 1.0);
    gradient.locations = @[@0.0,@1.0];
    [self.headerView.layer insertSublayer:gradient atIndex:0];
    
    CAGradientLayer *gradient1 = [BackgroundLayer navHeaderGradient];
    gradient1.frame = self.searchheaderView.bounds;
    gradient1.startPoint = CGPointMake(0.0, 0.0);
    gradient1.endPoint = CGPointMake(0.0, 1.0);
    gradient1.locations = @[@0.0,@1.0];
    [self.searchheaderView.layer insertSublayer:gradient1 atIndex:0];
    
    CAGradientLayer *gradient2 = [BackgroundLayer superViewGradient];
    gradient2.frame = self.topView.bounds;
    gradient2.startPoint = CGPointMake(0.0, 0.0);
    gradient2.endPoint = CGPointMake(0.0, 1.0);
    gradient2.locations = @[@0.9,@1.0];
    [self.topView.layer insertSublayer:gradient2 atIndex:0];
    
    if (!stringnametoselectedmodeselfortable.length) {
        if (LC!=NULL)
        {
            LinphoneProxyConfig *default_proxy = linphone_core_get_default_proxy_config(LC);
            if (default_proxy!=NULL)
            {
                // [self setlocationself];
                [self Setnotificationpermission];
            }
        }
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        LinphoneCoreSettingsStore *sipice=[[LinphoneCoreSettingsStore alloc]init];
        // settingsStore = [[LinphoneCoreSettingsStore alloc] init];
        [sipice transformLinphoneCoreToKeys];
        [sipice synchronize];
        //[sipice synchronizeAccounts];
    });
    if ([_addressField.text isEqualToString:RAZAPUSHCALLER])
        _addressField.text=@"";
    
    // [sipice recomputeAccountLabelsAndSync];
    [super viewWillAppear:animated];
    _btndial.selected=YES;
    _padView.hidden =
    !IPAD && UIInterfaceOrientationIsLandscape(PhoneMainView.instance.mainViewController.currentOrientation);
    
    // Set observer
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(callUpdateEvent:)
                                               name:kLinphoneCallUpdate
                                             object:nil];
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(coreUpdateEvent:)
                                               name:kLinphoneCoreUpdate
                                             object:nil];
    //[[Razauser SharedInstance]addCallToDatabase:@"OUTGOING" andsender:@"9999999998"];
    // Update on show
    LinphoneManager *mgr = LinphoneManager.instance;
    LinphoneCall *call = linphone_core_get_current_call(LC);
    LinphoneCallState state = (call != NULL) ? linphone_call_get_state(call) : 0;
    [self callUpdate:call state:state];
    
    if (IPAD) {
        BOOL videoEnabled = linphone_core_video_display_enabled(LC);
        BOOL previewPref = [mgr lpConfigBoolForKey:@"preview_preference"];
        
        if (videoEnabled && previewPref) {
            linphone_core_set_native_preview_window_id(LC, (__bridge void *)(_videoPreview));
            
            if (!linphone_core_video_preview_enabled(LC)) {
                linphone_core_enable_video_preview(LC, TRUE);
            }
            
            [_backgroundView setHidden:FALSE];
            [_videoCameraSwitch setHidden:FALSE];
        } else {
            linphone_core_set_native_preview_window_id(LC, NULL);
            linphone_core_enable_video_preview(LC, FALSE);
            [_backgroundView setHidden:TRUE];
            [_videoCameraSwitch setHidden:TRUE];
        }
    } else {
        linphone_core_enable_video_preview(LC, FALSE);
    }
    [_addressField setText:@""];
    //self.view.frame=CGRectMake(0, 70, self.view.frame.size.width, self.view.frame.size.height);
    // [self.view addSubview:self.uiviewofmain];
    // [self.portraitView1 bringSubviewToFront:self.uiviewofmain];
    //[self.landscapeView addSubview:self.uiviewofmain];
    //_uiviewofmain.frame=CGRectMake(0, SCREENHIGHT-100, SCREENWIDTH, _uiviewofmain.frame.size.height);
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(refreshvaltemp) name:@"refreshtempval" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatemessegesecounter:) name:@"messegedatecounter" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(missedcallcounter:) name:@"missedcallcounter" object:nil];
    int total= [LinphoneManager unreadMessageCount];
    [self updatechatreadunreadcounter:total];
    stringMissedbadge= [[Razauser SharedInstance]getmissed];
    //  if (LC!=NULL)
    //stringbadge =stringbadge+ linphone_core_get_missed_calls_count(LC);
    [self updatechatrecent:stringMissedbadge];
    /*---------3 button--------*/
    [self plistfile];
    valtocheckofpopup=1;
    
    [self.downBtn addTarget:self action:@selector(UpDownAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self datadorglobalsetting];
    globalnetworkclass *globalclass=[[globalnetworkclass alloc]init];
    int a=[self checkforavailablevalue];
    [globalclass mainsettingplist:a globalplist:dataforglobalplist pathforglobalplist:pathforglobalplist];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(makeacallparam:) name:@"makeacallvia3param" object:nil];
    [self initialSetUp];
    [self performSelector:@selector(updatespeaker) withObject:self afterDelay:1.0 ];
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self setsidebarapi];
    });
    
    
    // _lblrecentcounter.text=@"4";
}
-(void)updatespeaker
{
    BOOL mic= linphone_core_mic_enabled(LC);
    if (mic==NO) {
        linphone_core_enable_mic(LC, false);
    }
}
-(void)refreshvaltemp
{
    if (keyfortempmode.length)
    {
        keyfortempmode=nil;
        NSString *stringname;
        UIView *baseview=_maintitleview;
        for (id dummyview in baseview.subviews) {
            if ([dummyview isKindOfClass:[UIView class]]) {
                UIView *baseview2=dummyview;
                for (id dummyview2 in baseview2.subviews) {
                    if ([dummyview2 isKindOfClass:[UIButton class]]) {
                        UIButton *label = (UIButton *) dummyview2;
                        NSLog(@"%@",label.titleLabel.text);
                        stringname=label.titleLabel.text;
                    }
                    
                }
                
            }
        }
        if ([stringname isEqualToString:@"Country code"]) {
            //[self setlocationself];
        }
        else
            //[self setlocationself];
            [self setlocationmapsidebar:_current_Country andlongitude:_current_State andapikey:APIKEY];
    }
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [NSNotificationCenter.defaultCenter removeObserver:self];
}
//-(void)addnav
//{
//    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 44.0)];
//    UINavigationItem *titleItem = [[UINavigationItem alloc] initWithTitle:@"MyNavBar"];
//    NSDictionary *titleAttributesDictionary =  [NSDictionary dictionaryWithObjectsAndKeys:
//                                                [UIColor whiteColor],
//                                                UITextAttributeTextColor,
//                                                [UIColor redColor],
//                                                UITextAttributeTextShadowColor,
//                                                [NSValue valueWithUIOffset:UIOffsetMake(0, -1)],
//                                                UITextAttributeTextShadowOffset,
//                                                [UIFont fontWithName:@"HelveticaNeue-Light" size:20.0],
//                                                UITextAttributeFont,
//                                                nil];
//    navBar.titleTextAttributes = titleAttributesDictionary;
//    navBar.items = @[titleItem];
//    navBar.tintColor=[UIColor blueColor];
//    [self.view addSubview:navBar];
//}
-(void)settitleview:(NSString*)nameof
{
    //UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 44.0)];
    // UINavigationItem *titleItem = [[UINavigationItem alloc] initWithTitle:@"MyNavBar"];
    //UINavigationItem *titleItem = [[UINavigationItem alloc] init];
    UIFont *basefont;
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitleColor:AzureColor forState:UIControlStateNormal];
    // [button setBackgroundImage:[UIImage imageNamed:@"ddarrow.png"] forState:UIControlStateNormal];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    [button addTarget:self
               action:@selector(backToHOmePage)
     forControlEvents:UIControlEventTouchUpInside];
    
    
    NSArray *arr = [nameof componentsSeparatedByString:@" "];
    if (arr.count>=2)
    {
        if (![[arr objectAtIndex:1] isEqualToString:@"and"])
            nameof=[NSString stringWithFormat:@"%@ %@",[arr objectAtIndex:0], [arr objectAtIndex:1]];
        else
        {
            if (arr.count>=3)
                nameof=[NSString stringWithFormat:@"%@ %@",[arr objectAtIndex:0],[arr objectAtIndex:2]];
            else
                nameof=[NSString stringWithFormat:@"%@",[arr objectAtIndex:0]];
        }
    }
    [button setTitle:nameof forState:UIControlStateNormal];
    
    button.titleLabel.font = basefont=[UIFont fontWithName:@"SourceSansPro-Bold" size:14];
    
    //    if(nameof.length <=18)
    //        button.titleLabel.font = basefont=[UIFont fontWithName:@"Poppins-Regular" size:15];
    //    else if(nameof.length <=19 && nameof.length >=21)
    //        button.titleLabel.font = basefont=[UIFont fontWithName:@"Poppins-Regular" size:14];
    //    else if(nameof.length >=27)
    //        button.titleLabel.font = basefont=[UIFont fontWithName:@"Poppins-Regular" size:7];
    //    else if(nameof.length >=45)
    //        button.titleLabel.font = basefont=[UIFont fontWithName:@"Poppins-Regular" size:3];
    //    else
    //        button.titleLabel.font =basefont= [UIFont fontWithName:@"Poppins-Regular" size:10];
    
    CGSize stringSize = [nameof sizeWithFont:basefont];
    
    
    UIView *backView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, stringSize.width+10, 20)];// Here you can set View width and height as per your requirement for displaying titleImageView position in navigationbar
    [backView setBackgroundColor:[UIColor clearColor]];
    button.frame = CGRectMake(0, 0,stringSize.width+10, 20.0);
    [backView addSubview:button];
    
    UIImageView *dropdownImgView=[[UIImageView alloc]initWithFrame:CGRectMake(backView.frame.size.width-10, 7, 10, 10)];
    dropdownImgView.image = [UIImage imageNamed:@"blue_dropdown.png"];
    dropdownImgView.contentMode = UIViewContentModeCenter;
    dropdownImgView.clipsToBounds=YES;
    [backView addSubview:dropdownImgView];
    
    //titleImageView.contentMode = UIViewContentModeCenter;
    
    //  titleItem.titleView = backView;
    for (id dummyview in _maintitleview.subviews) {
        
        [dummyview removeFromSuperview];
        
    }
    [_maintitleview addSubview:backView];
    //    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"sidebaricon.png"]
    //                                                                         style:UIBarButtonItemStylePlain target:self action:@selector(previousecall)];
    
    //titleItem.leftBarButtonItem = revealButtonItem;
    // if (rightbarbtn) {
    //     titleItem.rightBarButtonItem = rightbarbtn;
    //}
    // navBar.items = @[titleItem];
    //[[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    // [[UINavigationBar appearance] setBackgroundColor:[UIColor redColor]];
    //    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed: @"header_bg.png"]
    //  forBarMetrics:UIBarMetricsDefault];
    // [self.view addSubview:navBar];
    
    
    
}
-(void)previousecall
{
    [self settitleview :@"Country code"];
    _addressField.text=nil;
    for (id dummyview in _mainrightbar.subviews) {
        
        [dummyview removeFromSuperview];
        
    }
    UICompositeView *cvc = PhoneMainView.instance.mainViewController;
    [cvc hideSideMenu:(cvc.sideMenuView.frame.origin.x == 0)];
}

-(void)backToHOmePage{
    [self.view endEditing:YES];
    self.searchBtn.hidden=NO;
    self.searchView.hidden=NO;
    
    CGRect searchViewFrame = self.searchView.frame;
    searchViewFrame.origin.x = SCREENWIDTH;
    self.searchView.frame = searchViewFrame;
    
    [UIView animateWithDuration:0.3 delay:0.0 options: UIViewAnimationOptionCurveEaseOut animations:^{
        CGRect searchViewFrame = self.searchView.frame;
        searchViewFrame.origin.x = 0;
        self.searchView.frame = searchViewFrame;
    } completion:^(BOOL finished){
    }];
    
    self.lblcountry.frame=CGRectMake(0, 44, SCREENWIDTH, SCREENHIGHT-64);
    [_lblcountry reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    isClickToPopup=NO;
    
    [_zeroButton setDigit:'0'];
    [_oneButton setDigit:'1'];
    [_twoButton setDigit:'2'];
    [_threeButton setDigit:'3'];
    [_fourButton setDigit:'4'];
    [_fiveButton setDigit:'5'];
    [_sixButton setDigit:'6'];
    [_sevenButton setDigit:'7'];
    [_eightButton setDigit:'8'];
    [_nineButton setDigit:'9'];
    [_starButton setDigit:'*'];
    [_hashButton setDigit:'#'];
    
    [_addressField setAdjustsFontSizeToFitWidth:TRUE]; // Not put it in IB: issue with placeholder size
    
    UILongPressGestureRecognizer *backspaceLongGesture =
    [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onBackspaceLongClick:)];
    [_backspaceButton addGestureRecognizer:backspaceLongGesture];
    
    UILongPressGestureRecognizer *zeroLongGesture =
    [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onZeroLongClick:)];
    [_zeroButton addGestureRecognizer:zeroLongGesture];
    
    UILongPressGestureRecognizer *oneLongGesture =
    [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onOneLongClick:)];
    [_oneButton addGestureRecognizer:oneLongGesture];
    
    //	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
    //																					initWithTarget:self
    //																					action:@selector(dismissKeyboards)];
    
    //[self.view addGestureRecognizer:tap];
    
    if (IPAD) {
        if (LinphoneManager.instance.frontCamId != nil) {
            // only show camera switch button if we have more than 1 camera
            [_videoCameraSwitch setHidden:FALSE];
        }
    }
    [self.lblcountry reloadData];
    [self.view bringSubviewToFront:_lblcountry];
    // [self addnav];
    countryarray=razaglobalcountryarray=[self Getcountrycode];
    [self.lblcountry setAllowsSelection:YES];
    [self creteInputAccessoryViewWithPrevious];
    [_searchCountry setInputAccessoryView:_inputAccView];
    [_searchCountry setEnablesReturnKeyAutomatically:YES];
    
    [_addressField setInputAccessoryView:_inputAccView];
    [_addressField setEnablesReturnKeyAutomatically:YES];
    
    [self settitleview :@"Country code"];
    
    self.downview.layer.shadowRadius=self.downBtn.layer.shadowRadius  = 10.0f;
    self.downview.layer.shadowColor= self.downBtn.layer.shadowColor   = [UIColor colorWithRed:240.f/255.f green:240.f/255.f blue:240.f/255.f alpha:1.f].CGColor;
    self.downview.layer.shadowOffset=self.downBtn.layer.shadowOffset  = CGSizeMake(0.0f, 0.0f);
    self.downview.layer.shadowOpacity=self.downBtn.layer.shadowOpacity = 0.9f;
    self.downview.layer.masksToBounds=self.downBtn.layer.masksToBounds = NO;
    UIEdgeInsets shadowInsets     = UIEdgeInsetsMake(0, 0, -10.0f, 0);
    UIBezierPath *shadowPath1     = [UIBezierPath bezierPathWithRect:UIEdgeInsetsInsetRect(self.downBtn.bounds, shadowInsets)];
    self.downBtn.layer.shadowPath = shadowPath1.CGPath;
    
    UIBezierPath *shadowPath      = [UIBezierPath bezierPathWithRect:UIEdgeInsetsInsetRect(self.downview.bounds, shadowInsets)];
    self.downview.layer.shadowPath= shadowPath.CGPath;
    
    
    self.callButton.layer.cornerRadius=self.callButton.frame.size.width/2.0;
    self.callButton.layer.masksToBounds=YES;
    
    
}
-(void)missedcallcounter:(NSNotification*)notify{
    int stringbadge=(int)[notify.object integerValue];
    stringbadge=stringbadge+ stringMissedbadge;
    if (stringbadge) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",stringbadge] forKey:@"missedcounterpush"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self updatechatrecent:stringbadge];
    }
}
- (void)updatemessegesecounter:(NSNotification *)notif
{
    //notif.object;
    int stringbadge=[LinphoneManager unreadMessageCount];//[notif.object integerValue];
    [self updatechatreadunreadcounter:stringbadge];
    
}
-(void)UpDownAction{
    
    if (valtocheckofpopup==1) {
        [UIView transitionWithView:self.downview
                          duration:0.8
                           options:UIViewAnimationOptionCurveEaseInOut
                        animations:^{
                            self.downview.layer.shadowColor=self.downBtn.layer.shadowColor  = [UIColor clearColor].CGColor;
                            self.openDownBGView.hidden=NO;
                            [self.downBtn setImage:[UIImage imageNamed:@"slide_down"] forState:UIControlStateNormal];
                            self.downBtn.frame=CGRectMake(15, SCREENHIGHT-182, self.downBtn.frame.size.width, self.downBtn.frame.size.height);
                            self.downview.frame=CGRectMake(0,self.downBtn.frame.origin.y+17, SCREENWIDTH, 145);
                            valtocheckofpopup=0;
                        }
                        completion:NULL];
        
    }
    else{
        NSLog(@"%f",self.downBtn.frame.size.width);
        [UIView transitionWithView:self.downview
                          duration:0.8
                           options:UIViewAnimationOptionCurveEaseInOut
                        animations:^{
                            self.downview.layer.shadowColor= self.downBtn.layer.shadowColor   = [UIColor colorWithRed:240.f/255.f green:240.f/255.f blue:240.f/255.f alpha:1.f].CGColor;
                            self.openDownBGView.hidden=YES;
                            [self.downBtn setImage:[UIImage imageNamed:@"slide_up"] forState:UIControlStateNormal];                        self.downBtn.frame=CGRectMake(15, SCREENHIGHT-55, self.downBtn.frame.size.width, self.downBtn.frame.size.height);
                            self.downview.frame=CGRectMake(0, self.downBtn.frame.origin.y+17, SCREENWIDTH, 145);
                            valtocheckofpopup=1;
                        }
                        completion:NULL];
        
    }
    
    
}



-(void)setlocationself
{
    locationManager = [[CLLocationManager alloc] init];
    [locationManager setDelegate:self];
    [locationManager setDistanceFilter:kCLDistanceFilterNone];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    if (IS_OS_8_OR_LATER) {
        if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [locationManager requestWhenInUseAuthorization];
            [locationManager requestAlwaysAuthorization];
        }
    }
    [locationManager startUpdatingLocation];
}
-(void)Setnotificationpermission
{
    UIUserNotificationSettings *notificationSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert| UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
    UIApplication *app = [UIApplication sharedApplication];
    //register the notification settings
    [app registerUserNotificationSettings:notificationSettings];
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *currentLoc=[locations objectAtIndex:0];
    // _coordinate=currentLoc.coordinate;
    NSString   *_current_Lat = [NSString stringWithFormat:@"%f",currentLoc.coordinate.latitude];
    NSString   *_current_Long = [NSString stringWithFormat:@"%f",currentLoc.coordinate.longitude];
    // [self setlocationmapsidebarself:_current_Lat andlongitude:_current_Long andapikey:APIKEY];
    NSLog(@"here lat %@ and here long %@",_current_Lat,_current_Long);
    //self._locationBlock();
    [locationManager stopUpdatingLocation];
    locationManager = nil;
}
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                         duration:(NSTimeInterval)duration {
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    switch (toInterfaceOrientation) {
        case UIInterfaceOrientationPortrait:
            [_videoPreview setTransform:CGAffineTransformMakeRotation(0)];
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
            [_videoPreview setTransform:CGAffineTransformMakeRotation(M_PI)];
            break;
        case UIInterfaceOrientationLandscapeLeft:
            [_videoPreview setTransform:CGAffineTransformMakeRotation(M_PI / 2)];
            break;
        case UIInterfaceOrientationLandscapeRight:
            [_videoPreview setTransform:CGAffineTransformMakeRotation(-M_PI / 2)];
            break;
        default:
            break;
    }
    CGRect frame = self.view.frame;
    frame.origin = CGPointMake(0, 0);
    _videoPreview.frame = frame;
    _padView.hidden = !IPAD && UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    _uiviewtabbar.hidden=NO;
    [LinphoneManager.instance shouldPresentLinkPopup];
}

#pragma mark - Event Functions

- (void)callUpdateEvent:(NSNotification *)notif {
    LinphoneCall *call = [[notif.userInfo objectForKey:@"call"] pointerValue];
    LinphoneCallState state = [[notif.userInfo objectForKey:@"state"] intValue];
    [self callUpdate:call state:state];
}

- (void)coreUpdateEvent:(NSNotification *)notif {
    if (IPAD) {
        if (linphone_core_video_display_enabled(LC) && linphone_core_video_preview_enabled(LC)) {
            linphone_core_set_native_preview_window_id(LC, (__bridge void *)(_videoPreview));
            [_backgroundView setHidden:FALSE];
            [_videoCameraSwitch setHidden:FALSE];
        } else {
            linphone_core_set_native_preview_window_id(LC, NULL);
            [_backgroundView setHidden:TRUE];
            [_videoCameraSwitch setHidden:TRUE];
        }
    }
}

#pragma mark - Debug Functions
- (void)presentMailViewWithTitle:(NSString *)subject forRecipients:(NSArray *)recipients attachLogs:(BOOL)attachLogs {
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
        if (controller) {
            controller.mailComposeDelegate = self;
            [controller setSubject:subject];
            [controller setToRecipients:recipients];
            
            if (attachLogs) {
                char *filepath = linphone_core_compress_log_collection();
                if (filepath == NULL) {
                    LOGE(@"Cannot sent logs: file is NULL");
                    return;
                }
                
                NSString *appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
                NSString *filename = [appName stringByAppendingString:@".gz"];
                NSString *mimeType = @"text/plain";
                
                if ([filename hasSuffix:@".gz"]) {
                    mimeType = @"application/gzip";
                    filename = [appName stringByAppendingString:@".gz"];
                } else {
                    LOGE(@"Unknown extension type: %@, cancelling email", filename);
                    return;
                }
                [controller setMessageBody:NSLocalizedString(@"Application logs", nil) isHTML:NO];
                [controller addAttachmentData:[NSData dataWithContentsOfFile:[NSString stringWithUTF8String:filepath]]
                                     mimeType:mimeType
                                     fileName:filename];
                
                ms_free(filepath);
            }
            self.modalPresentationStyle = UIModalPresentationPageSheet;
            [self.view.window.rootViewController presentViewController:controller
                                                              animated:TRUE
                                                            completion:^{
                                                            }];
        }
        
    } else {
        UIAlertController *errView = [UIAlertController alertControllerWithTitle:subject
                                                                         message:NSLocalizedString(@"Error: no mail account configured",
                                                                                                   nil)
                                                                  preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK"
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [errView addAction:defaultAction];
        [self presentViewController:errView animated:YES completion:nil];
    }
}

- (BOOL)displayDebugPopup:(NSString *)address {
    LinphoneManager *mgr = LinphoneManager.instance;
    NSString *debugAddress = [mgr lpConfigStringForKey:@"debug_popup_magic" withDefault:@""];
    if (![debugAddress isEqualToString:@""] && [address isEqualToString:debugAddress]) {
        UIAlertController *errView = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Debug", nil)
                                                                         message:NSLocalizedString(@"Choose an action", nil)
                                                                  preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil)
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [errView addAction:defaultAction];
        
        int debugLevel = [LinphoneManager.instance lpConfigIntForKey:@"debugenable_preference"];
        BOOL debugEnabled = (debugLevel >= ORTP_DEBUG && debugLevel < ORTP_ERROR);
        
        if (debugEnabled) {
            UIAlertAction* continueAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Send logs", nil)
                                                                     style:UIAlertActionStyleDefault
                                                                   handler:^(UIAlertAction * action) {
                                                                       NSString *appName =
                                                                       [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
                                                                       NSString *logsAddress = [mgr lpConfigStringForKey:@"debug_popup_email" withDefault:@""];
                                                                       [self presentMailViewWithTitle:appName forRecipients:@[ logsAddress ] attachLogs:true];
                                                                   }];
            [errView addAction:continueAction];
        }
        NSString *actionLog =
        (debugEnabled ? NSLocalizedString(@"Disable logs", nil) : NSLocalizedString(@"Enable logs", nil));
        
        UIAlertAction* logAction = [UIAlertAction actionWithTitle:actionLog
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              int newDebugLevel = debugEnabled ? 0 : ORTP_DEBUG;
                                                              [LinphoneManager.instance lpConfigSetInt:newDebugLevel forKey:@"debugenable_preference"];
                                                              [Log enableLogs:newDebugLevel];
                                                          }];
        [errView addAction:logAction];
        
        UIAlertAction* remAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Remove account(s) and self destruct", nil)
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              linphone_core_clear_proxy_config([LinphoneManager getLc]);
                                                              linphone_core_clear_all_auth_info([LinphoneManager getLc]);
                                                              @try {
                                                                  [LinphoneManager.instance destroyLinphoneCore:nil];
                                                              } @catch (NSException *e) {
                                                                  LOGW(@"Exception while destroying linphone core: %@", e);
                                                              } @finally {
                                                                  if ([NSFileManager.defaultManager
                                                                       isDeletableFileAtPath:[LinphoneManager documentFile:@"linphonerc"]] == YES) {
                                                                      [NSFileManager.defaultManager
                                                                       removeItemAtPath:[LinphoneManager documentFile:@"linphonerc"]
                                                                       error:nil];
                                                                  }
#ifdef DEBUG
                                                                  [LinphoneManager instanceRelease];
#endif
                                                              }
                                                              [UIApplication sharedApplication].keyWindow.rootViewController = nil;
                                                              // make the application crash to be sure that user restart it properly
                                                              LOGF(@"Self-destructing in 3..2..1..0!");
                                                          }];
        [errView addAction:remAction];
        
        [self presentViewController:errView animated:YES completion:nil];
        return true;
    }
    return false;
}

#pragma mark -

- (void)callUpdate:(LinphoneCall *)call state:(LinphoneCallState)state {
    // BOOL callInProgress = (linphone_core_get_calls_nb(LC) > 0);
    //_addContactButton.hidden = callInProgress;
    // _backButton.hidden = !callInProgress;
    [self plistfile];
    // [_callButton updateIcon:nil];
}

- (void)setAddress:(NSString *)address {
    [_addressField setText:address];
}

#pragma mark - UITextFieldDelegate Functions

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    //[textField performSelector:@selector() withObject:nil afterDelay:0];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == _addressField) {
        [_addressField resignFirstResponder];
    }
    if (textField.text.length > 0) {
        LinphoneAddress *addr = [LinphoneUtils normalizeSipOrPhoneAddress:textField.text];
        [LinphoneManager.instance call:addr andmodeVideoAudio:FALSE];
        if (addr)
            linphone_address_destroy(addr);
    }
    return YES;
}

#pragma mark - MFComposeMailDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error {
    [controller dismissViewControllerAnimated:TRUE
                                   completion:^{
                                   }];
    [self.navigationController setNavigationBarHidden:TRUE animated:FALSE];
}

#pragma mark - Action Functions

- (IBAction)onAddContactClick:(id)event {
    [ContactSelection setSelectionMode:ContactSelectionModeEdit];
    [ContactSelection setAddAddress:[_addressField text]];
    [ContactSelection setSipFilter:nil];
    [ContactSelection setNameOrEmailFilter:nil];
    [ContactSelection enableEmailFilter:FALSE];
    [PhoneMainView.instance changeCurrentView:ContactsListView.compositeViewDescription];
}

- (IBAction)onBackClick:(id)event {
    [PhoneMainView.instance popToView:CallView.compositeViewDescription];
}

- (IBAction)onAddressChange:(id)sender {
    if ([self displayDebugPopup:_addressField.text]) {
        _addressField.text = @"";
    }
    //_addContactButton.enabled =
    _backspaceButton.enabled = ([[_addressField text] length] > 0);
    if ([_addressField.text length] == 0) {
        [self.view endEditing:YES];
    }
}

- (IBAction)onBackspaceClick:(id)sender {
    if ([_addressField.text length] > 0) {
        [_addressField setText:[_addressField.text substringToIndex:[_addressField.text length] - 1]];
    }
}

- (void)onBackspaceLongClick:(id)sender {
    [_addressField setText:@""];
}

- (void)onZeroLongClick:(id)sender {
    // replace last character with a '+'
    NSString *newAddress =
    [[_addressField.text substringToIndex:[_addressField.text length] - 1] stringByAppendingString:@"+"];
    [_addressField setText:newAddress];
    linphone_core_stop_dtmf(LC);
}

- (void)onOneLongClick:(id)sender {
    LinphoneManager *lm = LinphoneManager.instance;
    NSString *voiceMail = [lm lpConfigStringForKey:@"voice_mail_uri"];
    LinphoneAddress *addr = [LinphoneUtils normalizeSipOrPhoneAddress:voiceMail];
    if (addr) {
        linphone_address_set_display_name(addr, NSLocalizedString(@"Voice mail", nil).UTF8String);
        [lm call:addr andmodeVideoAudio:FALSE];
        linphone_address_destroy(addr);
    } else {
        LOGE(@"Cannot call voice mail because URI not set or invalid!");
    }
    linphone_core_stop_dtmf(LC);
}

- (void)dismissKeyboards {
    [self.addressField resignFirstResponder];
}
- (IBAction)btnofmainclicked:(id)sender {
    //_uiviewofmain.frame=CGRectMake(0, SCREENHIGHT-150, SCREENWIDTH, _uiviewofmain.frame.size.height);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}
-(void)setlocationmapsidebarself:(NSString*)latitude andlongitude:(NSString*)longitude andapikey:(NSString*)apikey
{
    
    
    RazaTempratureObject *baseobj=[[RazaTempratureObject alloc]init];
    [baseobj setlocationmapsidebarself:latitude andlongitude:longitude andapikey:apikey callback:^(RazaTempratureObject *sellerarray, UIView *baseview, NSError *error) {
        if (baseview) {
            //UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc]
            //  initWithCustomView:baseview];
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(GotoSetTemprature)];
            
            [baseview addGestureRecognizer:singleTap];
            for (id dummyview in _mainrightbar.subviews) {
                
                [dummyview removeFromSuperview];
                
            }
            [_mainrightbar addSubview:baseview];
            // self.navigationItem.rightBarButtonItem = buttonItem;
            [self settitleview :@"Country code"];
            
            
            
            //[self settitleview:@"Australia (2222)"];
        }
        
    }];
    
    
    
    
    
}
-(void)GotoSetTemprature
{
    //    RazaTemprateBaseViewController *Raza_Temprature_object = [[RazaTemprateBaseViewController alloc]initWithNibName:@"RazaTemprateBaseViewController" bundle:nil];
    //    keyfortempmode=@"Temperature";
    //    Raza_Temprature_object.title = @"Temperature";
    //    [self.navigationController pushViewController:Raza_Temprature_object animated:YES];
    // [PhoneMainView.instance changeCurrentView:ChatsListView.compositeViewDescription];
    keyfortempmode=@"Temperature";
    RazaTemprateBaseViewController *view = VIEW(RazaTemprateBaseViewController);
    [PhoneMainView.instance changeCurrentView:view.compositeViewDescription];
}
-(NSArray*)Getcountrycode{
    NSString *path2 = [[NSBundle mainBundle] pathForResource: @"Razalist" ofType: @"json"];
    // NSArray *dictplist =[[NSArray alloc] initWithContentsOfFile:path2];
    NSData *content = [[NSData alloc] initWithContentsOfFile:path2];
    NSDictionary *dictplistbase = [NSJSONSerialization JSONObjectWithData:content options:kNilOptions error:nil];
    NSArray *dictplist=[dictplistbase objectForKey:@"countries"];
    return dictplist;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    NSArray *countrecent=[[NSUserDefaults standardUserDefaults]
                          objectForKey:RAZABASERECENTOBJECT];
    if (countrecent.count)
        return 35.0;
    else
        return 0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2; //one male and other female
}
- (NSInteger)tableView:(UITableView *)tableview numberOfRowsInSection:(NSInteger)section
{
    if (section==0)
    {
        NSArray *countrecent;//=[[NSUserDefaults standardUserDefaults]
        // objectForKey:RAZABASERECENTOBJECT];
        countrecent=tblcountryrecent;
        if (!countrecent.count&&(!(mode.length)))
            countrecent=[[NSUserDefaults standardUserDefaults]
                         objectForKey:RAZABASERECENTOBJECT];
        return countrecent.count;
    }
    else
        return countryarray.count;
    
}
//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
//
//    return [self dataRecordsWithSectionKey:countryarray];
//}
-(NSArray*)dataRecordsWithSectionKey:(NSArray *)countrylist {
    
    NSString* letter;
    NSMutableDictionary* _mData = [[NSMutableDictionary alloc] init];
    
    if ([countrylist count]) {
        for (NSDictionary *country in countrylist) {
            unichar setKey = [[country objectForKey:RazaCountry_name]  characterAtIndex:0];
            
            letter = [NSString stringWithFormat:@"%c",setKey];
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
    
    return [NSArray arrayWithArray:_keysections];
    
}

//- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
//    return index;//countryarray.count;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *getTempratureObject;
    static NSString *cellIdentifier = @"cellID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:
                UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    if (indexPath.section==0)
    {
        getTempratureObject=tblcountryrecent;
        if (!getTempratureObject.count)
            getTempratureObject=[[NSUserDefaults standardUserDefaults]
                                 objectForKey:RAZABASERECENTOBJECT];
    }
    else
        getTempratureObject=countryarray;
    
    [cell.textLabel setFont:[UIFont fontWithName:@"SourceSansPro-Regular" size:18.0f]];
    cell.textLabel.textColor=OxfordBlueColor;
    cell.textLabel.text=[NSString stringWithFormat:@"%@ (%@)",[[getTempratureObject objectAtIndex:indexPath.row] objectForKey:RazaCountry_name],[[getTempratureObject objectAtIndex:indexPath.row] objectForKey:RazaCountry_Code]];
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSArray *countrecent=[[NSUserDefaults standardUserDefaults]
                          objectForKey:RAZABASERECENTOBJECT];
    if ([countrecent count]) {
        RazaTempratureObject *baseobject=[[RazaTempratureObject alloc]init];
        if (section==0)
            return [baseobject GetTempratureview:RAZARECENTTEMPRATE andwidthofview:tableView.frame.size.width];
        else
            return [baseobject GetTempratureview:RAZAALLTEMPRATE andwidthofview:tableView.frame.size.width];
    }
    else
        return nil;
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *getTempratureObject;
    if (indexPath.section==0)
    {
        getTempratureObject=tblcountryrecent;
        if (!getTempratureObject.count)
            getTempratureObject=[[NSUserDefaults standardUserDefaults]
                                 objectForKey:RAZABASERECENTOBJECT];
    }
    else
    {
        RazaTempratureObject *baseobj=[[RazaTempratureObject alloc]init];
        [baseobj setRecentTempratue:countryarray andkeyof:RAZABASERECENTOBJECT andindexval:(int)indexPath.row];
        getTempratureObject=countryarray;
        
    }
    if(_addressField.text.length)
        _addressField.text=nil;
    
    NSString *prev=_addressField.text;
    NSString *code=[[getTempratureObject objectAtIndex:indexPath.row] objectForKey:RazaCountry_Code];
    NSString* result = [code stringByAppendingString:prev];
    _addressField.text=result;
    NSLog(@"%@",result);
    if(!_addressField.text.length)
    {
        
        //_numberString=nil;
        // self.labelPhoneNo.text=@"";
        // self.lblstdcode.text =[[[getTempratureObject objectAtIndex:indexPath.row] objectForKey:RazaCountry_Code] mutableCopy];
        //self.labelPhoneNo.text = [[[countryarray objectAtIndex:indexPath.row] objectForKey:RazaCountry_Code] mutableCopy];
    }
    else
    {
        
        // _numberString= [self.labelPhoneNo.text mutableCopy];//stringByAppendingString:self.labelPhoneNo.text] mutableCopy];
        //self.lblstdcode.text = [[getTempratureObject objectAtIndex:indexPath.row] objectForKey:RazaCountry_Code];
    }
    //    _numberString=[[_numberString stringByAppendingString:[[countryarray objectAtIndex:indexPath.row] objectForKey:@"countryCode"]] mutableCopy];//[[countryarray objectAtIndex:indexPath.row] objectForKey:@"countryCode"];
    //    self.labelPhoneNo.text = [self.labelPhoneNo.text stringByAppendingString:[[countryarray objectAtIndex:indexPath.row] objectForKey:@"countryCode"]];//[[countryarray objectAtIndex:indexPath.row] objectForKey:@"countryCode"];
    // [self updateDialNumber:_numberString];
    
    [self settitleview:[NSString stringWithFormat:@"%@ (%@)",[[getTempratureObject objectAtIndex:indexPath.row] objectForKey:RazaCountry_name],[[getTempratureObject objectAtIndex:indexPath.row] objectForKey:RazaCountry_Code]]];
    [_searchCountry resignFirstResponder];
    self.searchView.hidden=YES;
    self.searchBtn.hidden=NO;
    self.lblcountry.frame=CGRectMake(0, 44, SCREENWIDTH, SCREENHIGHT-64);
    // _viewCountry.hidden=YES;
    NSString  *imagenamestring = [[[getTempratureObject objectAtIndex:indexPath.row] objectForKey:RazaCountry_Code] stringByReplacingOccurrencesOfString:@"+" withString:@"011"];
    NSLog(@"%@",imagenamestring);
    //countryImageView.hidden=NO;
    // countryImageView.image=[UIImage imageNamed:imagenamestring];
    
    
    //    if(self.lblstdcode.text.length <=3)
    //        self.lblstdcode.font = [UIFont fontWithName:@"Poppins-Light" size:25];
    //    else if(self.lblstdcode.text.length > 3)
    //        self.lblstdcode.font = [UIFont fontWithName:@"Poppins-Light" size:16];
    [self setlocation:[[getTempratureObject objectAtIndex:indexPath.row] objectForKey:RazaCountry_name] andstate:[[getTempratureObject objectAtIndex:indexPath.row] objectForKey:RazaCountry_City]];
    
}
-(void)setlocation:(NSString*)countryname andstate:(NSString*)statename
{
    _current_Country=countryname;
    _current_State=statename;
    [self setlocationmapsidebar:countryname andlongitude:statename andapikey:APIKEY];
    
}
-(void)setlocationmapsidebar:(NSString*)latitude andlongitude:(NSString*)longitude andapikey:(NSString*)apikey
{
    
    
    RazaTempratureObject *baseobj=[[RazaTempratureObject alloc]init];
    [baseobj setlocationmapsidebar:latitude andlongitude:longitude andapikey:apikey callback:^(RazaTempratureObject *sellerarray, UIView *baseview, NSError *error) {
        
        if (baseview) {
            //UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc]
            // initWithCustomView:baseview];
            
            for (id dummyview in _mainrightbar.subviews) {
                [dummyview removeFromSuperview];
            }
            
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(GotoSetTemprature)];
            [baseview addGestureRecognizer:singleTap];
            [_mainrightbar addSubview:baseview];
        }
    }];
}
-(void)clicktopopup
{
    isClickToPopup=YES;
    NSArray *arr1_hover=[[NSArray alloc]initWithObjects:@"call_wifi.png",@"call_min.png",@"call_data.png", nil];
    NSArray *arr1=[[NSArray alloc]initWithObjects:@"call_wifi_hover.png",@"call_min_hover.png",@"call_data_hover.png", nil];
    
    aButton0 = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *btnImage0 = [UIImage imageNamed:[arr1 objectAtIndex:0]];
    UIImage *btnImage_0 = [UIImage imageNamed:[arr1_hover objectAtIndex:0]];
    
    [aButton0 setTag:0];
    [aButton0 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    NSInteger Aindex1 = [[datafornetwork valueForKey:@"valueof"] indexOfObject:@"1"];
    
    if (Aindex1==0){
        [aButton0 setImage:btnImage_0 forState:UIControlStateNormal];
    }
    else{
        [aButton0 setImage:btnImage0 forState:UIControlStateNormal];
    }
    
    //[aButton0 setImage:btnImage_0 forState:UIControlStateHighlighted];
    
    // [aButton setTitle:@"Show View" forState:UIControlStateNormal];
    float gapValue=(APP_FRAME.size.width-180)/4.0f;
    aButton0.frame = CGRectMake(gapValue, 30, 60, 60);
    // [aButton setTintColor:[UIColor redColor]];
    aButton0.backgroundColor = [UIColor clearColor];
    [self.downview addSubview:aButton0];
    
    aButton1= [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *btnImage1 = [UIImage imageNamed:[arr1 objectAtIndex:1]];
    UIImage *btnImage_1 = [UIImage imageNamed:[arr1_hover objectAtIndex:1]];
    
    [aButton1 setTag:1];
    [aButton1 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    if (Aindex1==1){
        [aButton1 setImage:btnImage_1 forState:UIControlStateNormal];
    }
    else{
        [aButton1 setImage:btnImage1 forState:UIControlStateNormal];
    }
    // [aButton1 setImage:btnImage1 forState:UIControlStateNormal];
    //[aButton1 setImage:btnImage_1 forState:UIControlStateHighlighted];
    
    float X_Co = (APP_FRAME.size.width - 60)/2;
    [aButton1 setFrame:CGRectMake(X_Co, 30, 60, 60)];
    // [aButton setTintColor:[UIColor redColor]];
    aButton1.backgroundColor = [UIColor clearColor];
    [self.downview addSubview:aButton1];
    
    aButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *btnImage2 = [UIImage imageNamed:[arr1 objectAtIndex:2]];
    UIImage *btnImage_2 = [UIImage imageNamed:[arr1_hover objectAtIndex:2]];
    
    [aButton2 setTag:2];
    [aButton2 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    if (Aindex1==2){
        [aButton2 setImage:btnImage_2 forState:UIControlStateNormal];
    }
    else{
        [aButton2 setImage:btnImage2 forState:UIControlStateNormal];
    }
    // [aButton2 setImage:btnImage2 forState:UIControlStateNormal];
    //[aButton2 setImage:btnImage_2 forState:UIControlStateHighlighted];
    
    // [aButton setTitle:@"Show View" forState:UIControlStateNormal];
    aButton2.frame = CGRectMake(APP_FRAME.size.width-(gapValue+60), 30, 60, 60);
    // [aButton setTintColor:[UIColor redColor]];
    aButton2.backgroundColor = [UIColor clearColor];
    [self.downview addSubview:aButton2];
    // }
    
    float labelGapValue=(APP_FRAME.size.width-210)/4.0f;
    float X_Co1 = (APP_FRAME.size.width - 70)/2;
    UILabel *wifiLbl=[[UILabel alloc]initWithFrame:CGRectMake(labelGapValue, 103, 70, 10)];
    UILabel *minsLbl=[[UILabel alloc]initWithFrame:CGRectMake(X_Co1, 103, 70, 10)];
    UILabel *dataLbl=[[UILabel alloc]initWithFrame:CGRectMake(APP_FRAME.size.width-(labelGapValue+70), 103, 70, 10)];
    wifiLbl.text=@"WIFI CALL";
    minsLbl.text=@"MINS CALL";
    dataLbl.text=@"DATA CALL";
    
    dataLbl.textAlignment=minsLbl.textAlignment =wifiLbl.textAlignment=NSTextAlignmentCenter;
    dataLbl.font=minsLbl.font=wifiLbl.font=[UIFont fontWithName:@"SourceSansPro-Bold" size:14];
    dataLbl.textColor=minsLbl.textColor=wifiLbl.textColor=OxfordBlueColor;
    dataLbl.alpha=minsLbl.alpha=wifiLbl.alpha=0.3f;
    [self.downview addSubview:wifiLbl];
    [self.downview addSubview:minsLbl];
    [self.downview addSubview:dataLbl];
    
}


- (IBAction)chatbuttonClickede:(id)sender {
}
- (IBAction)btnDialPadClicked:(id)sender {
    _btndial.selected=YES;
}
- (IBAction)btnChatClicked:(id)sender {
    [[LinphoneManager instance] lpConfigSetInt:NO forKey:@"animations_preference"];
    [_btndial setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [PhoneMainView.instance changeCurrentView:ChatsListView.compositeViewDescription];
}
- (IBAction)btnContactClicked:(id)sender {
    [[LinphoneManager instance] lpConfigSetInt:NO forKey:@"animations_preference"];
    _btndial.selected=NO;
    [ContactSelection setAddAddress:nil];
    [ContactSelection enableEmailFilter:FALSE];
    [ContactSelection setNameOrEmailFilter:nil];
    
    [PhoneMainView.instance changeCurrentView:ContactsListView.compositeViewDescription];
}

- (IBAction)btnrecentClicked:(id)sender {
    [[LinphoneManager instance] lpConfigSetInt:NO forKey:@"animations_preference"];
    _btndial.selected=NO;
    [PhoneMainView.instance changeCurrentView:HistoryListView.compositeViewDescription];
}
- (IBAction)btnmainbackClicked:(id)sender {
    self.searchView.hidden=YES;
    self.searchBtn.hidden=NO;
    [_lblcountry reloadData];
    self.lblcountry.frame=CGRectMake(0, 44, SCREENWIDTH, SCREENHIGHT-64);
    [self previousecall];
    
}
-(void)creteInputAccessoryViewWithPrevious
{
    if (_inputAccView) {
        _inputAccView = nil;
    }
    _inputAccView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, SCREENWIDTH, 44.0)];
    [_inputAccView setBackgroundColor:[UIColor whiteColor]];
    [_inputAccView setAlpha: 1.0];
    
    
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    _done = [[UIBarButtonItem alloc] initWithTitle:nil style:UIBarButtonItemStyleDone target:self action:@selector(doneButton:)];
    
    UILabel   *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDTH-60, 0, 100, 44)];
    [titleLabel setTextAlignment:NSTextAlignmentLeft];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    
    //   titleLabel.backgroundColor = UIColorFromRGBA(215, 236, 250, 1);
    titleLabel.text=@"Done";
    [titleLabel setFont:[UIFont fontWithName:@"SourceSansPro-Bold" size:16]];
    [titleLabel setTextColor:[UIColor whiteColor]];
    
    [_keyboardToolbar removeFromSuperview];
    _keyboardToolbar = [[UIToolbar alloc] init];
    _keyboardToolbar.frame = CGRectMake(0.0, 0.0, SCREENWIDTH, 44.0);
    
    _keyboardToolbar.items = [NSArray arrayWithObjects:spacer,_done, nil];
    // [_keyboardToolbar setBarStyle:UIBarStyleDefault];
    //[_keyboardToolbar setBackgroundColor:[UIColor clearColor]];
    // [_keyboardToolbar setBackgroundColor:kColorHeader];
    // _keyboardToolbar.barTintColor=kColorHeader;
    [_keyboardToolbar addSubview:titleLabel];
    
    CAGradientLayer *gradient = [BackgroundLayer navHeaderGradient];
    gradient.frame = _keyboardToolbar.bounds;
    gradient.startPoint = CGPointMake(0.0, 0.0);
    gradient.endPoint = CGPointMake(0.0, 1.0);
    gradient.locations = @[@0.0,@1.0];
    [_keyboardToolbar.layer insertSublayer:gradient atIndex:0];
    [_inputAccView addSubview:_keyboardToolbar];
}
-(IBAction)doneButton:(id)sender {
    
    if (self.searchCountry.text.length==0) {
        self.searchCountry.text=@"";
        mode=nil;
        countryarray = razaglobalcountryarray;
        tblcountryrecent=nil;
        [_lblcountry reloadData];
        self.lblcountry.frame=CGRectMake(0, 44, SCREENWIDTH, SCREENHIGHT-64);
        self.searchBtn.hidden=NO;
    }
    [_searchCountry resignFirstResponder];
    [_addressField resignFirstResponder];
}
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    //    if (![searchText length]) {
    //        mode=nil;
    //        countryarray = razaglobalcountryarray;
    //        tblcountryrecent=nil;
    //        [_tblcountrycode reloadData];
    //    }
    //else
    //    {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(dosearchquery) object:nil];
    // start a new one in 0.3 seconds
    [self performSelector:@selector(dosearchquery) withObject:nil afterDelay:.2];
    //}
}
-(void)dosearchquery
{
    
    // [self ShowWaiting:nil];
    if (self.searchCountry.text.length) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name contains[c] %@",self.searchCountry.text]; // if you need case sensitive search avoid '[c]' in the predicate
        //countryarray=razaglobalcountryarray
        mode=@"search";
        countryarray = [razaglobalcountryarray filteredArrayUsingPredicate:predicate];
        NSArray *bb=[[NSUserDefaults standardUserDefaults]
                     objectForKey:RAZABASERECENTOBJECT];
        tblcountryrecent=[bb filteredArrayUsingPredicate:predicate];
        [_lblcountry reloadData];
    }
    else
    {
        mode=nil;
        countryarray = razaglobalcountryarray;
        tblcountryrecent=nil;
        [_lblcountry reloadData];
    }
    
    // [self HideWaiting];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
    NSLog(@"%@",@"gggg");
}
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    searchBar.showsCancelButton = YES;
    return YES;
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    searchBar.text=@"";
    mode=nil;
    countryarray = razaglobalcountryarray;
    tblcountryrecent=nil;
    [_lblcountry reloadData];
    [_searchCountry resignFirstResponder];
    self.lblcountry.frame=CGRectMake(0, 44, SCREENWIDTH, SCREENHIGHT-64);
    self.searchBtn.hidden=NO;
    
}
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    searchBar.showsCancelButton = NO;
    [_searchCountry resignFirstResponder];
    return YES;
}
/*-----------from here condition of all 3 button-------*/

-(void)buttonClicked:(UIButton*)sender
{
    NSString *strforval;
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    
    NetworkStatus status = [reachability currentReachabilityStatus];
    
    if(status == NotReachable)
    {
        //No internet
        strforval=@"0";
    }
    else if (status == ReachableViaWiFi)
    {
        strforval=@"1";
    }
    else if (status == ReachableViaWWAN)
    {
        strforval=@"2";
    }
    
    int tag = (int)sender.tag;
    if(tag==0)
    {
        if ([strforval isEqual:@"1"])
        {
            NSMutableArray *dataFromPlist2 =[[NSMutableArray alloc]initWithArray:[dataforglobalplist valueForKey:@"name"]];
            NSInteger anIndex=[dataFromPlist2 indexOfObject:@"Wi-Fi"];
            
            NSMutableArray *dataFromPlistforvalue =[[NSMutableArray alloc]initWithArray:[dataforglobalplist valueForKey:@"valueof"]];
            if (![[dataFromPlistforvalue objectAtIndex:anIndex] isEqualToString:@"1"])
            {
                [self showpopupwithbutton:100];
            }
            else
            {
                
                [self forwifitest];
                
            }
        }
        else
        {
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Warning!"
                                                              message:[NSString stringWithFormat:@"Wi-Fi not available. Please turn it on from your phone’s settings"]
                                                             delegate:self
                                                    cancelButtonTitle:@"ok"
                                                    otherButtonTitles:nil];
            
            
            [message show];
        }
        
    }
    else if (tag==1)
    {
        NSMutableArray *dataFromPlist2 =[[NSMutableArray alloc]initWithArray:[dataforglobalplist valueForKey:@"name"]];
        NSInteger anIndex=[dataFromPlist2 indexOfObject:@"Minutes"];
        
        NSMutableArray *dataFromPlist23 =[[NSMutableArray alloc]initWithArray:[dataforglobalplist valueForKey:@"valueof"]];
        if (![[dataFromPlist23 objectAtIndex:anIndex] isEqualToString:@"1"])
        {
            [self showpopupwithbutton:1000];
        }
        else
        {
            
            [self forminutest];
        }
    }
    else if(tag==2)
    {
        if ([strforval isEqualToString:@"2"])
        {
            NSMutableArray *dataFromPlist2dataprev =[[NSMutableArray alloc]initWithArray:[dataforglobalplist valueForKey:@"name"]];
            NSInteger anIndex=[dataFromPlist2dataprev indexOfObject:@"Data"];
            
            NSMutableArray *dataFromPlist2data =[[NSMutableArray alloc]initWithArray:[datafornetwork valueForKey:@"valueof"]];
            if (![[dataFromPlist2data objectAtIndex:anIndex] isEqualToString:@"1"])
            {
                [self showpopupwithbutton:2000];
            }
            else
            {
                [self fordatatest];
                
            }
        }
        else if ([strforval isEqualToString:@"0"])
        {
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Warning!"
                                                              message:@"No network available"
                                                             delegate:self
                                                    cancelButtonTitle:@"ok"
                                                    otherButtonTitles:nil];
            
            
            [message show];
        }
        else
        {
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Warning!"
                                                              message:@"Please turn off Wi-Fi to be able to make a call using your data plan"
                                                             delegate:self
                                                    cancelButtonTitle:@"ok"
                                                    otherButtonTitles:nil];
            
            
            [message show];
        }
        
    }
    
}

/*---------first popup----------*/

-(void)showpopupwithbutton:(int)tagtofit
{
    NSString *str;
    switch (tagtofit) {
        case 100:
            str=@"Wi-fi?";
            break;
        case 1000:
            str=@"Minutes?";
            break;
        case 2000:
            str=@"Data?";
            break;
        default:
            break;
    }
    
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Warning!"
                                                      message:[NSString stringWithFormat:@"%@ %@ %@",@"Are you sure you want to make this call using", str, @"In your settings it is set to OFF"]
                                                     delegate:self
                                            cancelButtonTitle:nil
                                            otherButtonTitles:@"Yes",@"No",nil];
    message.tag=tagtofit;
    
    [message show];
}


/*---------------contion as per-----------*/

-(void)forwifitest
{
    // [self showwindowview];
    [self updateplistwith1:0];
    [self updateplistwith0:1];
    [self updateplistwith0:2];
    checkfor_useingnetwork=@"1";
    [aButton1 setImage:nil forState:UIControlStateNormal];
    [aButton2 setImage:nil forState:UIControlStateNormal];
    UIImage *btnImage1 = [UIImage imageNamed:@"call_wifi.png"];
    [aButton0 setImage:btnImage1 forState:UIControlStateNormal];
    UIImage *btnImage2 = [UIImage imageNamed:@"call_min_hover.png"];
    [aButton1 setImage:btnImage2 forState:UIControlStateNormal];
    
    UIImage *btnImage3 = [UIImage imageNamed:@"call_data_hover.png"];
    [aButton2 setImage:btnImage3 forState:UIControlStateNormal];
    /*===========modified global----------*/
    //    NSMutableArray *dataFromPlist2 =[[NSMutableArray alloc]initWithArray:[dataforglobalplist valueForKey:@"name"]];
    //    NSInteger anIndex=[dataFromPlist2 indexOfObject:@"Wi-Fi"];
    //    //if(anIndex!=0)
    //    [self switchon:(int)anIndex:0];
    
    [self hidepopup];
    //  [self UpDownAction];
    UIButton *callbtn = (UIButton *)[self.view viewWithTag:999];
    [callbtn setImage:[UIImage imageNamed:@"call_wifi"] forState:UIControlStateNormal];
    [_callButton updateIcon:@"call_wifi"];
    
}

-(void)forminutest
{
    [self updateplistwith1:1];
    [self updateplistwith0:0];
    [self updateplistwith0:2];
    checkfor_useingnetwork=@"2";
    UIImage *btnImage1 = [UIImage imageNamed:@"call_min.png"];
    [aButton1 setImage:btnImage1 forState:UIControlStateNormal];
    UIImage *btnImage2 = [UIImage imageNamed:@"call_wifi_hover.png"];
    [aButton0 setImage:nil forState:UIControlStateNormal];
    [aButton2 setImage:nil forState:UIControlStateNormal];
    
    [aButton0 setImage:btnImage2 forState:UIControlStateNormal];
    UIImage *btnImage3 = [UIImage imageNamed:@"call_data_hover.png"];
    [aButton2 setImage:btnImage3 forState:UIControlStateNormal];
    /*===========modified global----------*/
    //    NSMutableArray *dataFromPlist2 =[[NSMutableArray alloc]initWithArray:[dataforglobalplist valueForKey:@"name"]];
    //    NSInteger anIndex=[dataFromPlist2 indexOfObject:@"Minutes"];
    //    //  if (anIndex!=0)
    //    [self switchon:(int)anIndex : 1];
    //                else
    //                    [self onlyupdate:(int)anIndex];
    
    /*============end of modified=============*/
    [self hidepopup];
    UIButton *callbtn = (UIButton *)[self.view viewWithTag:999];
    [callbtn setImage:[UIImage imageNamed:@"call_min"] forState:UIControlStateNormal];
    [_callButton updateIcon:@"call_min"];
}
-(void)fordatatest{
    [self updateplistwith1:2];
    [self updateplistwith0:0];
    [self updateplistwith0:1];
    checkfor_useingnetwork=@"3";
    [aButton0 setImage:nil forState:UIControlStateNormal];
    [aButton1 setImage:nil forState:UIControlStateNormal];
    UIImage *btnImage1 = [UIImage imageNamed:@"call_data.png"];
    [aButton2 setImage:btnImage1 forState:UIControlStateNormal];
    UIImage *btnImage2 = [UIImage imageNamed:@"call_wifi_hover.png"];
    [aButton0 setImage:btnImage2 forState:UIControlStateNormal];
    UIImage *btnImage3 = [UIImage imageNamed:@"call_min_hover.png"];
    [aButton1 setImage:btnImage3 forState:UIControlStateNormal];
    /*===========modified global----------*/
    //    NSMutableArray *dataFromPlist2 =[[NSMutableArray alloc]initWithArray:[dataforglobalplist valueForKey:@"name"]];
    //    NSInteger anIndex=[dataFromPlist2 indexOfObject:@"Data"];
    //    //if (anIndex!=0)
    //    [self switchon:(int)anIndex:2];
    //                else
    //                    [self onlyupdate:(int)anIndex];
    
    /*============end of modified=============*/
    [self showalert];
    UIButton *callbtn = (UIButton *)[self.view viewWithTag:999];
    
    [callbtn setImage:[UIImage imageNamed:@"call_data"] forState:UIControlStateNormal];
    [_callButton updateIcon:@"call_data"];
}

/*--------------3'd step--------------*/

-(void)showwindowview
{
    viewwindow = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_FRAME.size.width, 500)];
    
    UIView *ContainerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, 330)];
    [viewwindow addSubview:ContainerView];
    
    ContainerView.center=viewwindow.center;
    ContainerView.backgroundColor=[UIColor whiteColor];
    ContainerView.clipsToBounds = YES;
    ContainerView.layer.cornerRadius=6;
    [viewwindow  addSubview:ContainerView];
    chkboxvalue=YES;
    UIButton *btnof= [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnof addTarget:self
              action:@selector(clicktook)
    forControlEvents:UIControlEventTouchUpInside];
    [btnof setTitle:@"Ok" forState:UIControlStateNormal];
    btnof.frame = CGRectMake(25, 210, 250, 50.0);
    btnof.backgroundColor=[UIColor redColor];
    btnof.layer.cornerRadius=6;
    UIButton *btnof1= [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnof1 addTarget:self
               action:@selector(clicktocancel)
     forControlEvents:UIControlEventTouchUpInside];
    [btnof1 setTitle:@"Cancel" forState:UIControlStateNormal];
    btnof1.frame = CGRectMake(25, 270, 250, 50.0);
    btnof1.layer.cornerRadius=6;
    btnof1.backgroundColor=[UIColor redColor];
    UIImage *img = [UIImage imageNamed:@"unchk.png"];
    
    btnofcheckbox= [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnofcheckbox setBackgroundImage:img forState:UIControlStateNormal];
    [btnofcheckbox addTarget:self
                      action:@selector(clicktocheckbox)
            forControlEvents:UIControlEventTouchUpInside];
    
    btnofcheckbox.frame = CGRectMake(10, 130, 20, 20);
    
    [ContainerView addSubview:btnofcheckbox];
    [ContainerView addSubview:btnof];
    [ContainerView addSubview:btnof1];
    viewwindow.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:.8];
    [self.view addSubview:viewwindow];
}


/*--------forth--------------------*/
-(void)updateplistwith1:(int)passtoswitch
{
    NSMutableArray *dataFromPlist2 =[[NSMutableArray alloc]initWithArray:[datafornetwork valueForKey:@"valueof"]];
    
    [dataFromPlist2 replaceObjectAtIndex:passtoswitch withObject:@"1"];
    
    
    [datafornetwork setObject:dataFromPlist2 forKey:@"valueof"];
    [datafornetwork writeToFile: pathfornetwork atomically:YES];
}
-(void)updateplistwith0:(int)passtoswitch
{
    NSMutableArray *dataFromPlist2 =[[NSMutableArray alloc]initWithArray:[datafornetwork valueForKey:@"valueof"]];
    
    [dataFromPlist2 replaceObjectAtIndex:passtoswitch withObject:@"0"];
    
    
    [datafornetwork setObject:dataFromPlist2 forKey:@"valueof"];
    [datafornetwork writeToFile: pathfornetwork atomically:YES];
}
/*------------fifth ------------*/
-(void)onlyupdate:(int)passtoswitch
{
    NSMutableArray *dataFromPlist2 =[[NSMutableArray alloc]initWithArray:[dataforglobalplist valueForKey:@"valueof"]];
    
    [dataFromPlist2 replaceObjectAtIndex:passtoswitch withObject:@"1"];
    
    
    [dataforglobalplist setObject:dataFromPlist2 forKey:@"valueof"];
    [dataforglobalplist writeToFile: pathforglobalplist atomically:YES];
}
- (void)switchon:(int)passtoswitch :(int) selectedparameter

{
    int checkhowmuch1=[self checkforavailablevalue];
    if (checkhowmuch1!=3) {
        NSMutableArray *dataFromPlist2 =[[NSMutableArray alloc]initWithArray:[dataforglobalplist valueForKey:@"valueof"]];
        
        [dataFromPlist2 replaceObjectAtIndex:passtoswitch withObject:@"1"];
        
        
        [dataforglobalplist setObject:dataFromPlist2 forKey:@"valueof"];
        [dataforglobalplist writeToFile: pathforglobalplist atomically:YES];
        
        int checkhowmuch=[self checkforavailablevalue];
        [self valuetoreplace:dataFromPlist2 andsecond:checkhowmuch andthird:selectedparameter];
    }
    
    else
    {
        if (passtoswitch==1) {
            NSMutableArray *dataFromPlist =[[NSMutableArray alloc]initWithArray:[dataforglobalplist valueForKey:@"name"]];
            
            [dataFromPlist exchangeObjectAtIndex:0 withObjectAtIndex:1];
            [dataforglobalplist setObject:dataFromPlist forKey:@"name"];
            
            NSMutableArray *dataFromPlist1 =[[NSMutableArray alloc]initWithArray:[dataforglobalplist valueForKey:@"order"]];
            [dataFromPlist1 exchangeObjectAtIndex:0 withObjectAtIndex:1];
            
            
            [dataforglobalplist setObject:dataFromPlist1 forKey:@"order"];
            
            
            NSMutableArray *dataFromPlist2 =[[NSMutableArray alloc]initWithArray:[dataforglobalplist valueForKey:@"valueof"]];
            
            [dataFromPlist2 exchangeObjectAtIndex:0 withObjectAtIndex:1];
            
            
            [dataforglobalplist setObject:dataFromPlist2 forKey:@"valueof"];
            [dataforglobalplist writeToFile: pathforglobalplist atomically:YES];
            
            
        }
        else if (passtoswitch==2) {
            NSMutableArray *dataFromPlist =[[NSMutableArray alloc]initWithArray:[dataforglobalplist valueForKey:@"name"]];
            
            [dataFromPlist exchangeObjectAtIndex:0 withObjectAtIndex:2];
            [dataFromPlist exchangeObjectAtIndex:1 withObjectAtIndex:2];
            [dataforglobalplist setObject:dataFromPlist forKey:@"name"];
            
            NSMutableArray *dataFromPlist1 =[[NSMutableArray alloc]initWithArray:[dataforglobalplist valueForKey:@"order"]];
            [dataFromPlist1 exchangeObjectAtIndex:0 withObjectAtIndex:2];
            [dataFromPlist1 exchangeObjectAtIndex:1 withObjectAtIndex:2];
            
            [dataforglobalplist setObject:dataFromPlist1 forKey:@"order"];
            
            
            NSMutableArray *dataFromPlist2 =[[NSMutableArray alloc]initWithArray:[dataforglobalplist valueForKey:@"valueof"]];
            
            [dataFromPlist2 exchangeObjectAtIndex:0 withObjectAtIndex:2];
            [dataFromPlist2 exchangeObjectAtIndex:1 withObjectAtIndex:2];
            
            [dataforglobalplist setObject:dataFromPlist2 forKey:@"valueof"];
            [dataforglobalplist writeToFile: pathforglobalplist atomically:YES];
            
            
        }
        
    }
    
    
    NSLog(@"alll%@",dataforglobalplist);
}
/*---------------six ---------------*/
-(void)hidepopup
{
    // valtocheckofpopup=1;
    //    [viewwindow removeFromSuperview];
    //    [UIView animateWithDuration:0.5
    //                     animations:^{
    //                         //theView.frame = newFrame;
    //                        // self.moveViewBottomCons.constant = -134;
    //                        // self.btnBottomCons.constant=53;
    //
    //                        // [self.uiviewofmain layoutIfNeeded];
    //                         //[self.btnofmain layoutIfNeeded];
    //
    //                         //                         if (iPhone4Or5oriPad==4)
    //                         //                         {
    //                         //                             _uiviewofmain.frame = CGRectMake(0, 317, 320, 150);// move
    //                         //                             _btnofmain.frame = CGRectMake(0, 384, 33, 50);
    //                         //                         }
    //                         //                         else
    //                         //                         {
    //                         //                             _uiviewofmain.frame = CGRectMake(0, 390, 320, 180);
    //                         //                             _btnofmain.frame = CGRectMake(0, 486, 33, 50);
    //                         //
    //                         //                         }
    //                     }
    //                     completion:^(BOOL finished){
    //                         // code to run when animation completes
    //                         // (in this case, another animation:)
    //                         [UIView animateWithDuration:0.5
    //                                          animations:^{
    //                                              //postStatusView.alpha = 0.0;   // fade out
    //                                          }
    //                                          completion:^(BOOL finished){
    //                                              //[postStatusView removeFromSuperview];
    //
    //                                          }];
    //                     }];
    
    if (valtocheckofpopup==1) {
        
    }
    else
    {
        [UIView transitionWithView:self.downview
                          duration:0.8
                           options:UIViewAnimationOptionCurveEaseInOut
                        animations:^{
                            self.downview.layer.shadowColor= self.downBtn.layer.shadowColor   = [UIColor colorWithRed:240.f/255.f green:240.f/255.f blue:240.f/255.f alpha:1.f].CGColor;
                            self.openDownBGView.hidden=YES;
                            [self.downBtn setImage:[UIImage imageNamed:@"slide_up"] forState:UIControlStateNormal];                        self.downBtn.frame=CGRectMake(15, SCREENHIGHT-55, self.downBtn.frame.size.width, self.downBtn.frame.size.height);
                            self.downview.frame=CGRectMake(0, self.downBtn.frame.origin.y+17, SCREENWIDTH, 145);
                            valtocheckofpopup=1;
                        }
                        completion:NULL];
    }
}

-(void)showalert{
    //checkfornetworktype=@"wifi";sim not available
    if ([checkfor_availablenetwork isEqual:@"1"]){
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Warning!"
                                                          message:@"Please turn off Wi-Fi to be able to make a call using your data plan."
                                                         delegate:self
                                                cancelButtonTitle:nil
                                                otherButtonTitles:@"ok",nil];
        
        [message show];
    }
    else
    {
        checkfor_useingnetwork=@"3";
        [self hidepopup];
    }
    
}
-(int)checkforavailablevalue
{
    
    int occurrences = 0;
    for(NSString *string in [dataforglobalplist valueForKey:@"valueof"]){
        occurrences += ([string isEqualToString:@"1"]?1:0); //certain object is @"Apple"
    }
    
    return occurrences;
}
/*----------eigth---------*/
-(void)valuetoreplace:(NSArray*)dataFromPlist2 andsecond:(int)checkhowmuch andthird: (int)selectedvalue
{
    
    
    NSMutableArray *dataFromPlistforfound =[[NSMutableArray alloc]initWithArray:[dataforglobalplist valueForKey:@"name"]];
    NSString *str;
    NSInteger anIndex;
    if (selectedvalue==0)
    {
        str=@"Wi-Fi";
        anIndex=[dataFromPlistforfound indexOfObject:@"Wi-Fi"];
        //
    }
    else if (selectedvalue==1)
    {
        anIndex=[dataFromPlistforfound indexOfObject:@"Minutes"];
    }
    else
    {
        anIndex=[dataFromPlistforfound indexOfObject:@"Data"];
    }
    NSMutableArray *dataFromPlistofname =[[NSMutableArray alloc]initWithArray:[dataforglobalplist valueForKey:@"name"]];
    
    [dataFromPlistofname exchangeObjectAtIndex:0 withObjectAtIndex:anIndex];
    
    [dataforglobalplist setObject:dataFromPlistofname forKey:@"name"];
    
    NSMutableArray *dataFromPlistoforder =[[NSMutableArray alloc]initWithArray:[dataforglobalplist valueForKey:@"order"]];
    [dataFromPlistoforder exchangeObjectAtIndex:0 withObjectAtIndex:anIndex];
    
    
    [dataforglobalplist setObject:dataFromPlistoforder forKey:@"order"];
    
    
    NSMutableArray *dataFromPlist2ofval =[[NSMutableArray alloc]initWithArray:[dataforglobalplist valueForKey:@"valueof"]];
    
    [dataFromPlist2ofval exchangeObjectAtIndex:0 withObjectAtIndex:anIndex];
    
    
    [dataforglobalplist setObject:dataFromPlist2ofval forKey:@"valueof"];
    [dataforglobalplist writeToFile: pathforglobalplist atomically:YES];
    
    NSInteger index = [dataFromPlist2ofval indexOfObject:@"0"];
    if (checkhowmuch==2)
    {
        if (index==1)
        {
            [self plistdatatoreplace:1 :2];
        }
    }
    
    
    
}
-(void)plistdatatoreplace :(int)tofirstnext :(int)tolastnext
{
    NSMutableArray *dataFromPlistofname =[[NSMutableArray alloc]initWithArray:[dataforglobalplist valueForKey:@"name"]];
    
    [dataFromPlistofname exchangeObjectAtIndex:tofirstnext withObjectAtIndex:tolastnext];
    
    [dataforglobalplist setObject:dataFromPlistofname forKey:@"name"];
    
    NSMutableArray *dataFromPlistoforder =[[NSMutableArray alloc]initWithArray:[dataforglobalplist valueForKey:@"order"]];
    [dataFromPlistoforder exchangeObjectAtIndex:tofirstnext withObjectAtIndex:tolastnext];
    
    
    [dataforglobalplist setObject:dataFromPlistoforder forKey:@"order"];
    
    
    NSMutableArray *dataFromPlist2ofval =[[NSMutableArray alloc]initWithArray:[dataforglobalplist valueForKey:@"valueof"]];
    
    [dataFromPlist2ofval exchangeObjectAtIndex:tofirstnext withObjectAtIndex:tolastnext];
    
    
    [dataforglobalplist setObject:dataFromPlist2ofval forKey:@"valueof"];
    [dataforglobalplist writeToFile: pathforglobalplist atomically:YES];
    
}
/*-------------9'th-----------*/
-(void)clicktook
{
    if (chkboxvalue==NO) {
        checkfor_useingnetwork=@"1";
        [self hidepopup];
    }
}
-(void)clicktocancel
{
    [self hidepopup];
}
-(void)clicktocheckbox
{
    if (chkboxvalue==YES)
    {
        
        
        UIImage *img = [UIImage imageNamed:@"checkbox.png"];
        [btnofcheckbox setBackgroundImage:img forState:UIControlStateNormal];
        chkboxvalue=NO;
    }
    else
    {
        UIImage *img = [UIImage imageNamed:@"unchk.png"];
        [btnofcheckbox setBackgroundImage:img forState:UIControlStateNormal];
        chkboxvalue=YES;
    }
}
-(void)plistfile
{
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //1
    NSString *documentsDirectory = [paths objectAtIndex:0]; //2
    pathfornetwork = [documentsDirectory stringByAppendingPathComponent:@"network_keypad.plist"]; //3
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath: pathfornetwork]) //4
    {
        NSString *bundle = [[NSBundle mainBundle] pathForResource:@"network_keypad" ofType:@"plist"]; //5
        
        [fileManager copyItemAtPath:bundle toPath: pathfornetwork error:&error]; //6
    }
    
    
    datafornetwork = [[NSMutableDictionary alloc] initWithContentsOfFile: pathfornetwork];
    [datafornetwork objectForKey:@"valueof"];
    [self setstageofbtncall:[datafornetwork objectForKey:@"valueof"]];
    
    if (datafornetwork.count>0) {
        if (!isClickToPopup)
            [self clicktopopup];
    }
}
-(void)setstageofbtncall:(NSArray *)checkvalueofarray
{
    //NSNumber *num=[NSNumber numberWithInteger:1];
    UIButton *callbtn = (UIButton *)[self.view viewWithTag:999];
    NSInteger anIndex=[checkvalueofarray indexOfObject:@"1"];
    if(NSNotFound == anIndex) {
        NSLog(@"not found");
    }
    else
    {
        NSLog(@"raju");
    }
    switch (anIndex) {
        case 0:
            [_callButton updateIcon:@"call_wifi"];
            [callbtn setImage:[UIImage imageNamed:@"call_wifi"] forState:UIControlStateNormal];
            break;
        case 1:
            [_callButton updateIcon:@"call_min"];
            [callbtn setImage:[UIImage imageNamed:@"call_min"] forState:UIControlStateNormal];
            break;
        case 2:
            [_callButton updateIcon:@"call_data"];
            [callbtn setImage:[UIImage imageNamed:@"call_data"] forState:UIControlStateNormal];
            break;
        default:
            break;
    }
    
}

/*----------------11----------*/
-(void)datadorglobalsetting
{
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //1
    NSString *documentsDirectory = [paths objectAtIndex:0]; //2
    pathforglobalplist = [documentsDirectory stringByAppendingPathComponent:@"network_update.plist"]; //3
    //NSLog(@"%@",path);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath: pathforglobalplist]) //4
    {
        NSString *bundle = [[NSBundle mainBundle] pathForResource:@"network_update" ofType:@"plist"]; //5
        
        [fileManager copyItemAtPath:bundle toPath: pathforglobalplist error:&error]; //6
    }
    
    
    dataforglobalplist = [[NSMutableDictionary alloc] initWithContentsOfFile: pathforglobalplist];
    
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSLog(@"Button Index =%ld",(long)buttonIndex);
    switch (alertView.tag) {
        case 100:
            if (buttonIndex == 0)
            {
                [self forwifitest];
                
            }
            else if(buttonIndex == 1)
            {
                [self hidepopup];
            }
            break;
            
        case 1000:
            if (buttonIndex == 0)
            {
                [self forminutest];
            }
            else if(buttonIndex == 1)
            {
                [self hidepopup];
            }
            break;
            
        case 2000:
            if (buttonIndex == 0)
            {
                [self fordatatest];
            }
            else if(buttonIndex == 1)
            {
                [self hidepopup];
            }
            break;
        default:
            break;
    }
    
}
-(void)Calltorazaout:(NSString*)phoneno{
    
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    
    NetworkStatus status = [reachability currentReachabilityStatus];
    
    if(status == NotReachable)
    {
        //No internet
        checkfor_availablenetwork=@"4";
    }
    else if (status == ReachableViaWiFi)
    {
        checkfor_availablenetwork=@"0";
    }
    else if (status == ReachableViaWWAN)
    {
        checkfor_availablenetwork=@"2";
    }
    
    //[self makeAudioCallWithRemoteParty:selectedCallNumber andSipStack:[mSipService getSipStack]];
    NSInteger Aindex1 = [[datafornetwork valueForKey:@"valueof"] indexOfObject:@"1"];
    NSLog(@"milanetwork%@",[NSString stringWithFormat:@"%ld",(long)Aindex1]);
    if ([[NSString stringWithFormat:@"%ld",(long)Aindex1] isEqual:@"1"])
    {
        [self callMadeViaCarrier:phoneno];
        //[self callMadeViaVOIP];
    }
    else if (checkfor_useingnetwork==nil)
    {
        NSLog(@"normal call");
        [self callMadeViaVOIP:phoneno];
        //[self makeCall];
    }
    else  if ([checkfor_availablenetwork isEqual: [NSString stringWithFormat:@"%ld",(long)Aindex1]])
    {
        NSLog(@"normal call");
        [self callMadeViaVOIP:phoneno];
        //[self makeCall];
    }
    else
    {
        NSString *straval;
        NSString *strause;
        switch ([checkfor_availablenetwork intValue]) {
            case 0:
                straval=@"Wifi";
                break;
            case 2:
                straval=@"Data plan";
                break;
                
            default:
                straval=@"No Network";
                break;
        }
        switch ([checkfor_availablenetwork intValue]) {
            case 1:
                strause=@"Wifi";
                break;
            case 3:
                strause=@"Data plan";
                break;
                
            default:
                break;
        }
        UIAlertView *message;
        if ([strause isEqualToString:@"Wifi"]){
            message = [[UIAlertView alloc] initWithTitle:@"Warning!"
                                                 message:@"Wi-Fi not available. Please turn it on from your phone’s settings"
                                                delegate:self
                                       cancelButtonTitle:nil
                                       otherButtonTitles:@"ok",nil];
        }
        else{
            message = [[UIAlertView alloc] initWithTitle:@"Warning!"
                                                 message:@"Please turn off Wi-Fi to be able to make a call using your data plan"
                                                delegate:self
                                       cancelButtonTitle:nil
                                       otherButtonTitles:@"ok",nil];
        }
        
        [message show];
        
    }
    
    
}
-(void)callMadeViaCarrier:(NSString*)dialedphone {
    
    //[self addCallToDatabaseWithPhoneNumber:_numberString withCallType:OUTGOING_CALL withMediaType:VIA_VOIP];
    // [actionsheet removeFromSuperview];
    // actionsheet = nil;
    [[Razauser SharedInstance]ShowWaiting:nil];
    NSString *localSetAccessNumber = [RAZA_USERDEFAULTS objectForKey:@"accessnumber"];
    
    if (!localSetAccessNumber || IS_EMPTY(localSetAccessNumber)) {
        
        [RAZA_APPDELEGATE showAlertWithMessage:ERROR_NO_ACCESS_NUMBER_TO_DIAL withTitle:@"" withCancelTitle:@"Ok"];
    }
    else {
        [self sendDestination:dialedphone withAccessNumber:localSetAccessNumber];
    }
}
-(void)sendDestination:(NSString*)number withAccessNumber:(NSString *)accessnumber
{
    
    //[self makeAudioCallWithRemoteParty:number andSipStack:[mSipService getSipStack]];
    
    //[CallViewController makeAudioCallWithRemoteParty:accessnumber andSipStack:[mSipService getSipStack]];
    
    number = [number stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSString *userpin = [[RAZA_USERDEFAULTS objectForKey:@"logininfo"] objectForKey:LOGIN_RESPONSE_PIN];
    
    BOOL network = [RAZA_APPDELEGATE checkNetworkPriorRequest];
    
    if (network) {
        
        if (userpin && [userpin length]) {
            [[Razauser SharedInstance]addCallToDatabase:@"outgoing" andsender:number];
            [[RazaServiceManager sharedInstance] requestToSetDestinationWithPin:userpin withAccessNo:accessnumber withPhoneNo:number withDelegate:self];
            
            
        } else {
            [[Razauser SharedInstance]HideWaiting];
            [RAZA_APPDELEGATE showAlertWithMessage:ERROR_NO_USER_PIN withTitle:@"" withCancelTitle:@"Ok"];
        }
        
    }
    else {
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
            [RAZA_APPDELEGATE showAlertWithMessage:ERROR_NO_ACCESS_NUMBER_TO_DIAL withTitle:nil withCancelTitle:@"Ok"];
        }
        else {
            
            [self buildContactDetails:accessnumber];
            if ([[Razauser SharedInstance]chkforsimGlobal]) {
                if (!(_addressField.text.length>10)) {
                    [Razauser SharedInstance].modeofview=@"lenght";
                    NSString *test =[@"tel:" stringByAppendingString:accessnumber];
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:test]];
                }
                else
                    [self showTempratureoutgoingcall:_addressField.text andaccessnumber:accessnumber];
                
                
            }
            else
                [RAZA_APPDELEGATE showAlertWithMessage:REQUEST_WITHOUT_SIM withTitle:nil
                                       withCancelTitle:@"Ok"];
            
            
        }
    }
    else {
        
        //        RazaSqlQuery *sqlQuery = [[RazaSqlQuery alloc]init];
        //
        //        NSDictionary *callInfo = [self getCurrentDateTimeWithPhoneInfo];
        //
        //        [sqlQuery deleteRecentCallRecordWithDate:[callInfo objectForKey:@"date"] withPhoneNo:[callInfo objectForKey:@"phoneno"] withDelegate:nil];
        
        [RAZA_APPDELEGATE showAlertWithMessage:[info objectForKey:@"error"] withTitle:@"access number!" withCancelTitle:@"Ok"];
    }
    
}
- (ABRecordRef)buildContactDetails:(NSString *)number
{
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    ABRecordRef aRecord = ABPersonCreate();
    CFErrorRef  anError = NULL;
    ABAddressBookRef addressBook;
    CFErrorRef error = NULL;
    ABAddressBookRef m_addressbook = ABAddressBookCreateWithOptions(NULL, &error);
    if (!m_addressbook) {
        NSLog(@"opening address book");
    }
    
    // can be cast to NSArray, toll-free
    
    //    ABRecordRef source = ABAddressBookCopyDefaultSource(m_addressbook); // or get the source with ABPersonCopySource(somePersonsABRecordRef);
    
    //  CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeopleInSourceWithSortOrdering(m_addressbook, source, kABPersonSortByFirstName);
    
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(m_addressbook);
    
    //CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(m_addressbook);
    CFIndex nPeople = ABAddressBookGetPersonCount(m_addressbook);
    
    // CFStrings can be cast to NSString!
    NSString *firstName2;
    CFStringRef firstName1, lastName1;
    BOOL found=FALSE;
    ABRecordRef ref ;
    for (int i=0;i < nPeople;i++) {
        ref = CFArrayGetValueAtIndex(allPeople,i);
        firstName2 = (__bridge NSString *)(ABRecordCopyValue(ref, kABPersonFirstNameProperty));
        
        NSString *searchString = @"Raza Mobile";
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[cd] %@",searchString];
        
        if ([predicate evaluateWithObject:firstName2] == YES) {
            found = TRUE;
            break;
        }
        
        //		NSRange range = [firstName2 rangeOfString : searchString];
        //
        //
        //		if (range.location != NSNotFound)
        //		{
        //			found=TRUE;
        //			NSLog(@"I found something.");
        //            break;
        //		}
        
    }
    if(found)
    {
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSString *callingNo=[NSString stringWithFormat:@"+1 %@",number];
        if(![callingNo isEqualToString:[prefs objectForKey:@"contactCallNumber"]])
            [self updatePhone:ref phone:callingNo addressbook:m_addressbook];
        
        [prefs setObject:callingNo forKey:@"contactCallNumber"];
        
    }
    else
    {
        if (!contactFlag) {
            if(![[number stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""])
            {
                NSString *contactName = [NSString stringWithFormat:@"Raza Mobile"];
                ABRecordSetValue(aRecord, kABPersonFirstNameProperty,
                                 (__bridge CFTypeRef)(contactName), &anError);
            }
        }
        else
        {
            NSString *contactName = [NSString stringWithFormat:@"Raza Mobile"];
            
            ABRecordSetValue(aRecord, kABPersonFirstNameProperty,
                             (__bridge CFTypeRef)(contactName), &anError);
        }
        
        ABRecordSetValue(aRecord, kABPersonLastNameProperty,
                         CFSTR(""), &anError);
        NSString *callingNo=[NSString stringWithFormat:@"+1 %@",number];
        [prefs setObject:callingNo forKey:@"contactCallNumber"];
        ABMultiValueRef phone = ABMultiValueCreateMutable(kABStringPropertyType);
        ABMultiValueAddValueAndLabel(phone, (__bridge CFTypeRef)(callingNo), kABPersonPhoneMobileLabel, NULL);
        ABRecordSetValue(aRecord, kABPersonPhoneProperty, phone, NULL);
        CFRelease(phone);
        if (anError != NULL) {
            
            NSLog(@"error while creating..");
        }
        
        firstName1 = (CFStringRef) ABRecordCopyValue(aRecord, kABPersonFirstNameProperty);
        lastName1  = (CFStringRef) ABRecordCopyValue(aRecord, kABPersonLastNameProperty);
        
        //  addressBook = ABAddressBookCreate();
        
        
        addressBook = ABAddressBookCreateWithOptions(NULL, &error);
        
        BOOL isAdded = ABAddressBookAddRecord (
                                               addressBook,
                                               aRecord,
                                               &error
                                               );
        
        if(isAdded){
            
            NSLog(@"added..");
        }
        if (error != NULL) {
            NSLog(@"ABAddressBookAddRecord %@", error);
        }
        error = NULL;
        BOOL isSaved = ABAddressBookSave (
                                          addressBook,
                                          &error
                                          );
        
        if(isSaved){
            
            NSLog(@"saved..");
        }
        
        if (error != NULL) {
            NSLog(@"ABAddressBookSave %@", error);
        }
    }
    
    return aRecord;
}
-(void)updatePhone:(ABRecordRef)person phone:(NSString*)phone addressbook:(ABAddressBookRef)addressBook{
    CFStringRef selectedPhoneType= (CFStringRef)@"other";
    ABMutableMultiValueRef phoneNumberMultiValue =  ABMultiValueCreateMutableCopy (ABRecordCopyValue(person, kABPersonPhoneProperty));
    ABMultiValueAddValueAndLabel(phoneNumberMultiValue, (__bridge CFTypeRef)(phone),  selectedPhoneType, NULL);
    ABRecordSetValue(person, kABPersonPhoneProperty, phoneNumberMultiValue, nil);
    ABAddressBookSave (
                       addressBook,
                       NULL
                       );
}
- (void)makeacallparam:(NSNotification *)notif
{
    [self Calltorazaout:notif.object];
    //    NSString *calledphone=notif.object;
    //    LinphoneAddress *addr = [LinphoneUtils normalizeSipOrPhoneAddress:calledphone];
    //    [LinphoneManager.instance call:addr];
    //    if (addr)
    //        linphone_address_destroy(addr);
}
-(void)callMadeViaVOIP:(NSString*)callphonenumber
{
    
    RazaTempratureObject *baseobj=[[RazaTempratureObject alloc]init];
    [baseobj checkvalforTemp:callphonenumber callback:^(NSDictionary *result) {
        
        [Razauser SharedInstance].tempdict=result;
        NSLog(@"%@", [Razauser SharedInstance].tempdict);
        
        NSString *calledphone=callphonenumber;
        LinphoneAddress *addr = [LinphoneUtils normalizeSipOrPhoneAddress:calledphone];
        [LinphoneManager.instance call:addr andmodeVideoAudio:FALSE];
        if (addr)
            linphone_address_destroy(addr);
        
    }];
    
    
}
-(void)updatechatreadunreadcounter:(int)total
{
    // int stringbadge= [[Razauser SharedInstance]getmissed];
    //[self updatechatrecent:stringbadge];
    //int aa=[[[Razauser SharedInstance]getPushrazaCounter]allKeys];
    int t = 0;//=(int)[[[Razauser SharedInstance]getPushrazaCounter] allKeys].count;
    NSDictionary *pushdict=[[Razauser SharedInstance]getPushrazaCounter];
    for (NSString* key in pushdict)
    {
        int value = [[pushdict objectForKey:key] intValue];
        t=t+value;
    }
    total=total+t;
    if (total)
    {
        
        _lblcounterchat.layer.cornerRadius = _lblcounterchat.frame.size.width / 2;
        _lblcounterchat.clipsToBounds = YES;
        _lblcounterchat.hidden=NO;
        
        _lblcounterchat.text=[NSString stringWithFormat:@"%d",total];
        //  _unreadCountView.hidden=NO;
        _unreadCountView.backgroundColor=[UIColor clearColor];
        [_unreadCountView startAnimating:YES];
    }
    else
    {
        _lblcounterchat.layer.cornerRadius = _lblcounterchat.frame.size.width / 2;
        _lblcounterchat.clipsToBounds = YES;
        _lblcounterchat.hidden=YES;
        // _unreadCountView.hidden=YES;
        _unreadCountView.backgroundColor=[UIColor clearColor];
        [_unreadCountView stopAnimating:YES];
    }
    
}
-(void)updatechatrecent:(int)total
{
    //    //int aa=[[[Razauser SharedInstance]getPushrazaCounter]allKeys];
    //    int t = 0;//=(int)[[[Razauser SharedInstance]getPushrazaCounter] allKeys].count;
    //    NSDictionary *pushdict=[[Razauser SharedInstance]getPushrazaCounter];
    //    for (NSString* key in pushdict)
    //    {
    //        int value = [[pushdict objectForKey:key] intValue];
    //        t=t+value;
    //    }
    //    total=total+t;
    if (total)
    {
        
        _lblrecentcounter.layer.cornerRadius = _lblrecentcounter.frame.size.width / 2;
        _lblrecentcounter.clipsToBounds = YES;
        _lblrecentcounter.hidden=NO;
        
        _lblrecentcounter.text=[NSString stringWithFormat:@"%d",total];
        //  _unreadCountView.hidden=NO;
        _unreadCountrecentView.backgroundColor=[UIColor clearColor];
        [_unreadCountrecentView startAnimating:YES];
    }
    else
    {
        _lblrecentcounter.layer.cornerRadius = _lblrecentcounter.frame.size.width / 2;
        _lblrecentcounter.clipsToBounds = YES;
        _lblrecentcounter.hidden=YES;
        // _unreadCountView.hidden=YES;
        _unreadCountrecentView.backgroundColor=[UIColor clearColor];
        [_unreadCountrecentView stopAnimating:YES];
    }
    
}

- (void)initialSetUp {
    
    if ([RAZA_APPDELEGATE checkNetworkPriorRequest]) {
        
        NSDictionary *loginInfo = [RAZA_USERDEFAULTS objectForKey:@"logininfo"];
        [[RazaServiceManager sharedInstance] requestToGetPinBalance:[loginInfo objectForKey:LOGIN_RESPONSE_PIN]];
        // [RazaServiceManager sharedInstance].delegate = self;
        [RazaDataModel sharedInstance].delegate=self;
    }
    
}
-(void)updateView{
    if ([[RazaAccountModel sharedInstance].balance length]) {
        //_lblbalance.text=[NSString stringWithFormat:@"Balance $%@",[RazaAccountModel sharedInstance].balance];
        _lblbalance.attributedText=[self getAttributedText:@"Balance " secondStr:[NSString stringWithFormat:@"$%@",[RazaAccountModel sharedInstance].balance]];
    }
}
-(NSMutableAttributedString*)getAttributedText:(NSString*)first  secondStr:(NSString*)secondStr{
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@",first,secondStr]];
    [attrStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"SourceSansPro-Regular" size:18] range:NSMakeRange(0, [first length])];
    [attrStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"SourceSansPro-Bold" size:18] range:NSMakeRange([first length]+1, [secondStr length])];
    return attrStr;
}

-(void)setsidebarapi
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSURL *URL = [NSURL URLWithString:@"http://razaimages.razatelecom.com/profile/api/index.php"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    // request.HTTPBody = [xml dataUsingEncoding:NSUTF8StringEncoding];
    //request.HTTPMethod = @"POST";
    //[request setValue:@"text/xml" forHTTPHeaderField:@"Content-Type"];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (error) {
            NSLog(@"Error: %@", error);
            
        } else {
            NSLog(@"%@ %@", response, responseObject);
            NSString *json_string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            // NSString *newStr = [json_string substringWithRange:NSMakeRange(2, [json_string length]-2)];
            NSData* data = [json_string dataUsingEncoding:NSUTF8StringEncoding];
            
            
            
            NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            if (jsonDict) {
                int vv=[[jsonDict valueForKey:@"status"] intValue];//0;//
                if (vv==1)
                    [[Razauser SharedInstance] setsidebar:@"show"];
                else
                    [[Razauser SharedInstance] setsidebar:nil];
                
                // NSLog(@"%@",jsonDict);
            }
            
        }
        
    }];
    [dataTask resume];
    
}
-(void)showTempratureoutgoingcall:(NSString*)callingphone andaccessnumber:(NSString*)callingaccessnumber
{
    RazaTempratureObject *baseobj=[[RazaTempratureObject alloc]init];
    [baseobj checkvalforTemp:callingphone callback:^(NSDictionary *result) {
        
        [Razauser SharedInstance].tempdict=result;
        NSLog(@"%@", [Razauser SharedInstance].tempdict);
        
        
        CallOutgoingView *view = VIEW(CallOutgoingView);
        
        view.delegateforminuts=self;
        view.phoneNumber=callingphone;//@"+919716432545";//
        view.Accessnumber=callingaccessnumber;
        [PhoneMainView.instance changeCurrentView:view.compositeViewDescription];
        
    }];
    
}
-(void)MinutscallwithDelegateMethod:(NSString *)data
{
    if (data.length) {
        [Razauser SharedInstance].modeofview=@"lenght";
        NSString *test =[@"tel:" stringByAppendingString:data];//[@"tel:" stringByAppendingString:[NSString stringWithFormat:@"001%@",accessnumber]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:test]];
    }
}
- (IBAction)searchBackBtnAction:(id)sender {
    self.searchBtn.hidden=NO;
    [self.searchCountry resignFirstResponder];
    [_lblcountry reloadData];
    self.lblcountry.frame=CGRectMake(0, 44, SCREENWIDTH, SCREENHIGHT-64);
    
    CGRect searchViewFrame = self.searchView.frame;
    searchViewFrame.origin.x = 0;
    self.searchView.frame = searchViewFrame;
    
    [UIView animateWithDuration:0.3 delay:0.0 options: UIViewAnimationOptionCurveEaseOut animations:^{
        CGRect searchViewFrame = self.searchView.frame;
        searchViewFrame.origin.x = SCREENWIDTH;
        self.searchView.frame = searchViewFrame;
    } completion:^(BOOL finished){
        self.searchView.hidden=YES;
    }];
    
}
- (IBAction)searchBtnAction:(id)sender {
    self.lblcountry.frame=CGRectMake(0, 88, SCREENWIDTH, SCREENHIGHT-108);
    [self.searchCountry becomeFirstResponder];
    self.searchBtn.hidden=YES;
    
}
@end
