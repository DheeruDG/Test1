//
//  RazaLoginViewController.m
//  linphone
//
//  Created by umenit on 11/26/16.
//
//

#import "RazaLoginViewController.h"
//#import "RazaHomeViewController.h"
//#import "ConnectionUtil.h"
//#import "RazaSignUpViewController.h"
#import "RazaLoginModel.h"
#import "PhoneMainView.h"
@interface RazaLoginViewController ()

@end
static NSString *alertTitle = @"Login";
@implementation RazaLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CAGradientLayer *gradient = [BackgroundLayer linearGradient];
    gradient.frame = self.loginButton.bounds;
    gradient.startPoint = CGPointMake(0.0,0.0);
    gradient.endPoint = CGPointMake(1.0,0.0);
    [self.loginButton.layer insertSublayer:gradient atIndex:0];
    
    CAGradientLayer *gradient1 = [BackgroundLayer linearGradient];
    gradient1.frame = self.verifyBtn.bounds;
    gradient1.startPoint = CGPointMake(0.0,0.0);
    gradient1.endPoint = CGPointMake(1.0,0.0);
    [self.verifyBtn.layer insertSublayer:gradient1 atIndex:0];
    
    CAGradientLayer *gradient2 = [BackgroundLayer linearGradient];
    gradient2.frame = self.resetPassBtn.bounds;
    gradient2.startPoint = CGPointMake(0.0,0.0);
    gradient2.endPoint = CGPointMake(1.0,0.0);
    [self.resetPassBtn.layer insertSublayer:gradient2 atIndex:0];
    
    // self.emailTF.
    // @property (weak, nonatomic) IBOutlet UITextField *passwordTF;
    // @property (weak, nonatomic) IBOutlet UITextField *phoneTF;
    
    [self checkDeviceIdExistence];
    
    [self createInputAccessoryView];
    
    //    if (IS_EMPTY([RAZA_USERDEFAULTS objectForKey:@"localphoneno"]) ||
    //        ![RAZA_USERDEFAULTS objectForKey:@"localphoneno"]) {
    //        [self openDialogEntry:@"localphoneentry"];
    //    }
    
    internetReach = [Reachability reachabilityForInternetConnection];
    NetworkStatus internetStatus = [internetReach currentReachabilityStatus];
    
    if((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN) ){
        
        [RAZA_APPDELEGATE showMessage:REQUEST_WITHOUT_NETWORK withMode:MBProgressHUDModeText withDelay:2.0 withShortMessage:YES];
    }
    else {
        if (!self.isSignOut) {
            //[RAZA_APPDELEGATE setUpApplicationWithPreData];
        }
    }
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(callaftersignup) name:@"callaftersignup" object:nil];
    
    
    //    CGRect frameForForgorPwd = CGRectMake(APP_FRAME.size.width / 2 - 60, self.loginButton.frame.size.height + self.loginButton.frame.origin.y + 10 , 120, 30);
    //
    //    // if screen size less than 568
    //    if (! IS_IPHONE_5) {
    //        frameForForgorPwd = CGRectMake(APP_FRAME.size.width / 2 - 60, self.loginButton.frame.size.height + self.loginButton.frame.origin.y , 120, 30);
    //    }
    
    // _razaLinkButton = [[UIButton alloc] initWithFrame:frameForForgorPwd];
    //  _razaLinkButton.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:12.5];
    // [_razaLinkButton setTitle:@"Forgot Password?" forState:UIControlStateNormal];
    //_razaLinkButton.backgroundColor = [UIColor clearColor];
    
    //[self.view addSubview:_razaLinkButton];
    
    UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(forgotPassword:)];
    // if labelView is not set userInteractionEnabled, you must do so
    [_razaLinkButton setUserInteractionEnabled:YES];
    [_razaLinkButton addGestureRecognizer:gesture];
    
    /*
     NgnBaseService<INgnSipService>* mSipService;
     NgnBaseService<INgnConfigurationService>* mConfigurationService;
     
     NgnEngine *ngnEngine = [NgnEngine sharedInstance];
     mSipService = [ngnEngine getSipService];
     mConfigurationService = [ngnEngine getConfigurationService];
     
     [self updateStatus:mSipService];
     
     [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(onRegistrationEvent:) name:kNgnRegistrationEventArgs_Name object:nil];
     
     NSString* publicId = [[NgnEngine getInstance].configurationService getStringWithKey:IDENTITY_IMPU];
     */
    
}
-(void)callaftersignup
{
    
    // NSString *email = [[NSUserDefaults standardUserDefaults] stringForKey:@"callaftersignupemail"];
    NSString *phone = [[NSUserDefaults standardUserDefaults]
                       stringForKey:@"callaftersignupphone"];
    NSString *pass = [[NSUserDefaults standardUserDefaults]
                      stringForKey:@"callaftersignuppassword"];
    self.phoneTF.text=phone;
    NSString *valueToSave = phone;
    [[NSUserDefaults standardUserDefaults] setObject:valueToSave forKey:@"sipphone"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    //    [[RazaServiceManager sharedInstance]requestLoginVerify:email withPassword:pass withPhone:phone withDeviceId:RAZA_APPDELEGATE.deviceID withDeviceType:@"" withDevice_PhoneNumber:phone withDeviceIP_Address:RAZA_APPDELEGATE.getIPAddress withDeviceIMEI_Number:@"" withClientDateTime:RAZA_APPDELEGATE.getTime withDeviceLongitude_Latitude:RAZA_APPDELEGATE.latitudelongitude];
    //    [RazaDataModel sharedInstance].delegate = self;
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    //requestLoginConfirmWithUserNameLogin_V2
    [[RazaServiceManager sharedInstance]LoginWithPassCode:pass  withPhone:phone  withDeviceId:RAZA_APPDELEGATE.deviceID withDeviceType:@"ios" withDevice_PhoneNumber:self.phoneTF.text withDeviceIP_Address:RAZA_APPDELEGATE.getIPAddress  withDeviceIMEI_Number:RAZA_APPDELEGATE.deviceID withClientDateTime:RAZA_APPDELEGATE.getTime withDeviceLongitude_Latitude:RAZA_APPDELEGATE.latitudelongitude];
    [RazaDataModel sharedInstance].delegate = self;
    self.phoneTF.text=phone;
}
-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    //[prefs removeObjectForKey:@"userPin"];
    //[prefs removeObjectForKey:@"memberID"];
    
    [prefs removeObjectForKey:@"LOGIN"];
    
    [prefs removeObjectForKey:LOGIN_RESPONSE_USERTYPE];
    //[prefs removeObjectForKey:@"memberID"];
    
    [prefs removeObjectForKey:CREDIT_CARD_NUMBER];
    [prefs removeObjectForKey:STREET_1];
    
    [prefs removeObjectForKey:STREET_2];
    [prefs removeObjectForKey:CITY];
    
    [prefs removeObjectForKey:STATE];
    [prefs removeObjectForKey:ZIPCOD];
    
    [prefs removeObjectForKey:COUPON_AMOUNT];
    [prefs removeObjectForKey:CC_EXPIRATION];
    
    [prefs removeObjectForKey:CC_SECURITY];
    [prefs removeObjectForKey:COUNTRY_CODE];
    
    [prefs removeObjectForKey:COUNTRY_FROM_ID];
    [prefs removeObjectForKey:COUNTRY_TO_ID];
    
    [prefs removeObjectForKey:CARD_ID];
    [prefs removeObjectForKey:ORDER_ID];
    
    //[prefs removeObjectForKey:@"countrylist"];
    [prefs removeObjectForKey:RECHARGE_FROM_POINT];
    
    [prefs removeObjectForKey:REWARD_POINT];
    [prefs removeObjectForKey:COUNTRY_ID];
    
    [prefs removeObjectForKey:SESSION_ID];
    [prefs removeObjectForKey:AMOUNT_LIST];
    
    [prefs removeObjectForKey:FROM_POINT];
    [prefs removeObjectForKey:MAKE_CALL_RESPONSE];
    
    [self registerForKeyboardNotifications];
    
    _viewVerify.hidden=YES;
}


