//
//  RazaCreditCardController.m
//  Raza
//
//  Created by Praveen S on 11/23/13.
//  Copyright (c) 2013 Raza. All rights reserved.
//

#import "RazaCreditCardController.h"
#import "RazaPersonInfoViewController.h"
//#import "RazaTermsVC.h"
//#import "RazaAppDelegate.h"
#import "PhoneMainView.h"
@interface RazaCreditCardController ()

@end

@implementation RazaCreditCardController

//static NSString *CellIdentifier = @"AccountCell";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Recharge" image:[UIImage imageNamed:@"recharge.png"] tag:3];
    }
    return self;
}

#pragma mark -
#pragma mark View methods
-(void)clear{
    _textFieldCreditCard.text =@"";
    _textFieldMonth.text=@"";
    _textFieldYear.text=@"";
    _textFieldSecurity.text=@"";
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    rechargeAmountArray=[[NSMutableArray alloc]initWithObjects:@"10",@"20",@"50",@"90",@"100", nil];
    [self.tableView registerClass: [UITableViewCell class] forCellReuseIdentifier:@"PointsCell"];
    
    isAutoFillEnroll=NO;
    
    
    
    [self createInputAccessoryView];
    [self registerForKeyboardNotifications];
    
    //self.containerView.layer.cornerRadius = 10.0;
    self.checkBoxLabel.text = @"\u2610";
    
    // Do any additional setup after loading the view from its nib.
    
    _defaultAmounts = [NSArray arrayWithObjects:@"10", @"20", @"50", @"90", @"100", nil];
    
    NSDictionary *rateDict = [NSDictionary dictionaryWithObjects:_defaultAmounts forKeys:_defaultAmounts];
    
    if (!IS_IPHONE_5) {
        //do
        self.containerView.frame = IPHONE4_FRAME(self.containerView, 0, 0, 0, 95);
        
    }
    
    _ratePickerVC = [[RazaPickerViewController alloc] initWithDataDictionary:rateDict];
    _ratePickerVC.razapickerdelegate = self;
    //[self navigatetosidebar];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    CAGradientLayer *gradient = [BackgroundLayer navHeaderGradient];
    gradient.frame = self.headerView.bounds;
    gradient.startPoint = CGPointMake(0.0, 0.0);
    gradient.endPoint = CGPointMake(0.0, 1.0);
    gradient.locations = @[@0.0,@1.0];
    [self.headerView.layer insertSublayer:gradient atIndex:0];
    
    CAGradientLayer *gradient1 = [BackgroundLayer linearGradient];
    gradient1.frame = _buttonSubmit.bounds;
    gradient1.startPoint = CGPointMake(0.0,0.0);
    gradient1.endPoint = CGPointMake(1.0,0.0);
    [_buttonSubmit.layer insertSublayer:gradient1 atIndex:0];
    
    if ([RazaAccountModel sharedInstance].balance.length>0) {
        self.balanceLbl.text=[NSString stringWithFormat:@"$%@",[RazaAccountModel sharedInstance].balance];
    }else{
        self.balanceLbl.text=@"$0";
    }
    [Razauser SharedInstance].sideBarIndex=1;
    
    checkvalidcreditcard=[[globalnetworkclass alloc]init];
    [checkvalidcreditcard validation_check:@""];
    self.title = @"Recharge";
    check=NO;
    //    self->navigationItemCompose = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"settings.png"] style:UIBarButtonItemStylePlain target:self action:@selector(onButtonrazasetting)];
    //    self.navigationItem.rightBarButtonItem = self->navigationItemCompose;
    
    
    NSMutableDictionary *oldLoginInfo = [[RAZA_USERDEFAULTS valueForKey:@"logininfo"] mutableCopy];
    BOOL isAutoRefillEnrolled=[[oldLoginInfo objectForKey:@"AutoRefillEnrolled"] boolValue];
    if (isAutoRefillEnrolled) {
        self.autoRechargeView.hidden=YES;
        self.nextBtnTopConst.constant=50;
    }else{
        self.autoRechargeView.hidden=NO;
        self.nextBtnTopConst.constant=167;
    }
    
}
-(void)checkcreditcard:(NSString*)creditcardnumber{
    if (creditcardnumber.length>=12) {
        if ([checkvalidcreditcard validation_check:creditcardnumber]) {
            self.creditcardinfo.textColor = [UIColor colorWithRed:73/255.0 green:211/255.0 blue:33/255.0  alpha:1];
            self.creditcardinfo.text=validcreditcard;
            
        }
        else
        {
            self.creditcardinfo.textColor = [UIColor colorWithRed:208/255.0 green:2/255.0 blue:27/255.0  alpha:1];
            self.creditcardinfo.text=INvalidcreditcard;
        }
    }
    else
    {
        self.creditcardinfo.textColor = [UIColor colorWithRed:208/255.0 green:2/255.0 blue:27/255.0  alpha:1];
        self.creditcardinfo.text=INvalidcreditcard;
        
    }
    
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark UITextField delegate methods
//-(void)onButtonrazasetting
//{
//  RazaSettingsViewController  *settingVC = [[RazaSettingsViewController alloc] initWithNibName: @"RazaSettingsViewController" bundle:nil];
//
//[self.navigationController pushViewController:settingVC animated:YES];
//}
-(void)textFieldDidBeginEditing:(UITextField *)textField {
    
    _activeTextField = textField;
    if (keyboardVisible)
        [self ensureVisible:textField];
    [textField setInputAccessoryView:_inputAccView];
    [textField setEnablesReturnKeyAutomatically:YES];
    
    if (textField.tag == MONTH_TEXT || textField.tag == YEAR_TEXT) {
        self.containerView.hidden = YES;
        self.balanceView.hidden=YES;
        self.pickerExpiration.hidden = NO;
        [self updatedone];
        //FIXME: Objective to add PickerView as input view to textfield
        [textField resignFirstResponder];
        
        
    }
    if (textField.tag == CODE_TEXT) {
        
        self.containerView.frame = CGRectOffset(self.containerView.frame, 0, -60);
    }
    if (textField.tag == AMOUNT_TEXT) {
        
        [textField resignFirstResponder];
        
        _popoverRateList = [[PopoverViewController alloc] initWithFrame:CGRectMake(0, 0, APP_FRAME.size.width, APP_FRAME.size.height) withToolbar:NO];
        
        _popoverRateList.title = @"Recharges";
        
        [_popoverRateList addPopoverContent:_ratePickerVC];
        
        [_popoverRateList presentInViewController:self];
    }
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    if (textField.tag == MONTH_TEXT || textField.tag == YEAR_TEXT) {
        
        [_activeTextField resignFirstResponder];
        //y=500
        self.pickerExpiration.frame = CGRectMake(0, 0, self.pickerExpiration.frame.size.width, self.pickerExpiration.frame.size.height);
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:.10];
        [UIView setAnimationDelegate:self];
        //y==200
        self.pickerExpiration.frame = CGRectMake(0, 0, self.pickerExpiration.frame.size.width, self.pickerExpiration.frame.size.height);
        //[self.view addSubview:self.pickerExpiration];
        [UIView commitAnimations];
        return YES;
    }
    
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    _activeTextField = nil;
    
    NSString *newString ;
    if ([_textFieldCreditCard.text length]) {
        newString  = _textFieldCreditCard.text;
    }
    else
        newString=@"3";
    //[self updateTextLabelsWithText: newString];
    
    [self checkcreditcard:newString];
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark -
#pragma mark UIButton action methods

- (IBAction)actionTerms:(id)sender {
    
    // RazaTermsVC *termVC = [[RazaTermsVC alloc]initWithNibName:@"RazaTermsVC" bundle:nil];
    //[self.navigationController pushViewController:termVC animated:YES];
    //[self.navigationController presentViewController:termVC animated:YES completion:nil];
    RazaTermsVC *view = VIEW(RazaTermsVC);
    [PhoneMainView.instance changeCurrentView:view.compositeViewDescription];
}

- (IBAction)actionSubmit:(id)sender {
    
    BOOL network = [RAZA_APPDELEGATE checkNetworkPriorRequest];
    
    if (network) {
        
        if ([self isValidateTextField]) {
            
            NSString *cardexpiry = [self.textFieldMonth.text stringByAppendingString:[NSString stringWithFormat:@"/%@", self.textFieldYear.text]];
            NSArray *keyArray = @[@"cardNo",@"ccexpiration",@"ccsecurity"];
            NSArray *valueArray = @[self.textFieldCreditCard.text, cardexpiry, self.textFieldSecurity.text];
            
            NSDictionary *cardInfo = [NSDictionary dictionaryWithObjects:valueArray forKeys:keyArray];
            [RAZA_USERDEFAULTS setValuesForKeysWithDictionary:cardInfo];
            
            [RAZA_APPDELEGATE showIndeterminateMessage:MESSAGE_FETCHING_BILLING_INFO withShortMessage:NO];
            
            //Request to get the billing info first
            //FIXME: Why to call getBillingInfo, when we have already called at login
            //Answer: Because you would not get the update billing info untill unless the user logged-in again
            
            NSDictionary *loginInfo = [RAZA_USERDEFAULTS objectForKey:@"logininfo"];
            
            [[RazaServiceManager sharedInstance] requestToGetBillingInfo:[loginInfo objectForKey:LOGIN_RESPONSE_ID]];
            [RazaDataModel sharedInstance].delegate = self;
            [_activeTextField resignFirstResponder];
            
        }
    }
    else {
        
        [RAZA_APPDELEGATE showAlertWithMessage:REQUEST_WITHOUT_NETWORK withTitle:@"Network Error" withCancelTitle:@"Dismiss"];
    }
    
    
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    NSString *strofcredit;
    UILabel  * label = [[UILabel alloc] initWithFrame:CGRectMake(40, 70, 300, 100)];
    
    if(textField.tag == CREDIT_TEXT)
    {
        [label setText:[textField.text stringByReplacingCharactersInRange:range withString:string]];
        strofcredit = label.text;
    }
    else
        strofcredit=_textFieldCreditCard.text;
    
    
    if(textField.tag == CREDIT_TEXT){
        if (_textFieldCreditCard.text.length >= MAX_LENGTH && range.length == 0){
            
            [RAZA_APPDELEGATE showMessage:@"Max 20 Digits" withMode:MBProgressHUDModeText withDelay:1.5 withShortMessage:YES];
            return NO; // return NO to not change text
        }
        else
        {
            return YES;
            
        }
    }
    if(textField.tag==CODE_TEXT)
    {
        NSUInteger newLength = [self.textFieldSecurity.text length] + [string length] - range.length;
        return newLength <= 4;
    }
    
    return YES;
    
}

- (IBAction)buttonDone:(id)sender {
    
}

#pragma mark -
#pragma mark Touch event methods

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [_activeTextField resignFirstResponder];
    
    [self resetVisibleRect];
}

