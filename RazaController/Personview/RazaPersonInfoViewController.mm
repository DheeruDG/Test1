//
//  RazaPersonInfoViewController.m
//  Raza
//
//  Created by Praveen S on 11/24/13.
//  Copyright (c) 2013 Raza. All rights reserved.
//

#import "RazaPersonInfoViewController.h"
#import "RazaServiceManager.h"
#import "RazaLoginModel.h"
#import "PhoneMainView.h"
@interface RazaPersonInfoViewController ()

@end

static NSString *alertTitle = @"Billing Info";

@implementation RazaPersonInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        _stateTableView = [[RazaStateListTableView alloc]initWithFrame:CGRectMake(0, 0, APP_FRAME.size.width, APP_FRAME.size.height-self.navigationController.navigationBar.frame.size.height-40) withDelegate:self];
        _stateTableView.bounces=NO;
        _stateTableView.separatorColor=[UIColor clearColor];
        _popoverPersonInfo = [[PopoverViewController alloc] initWithFrame:CGRectMake(0, 0, APP_FRAME.size.width, APP_FRAME.size.height) withToolbar:YES];
    }
    return self;
}

- (void)viewDidLoad{
    

    
    _buttonState.enabled = YES;
    //[RazaAppDelegate roundedLayerViewCommentTop:_containerView.layer radius:10.0f borderWidth:0.0f shadow:NO];
    
    //_containerView.backgroundColor = UIColorFromRGBA(215, 236, 250, 1);
    
    [super viewDidLoad];
    
    self.textZipCode.text = [RazaLoginModel sharedInstance].zipcode;
        
    [self createInputAccessoryView];
    [self registerForKeyboardNotifications];
    
    [self formEntry];
    _containerScrollView.contentSize = _containerView.bounds.size;
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
    
    _textZipCode.keyboardType=UIKeyboardTypeDefault;
    self.title = @"Personal Info";
   //self.textFirstName.text=@"";
  // self.textLastName.text=@"";
  //  self.textStreet.text=@"";
  // self.textCity.text=@"";
    NSLog(@"%@---",personalinfo);
//    self.textFirstName.text=[personalinfo objectForKey:@"personal_firstname"];
//    self.textLastName.text=[personalinfo objectForKey:@"personal_lastname"];
//    self.textStreet.text=[personalinfo objectForKey:@"personal_address"];
//    self.textCity.text=[personalinfo objectForKey:@"personal_city"];
//    
//    self.textZipCode.text=[personalinfo objectForKey:@"personal_zip"];
    
}

-(void)viewWillDisappear:(BOOL)animated {
    
    [RazaDataModel sharedInstance].delegate = nil;
}

#pragma mark -
#pragma mark UITextField delegate methods

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    _activeTextField = textField;
    if (keyboardVisible)
        [self ensureVisible:textField];
    _activeTextField = textField;
    [textField setInputAccessoryView:_inputAccView];
    [textField setEnablesReturnKeyAutomatically:YES];
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    _activeTextField = nil;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.tag == 4) {
//        NSCharacterSet *digitSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
//        for (int i = 0; i < [string length]; i++) {
//            unichar c = [string characterAtIndex:i];
//            if (![digitSet characterIsMember:c]) {
//                return NO;
//            }
//        }
        
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return (newLength > 2) ? NO : YES;
    }
    
    return YES;
    
}

#pragma mark -
#pragma mark touch event methods

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [_activeTextField resignFirstResponder];
    [self resetVisibleRect];
}
-(BOOL)isValidateTextField {
   
    
    if (IS_EMPTY(self.textFirstName.text) ||
        IS_EMPTY(self.textLastName.text) ||
        IS_EMPTY(self.addressLine1Txt.text) ||
        IS_EMPTY(self.textCity.text) ||
        IS_EMPTY(self.textZipCode.text)) {
        [RAZA_APPDELEGATE showMessage:@"Please Fill Information" withMode:MBProgressHUDModeText withDelay:1.5 withShortMessage:NO];
        return NO;
    }
    return YES;
}
#pragma mark -
#pragma mark UIButton action methods