//-(void)updateStatus:(NgnBaseService<INgnSipService> *)mSipService{
//
//	if([mSipService isRegistered]){
//		NSLog(@"Connected");
//	}
//	else {
//		NSLog(@"Not Connected");
//	}
//}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark UIButton methods

- (IBAction)registerClicked:(id)sender {
    
    //    RazaSignUpViewController *signUpController = [[RazaSignUpViewController alloc]
    //                                                  initWithNibName:@"RazaSignUpViewController" bundle:nil];
    //
    // [self.navigationController pushViewController:signUpController animated:YES];
    //[self.navigationController presentViewController:signUpController animated:YES completion:nil];
    
    //  [self presentViewController:signUpController animated:YES completion:nil];
    RazaSignUpViewController *view = VIEW(RazaSignUpViewController);
    
    [PhoneMainView.instance changeCurrentView:view.compositeViewDescription];
}



#pragma mark -
#pragma mark custom methods

-(void)checkDeviceIdExistence
{
    NSString *request = [NSString stringWithFormat:
                         @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                         "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                         "<soap:Header>\n"
                         "<Raza_AuthHeader xmlns=\"http://tempuri.org/\">\n"
                         "<AuthUsername>mobileapp</AuthUsername>\n"
                         "<AuthPassword>app123</AuthPassword>\n"
                         "</Raza_AuthHeader>\n"
                         "</soap:Header>\n"
                         "<soap:Body>\n"
                         "<Does_DeviceID_Exist xmlns=\"http://tempuri.org/\">\n"
                         "<Device_ID>%@</Device_ID>\n"
                         "</Does_DeviceID_Exist>\n"
                         "</soap:Body>\n"
                         "</soap:Envelope>\n",RAZA_APPDELEGATE.deviceID];
    
    
    ConnectionUtil* cnutil=[[ConnectionUtil alloc]init];
    [cnutil initConnection:request withProtocol:self withResultType:@"Does_DeviceID_ExistResult" withMethod:@"http://tempuri.org/Does_DeviceID_Exist"];
    [super viewDidLoad];
}
- (void)getCallBackResponseNewsip:(NSDictionary *)resultString withResultType:(NSString *)resultType
{
    
}
-(void)getCallBackResponse:(NSString *)resultString withResultType:(NSString *)resultType {
    
    //    if (![resultString isEqualToString:RESP_ERROR]) {
    //
    //        //[self toWhichView:resultString];
    //
    //        if([[resultType stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@"Get_Rates_By_CountryResult"])
    //        {
    //            NSArray *listItems = [resultString componentsSeparatedByString:@"~"];
    //            NSString *chkStatus=[listItems objectAtIndex:0];
    //            NSArray *listItems2 = [chkStatus componentsSeparatedByString:@"="];
    //
    //            if( [[[listItems2 objectAtIndex:1]stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@"1"])
    //            {
    //                NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    //                [prefs setObject:[listItems objectAtIndex:1]  forKey:@"destinationList"];
    //            }
    //        }
    //        else if( [[resultType stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@"Get_Country_ListResponse"])
    //        {
    //            NSArray *listItems = [resultString componentsSeparatedByString:@"~"];
    //            NSString * chkStatus=[listItems objectAtIndex:0];
    //            NSArray *listItems2 = [chkStatus componentsSeparatedByString:@"="];
    //
    //            if( [[[listItems2 objectAtIndex:1]stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@"1"])
    //            {
    //                NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    //                [prefs setObject:[listItems objectAtIndex:1]  forKey:@"countrylist"];
    //                //[self moveToAddressBook];
    //            }
    //        }
    //    }
}

#pragma mark -
#pragma mark Forgot Password methods

-(IBAction)forgotPassword:(id)sender {
    if (self.phoneTF.text.length>0) {
        _passwordTF.text=@"";
        _passwordTF.placeholder=@"PASSCODE / PASSWORD";
        [RazaServiceManager sharedInstance].delegate = self;
        
        [[Razauser SharedInstance]ShowWaitingshort:nil andtime:5];
        [[RazaServiceManager sharedInstance]SendPassCode:self.phoneTF.text  withDeviceId:RAZA_APPDELEGATE.deviceID withDeviceType:@"ios" withDevice_PhoneNumber:self.phoneTF.text withDeviceIP_Address:RAZA_APPDELEGATE.getIPAddress  withDeviceIMEI_Number:RAZA_APPDELEGATE.deviceID withClientDateTime:RAZA_APPDELEGATE.getTime withDeviceLongitude_Latitude:RAZA_APPDELEGATE.latitudelongitude];
    }else{
        [RAZA_APPDELEGATE showMessage:ERROR_PHONE_REQUIRED withMode:MBProgressHUDModeText withDelay:1 withShortMessage:NO];
    }
    /*
     self.forgotPassView.hidden=NO;
     
     CGRect napkinBottomFrame = self.forgotPassView.frame;
     napkinBottomFrame.origin.x = SCREENWIDTH;
     self.forgotPassView.frame = napkinBottomFrame;
     
     [UIView animateWithDuration:0.3 delay:0.0 options: UIViewAnimationOptionCurveEaseOut animations:^{
     CGRect napkinBottomFrame = self.forgotPassView.frame;
     napkinBottomFrame.origin.x = 0;
     self.forgotPassView.frame = napkinBottomFrame;
     } completion:^(BOOL finished){ }];
     */
    
    // [self openDialogEntry:@"forgotpassword"];
}