#pragma mark -
#pragma mark Custom methods

-(BOOL)isValidateTextField {
    //NSString *forvalue=self.buttonAmount.titleLabel.text;
    NSString *forvalue;
    if ([strofchkval length])
        forvalue=strofchkval;
    else
        forvalue=self.selectedAmountLbl.text;
    if ([forvalue isEqual:@"Select amount"]){
        [RAZA_APPDELEGATE showAlertWithMessage:@"Please select amount" withTitle:@"" withCancelTitle:@"Ok"];
        return NO;
    }else if (IS_EMPTY(self.textFieldCreditCard.text)) {
        [RAZA_APPDELEGATE showAlertWithMessage:@"Please enter credit card" withTitle:@"" withCancelTitle:@"Ok"];
        return NO;
    }else if (IS_EMPTY(self.textFieldMonth.text)){
        [RAZA_APPDELEGATE showAlertWithMessage:@"Please select expiry month" withTitle:@"" withCancelTitle:@"Ok"];
        return NO;
    }else if (IS_EMPTY(self.textFieldYear.text)){
        [RAZA_APPDELEGATE showAlertWithMessage:@"Please select expiry year" withTitle:@"" withCancelTitle:@"Ok"];
        return NO;
    }else if (IS_EMPTY(self.textFieldSecurity.text)){
        [RAZA_APPDELEGATE showAlertWithMessage:@"Please enter security code" withTitle:@"" withCancelTitle:@"Ok"];
        return NO;
    }else if (_textFieldCreditCard.text.length<12){
        [RAZA_APPDELEGATE showAlertWithMessage:@"Please enter valid credit card" withTitle:@"" withCancelTitle:@"Ok"];
        return NO;
    }else if (_textFieldCreditCard.text.length>=12) {
        if (![checkvalidcreditcard validation_check:_textFieldCreditCard.text]) {
            [RAZA_APPDELEGATE showAlertWithMessage:@"Please enter valid credit card" withTitle:@"" withCancelTitle:@"Ok"];
            return NO;
        }
    }
    
    
    
    return YES;
}