- (IBAction)actionSubmit:(id)sender {
    [_activeTextField resignFirstResponder];
    
    if ([RAZA_APPDELEGATE checkNetworkPriorRequest]) {
        
        if ([self isValidateTextField]) {
            
            
        NSString *stateID = [[stateInfo allKeys] objectAtIndex:0];
        
        [RAZA_APPDELEGATE showIndeterminateMessage:MESSAGE_RECHARGE_INPROGRESS withShortMessage:NO];
        
        NSString *memberid = [[RAZA_USERDEFAULTS objectForKey:@"logininfo"] objectForKey:LOGIN_RESPONSE_ID];
        //Ask
        
        //FIXME: by making dynamic. Call get country from request before like app luanch
        
        NSString *countryID = [RazaHelper getCountryIDForCountryName:self.countryTxt.text];
        /*-----refreshinfo----*/
            
            personalinfo=[[NSMutableDictionary alloc]initWithObjectsAndKeys:self.textFirstName.text,@"personal_firstname",self.textLastName.text,@"personal_lastname",self.textStreet.text,@"personal_address",self.textCity.text,@"personal_city",stateID,@"personal_state",self.textZipCode.text,@"personal_zip",countryID,@"personl_counter",nil];
             /*-----end refreshinfo----*/
           
            
            
        [[RazaServiceManager sharedInstance] requestToUpdateBillingInfo:memberid withFirstName:self.textFirstName.text withLastName:self.textLastName.text withAddress:self.addressLine1Txt.text withCity:self.textCity.text withState:stateID withZip:self.textZipCode.text withCountry:countryID];
        
        [RazaDataModel sharedInstance].delegate = self;
            }
    }
    else {
        
        [RAZA_APPDELEGATE showAlertWithMessage:REQUEST_WITHOUT_NETWORK withTitle:@"Network Error" withCancelTitle:@"Dismiss"];
    }
}

- (IBAction)actionCountryFromButton:(UIButton *)sender {
    
    [_activeTextField resignFirstResponder];
    
    if (![RazaDataModel sharedInstance].countryFromList ||
        ![[RazaDataModel sharedInstance].countryFromList count]) {
        
        [[RazaServiceManager sharedInstance] getCountryListWithSearchType:COUNTRY_FROM_SEARCHTYPE withDestination:@"0"];
        [RazaDataModel sharedInstance].delegate = self;
    }
    else {
        [self loadCountryFromValues];
    }
}

- (IBAction)actionButtonState:(id)sender {
    
    NSString *countryName = self.countryTxt.text;
    
    if (!stateInfo || ![[stateInfo allKeys] count]) {
        
        NSDictionary *countryInfo = [NSDictionary dictionaryWithObjectsAndKeys:countryName,@"countryname", nil];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GetStateNotification" object:countryInfo];
    }
    else {
        
        NSString *stateID = [[stateInfo allKeys] objectAtIndex:0];
        
        NSString *stateName = [stateInfo objectForKey:stateID];
        
        NSDictionary *countryInfo = [NSDictionary dictionaryWithObjectsAndKeys:countryName,@"countryname",
                                     stateName, @"statename", stateID, @"stateid", nil];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GetStateNotification" object:countryInfo];
    
    
    }
    
    [self showStateListTableViewForSelectedCountry];
}

#pragma mark -
#pragma mark State list collection methods

-(void)showStateListTableViewForSelectedCountry {
    
    _stateTableView.hidden = NO;
    //_aceessTableView.hidden = YES;
    _countryTableView.hidden = YES;
    
    UIViewController *containerVC = [[UIViewController alloc]init];
    containerVC.view.backgroundColor = [UIColor clearColor];
    _stateTableView.backgroundColor=[UIColor clearColor];
    UIImageView *bgImgView=[[UIImageView alloc]initWithFrame:containerVC.view.frame];
    bgImgView.image=[UIImage imageNamed:@"Raza_BGImage.png"];
    [containerVC.view addSubview:bgImgView];
    [containerVC.view addSubview:_stateTableView];
    [containerVC.view bringSubviewToFront:_stateTableView];
    [_stateTableView reloadData];
    
    [_popoverPersonInfo setPopoverTitle:self.countryTxt.text];
    
    [_popoverPersonInfo addPopoverContent:containerVC];
    
    [_popoverPersonInfo presentInViewController:self];
}