-(void)openDialogEntry:(NSString *)type
{
    NSString *otherButtonTitle = @"Continue";
    NSString *alertTitle = @"Enter your email address";
    NSString *cancelButtonTitle = @"Cancel";
    NSString *placeHolder = @"email address";
    
    if ([type isEqualToString:@"localphoneentry"]) {
        otherButtonTitle = @"Sumbit";
        alertTitle = @"Enter your phone number";
        cancelButtonTitle = nil;
        placeHolder = @"phone number";
    }
    
    _passwordAlert = [[UIAlertView alloc] initWithTitle:alertTitle message:@"" delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitle, nil];
    _passwordAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
    _passwordAlert.tag = 1000;
    _alertTextField = [_passwordAlert textFieldAtIndex:0];
    _alertTextField.keyboardType = UIKeyboardTypeEmailAddress;
    _alertTextField.placeholder = placeHolder;
    
    _alertTextField.delegate = self;
    _alertTextField.tag = 1;
    
    [_passwordAlert show];
    
}

#pragma mark -
#pragma mark UIAlertView delegate methods

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    BOOL network = [RAZA_APPDELEGATE checkNetworkPriorRequest];
    
    if (network) {
        
        if (buttonIndex == 1) {
            
            BOOL isValidEmail = [RAZA_APPDELEGATE isValidEmail:_alertTextField.text];
            
            if (isValidEmail) {
                [[RazaServiceManager sharedInstance] requestToGetPassword:_alertTextField.text withDelegate:self];
                [RazaServiceManager sharedInstance].delegate = self;
            }
            else {
                [RAZA_APPDELEGATE showAlertWithMessage:ERROR_INVALID_EMAIL withTitle:alertTitle withCancelTitle:@"Ok"];
            }
        }
        //for submit button
        if (buttonIndex == 0) {
            [RAZA_USERDEFAULTS setObject:_alertTextField.text forKey:@"localphoneno"];
        }
    }
    else {
        [RAZA_APPDELEGATE showAlertWithMessage:@"" withTitle:NETWORK_UNAVAILABLE withCancelTitle:@"Dismiss"];
    }
}

#pragma mark -
#pragma mark UITextFieldDelegate methods

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    
    activeField = textField;
    
    _keyboardToolbar = nil;
    _inputAccView = nil;
    
    if (activeField.tag == PHONE_TEXTFIELD || activeField.tag == VERIFY_TEXTFIELD) {
        [self accessoryViewForDoneBarButton];
    }
    else {
        [self createInputAccessoryView];
    }
    
    [textField setInputAccessoryView:_inputAccView];
    [textField setEnablesReturnKeyAutomatically:YES];
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    activeField = nil;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [activeField resignFirstResponder];
}

-(void)createInputAccessoryView
{
    
    _inputAccView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0,self.view.frame.size.width, 44.0)];
    [_inputAccView setBackgroundColor:[UIColor clearColor]];
    [_inputAccView setAlpha: 1.0];
    
    _previous = [[UIBarButtonItem alloc] initWithTitle:@"Previous" style:UIBarButtonItemStyleBordered target:self action:@selector(previosButton:)];
    
    //  [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:(51.0f/255.0f) green:(153.0f/255.0f) blue:(255.0f/255.0f) alpha:1]];
    //[_previous setTintColor:[UIColor redColor]];
    //[[UIBarButtonItem appearance] setBackgroundImage:[[UIImage alloc] init] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    [_previous setBackgroundImage:[[UIImage alloc] init] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    [_previous setTintColor:Kcolorforkeyboardtoolabr];
    
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    _next = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStyleBordered target:self action:@selector(nextButton:)];
    [_next setBackgroundImage:[[UIImage alloc] init] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    [_next setTintColor:Kcolorforkeyboardtoolabr];
    
    [_keyboardToolbar removeFromSuperview];
    
    if (!_keyboardToolbar) {
        _keyboardToolbar = [[UIToolbar alloc] init];
    }
    
    _keyboardToolbar.frame = CGRectMake(0.0, 0.0, self.view.frame.size.width, 44.0);
    
    _keyboardToolbar.items = [NSArray arrayWithObjects:_previous,spacer, _next, nil];
    // [TODO:ios update]
    
    
    
    // [_keyboardToolbar setBarTintColor:kColorKeyboard];
    [_keyboardToolbar setBarStyle:UIBarStyleDefault];
    //  [_keyboardToolbar setBackgroundColor:[UIColor clearColor]];
    CAGradientLayer *gradient = [BackgroundLayer navHeaderGradient];
    gradient.frame = _keyboardToolbar.bounds;
    gradient.startPoint = CGPointMake(0.0, 0.0);
    gradient.endPoint = CGPointMake(0.0, 1.0);
    gradient.locations = @[@0.0,@1.0];
    [_keyboardToolbar.layer insertSublayer:gradient atIndex:0];
    
    [_inputAccView addSubview:_keyboardToolbar];
}

-(void)accessoryViewForDoneBarButton
{
    
    _inputAccView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0,self.view.frame.size.width, 44.0)];
    [_inputAccView setBackgroundColor:[UIColor clearColor]];
    [_inputAccView setAlpha: 1.0];
    
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    _done = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(doneButton:)];
    [_done setBackgroundImage:[[UIImage alloc] init] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    [_done setTintColor:Kcolorforkeyboardtoolabr];
    
    
    [_keyboardToolbar removeFromSuperview];
    
    if (!_keyboardToolbar) {
        _keyboardToolbar = [[UIToolbar alloc] init];
    }
    
    _keyboardToolbar.frame = CGRectMake(0.0, 0.0, self.view.frame.size.width, 44.0);
    
    _keyboardToolbar.items = [NSArray arrayWithObjects:spacer, _done, nil];
    // [TODO:ios update]
    
    
    
    // [_keyboardToolbar setBarTintColor:kColorKeyboard];
    [_keyboardToolbar setBarStyle:UIBarStyleDefault];
    // [_keyboardToolbar setBackgroundColor:[UIColor clearColor]];
    CAGradientLayer *gradient = [BackgroundLayer navHeaderGradient];
    gradient.frame = _keyboardToolbar.bounds;
    gradient.startPoint = CGPointMake(0.0, 0.0);
    gradient.endPoint = CGPointMake(0.0, 1.0);
    gradient.locations = @[@0.0,@1.0];
    [_keyboardToolbar.layer insertSublayer:gradient atIndex:0];
    [_inputAccView addSubview:_keyboardToolbar];
}