#pragma mark -
#pragma mark Keyboard Toolbar design methods

-(void)createInputAccessoryView{
    
    _inputAccView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0,APP_FRAME.size.width, 44.0)];
    [_inputAccView setBackgroundColor:[UIColor clearColor]];
    [_inputAccView setAlpha: 1.0];
    
    
    UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIBarButtonItem *doneBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(doneButtonAction:)];
    
    [doneBarButton setBackgroundImage:[[UIImage alloc] init] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    [doneBarButton setTintColor:Kcolorforkeyboardtoolabr];
    
    
    [_keyboardToolbar removeFromSuperview];
    _keyboardToolbar = [[UIToolbar alloc] init];
    _keyboardToolbar.frame = CGRectMake(0.0, 0.0, APP_FRAME.size.width, 44.0);
    CAGradientLayer *gradient = [BackgroundLayer navHeaderGradient];
    gradient.frame = _keyboardToolbar.bounds;
    gradient.startPoint = CGPointMake(0.0, 0.0);
    gradient.endPoint = CGPointMake(0.0, 1.0);
    gradient.locations = @[@0.0,@1.0];
    [_keyboardToolbar.layer insertSublayer:gradient atIndex:0];
    _keyboardToolbar.items = [NSArray arrayWithObjects:flex, doneBarButton, nil];
    
    // [TODO:ios update]
    
    
    
    [_keyboardToolbar setBarTintColor:kColorKeyboard];
    [_keyboardToolbar setBarStyle:UIBarStyleDefault];
    [_keyboardToolbar setBackgroundColor:kColorKeyboard];
    
    [_inputAccView addSubview:_keyboardToolbar];
}

