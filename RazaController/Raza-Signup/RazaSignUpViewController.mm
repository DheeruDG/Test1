//
//  RazaSignUpViewController.m
//  Raza
//
//  Created by Praveen S on 11/17/13.
//  Copyright (c) 2013 Raza. All rights reserved.
//

#import "RazaSignUpViewController.h"
#import "RazaCountryFromModel.h"
#import "RazaCountryToModel.h"
#import "RazaAutoCountryVC.h"
#import "RazaCountryFromTableView.h"
#import "RazaFreePointLoginVC.h"
#import "PhoneMainView.h"
//#import "RazaHomeViewController.h"

@interface RazaSignUpViewController ()

@end

static NSString *alertTitle = @"Register";

@implementation RazaSignUpViewController

//static NSString *CellIdentifier = @"CountryCell";
//static NSString *AutoCellIdentifier = @"AutoCountryCell";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (!self) {
        // Custom initialization
        return nil;
    }
    
    _popoverSignup = [[PopoverViewController alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHIGHT) withToolbar:YES];
    
    return self;
}

#pragma mark -
#pragma mark view methods

-(void)viewWillAppear:(BOOL)animated {
    //[[self navigationController] setNavigationBarHidden:NO animated:YES];
    
    CAGradientLayer *gradient = [BackgroundLayer linearGradient];
    gradient.frame = self.signupButton.bounds;
    gradient.startPoint = CGPointMake(0.0,0.0);
    gradient.endPoint = CGPointMake(1.0,0.0);
    [self.signupButton.layer insertSublayer:gradient atIndex:0];
    
    [NSNotificationCenter.defaultCenter removeObserver:self name:@"RESENDSMSSIGNUP" object:nil];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    //UINavigationBar *navbar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    
    //    UINavigationItem *navItem = [[UINavigationItem alloc] init];
    //    navItem.title = @"Register";
    //
    //    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"<Back" style:UIBarButtonItemStylePlain target:self action:@selector(backtohome)];
    //    navItem.leftBarButtonItem = leftButton;
    //
    //
    //    navbar.items = @[ navItem ];
    
    //   [self.view addSubview:navbar];
    // [self ensureVisible:_emailTextField];
    _countryimg.image=[UIImage imageNamed:@"1.png"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resendsms) name:@"RESENDSMSSIGNUP" object:nil];
}
-(void)backtohome
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [RazaDataModel sharedInstance].delegate = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // [TODO:ios update]
    _countryTableView.separatorColor = [UIColor clearColor];
    self.loginOverlay.layer.cornerRadius = 10.0;
    self.loginOverlay.center = self.view.center;
    
    self.title = @"Register";
    self.emailTextField.tag = EMAIL;
    self.pwdTextField.tag = PASSWORD;
    self.phoneTextField.tag = PHONE;
    
    self.txtzipcode.tag=txtzip;
    //self.zipcodeTextField.tag = ZIPCODE;
    
    self.emailTextField.delegate = self;
    self.pwdTextField.delegate = self;
    self.phoneTextField.delegate = self;
    
    self.txtzipcode.delegate=self;
    
    self.phoneTextField.keyboardType=UIKeyboardTypeNumberPad;
    self.txtzipcode.keyboardType=UIKeyboardTypeDefault;
    //self.zipcodeTextField.delegate = self;
    
    self.tableNavBar.title = @"Country";
    
    // Do any additional setup after loading the view from its nib.
    
    _countryTableView.hidden = YES;
    
    [self createInputAccessoryView];
    
    [self registerForKeyboardNotifications];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark action events

static NSString * extracted() {
    return COUNTRY_FROM_SEARCHTYPE;
}

-(void)actionCountryFromButton:(id)sender {
    
    [activeField resignFirstResponder];
    
    if (![RazaDataModel sharedInstance].countryFromList ||
        ![[RazaDataModel sharedInstance].countryFromList count]) {
        
        [[RazaServiceManager sharedInstance] getCountryListWithSearchType:extracted() withDestination:@"0"];
        [RazaDataModel sharedInstance].delegate = self;
    }
    else {
        [self loadCountryFromValues];
    }
}