-(IBAction)doneButton:(id)sender {
    
    [activeField resignFirstResponder];
}

#pragma mark - Keyboard, textfield management

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    //self.errorLabel.text = @"";
    NSDictionary* info = [aNotification userInfo];
    keyboardSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    // Ensure that active text field is visible
    [self ensureVisible:activeField withPrevious:NO];
    
    keyboardVisible = YES;
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    // Reset view
    [self resetVisibleRect];
    
    keyboardVisible = NO;
}

#pragma mark - Keyboard Next/Previous Done
- (IBAction)nextButton:(id)sender
{
    if ([self.emailTF isFirstResponder])
    {
        [self.phoneTF becomeFirstResponder];
        //next.enabled = YES;
        activeField = self.phoneTF;
    }
    else if ([self.phoneTF isFirstResponder])
    {
        [self.passwordTF becomeFirstResponder];
        activeField = self.passwordTF;
    }
    
    [self ensureVisible:activeField withPrevious:NO];
}

- (IBAction)previosButton:(id)sender
{
    if ([self.phoneTF isFirstResponder])
    {
        [self.emailTF becomeFirstResponder];
        activeField = self.emailTF;
    }
    
    [self ensureVisible:activeField withPrevious:YES];
}

#pragma mark - TextField scrolling helpers

- (void)ensureVisible:(UITextField*)textField withPrevious:(BOOL)previous
{
    CGRect bounds = self.view.bounds;
    
    CGPoint textFieldOrigin = [self.view convertPoint:textField.frame.origin fromView:self.loginOverlay];
    CGSize textFieldSize = textField.bounds.size;
    
    CGFloat slideValue = 0.0;
    if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation))
        if (previous) {
            //slideValue = bounds.size.height + keyboardSize.height + textFieldSize.height + textFieldOrigin.y;
        } else {
            slideValue = bounds.size.height - keyboardSize.height - textFieldSize.height - textFieldOrigin.y;
        }
        else
            slideValue = bounds.size.height - keyboardSize.width - textFieldSize.height - textFieldOrigin.y;
    
    if (slideValue < 0)
        [self slideWithYValue:slideValue - 2];
}

- (void)resetVisibleRect
{
    [self slideWithYValue:0.0];
}

- (void)slideWithYValue:(float)value
{
    CGRect bounds = self.view.frame;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation))
        [self.view setFrame:CGRectMake(0, value, bounds.size.width, bounds.size.height)];
    else
        [self.view setFrame:CGRectMake(value, 0, bounds.size.width, bounds.size.height)];
    [UIView commitAnimations];
}

#pragma mark -
#pragma mark IBAction methods

- (IBAction)loginClicked:(id)sender {
//    DialerView *view = VIEW(DialerView);
//    [PhoneMainView.instance changeCurrentView:view.compositeViewDescription];
    [self loginvalue];
    //[PhoneMainView.instance popCurrentView];
}

-(BOOL)validateTextField {
    
    self.errorMessage = @"";
    if (![self.passwordTF.text length]) {
        self.errorMessage = ERROR_PASSWORD_REQUIRED;
        return NO;
    }
    if (![self.phoneTF.text length]) {
        self.errorMessage = ERROR_PHONE_REQUIRED;
        return NO;
    }
    
    return YES;
}

#pragma mark -
#pragma mark Service Manager delegate methods