-(void)setStateButtonTitleWithStateInfo:(NSString *)stateID withStateName:(NSString *)stateName {

    stateInfo = nil;
    
    stateInfo = [NSDictionary dictionaryWithObject:stateName forKey:stateID];
    
    [_buttonState setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    
    //_buttonState.titleLabel.text = stateName;
    self.stateTxt.text=stateName;
    

}


#pragma mark -
#pragma mark RazaStateTableViewDelegate methods

-(void)selectedRowForState:(NSString *)value withKey:(NSString *)key {
    
    [self setStateButtonTitleWithStateInfo:key withStateName:value];
    
    _stateTableView.hidden = YES;
    
    [_popoverPersonInfo dismiss];
}

-(void)updateStateInfoAndShowStateList:(NSString *)stateID withStateName:(NSString *)stateName {
    
    [self setStateButtonTitleWithStateInfo:stateID withStateName:stateName];
}

#pragma mark -
#pragma mark RazaCountryFromTableView delegate methods

-(void)selectedRowForCountry:(RazaCountryFromModel *)countryFromModel {
    
    [self.countryFromButton setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    
    self.textZipCode.keyboardType = UIKeyboardTypeDefault;
    
    if ([countryFromModel.countryName isEqualToString:@"U.S.A."]) {
        self.textZipCode.keyboardType = UIKeyboardTypeDefault;//UIKeyboardTypeNumberPad;
    }
    self.countryTxt.text=countryFromModel.countryName;
  //  [self.countryFromButton setTitle:countryFromModel.countryName forState:UIControlStateNormal];
    _countryTableView.hidden = YES;
    
    _buttonState.enabled = YES;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"GetStateNotification" object:countryFromModel];
    
    [_popoverPersonInfo dismiss];
}


#pragma mark -
#pragma mark load country from & country to methods

-(void)loadCountryFromValues {
    
    _countryTableView = [[RazaCountryFromTableView alloc] initWithFrame:CGRectMake(0, 0, APP_FRAME.size.width, APP_FRAME.size.height) withDelegate:self];
    _countryTableView.bounces=NO;
    [_activeTextField resignFirstResponder];
    
    _countryTableView.hidden = NO;
    
    UIViewController *containerVC = [[UIViewController alloc]init];
    containerVC.view.backgroundColor = [UIColor clearColor];
    _countryTableView.backgroundColor=[UIColor clearColor];
    UIImageView *bgImgView=[[UIImageView alloc]initWithFrame:containerVC.view.frame];
    bgImgView.image=[UIImage imageNamed:@"Raza_BGImage.png"];
    [containerVC.view addSubview:bgImgView];
    [containerVC.view addSubview:_countryTableView];
    
    [_popoverPersonInfo setPopoverTitle:@"Select Country"];
    
    [_popoverPersonInfo addPopoverContent:containerVC];
    
    [_popoverPersonInfo presentInViewController:self];
}

-(void)formEntry {
    
    NSDictionary *personalInfo = [RazaLoginModel sharedInstance].personalInfo;
    
    self.textFirstName.text = [personalInfo objectForKey:FIRST_NAME];
    self.textLastName.text = [personalInfo objectForKey:LAST_NAME];
    self.addressLine1Txt.text = [personalInfo objectForKey:ADDRESS];
    self.textCity.text = [personalInfo objectForKey:CITY];
    self.textZipCode.text = [personalInfo objectForKey:ZIPCODE];
    
    NSString *stateID = [personalInfo objectForKey:STATE];
    NSString *country = [personalInfo objectForKey:COUNTRY];
    
    stateInfo = [RazaHelper getStateInfoForStateKey:stateID withCountry:country];
    
    NSString *stateName = [stateInfo objectForKey:stateID];
    self.countryTxt.text=country;
    //[self.countryFromButton setTitle:country forState:UIControlStateNormal];
    self.stateTxt.text=stateName;
   // [_buttonState setTitle:stateName forState:UIControlStateNormal];
    
    UIColor *blackColor = [UIColor blackColor];
    
    [_buttonState setTitleColor:blackColor forState:UIControlStateNormal];
    [self.countryFromButton setTitleColor:blackColor forState:UIControlStateNormal];
    
    self.textZipCode.keyboardType = UIKeyboardTypeDefault;
    
    if ([country isEqualToString:@"U.S.A."]) {
        self.textZipCode.keyboardType = UIKeyboardTypeDefault;//UIKeyboardTypeNumberPad;
    }
}


#pragma mark -
#pragma RazaDataModel delegate methods

-(void)updateViewWithRequestIndentity:(NSString *)requestIndentity {
    
    _countryTableView = [[RazaCountryFromTableView alloc] initWithFrame:CGRectMake(0, 0, APP_FRAME.size.width, APP_FRAME.size.height) withDelegate:self];
    
    [_activeTextField resignFirstResponder];
    
    _countryTableView.hidden = NO;
    
    UIViewController *containerVC = [[UIViewController alloc]init];
    containerVC.view.backgroundColor = [UIColor clearColor];
    [containerVC.view addSubview:_countryTableView];
    
    [_popoverPersonInfo setPopoverTitle:@"Select Country"];
    
    [_popoverPersonInfo addPopoverContent:containerVC];
    
    [_popoverPersonInfo presentInViewController:self];
}

-(void)updateView {
    
    if ([[RazaAccountModel sharedInstance].balance length])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RechargeNotification" object:[RazaAccountModel sharedInstance].balance];
       // self.tabBarController.selectedIndex = KEYPAD_TAB;
    }
}