- (IBAction)gobackBtn:(id)sender {
    // [self.navigationController popToRootViewControllerAnimated:YES];
    RazaLoginViewController *view = VIEW(RazaLoginViewController);
    [PhoneMainView.instance popToView:view.compositeViewDescription];
}

-(void)actionCountryToButton:(id)sender {
    
    if (![RazaDataModel sharedInstance].countryToList ||
        ![[RazaDataModel sharedInstance].countryToList count]) {
        
        [[RazaServiceManager sharedInstance] getCountryListWithSearchType:COUNTRY_TO_SEARCHTYPE withDestination:@"0"];
        [RazaDataModel sharedInstance].delegate = self;
    }
    else {
        [self loadCountryToValues];
    }
}
-(void)resendsms{
    if ([self validateTextField])
    {
        
        [RazaServiceManager sharedInstance].delegate = self;
        
        NSString *countryFromID = [NSString stringWithFormat:@"%ld", (long)self.countryFromButton.tag];
        // NSString *countryToID = [NSString stringWithFormat:@"%ld", (long)self.countryToButton.tag];
        
        if ([RAZA_APPDELEGATE checkNetworkPriorRequest]){

            //=========new phase sms signup============*/
            [[Razauser SharedInstance]ShowWaiting:@""];
            //requestToSignUp_Eligible_V1
            [[RazaServiceManager sharedInstance] CustomerSignUpEligible_V1:self.emailTextField.text withPhone:self.phoneTextField.text withCountrycode:countryFromID withDevice_PhoneNumber:self.phoneTextField.text withDeviceIP_Address:RAZA_APPDELEGATE.getIPAddress withDeviceIMEI_Number:@"" withClientDateTime:RAZA_APPDELEGATE.getTime withDeviceLongitude_Latitude:RAZA_APPDELEGATE.latitudelongitude];
            [RazaDataModel sharedInstance].delegate = self;
            
        }
    }
    else {
        [RAZA_APPDELEGATE showAlertWithMessage:self.errorMessage withTitle:@"Sign up" withCancelTitle:@"Ok"];
    }
    
    
}
- (IBAction)signupClicked:(id)sender {
    [self resendsms];
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
    [self ensureVisible:activeField];
    
    keyboardVisible = YES;
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    // Reset view
    [self resetVisibleRect];
    
    keyboardVisible = NO;
}


#pragma mark - TextField scrolling helpers

- (void)ensureVisible:(UITextField*)textField
{
    CGRect bounds = self.view.bounds;
    
    CGPoint textFieldOrigin = [self.view convertPoint:textField.frame.origin fromView:self.loginOverlay];
    CGSize textFieldSize = textField.bounds.size;
    
    CGFloat slideValue = 0.0;
    if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation))
        slideValue = bounds.size.height - keyboardSize.height - textFieldSize.height - textFieldOrigin.y;
    else
        slideValue = bounds.size.height - keyboardSize.width - textFieldSize.height - textFieldOrigin.y;
    
    if (slideValue < 0)
        [self slideWithYValue:slideValue -5];//+10
}

- (void)resetVisibleRect
{
    [self slideWithYValue:0.0];
}

- (void)slideWithYValue:(float)value
{
    if (value<=-254) {
        value=-200;
    }
    
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
#pragma mark UITextFieldDelegate methods

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(UITextFieldTextDidChange:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:textField];
    if (keyboardVisible)
        [self ensureVisible:textField];
    
    activeField = textField;
    
    if (textField.tag == PHONE ) {
        [self createInputAccessoryView];
    }else if(textField.tag == EMAIL) {
        [self accessoryViewForDoneBarButton];
    }
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 266.0, 0.0);
    self.scrollView.contentInset = contentInsets;
    [textField setInputAccessoryView:_inputAccView];
    [textField setEnablesReturnKeyAutomatically:YES];
}
- (void) UITextFieldTextDidChange:(NSNotification*)notification
{
    
    UITextField * textfield = (UITextField*)notification.object;
    if (textfield.tag==PHONE)
    {
        activeField = nil;
        NSString *strphone = @"1";
        strphone = [strphone stringByAppendingString:self.phoneTextField.text];
        [self updateFlagImage:strphone];
    }
    
    
    // do something with the text and/or the text field here,
    // like validation, etc.
}
-(void)textFieldDidEndEditing:(UITextField *)textField {
    
    activeField = nil;
    
    //    if([self.countrycodetxt.text isEqual:@"+91"]||[self.countrycodetxt.text isEqual:@"0"])
    //    {
    //        [_countryimg setImage:[UIImage imageNamed: @"011212.png"]];
    //    }
    
}