-(void)doneButtonAction:(UIBarButtonItem *)sender {
    
    [_activeTextField resignFirstResponder];
    [self.view endEditing:YES];
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
    CGRect bounds = self.containerView.bounds;
    if (_activeTextField == self.textFieldCreditCard ||
        _activeTextField == self.textFieldSecurity) {
        textFieldOrigin = [self.containerView convertPoint:textField.frame.origin fromView:_labelSelectAmount];
    }
    else {
        [self resetVisibleRect];
    }
    
    CGSize textFieldSize = textField.bounds.size;
    
    CGFloat slideValue = 0.0;
    if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation))
        slideValue = bounds.size.height - keyboardSize.height - textFieldSize.height - textFieldOrigin.y-10;
    else
        slideValue = bounds.size.height - keyboardSize.width - textFieldSize.height - textFieldOrigin.y-10;
    
    if (slideValue < 0)
    {
        [self slideWithYValue:slideValue - 2];
        //        float yscale = IS_IPHONE_5 ? 28.0 : -100.0;
        //        [self slideWithYValue:yscale];
        
    }
}

- (void)resetVisibleRect
{
    [self slideWithYValue:0.0];
}

- (void)slideWithYValue:(float)value
{
    CGRect bounds = self.containerView.frame;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation))
        [self.containerView setFrame:CGRectMake(self.containerView.frame.origin.x, value, bounds.size.width, bounds.size.height)];
    else
        [self.containerView setFrame:CGRectMake(self.containerView.frame.origin.x, 64, bounds.size.width, bounds.size.height)];
    [UIView commitAnimations];
}

-(void)updateView {
    //do something
    
    [RAZA_APPDELEGATE hideIndeterminateIndicator:YES];
    NSLog(@"%@",[RazaLoginModel sharedInstance].firstName);
    //    RazaPersonInfoViewController *personInfoVC = [[RazaPersonInfoViewController alloc]initWithNibName:@"RazaPersonInfoViewController" bundle:nil];
    //    personInfoVC.rechargeAmount = self.buttonAmount.titleLabel.text;
    //    [self.navigationController pushViewController:personInfoVC animated:YES];
    RazaPersonInfoViewController *view = VIEW(RazaPersonInfoViewController);
    view.rechargeAmount = self.selectedAmountLbl.text;
    view.isAutoRefillEnroll=isAutoFillEnroll;
    [PhoneMainView.instance changeCurrentView:view.compositeViewDescription];
}

#pragma mark -
#pragma mark RazaPickerViewDelegate methods

-(void)razaPickerViewSelected:(NSString *)selectedValue {
    strofchkval=selectedValue;
    //[self.buttonAmount setTitle:selectedValue forState:UIControlStateNormal];
    self.selectedAmountLbl.text=selectedValue;
    
    [_popoverRateList dismiss];
}