-(void)getDataFromModel:(NSDictionary *)info withResponseType:(NSString *)responseType {
    
    [RAZA_APPDELEGATE hideIndeterminateIndicator:YES];
    
    BOOL network = [RAZA_APPDELEGATE checkNetworkPriorRequest];
    
    if (network) {
        
        loginInfo = [RAZA_USERDEFAULTS objectForKey:@"logininfo"];
        
        
        if ([responseType isEqualToString:@"LoginResult"]) {
            if ([loginInfo objectForKey:LOGIN_RESPONSE_STATUS] && [[loginInfo objectForKey:LOGIN_RESPONSE_STATUS] isEqualToString:@"1"]) {
                
                [RazaHelper registerAccountToSIPServerWithEmail:self.emailTF.text withPassword:self.passwordTF.text withPhoneNumber:self.phoneTF.text];
                [RAZA_USERDEFAULTS setObject:self.phoneTF.text forKey:@"profilephone"];
                
                [self checkForMemberType];
                
            }
            else {
                [HUD hide:YES];
                if ([[info objectForKey:@"error"] isEqual:@"no record"])
                {
                    [RAZA_APPDELEGATE showAlertWithMessage:@"wrong credential" withTitle:alertTitle withCancelTitle:@"Ok"];
                }
                else
                    [RAZA_APPDELEGATE showAlertWithMessage:[info objectForKey:@"error"] withTitle:alertTitle withCancelTitle:@"Ok"];
                //[RAZA_APPDELEGATE showAlertWithMessage:@"rakesh" withTitle:alertTitle withCancelTitle:@"Ok"];
            }
        }
        else if ([responseType isEqualToString:@"LoginWithPassCode"]) {
            if ([[info objectForKey:@"ResponseCode"] isEqualToString:@"1"]) {
                [RAZA_USERDEFAULTS setObject:self.phoneTF.text forKey:@"profilephone"];
                [self setlogincredential:[info valueForKey:@"SipPassword"] andaccessnumber:[info valueForKey:@"AccessNumber"]];
                [self checkForMemberType];
                
            }else if ([[info objectForKey:@"ResponseCode"] isEqualToString:@"2"]){
                [HUD hide:YES];
                self.verifyScreenMsg.attributedText=[self getAttributedText:@"A text message with your verification code has been sent to " secondStr:[NSString stringWithFormat:@"%@:",self.phoneTF.text]];
                [self show:NO];
               // NSString*VerificationCode=[info objectForKey:@"VerificationCode"];
                [RAZA_APPDELEGATE showAlertWithMessage:[NSString stringWithFormat:@"A text message with your verification code has been sent to %@",self.phoneTF.text] withTitle:@"PASSCODE / PASSWORD" withCancelTitle:@"Ok"];

            }
            else {
                [HUD hide:YES];
                [RAZA_APPDELEGATE showAlertWithMessage:[info objectForKey:@"ResponseMessage"] withTitle:alertTitle withCancelTitle:@"Ok"];
            }
            
        }
        
        else if ([responseType isEqualToString:@"Login_VerifyResult"]) {
            if ([[info objectForKey:LOGIN_RESPONSE_STATUS] isEqualToString:@"1"]&&[[info objectForKey:LOGIN_RESPONSE_RESULTTYPE] isEqualToString:@"false"]) {
                [HUD hide:YES];
                // [RAZA_APPDELEGATE showAlertWithMessage:@"call another" withTitle:alertTitle withCancelTitle:@"Ok"];
                // _txtverifytext.text=[info objectForKey:@"code"];
                //[self show:NO];
                if (_viewVerify.hidden==YES)
                    [self show:NO];
                else
                    [RAZA_APPDELEGATE showAlertWithMessage:RAZAMESSAGEUSERRESENDMESSAGE withTitle:alertTitle withCancelTitle:@"Ok"];
                
            }
            else if ([[info objectForKey:LOGIN_RESPONSE_STATUS] isEqualToString:@"1"]&&[[info objectForKey:LOGIN_RESPONSE_RESULTTYPE] isEqualToString:@"true"]) {
                
                [[RazaServiceManager sharedInstance]requestLoginConfirmWithUserNameLogin_V2:self.emailTF.text withPassword:self.passwordTF.text  withPhone:self.phoneTF.text withVerificationcode:@"" withDeviceId:RAZA_APPDELEGATE.deviceID withDeviceType:@"ios" withDevice_PhoneNumber:self.phoneTF.text withDeviceIP_Address:RAZA_APPDELEGATE.getIPAddress  withDeviceIMEI_Number:RAZA_APPDELEGATE.deviceID withClientDateTime:RAZA_APPDELEGATE.getTime withDeviceLongitude_Latitude:RAZA_APPDELEGATE.latitudelongitude];
                [RazaDataModel sharedInstance].delegate = self;
                // [RAZA_APPDELEGATE showAlertWithMessage:@"BYPASS IT" withTitle:alertTitle withCancelTitle:@"Ok"];
                //_txtverifytext.text=[info objectForKey:@"code"];
                //[self show:NO];
                
            }
            else {
                [HUD hide:YES];
                [RAZA_APPDELEGATE showAlertWithMessage:[info objectForKey:@"error"] withTitle:alertTitle withCancelTitle:@"Ok"];
            }
            
        }
        else if ([responseType isEqualToString:@"Login_V1Result"]||[responseType isEqualToString:@"Login_V2Result"]) {
            if ([[loginInfo objectForKey:LOGIN_RESPONSE_STATUS] isEqualToString:@"1"]) {
                [RAZA_USERDEFAULTS setObject:self.phoneTF.text forKey:@"profilephone"];
                [self setlogincredential:[info valueForKey:@"sippwd"] andaccessnumber:[info valueForKey:@"accessno"]];
                [self checkForMemberType];
                
            }
            else {
                [HUD hide:YES];
                [RAZA_APPDELEGATE showAlertWithMessage:[info objectForKey:@"error"] withTitle:alertTitle withCancelTitle:@"Ok"];
            }
            
        }
        
        else if ([responseType isEqualToString:@"Get_Billing_Information_V1Result"]) {
            [HUD hide:YES];
            [self makeRechargePinForFreeTrialMember];
        }
        else if ([responseType isEqualToString:@"add_subscriber"] ||[responseType isEqualToString:@"update_subscriber"])
        {
            
            
            
            if (![[info objectForKey:@"ERROR"] isEqualToString:@"ERROR"]) {
                
                if (![[info objectForKey:@"RESPONSE_TEXT"] isEqualToString:@"Success"])
                {
                    [[RazaServiceManager sharedInstance] requestLoginWithNewSipServer:@"" withPassword:self.passwordTF.text withPhone:self.phoneTF.text withDeviceId:[RAZA_APPDELEGATE deviceToken] andmethodemode:@"update_subscriber"];
                }
                else
                {
                    [HUD hide:YES];
                    //                RazaTabBarController *tabbarController = [[RazaTabBarController alloc]initWithNibName:@"RazaTabBarController" bundle:nil];
                    //                [self.navigationController presentViewController:tabbarController animated:YES completion:nil];
                    // RAZA_APPDELEGATE.window.rootViewController= [RAZA_APPDELEGATE navcontrollertest];
                    [[NSUserDefaults standardUserDefaults] setObject:Razatempraturemode forKey:Razatempraturemode];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    //  DialerView *view = VIEW(DialerView);
                    // [PhoneMainView.instance changeCurrentView:view.compositeViewDescription];
                    // RazaSipLoginModel *loginmodel=[[RazaSipLoginModel alloc]init];
                    // [loginmodel setupforlogin];
                    // MyViewController.h
                    MyViewController *view = VIEW(MyViewController);
                    
                    [PhoneMainView.instance changeCurrentView:view.compositeViewDescription];
                }
            }
            else
            {
                [HUD hide:YES];
                [RAZA_USERDEFAULTS removeObjectForKey:@"logininfo"];//objectForKey:@"logininfo"
                [RAZA_APPDELEGATE showAlertWithMessage:@"Bad request server" withTitle:alertTitle withCancelTitle:@"Ok"];
            }
            
        }
        
        else {
            [HUD hide:YES];
            [RAZA_USERDEFAULTS removeObjectForKey:@"logininfo"];
            [RAZA_APPDELEGATE showAlertWithMessage:@"Bad request" withTitle:alertTitle withCancelTitle:@"Ok"];
        }
        
        //        if ([responseType isEqualToString:@"LoginResult"]) {
        //
        //            if ([loginInfo objectForKey:LOGIN_RESPONSE_STATUS] && [[loginInfo objectForKey:LOGIN_RESPONSE_STATUS] isEqualToString:@"1"]) {
        //
        //                RAZA_APPDELEGATE.isLoggedIn = [[loginInfo objectForKey:LOGIN_RESPONSE_STATUS] boolValue];
        //
        //                //[self initialRequestBeforeAddressBook];
        //
        //                RazaTabBarController *tabbarController = [[RazaTabBarController alloc]initWithNibName:@"RazaTabBarController" bundle:nil];
        //                [self.navigationController presentViewController:tabbarController animated:YES completion:nil];
        //
        //            } else {
        //                error = [info objectForKey:@"error"];
        //            }
        //        }
    }
    else
        [HUD hide:YES];
}