-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
}

#pragma mark - 
#pragma mark Keyboard Next/Previous Done

- (IBAction)nextButton:(id)sender
{
    if ([self.phoneTextField isFirstResponder]){
        [self.phoneTextField resignFirstResponder];
        activeField = self.emailTextField;
    }
    [activeField becomeFirstResponder];
    
    [self ensureVisible:activeField];
}

- (IBAction)previosButton:(id)sender
{
    if ([self.emailTextField isFirstResponder]){
        [self.emailTextField resignFirstResponder];
        activeField = self.phoneTextField;
    }
    [activeField becomeFirstResponder];
    
    [self ensureVisible:activeField];
}

#pragma mark -
#pragma mark RazaDataModel delegate methods

-(void)getDataFromModel:(NSDictionary *)info withResponseType:(NSString *)responseType {
//    {
//        ResponseCode = 0;
//        ResponseMessage = "invalid mobile phone number";
//    }
    [[Razauser SharedInstance]HideWaiting];
    if ([[info objectForKey:@"ResponseCode"] isEqualToString:@"0"]) {
        
        [RAZA_APPDELEGATE showAlertWithMessage:[info objectForKey:@"ResponseMessage"] withTitle:alertTitle withCancelTitle:@"Ok"];
    }
    else {
        
        NSString *countryFromID = [NSString stringWithFormat:@"%ld", (long)self.countryFromButton.tag];
        NSString *countryToID = [NSString stringWithFormat:@"%ld", (long)self.countryToButton.tag];
        // NSString *letters = @"0123456789";
        // NSString *str=[self randomStringWithLength:5 letters:letters];
        
        NSString *VerificationCode=[info objectForKey:@"VerificationCode"];
        
        dictforsignupsms=[[NSMutableDictionary alloc]initWithObjectsAndKeys:_emailTextField.text,@"key_emailid",VerificationCode,@"key_verifiedsms",_phoneTextField.text,@"key_mobile",RAZA_APPDELEGATE.deviceID,@"key_deviceid",countryFromID,@"key_countryfrom",countryToID,@"key_countryto",nil];
        NSString *strphone = @"1";
        
        strphone = [strphone stringByAppendingString:self.phoneTextField.text];
        UICompositeViewDescription *vv=PhoneMainView.instance.currentView;//RazaSignUpViewController Razasignup_verification
        
        if ([vv.name isEqualToString:@"Razasignup_verification"]){
           // [RAZA_APPDELEGATE showAlertWithMessage:RAZASMSRESEND withTitle:[NSString stringWithFormat:@"Code: %@",VerificationCode] withCancelTitle:ERROR_OK];
        }else
        {
            Razasignup_verification *view = VIEW(Razasignup_verification);
            
            [PhoneMainView.instance changeCurrentView:view.compositeViewDescription];
        }
        //Razasignup_verification *viewController = [[Razasignup_verification alloc] init];
        // [viewController.navigationController setNavigationBarHidden:NO animated:YES];
        //[self.navigationController pushViewController:viewController animated:YES];
        // [[RazaServiceManager sharedInstance] Send_SMS_Message:strphone Message:[NSString stringWithFormat:@"Raza sign up sms verification code !%@",str] RecipientName:_emailTextField.text];
        // [RazaDataModel sharedInstance].delegate = self;
        /* [self sendSMS:[dictforsignupsms objectForKey:@"key_verifiedsms"] recipientList:[NSArray arrayWithObjects:[dictforsignupsms objectForKey:@"key_mobile"], nil]];*/
        
        
    }
}
//- (void)sendSMS:(NSString *)bodyOfMessage recipientList:(NSArray *)recipients
//{
//    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
//    if([MFMessageComposeViewController canSendText])
//    {
//        controller.body = bodyOfMessage;
//        controller.recipients = recipients;
//    
//        controller.messageComposeDelegate = self;
//        [self presentModalViewController:controller animated:YES];
//    }    
//}
//- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
//{
//    [self dismissModalViewControllerAnimated:YES];
//    
//    if (result == MessageComposeResultCancelled)
//        NSLog(@"Message cancelled");
//    else if (result == MessageComposeResultSent)
//    {
//        Razasignup_verification *viewController = [[Razasignup_verification alloc] init];
//    [viewController.navigationController setNavigationBarHidden:NO animated:YES];
//    [self.navigationController pushViewController:viewController animated:YES];
//    }
//    else
//        NSLog(@"Message failed");
//}
-(void)getDataFromModelforsms:(NSDictionary *)info withResponseType:(NSString *)responseType {
    
    if ([info objectForKey:@"error"]) {
        
        [RAZA_APPDELEGATE showAlertWithMessage:[info objectForKey:@"error"] withTitle:alertTitle withCancelTitle:@"Ok"];
    }
    else
    {
        Razasignup_verification *viewController = [[Razasignup_verification alloc] init];
        [viewController.navigationController setNavigationBarHidden:NO animated:YES];
        [self.navigationController pushViewController:viewController animated:YES];
    }
}
#pragma mark -
#pragma mark form validation methods