-(void)getDataFromModel:(NSDictionary *)info withResponseType:(NSString *)responseType {
    
    NSString *errorMessage = @"";
    
    BOOL network = [RAZA_APPDELEGATE checkNetworkPriorRequest];
    
    if ([responseType isEqualToString:@"Update_Billing_Information_V1Response"]) {
        
        NSString *memberid = [[RAZA_USERDEFAULTS objectForKey:@"logininfo"] objectForKey:LOGIN_RESPONSE_ID];
        
        NSString *userpin = [[RAZA_USERDEFAULTS objectForKey:@"logininfo"] objectForKey:LOGIN_RESPONSE_PIN];
        
        NSString *stateID = [[stateInfo allKeys] objectAtIndex:0];
        //NSString *countryValue = self.countryFromButton.titleLabel.text;
        
        NSString *countryId = [RazaHelper getCountryIDForCountryName:self.countryTxt.text];

        if ([[info objectForKey:@"status"] isEqualToString:@"1"]) {
            
            if (self.isRedeem) {
                //Make a request for redeem
                
                if (network) {
                    
                    [[RazaServiceManager sharedInstance] requestToRedeemNowWithMember:memberid withUserPin:userpin withCouponamount:self.rechargeAmount withAddress1:self.addressLine1Txt.text withAddress2:self.addressLine2Txt.text withCity:self.textCity.text withState:stateID withZip:self.textZipCode.text withCountry:countryId withIP:RAZA_APPDELEGATE.ipAddress];
                }
            }
            else if([self.rechargeAmount length]) {                
                
                NSString *cardno = [RAZA_USERDEFAULTS objectForKey:@"cardNo"];
                
                NSString *ccexpiration = [RAZA_USERDEFAULTS objectForKey:@"ccexpiration"];
                
                ccexpiration = [RAZA_APPDELEGATE getDateInMMYY:ccexpiration];
                
                NSString *ccsecurity = [RAZA_USERDEFAULTS objectForKey:@"ccsecurity"];
                
                if (network) {
                    //Make a request for Recharge
                    //requestRechargePinWithMember

                    [[RazaServiceManager sharedInstance] RechargePin:memberid withUserPin:userpin withPurchase:self.rechargeAmount withCardNumber:cardno withCardExpiry:ccexpiration withCVV:ccsecurity address1:self.addressLine1Txt.text address2:self.addressLine1Txt.text withCity:self.textCity.text withState:stateID withZip:self.textZipCode.text withCountry:countryId withIP:RAZA_APPDELEGATE.ipAddress autoRefillEnroll:_isAutoRefillEnroll];
                }
            }
        }
        else {
            
            errorMessage = [info objectForKey:@"error"];
            //[RAZA_APPDELEGATE showMessage:errorMessage withMode:MBProgressHUDModeText withDelay:1.0 withShortMessage:NO];
            [RAZA_APPDELEGATE showAlertWithMessage:errorMessage withTitle:alertTitle withCancelTitle:@"Ok"];

             [RAZA_APPDELEGATE hideIndeterminateIndicator:YES];
        }
        
        //Clean the existed personal info after updating the billing info
        
        [RazaLoginModel sharedInstance].personalInfo = nil;
        
    }
    if ([responseType isEqualToString:@"Recharge_Pin_V1Result"] || [responseType isEqualToString:@"RechargePinResult"] || [responseType isEqualToString:@"Recharge_Pin_RedeemResult"]) {
        
        [RAZA_APPDELEGATE hideIndeterminateIndicator:YES];
        
        if ([[info objectForKey:@"status"] isEqualToString:@"1"]) {
                //TODO: do something after recharge success
            personalinfo=[[NSMutableDictionary alloc]init];
            [RAZA_APPDELEGATE showAlertWithMessage:RAZARECHARGEDONE withTitle:nil withCancelTitle:@"Ok"];
            
            if (network) {
                NSMutableDictionary *oldLoginInfo = [[RAZA_USERDEFAULTS valueForKey:@"logininfo"] mutableCopy];
                [oldLoginInfo setObject:[NSNumber numberWithBool:_isAutoRefillEnroll] forKey:@"AutoRefillEnrolled"];
                [RAZA_USERDEFAULTS removeObjectForKey:@"logininfo"];
                [RAZA_USERDEFAULTS setObject:oldLoginInfo forKey:@"logininfo"];
                
                // request to get total balance after successfully recharge
                NSDictionary *loginInfo = [RAZA_USERDEFAULTS objectForKey:@"logininfo"];
                [[RazaServiceManager sharedInstance] requestToGetPinBalance:[loginInfo objectForKey:LOGIN_RESPONSE_PIN]];
                [RazaDataModel sharedInstance].delegate = self;
                [PhoneMainView.instance changeCurrentView:DialerView.compositeViewDescription];
            }
        }
        else {
            errorMessage = [info objectForKey:@"error"];
            [RAZA_APPDELEGATE showAlertWithMessage:errorMessage withTitle:alertTitle withCancelTitle:@"Ok"];
        }
    }
    if (IS_NOTEMPTY(errorMessage)) {
        
        //[RAZA_APPDELEGATE showMessage:errorMessage withMode:MBProgressHUDModeText withDelay:1 withShortMessage:NO];
       // [RAZA_APPDELEGATE showAlertWithMessage:errorMessage withTitle:alertTitle withCancelTitle:@"Ok"];
    }    
}