-(void)receivedDataFromService:(NSDictionary *)info withResponseType:(NSString *)responseType {
    [HUD hide:YES];
    if ([responseType isEqualToString:@"Does_FreeTrial_Exist_V1Result"]) {
        
        // Paid member
        if (([[info objectForKey:@"result"] isEqualToString:@"y"]) && ([[info objectForKey:@"status"] isEqualToString:@"1"])) {
            //do nothing
            //TOASK: Why do We need to call requestToGetBillingInfo on login why not on recharge pin
            //[[RazaServiceManager sharedInstance] requestToGetBillingInfo:[loginInfo objectForKey:@"id"]];
            //TODO: In old app after getting billing info; the Recharge_Pin_FreeTrial request was made.
            
            //            BOOL network = [RAZA_APPDELEGATE checkNetworkPriorRequest];
            //
            //            if (network) {
            //
            //                [[RazaServiceManager sharedInstance] requestToGetBillingInfo:[loginInfo objectForKey:LOGIN_RESPONSE_ID]];
            //                [RazaDataModel sharedInstance].delegate = self;
            //            }
            
            [self sendToDialPadPage];
            
        }
        else {
            
            [self getBillingInfoForMember];
        }
        
    }
    if ([responseType isEqualToString:@"Get_Password_V1Result"]) {
        if ([info objectForKey:@"error"]) {
            
            //[RAZA_APPDELEGATE showMessage:[info objectForKey:@"error"] withMode:MBProgressHUDModeText withDelay:2.0 withShortMessage:NO];
            [RAZA_APPDELEGATE showAlertWithMessage:[info objectForKey:@"error"] withTitle:alertTitle withCancelTitle:@"Ok"];
            
        }
        else {
            
            //[RAZA_APPDELEGATE showMessage:SUCCESSFULLY_CHANGED_PASSWORD withMode:MBProgressHUDModeText withDelay:2.0 withShortMessage:YES];
            [RAZA_APPDELEGATE showAlertWithMessage:SUCCESSFULLY_CHANGED_PASSWORD withTitle:alertTitle withCancelTitle:@"Ok"];
        }
    }
    
    if ([responseType isEqualToString:@"SendPassCode"]) {
        [RAZA_APPDELEGATE hideIndeterminateIndicator:YES];
        [[Razauser SharedInstance]HideWaiting];
        
        if ([[info objectForKey:@"ResponseCode"] isEqualToString:@"0"]) {
            [RAZA_APPDELEGATE showAlertWithMessage:[info objectForKey:@"ResponseMessage"] withTitle:@"Forgot Passcode / Password" withCancelTitle:@"Ok"];
        }
        else {
            self.verifyScreenMsg.attributedText=[self getAttributedText:@"A text message with your verification code has been sent to " secondStr:[NSString stringWithFormat:@"%@:",self.phoneTF.text]];
            [self show:NO];
            //NSString*VerificationCode=[info objectForKey:@"VerificationCode"];
            [RAZA_APPDELEGATE showAlertWithMessage:[NSString stringWithFormat:@"A text message with your verification code has been sent to %@",self.phoneTF.text] withTitle:@"Forgot Passcode / Password" withCancelTitle:@"Ok"];
            
        }
    }
    
}

-(void)checkForMemberType {
    
    //To check Free trial exist
    
    if ([RAZA_APPDELEGATE checkNetworkPriorRequest]) {
        
        [RazaServiceManager sharedInstance].delegate = self;
        [[RazaServiceManager sharedInstance] requestFreeTrialExistWithMemberId:[loginInfo objectForKey:LOGIN_RESPONSE_ID]];
        
    }
    //To check get pin balance
    
    //[[RazaServiceManager sharedInstance] requestToGetPinBalance:[loginInfo objectForKey:@"pin"]];
    //    [RazaServiceManager sharedInstance].delegate = self;
}

//-(void)updateView {
//
//    [RAZA_APPDELEGATE hideIndeterminateIndicator:YES];
//
//    if ([loginInfo objectForKey:LOGIN_RESPONSE_STATUS] && [[loginInfo objectForKey:LOGIN_RESPONSE_STATUS] isEqualToString:@"1"]) {
//
//        //To check Free trial exist
//
//        if ([RAZA_APPDELEGATE checkNetworkPriorRequest]) {
//            [[RazaServiceManager sharedInstance] requestFreeTrialExistWithMemberId:[loginInfo objectForKey:LOGIN_RESPONSE_ID]];
//        }
//
//        //        RazaTabBarController *tabbarController = [[RazaTabBarController alloc]initWithNibName:@"RazaTabBarController" bundle:nil];
//        //        [self.navigationController presentViewController:tabbarController animated:YES completion:nil];
//    }
//    else {
//
//        //[RAZA_APPDELEGATE showMessage:ERROR_USERNAME_PWD withMode:MBProgressHUDModeText withDelay:1 withShortMessage:YES];
//        [RAZA_APPDELEGATE showAlertWithMessage:ERROR_USERNAME_PWD withTitle:alertTitle withCancelTitle:@"Ok"];
//    }
//}