-(NSString *) randomStringWithLength: (int) len letters:(NSString *)letters {
    
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i=0; i<len; i++)
    {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform((int)[letters length])]];
    }
    
    return randomString;
}
-(BOOL)validateTextField{
    self.errorMessage = @"";
    
    BOOL valid=YES;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"];
    
    if(([self.countryFromTxt.text isEqualToString:@""]&& [self.countryFromTxt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]])){
        valid = NO;
        self.errorMessage = ERROR_COUNTRY_FROM_REQUIRED;
        
    }else if([self.phoneTextField.text isEqualToString:@""] && [self.phoneTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]){
        valid = NO;
        self.errorMessage = ERROR_PHONE_REQUIRED;
    }else if([self.emailTextField.text isEqualToString:@""] && [self.emailTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]){
        valid = NO;
        self.errorMessage = ERROR_EMAIL_REQUIRED;
    }else if(![emailTest evaluateWithObject:self.emailTextField.text]){
        valid = NO;
        self.errorMessage = ERROR_EMAIL_VALIDATION_REQUIRED;
    }else if (!([self.phoneTextField.text length]==10)) {
        self.errorMessage = ERROR_PHONE_VALIDATION_REQUIRED;
        return NO;
    }
    
    return valid;
}

#pragma mark -
#pragma mark RazaCountryFromTableView delegate methods