-(BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)thePopoverController{
    return YES;
}

#pragma mark -
#pragma mark Button action methods

-(void)actionAmount:(id)sender {
    ////    _popoverRateList = [[PopoverViewController alloc] initWithFrame:CGRectMake(0, 0, APP_FRAME.size.width, APP_FRAME.size.height) withToolbar:NO];
    //    _popoverRateList = [[PopoverViewController alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHIGHT) withToolbar:NO];
    //    //  _popoverRateList.=CGPointMake(APP_FRAME.size.width/2, APP_FRAME.size.height/2);
    //    [_popoverRateList addPopoverContent:_ratePickerVC];
    //    [_popoverRateList presentInViewController:self];
    
    self.tableView.hidden=NO;
    
}
-(void)Submitcreditcard
{
    [containerViewmy removeFromSuperview];
    NSString *strtoyear,*strtomonth;
    
    if ([self.pickerExpiration.selectedMonth length])
    {
        strtomonth=nil;
        strtoyear=nil;
        
    }
    else
    {
        self.pickerExpiration.selectedMonth =self.pickerExpiration.selfselectedMonth;
        self.pickerExpiration.selectedYear=self.pickerExpiration.selfselectedYear;
    }
    
    if (self.pickerExpiration.selectedMonth !=nil)
    {
        if ([checkvalidcreditcard checkvaliddate:self.pickerExpiration.selectedMonth andyearval:self.pickerExpiration.selectedYear])
        {
            [self calltocheckvaliddate];
        }
        else
            [RAZA_APPDELEGATE showMessage:@"Invalid date" withMode:MBProgressHUDModeText withDelay:1.5 withShortMessage:YES];
    }
    else
        [self calltocheckvaliddate];
    
}
-(void)calltocheckvaliddate
{
    self.navigationItem.rightBarButtonItem=nil;
    self.textFieldMonth.text = self.pickerExpiration.selectedMonth;
    self.textFieldYear.text = self.pickerExpiration.selectedYear;
    
    self.pickerExpiration.hidden = YES;
    self.containerView.hidden = NO;
    self.balanceView.hidden=NO;
    
}

-(void)updatedone{
    containerViewmy = [[UIView alloc] initWithFrame:CGRectMake(0, -20, SCREENWIDTH, 64)];
    [containerViewmy setBackgroundColor:kColorHeader];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self
               action:@selector(Submitcreditcard)
     forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal ];
    [button setTitle:@"Done" forState:UIControlStateNormal];
    button.frame = CGRectMake(SCREENWIDTH-60, 20, 50, 44);
    [button.titleLabel setFont:[UIFont fontWithName:@"SourceSansPro-Bold" size:18]];
    
    CAGradientLayer *gradient = [BackgroundLayer navHeaderGradient];
    gradient.frame = containerViewmy.bounds;
    gradient.startPoint = CGPointMake(0.0, 0.0);
    gradient.endPoint = CGPointMake(0.0, 1.0);
    gradient.locations = @[@0.0,@1.0];
    [containerViewmy.layer insertSublayer:gradient atIndex:0];
    
    [containerViewmy addSubview:button];
    [self.view addSubview:containerViewmy];
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
    UICompositeView *cvc = PhoneMainView.instance.mainViewController;
    [cvc hideSideMenu:(cvc.sideMenuView.frame.origin.x == 0)];
}

- (IBAction)autoRechargeBtnAction:(id)sender {
    if (self.autoRechargeBtn.selected==YES) {
        isAutoFillEnroll=NO;
        self.autoRechargeBtn.selected=NO;
    }else{
        isAutoFillEnroll=YES;
        self.autoRechargeBtn.selected=YES;
    }
}
- (IBAction)securityAction:(id)sender {
    self.cvvView.hidden=NO;
    [self.view endEditing:YES];
}
- (IBAction)closeCVVViewAction:(id)sender {
    self.cvvView.hidden=YES;
}

#pragma mark -
#pragma mark UITableView delegate & datasource methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [rechargeAmountArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"PointsCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.textColor=OxfordBlueColor;
    cell.textLabel.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:18];
    cell.textLabel.text=[NSString stringWithFormat:@"$%@",rechargeAmountArray[indexPath.row]];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.tableView.hidden=YES;
    self.selectedAmountLbl.text=rechargeAmountArray[indexPath.row];
}

@end