-(void)sendToDialPadPage {
    
    if ([loginInfo objectForKey:@"ResponseCode"] && [[loginInfo objectForKey:@"ResponseCode"] isEqualToString:@"1"]) {
        
        
        //
        //        RAZA_APPDELEGATE.isLoggedIn = [[loginInfo objectForKey:LOGIN_RESPONSE_STATUS] boolValue];
        //
        //        RazaTabBarController *tabbarController = [[RazaTabBarController alloc]initWithNibName:@"RazaTabBarController" bundle:nil];
        //        [self.navigationController presentViewController:tabbarController animated:YES completion:nil];
        ////        http://216.178.226.139/jsonWS/adduserwithdevice.php?email_address=aaa@aa.com&password=111&phone_number=1112&devicetoken=dfdfdfdf333ddddd
        //      //  NSString *str = [RAZA_APPDELEGATE.deviceID stringByReplacingOccurrencesOfString:@"-" withString:@""];
        //
        //        [RAZA_USERDEFAULTS setObject:self.phoneTF.text forKey:@"localphone"];
        //         NSString *urlStr = [[RazaHelper formValidURL:DEFAULT_SIP_ADDRESS] stringByAppendingString:API_SIPUSER_WITH_DEVICE];
        //        NSString *url_str=[NSString stringWithFormat:@"?email_address=%@&password=%@&phone_number=%@&devicetoken=%@&type=%s",self.emailTF.text,self.passwordTF.text,self.phoneTF.text,[RAZA_APPDELEGATE deviceToken],"I"];
        //        url_str = [urlStr stringByAppendingString:url_str];
        ////        RAZA_APPDELEGATE.phonenumbervalue = self.phoneTF.text;
        //        url_str = [url_str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        //
        //        NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:url_str]];
        //
        //        NSData *response = [NSURLConnection sendSynchronousRequest:request  returningResponse:nil error:nil];
        //
        //        NSString *json_string = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
        //        NSLog(@"%@",json_string);
        //
        //      //  [NSThread sleepForTimeInterval:2.0];
        //         [RAZA_APPDELEGATE startSIPService];
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        
        //       [HUD show:YES];
        //        [[RazaServiceManager sharedInstance] requestLoginWithNewSipServer:@"" withPassword:self.passwordTF.text withPhone:self.phoneTF.text withDeviceId:[RAZA_APPDELEGATE deviceToken] andmethodemode:@"add_subscriber"];
        //
        //
        //    [RazaDataModel sharedInstance].delegate = self;
        
        [HUD hide:YES];
        //                RazaTabBarController *tabbarController = [[RazaTabBarController alloc]initWithNibName:@"RazaTabBarController" bundle:nil];
        //                [self.navigationController presentViewController:tabbarController animated:YES completion:nil];
        // RAZA_APPDELEGATE.window.rootViewController= [RAZA_APPDELEGATE navcontrollertest];
        [[NSUserDefaults standardUserDefaults] setObject:Razatempraturemode forKey:Razatempraturemode];
        [[NSUserDefaults standardUserDefaults] synchronize];
        _passwordTF.text=@"";
        _phoneTF.text=@"";
        _phoneTF.placeholder=@"PHONE NUMBER";
        _passwordTF.placeholder=@"PASSCODE / PASSWORD";
        
        MyViewController *view = VIEW(MyViewController);
        [view callfornotify];
        
        // [PhoneMainView.instance changeCurrentView:view.compositeViewDescription];
        //  RazaSipLoginModel *loginmodel=[[RazaSipLoginModel alloc]init];
        // [loginmodel setupforlogin];
        //  DialerView *view = VIEW(DialerView);
        //  [PhoneMainView.instance changeCurrentView:view.compositeViewDescription];
        /* RazaTabBarController *tabbarController = [[RazaTabBarController alloc]initWithNibName:@"RazaTabBarController" bundle:nil];
         [self.navigationController presentViewController:tabbarController animated:YES completion:nil];
         [RAZA_APPDELEGATE startSIPService];*/
        
    }
}

-(void)getBillingInfoForMember {
    
    [RazaServiceManager sharedInstance].delegate = self;
    [[RazaServiceManager sharedInstance] requestToGetBillingInfo:[loginInfo objectForKey:LOGIN_RESPONSE_ID]];
}

-(void)makeRechargePinForFreeTrialMember {
    
    NSDictionary *personalInfo = [RazaLoginModel sharedInstance].personalInfo;
    
    NSString *memberid = [[RAZA_USERDEFAULTS objectForKey:@"logininfo"] objectForKey:LOGIN_RESPONSE_ID];
    
    NSString *userpin = [[RAZA_USERDEFAULTS objectForKey:@"logininfo"] objectForKey:LOGIN_RESPONSE_PIN];
    
    NSString *street = [personalInfo objectForKey:ADDRESS];
    NSString *city = [personalInfo objectForKey:CITY];
    NSString *state = [personalInfo objectForKey:STATE];
    NSString *zipcode = [personalInfo objectForKey:ZIPCODE];
    NSString *country = [personalInfo objectForKey:COUNTRY];
    
    [[RazaServiceManager sharedInstance] requestRechargePinWithFreeTrialMember:memberid withUserPin:userpin withPurchase:@"0" withStreet:street withCity:city withState:state withZip:zipcode withCountry:country withIP:RAZA_APPDELEGATE.ipAddress];
    
}

-(void)updateView {
    
    //[self checkForMemberType];
    [self makeRechargePinForFreeTrialMember];
    
    [self sendToDialPadPage];
}
-(void)show:(BOOL)showhideparam{
    if (showhideparam){
        _razaLinkButton.hidden=NO;
        CGRect napkinBottomFrame = self.viewVerify.frame;
        napkinBottomFrame.origin.x = 0;
        self.viewVerify.frame = napkinBottomFrame;
        
        [UIView animateWithDuration:0.3 delay:0.0 options: UIViewAnimationOptionCurveEaseOut animations:^{
            CGRect napkinBottomFrame = self.viewVerify.frame;
            napkinBottomFrame.origin.x = SCREENWIDTH;
            self.viewVerify.frame = napkinBottomFrame;
        } completion:^(BOOL finished){
            self.viewVerify.hidden=YES;
        }];
    }else{
        _razaLinkButton.hidden=YES;
        
        self.viewVerify.hidden=NO;
        
        CGRect napkinBottomFrame = self.viewVerify.frame;
        napkinBottomFrame.origin.x = SCREENWIDTH;
        self.viewVerify.frame = napkinBottomFrame;
        
        [UIView animateWithDuration:0.3 delay:0.0 options: UIViewAnimationOptionCurveEaseOut animations:^{
            CGRect napkinBottomFrame = self.viewVerify.frame;
            napkinBottomFrame.origin.x = 0;
            self.viewVerify.frame = napkinBottomFrame;
        } completion:^(BOOL finished){/*done*/}];
        
    }
}
- (IBAction)btnverifysmsclicked:(id)sender {
    if ([RAZA_APPDELEGATE checkNetworkPriorRequest]) {
        if (_txtverifytext.text.length) {
            [[Razauser SharedInstance]ShowWaitingshort:nil andtime:5];
            [[RazaServiceManager sharedInstance]LoginWithPassCode:_txtverifytext.text  withPhone:self.phoneTF.text  withDeviceId:RAZA_APPDELEGATE.deviceID withDeviceType:@"ios" withDevice_PhoneNumber:self.phoneTF.text withDeviceIP_Address:RAZA_APPDELEGATE.getIPAddress  withDeviceIMEI_Number:RAZA_APPDELEGATE.deviceID withClientDateTime:RAZA_APPDELEGATE.getTime withDeviceLongitude_Latitude:RAZA_APPDELEGATE.latitudelongitude];
            [RazaDataModel sharedInstance].delegate = self;
        }
        else
            [RAZA_APPDELEGATE showAlertWithMessage:ERRORVERIFY withTitle:@"" withCancelTitle:ERROR_OK];
    }
    else
        [RAZA_APPDELEGATE showAlertWithMessage:NETWORK_UNAVAILABLE withTitle:@"" withCancelTitle:ERROR_OK];
}