-(void)selectedRowForCountry:(RazaCountryFromModel *)countryFromModel {
    
    [self.countryFromButton setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    self.countryFromButton.tag = [countryFromModel.countryID integerValue];
    //[self.countryFromButton setTitle:countryFromModel.countryName forState:UIControlStateNormal];
    self.countryFromTxt.text=countryFromModel.countryName;
    _countryTableView.hidden = YES;
    [_popoverSignup dismiss];
    [activeField becomeFirstResponder];
}

#pragma mark -
#pragma mark RazaAutoCountryVC delegate methods

-(void)updateCountryToTextField:(RazaCountryToModel *)countryToModel {
    
    if (countryToModel) {
        [self.countryToButton setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
        
        self.countryToButton.tag = [countryToModel.countryID integerValue];
        self.countryToTxt.text=countryToModel.countryName;
        //[self.countryToButton setTitle:countryToModel.countryName forState:UIControlStateNormal];
    }
    
    [mainview removeFromSuperview];
}

#pragma mark -
#pragma mark keyboard accessory view methods

-(void)createInputAccessoryView
{
    if (_inputAccView) {
        _inputAccView = nil;
    }
    _inputAccView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0,self.view.frame.size.width, 44.0)];
    [_inputAccView setBackgroundColor:[UIColor clearColor]];
    [_inputAccView setAlpha: 1.0];
    
    _previous = [[UIBarButtonItem alloc] initWithTitle:@"Previous" style:UIBarButtonItemStyleBordered target:self action:@selector(previosButton:)];
    [_previous setBackgroundImage:[[UIImage alloc] init] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    [_previous setTintColor:Kcolorforkeyboardtoolabr];
    
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    _next = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStyleBordered target:self action:@selector(nextButton:)];
    [_next setBackgroundImage:[[UIImage alloc] init] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    [_next setTintColor:Kcolorforkeyboardtoolabr];
    
    
    [_keyboardToolbar removeFromSuperview];
    _keyboardToolbar = [[UIToolbar alloc] init];
    _keyboardToolbar.frame = CGRectMake(0.0, 0.0, self.view.frame.size.width, 44.0);
    
    _keyboardToolbar.items = [NSArray arrayWithObjects:_previous,spacer, _next, nil];
    // [TODO:ios update]
    
    // UIColor *defaultColor = kColorHeader;
    
    //  [_keyboardToolbar setBarTintColor:defaultColor];
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
    
    if (_inputAccView) {
        _inputAccView = nil;
    }
    
    _inputAccView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0,self.view.frame.size.width, 44.0)];
    [_inputAccView setBackgroundColor:[UIColor clearColor]];
    [_inputAccView setAlpha: 1.0];
    
    _previous = [[UIBarButtonItem alloc] initWithTitle:@"Previous" style:UIBarButtonItemStyleBordered target:self action:@selector(previosButton:)];
    [_previous setBackgroundImage:[[UIImage alloc] init] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    [_previous setTintColor:Kcolorforkeyboardtoolabr];
    
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    _done = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(doneButton:)];
    
    [_done setBackgroundImage:[[UIImage alloc] init] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    [_done setTintColor:Kcolorforkeyboardtoolabr];
    
    [_keyboardToolbar removeFromSuperview];
    
    if (!_keyboardToolbar) {
        _keyboardToolbar = [[UIToolbar alloc] init];
    }
    
    _keyboardToolbar.frame = CGRectMake(0.0, 0.0, self.view.frame.size.width, 44.0);
    
    _keyboardToolbar.items = [NSArray arrayWithObjects:_previous, spacer, _done, nil];
    // [TODO:ios update]
    
    // UIColor *defaultColor = kColorHeader;
    
    // [_keyboardToolbar setBarTintColor:defaultColor];
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
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
    self.scrollView.contentInset = contentInsets;
}

#pragma mark -
#pragma mark load country from & country to methods

-(void)loadCountryFromValues {
    
    _countryTableView = [[RazaCountryFromTableView alloc] initWithFrame:CGRectMake(0, 0, APP_FRAME.size.width, APP_FRAME.size.height) withDelegate:self];
    _countryTableView.bounces=NO;
    [activeField resignFirstResponder];
    
    _countryTableView.hidden = NO;
    
    UIViewController *containerVC = [[UIViewController alloc]init];
    containerVC.view.backgroundColor = [UIColor clearColor];
    _countryTableView.backgroundColor = [UIColor clearColor];
    [containerVC.view addSubview:_countryTableView];
    
    [_popoverSignup setPopoverTitle:@"Select Country"];
    
    [_popoverSignup addPopoverContent:containerVC];
    
    [_popoverSignup presentInViewController:self];
}

-(void)loadCountryToValues {
    mainview=[[UIView alloc]initWithFrame:CGRectMake(0, -20, SCREENWIDTH, SCREENHIGHT)];
    [self.view addSubview:mainview];
    RazaAutoCountryVC *autoCountryVC = [[RazaAutoCountryVC alloc]initWithNibName:@"RazaAutoCountryVC" bundle:nil];
    autoCountryVC.delegate = self;
    //[self.navigationController presentViewController:autoCountryVC animated:YES completion:nil];
    
    UIViewController *childViewController ;// create your child view controller
    
    // RazaContactsViewController *contactVC = [[RazaContactsViewController alloc]init];
    childViewController=autoCountryVC;
    [self addChildViewController:childViewController];
    [mainview addSubview:childViewController.view];
    [childViewController didMoveToParentViewController:self];
    
    NSArray *horzConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[childView]|"
                                                                       options:0
                                                                       metrics:nil
                                                                         views:@{@"childView" : childViewController.view}];
    
    NSArray *vertConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[childView]|"
                                                                       options:0
                                                                       metrics:nil
                                                                         views:@{@"childView" : childViewController.view}];
    
    [self.view addConstraints:horzConstraints];
    [self.view addConstraints:vertConstraints];
    
    childViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
}