-(void)createInputAccessoryView
{
    
    _inputAccView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0,APP_FRAME.size.width, 40.0)];
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
    _keyboardToolbar.frame = CGRectMake(0.0, 0.0, APP_FRAME.size.width, 40.0);
    
    _keyboardToolbar.items = [NSArray arrayWithObjects:_previous,spacer, _next, nil];
    // [TODO:ios update]
    
   // UIColor *defaultColor = kColorHeader;
    
    //[_keyboardToolbar setBarTintColor:defaultColor];
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
    [self ensureVisible:_activeTextField];
    
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
    CGPoint textFieldOrigin = CGPointMake(0, 0);
    CGRect bounds = self.view.bounds;
    
    if (!IS_IPHONE_5) {
        if (_activeTextField == self.textCity ||
            _activeTextField == self.textState) {
            textFieldOrigin = [self.view convertPoint:textField.frame.origin fromView:self.textFirstName];
        }
    }
    
    if (_activeTextField == self.textCountry ||
        _activeTextField == self.textZipCode) {
        textFieldOrigin = [self.view convertPoint:textField.frame.origin fromView:self.textFirstName];
    }else {
        [self resetVisibleRect];
    }
    
    CGSize textFieldSize = textField.bounds.size;
    
    CGFloat slideValue = 0.0;
    if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation))
        slideValue = bounds.size.height - keyboardSize.height - textFieldSize.height - textFieldOrigin.y;
    else
        slideValue = bounds.size.height - keyboardSize.width - textFieldSize.height - textFieldOrigin.y;
    
    if (slideValue < 0)
        [self slideWithYValue:slideValue-2];
}