- (IBAction)btnViewVerifyHideClicked:(id)sender {
    [self show:YES];
}

- (IBAction)btnbackclicked:(id)sender {
    [self show:YES];
}

- (IBAction)btnRetrysmssend:(id)sender {
  //  [self loginvalue];
    [RazaServiceManager sharedInstance].delegate = self;
    
    [[Razauser SharedInstance]ShowWaiting:@""];
    [[RazaServiceManager sharedInstance]SendPassCode:self.phoneTF.text  withDeviceId:RAZA_APPDELEGATE.deviceID withDeviceType:@"ios" withDevice_PhoneNumber:self.phoneTF.text withDeviceIP_Address:RAZA_APPDELEGATE.getIPAddress  withDeviceIMEI_Number:RAZA_APPDELEGATE.deviceID withClientDateTime:RAZA_APPDELEGATE.getTime withDeviceLongitude_Latitude:RAZA_APPDELEGATE.latitudelongitude];
}
-(void)setlogincredential:(NSString*)sippassword andaccessnumber:(NSString*)accessnumberstring
{
    
    [[NSUserDefaults standardUserDefaults] setValue:sippassword forKey:@"lock"];
    [[NSUserDefaults standardUserDefaults] setValue:accessnumberstring forKey:@"accessnumber"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
static UICompositeViewDescription *compositeDescription = nil;

+ (UICompositeViewDescription *)compositeViewDescription {
    if (compositeDescription == nil) {
        compositeDescription = [[UICompositeViewDescription alloc] init:self.class
                                                              statusBar:nil
                                                                 tabBar:nil
                                                               sideMenu:nil
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

-(void)loginvalue
{
    if ([activeField becomeFirstResponder]) {
        [activeField resignFirstResponder];
    }
    
    //To check if all field is entered
    if ([self validateTextField]) {
        
        
        if ([RAZA_APPDELEGATE checkNetworkPriorRequest]) {
            HUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:HUD];
            [HUD show:YES];
            
            /*----------uncoment sms based-----*///
            //LoginWithPassCode
            
            [[RazaServiceManager sharedInstance]LoginWithPassCode:self.passwordTF.text  withPhone:self.phoneTF.text withDeviceId:RAZA_APPDELEGATE.deviceID withDeviceType:@"ios" withDevice_PhoneNumber:self.phoneTF.text withDeviceIP_Address:RAZA_APPDELEGATE.getIPAddress  withDeviceIMEI_Number:RAZA_APPDELEGATE.deviceID withClientDateTime:RAZA_APPDELEGATE.getTime withDeviceLongitude_Latitude:RAZA_APPDELEGATE.latitudelongitude];
            
            //            [[RazaServiceManager sharedInstance]requestLoginVerify:self.emailTF.text withPassword:self.passwordTF.text withPhone:self.phoneTF.text withDeviceId:RAZA_APPDELEGATE.deviceID withDeviceType:@"" withDevice_PhoneNumber:self.phoneTF.text withDeviceIP_Address:RAZA_APPDELEGATE.getIPAddress withDeviceIMEI_Number:@"" withClientDateTime:RAZA_APPDELEGATE.getTime withDeviceLongitude_Latitude:RAZA_APPDELEGATE.latitudelongitude];
            
            NSString *valueToSave = self.phoneTF.text;
            [[NSUserDefaults standardUserDefaults] setObject:valueToSave forKey:@"sipphone"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [RazaDataModel sharedInstance].delegate = self;
            /*=========end=========*/
        }
        else {
            
            [RAZA_APPDELEGATE showAlertWithMessage:@"" withTitle:NETWORK_UNAVAILABLE withCancelTitle:@"Dismiss"];
        }
        
    } else {
        
        //[RAZA_APPDELEGATE showMessage:self.errorMessage withMode:MBProgressHUDModeText withDelay:1 withShortMessage:NO];
        [RAZA_APPDELEGATE showAlertWithMessage:self.errorMessage withTitle:alertTitle withCancelTitle:@"Ok"];
    }
    
}
- (IBAction)forgotPassBackAction:(id)sender {
    CGRect napkinBottomFrame = self.forgotPassView.frame;
    napkinBottomFrame.origin.x = 0;
    self.forgotPassView.frame = napkinBottomFrame;
    
    [UIView animateWithDuration:0.3 delay:0.0 options: UIViewAnimationOptionCurveEaseOut animations:^{
        CGRect napkinBottomFrame = self.forgotPassView.frame;
        napkinBottomFrame.origin.x = SCREENWIDTH;
        self.forgotPassView.frame = napkinBottomFrame;
    } completion:^(BOOL finished){
        self.forgotPassView.hidden=YES;
    }];
}
- (IBAction)resetPassAction:(id)sender {
    if (self.emailForgotTxt.text.length) {
        BOOL isValidEmail = [RAZA_APPDELEGATE isValidEmail:self.emailForgotTxt.text];
        if (isValidEmail) {
            [[RazaServiceManager sharedInstance] requestToGetPassword:self.emailForgotTxt.text withDelegate:self];
            [RazaServiceManager sharedInstance].delegate = self;
        }
        else {
            [RAZA_APPDELEGATE showAlertWithMessage:@"Please enter valid email address." withTitle:@"Forgot Passcode / Password" withCancelTitle:@"OK"];
        }
    }else{
        [RAZA_APPDELEGATE showAlertWithMessage:@"Please enter email address." withTitle:@"Forgot Passcode / Password" withCancelTitle:@"OK"];
    }
    
}

-(NSMutableAttributedString*)getAttributedText:(NSString*)first  secondStr:(NSString*)secondStr{
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@",first,secondStr]];
    [attrStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"SourceSansPro-Regular" size:18] range:NSMakeRange(0, [first length])];
    [attrStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"SourceSansPro-Bold" size:18] range:NSMakeRange([first length]+1, [secondStr length])];
    
    return attrStr;
}

@end