#pragma mark -
#pragma mark RazaDataModel delegate methods

-(void)updateViewWithRequestIndentity:(NSString *)requestIndentity {
    
    if ([requestIndentity isEqualToString:COUNTRY_TO_SEARCHTYPE]) {
        [self loadCountryToValues];
    }
    else {
        [self loadCountryFromValues];
    }
}

-(void)updateFlagImage:(NSString *)phoneno {
    
    if ([phoneno length]>1)
    {
        
        [self getCountryImage:phoneno];
        
        UIImage *flagImage = [UIImage imageNamed:_flagName];
        
        if (!flagImage || IS_EMPTY(_flagName)) {
            
            flagImage = [self getUSCountryImage:phoneno];
        }
        
        if (mainvalue==10)
        {
            _countryimg.image = [UIImage imageNamed:@"1.png"];
        }
        else
        {
            if (flagImage==nil) {
                _countryimg.image = [UIImage imageNamed:@"1.png"];
            }
            else
                _countryimg.image = flagImage;
        }
        
    }
    else {
        _countryimg.image = [UIImage imageNamed:@"1.png"];
    }
}

-(void)getCountryImage:(NSString *)phone {
    
    NSArray* phones = [phone componentsSeparatedByCharactersInSet :[NSCharacterSet whitespaceCharacterSet]];
    phone = [phones componentsJoinedByString:@""];
    mainvalue=[phone length];
    NSLog(@"phone%lu",(unsigned long)[phone length]);
    _flagName = @"";
    
    
    [RAZA_APPDELEGATE.appCountriesFlag enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        
        NSEnumerator *e = [obj objectEnumerator];
        NSString *object;
        
        while (object = [e nextObject]) {
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF BEGINSWITH[cd] %@",object];
            
            if ([phone length] > 1 && [predicate evaluateWithObject:phone] == YES) {
                NSLog(@"keymila %@ {%@ - %@}", key, object, phone);
                _flagName = key;
                break;
                
            }
            
        }
    }];
    
    if ([_flagName isEqualToString:@"1"])
        _flagName = phone;
    
}
-(UIImage *)getUSCountryImage:(NSString *)phoneno {
    
    NSSet *sourceSet = [NSSet setWithObjects:@"+", @"-", @"(", @")", nil];
    
    NSString *firstChar = [phoneno substringToIndex:1];
    
    NSPredicate *wildcharpredicate = [NSPredicate predicateWithFormat:@"SELF BEGINSWITH[cd] %@", firstChar];
    
    NSSet *filteredSet = [sourceSet filteredSetUsingPredicate:wildcharpredicate];
    
    // for +1 no matter of number after +1
    if ([filteredSet count]) {
        
        if ([phoneno length] > 1) {
            
            NSRange range = NSMakeRange(1, 1);
            
            //if ([phoneno length] > 5) {
            
            NSString *charAfterSymbol = [phoneno substringWithRange:range];
            
            if ([charAfterSymbol isEqualToString:@"1"]) {
                return [UIImage imageNamed:@"1.png"];
            }
            //}
        }
    }
    // for 1 after 4 for eg. 1-xxx
    else if ([phoneno length] > 3) {
        
        NSString *firstCharWithOne = [phoneno substringToIndex:1];
        
        if ([firstCharWithOne isEqualToString:@"1"]) {
            return [UIImage imageNamed:@"1.png"];
        }
        else {
            return [self getUSCountryImageForPhoneNo:phoneno startsWith:@"001"];
        }
    }
    
    else {
        
        return [self getUSCountryImageForPhoneNo:phoneno startsWith:@"001"];
        
    }
    
    return nil;
}
-(UIImage *)getUSCountryImageForPhoneNo:(NSString *)phoneno startsWith:(NSString *)zerozeroone {
    
    NSPredicate *zerozeroOnePredicate = [NSPredicate predicateWithFormat:@"SELF BEGINSWITH[cd] %@", zerozeroone];
    
    if ([zerozeroOnePredicate evaluateWithObject:phoneno]) {
        return [UIImage imageNamed:@"1.png"];
    }
    
    return nil;
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



@end