- (void)resetVisibleRect
{
    [self slideWithYValue:0];
}

- (void)slideWithYValue:(float)value
{
//    if (value==0) {
//        value=50;
//    }
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

#pragma mark - Keyboard Next/Previous Done
- (IBAction)nextButton:(id)sender
{
    if ([self.textFirstName isFirstResponder])
    {
        [self.textLastName becomeFirstResponder];
        //next.enabled = YES;
        _activeTextField = self.textLastName;
    }
    else if ([self.textLastName isFirstResponder])
    {
        [self.textStreet becomeFirstResponder];
        _activeTextField = self.textStreet;
    }
    else if ([self.addressLine1Txt isFirstResponder])
    {
        [self.addressLine2Txt becomeFirstResponder];
        _activeTextField = self.textCity;
    }
    else if ([self.addressLine2Txt isFirstResponder])
    {
        [self.textCity becomeFirstResponder];
        _activeTextField = self.textCity;
    }
    else if ([self.textCity isFirstResponder])
    {
        [self.textZipCode becomeFirstResponder];
        _activeTextField = self.textZipCode;
    }
    else if ([self.textState isFirstResponder])
    {
        [self.textZipCode becomeFirstResponder];
        _activeTextField = self.textZipCode;
    }
    else if ([self.textZipCode isFirstResponder])
    {
        [_activeTextField resignFirstResponder];
    }
    [self ensureVisible:_activeTextField];
}

- (IBAction)previosButton:(id)sender
{
    if ([self.textCountry isFirstResponder])
    {
        [self.textZipCode becomeFirstResponder];
        
        //next.enabled = YES;
    }
    else if ([self.textZipCode isFirstResponder])
    {
        [self.textCity becomeFirstResponder];
    }
    else if ([self.textState isFirstResponder])
    {
        [self.textCity becomeFirstResponder];
    }
    else if ([self.textCity isFirstResponder])
    {
        [self.addressLine2Txt becomeFirstResponder];
    }
    else if ([self.addressLine2Txt isFirstResponder])
    {
        [self.addressLine1Txt becomeFirstResponder];
    }
    else if ([self.addressLine1Txt isFirstResponder])
    {
        [self.textLastName becomeFirstResponder];
    }
    else if ([self.textLastName isFirstResponder])
    {
        [self.textFirstName becomeFirstResponder];
    }
    
    [self ensureVisible:_activeTextField];
}
static UICompositeViewDescription *compositeDescription = nil;

+ (UICompositeViewDescription *)compositeViewDescription {
    if (compositeDescription == nil) {
        compositeDescription = [[UICompositeViewDescription alloc] init:self.class
                                                              statusBar:nil
                                                                 tabBar:nil
                                                               sideMenu:SideMenuView.class
                                                             fullscreen:false
                                                         isLeftFragment:NO
                                                           fragmentWith:ContactsListView.class];
    }
    return compositeDescription;
}

- (UICompositeViewDescription *)compositeViewDescription {
    return self.class.compositeViewDescription;
}

- (IBAction)backAction:(id)sender {
    if (self.isRedeem) {
        RazaRewardPointVC *view = VIEW(RazaRewardPointVC);
        [PhoneMainView.instance popToView:view.compositeViewDescription];
    }else{
        RazaCreditCardController *view = VIEW(RazaCreditCardController);
        [PhoneMainView.instance popToView:view.compositeViewDescription];
    }

}
@end
