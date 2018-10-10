    //
//  RazaFreePointLoginVC.m
//  Raza
//
//  Created by Praveen S on 11/17/13.
//  Copyright (c) 2013 Raza. All rights reserved.
//

#import "RazaFreePointLoginVC.h"
#import "RazaServiceManager.h"
#import "RazaDataModel.h"
#import "RazaLoginModel.h"
//#import "RazaTabBarController.h"

@interface RazaFreePointLoginVC ()

@end

@implementation RazaFreePointLoginVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.backgroundColor = [UIColor whiteColor];
        
    }
    return self;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark view methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Free Login";
    self.loginOverlay.layer.cornerRadius = 10.0;
    self.loginOverlay.center = self.view.center;
    // Do any additional setup after loading the view from its nib.
    [self createInputAccessoryView];
}

-(void)viewWillAppear:(BOOL)animated {
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    [self registerForKeyboardNotifications];
}

#pragma mark -
#pragma mark UITextFieldDelegate methods

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    activeField = textField;
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
    
    _inputAccView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, APP_FRAME.size.width, 44.0)];
    [_inputAccView setBackgroundColor:[UIColor clearColor]];
    [_inputAccView setAlpha: 1.0];
    
    _previous = [[UIBarButtonItem alloc] initWithTitle:@"Previous" style:UIBarButtonItemStyleBordered target:self action:@selector(previosButton:)];
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    _next = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStyleBordered target:self action:@selector(nextButton:)];
    [_keyboardToolbar removeFromSuperview];
    _keyboardToolbar = [[UIToolbar alloc] init];
    _keyboardToolbar.frame = CGRectMake(0.0, 0.0, APP_FRAME.size.width, 44.0);
    
    _keyboardToolbar.items = [NSArray arrayWithObjects:_previous,spacer, _next, nil];
    [_keyboardToolbar setBarStyle:UIBarStyleBlack];
    [_keyboardToolbar setBackgroundColor:[UIColor clearColor]];
    
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
        [self.passwordTF becomeFirstResponder];
        //next.enabled = YES;
        activeField = self.passwordTF;
    }
    else if ([self.passwordTF isFirstResponder])
    {
        [self.phoneTF becomeFirstResponder];
        activeField = self.phoneTF;
    }
    else if ([self.phoneTF isFirstResponder])
    {
        [self.emailTF becomeFirstResponder];
        activeField = self.emailTF;
    }
    [self ensureVisible:activeField withPrevious:NO];
}

- (IBAction)previosButton:(id)sender
{
    if ([self.passwordTF isFirstResponder])
    {
        [self.emailTF becomeFirstResponder];
        //next.enabled = YES;
    }
    else if ([self.phoneTF isFirstResponder])
    {
        [self.passwordTF becomeFirstResponder];
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
        [self slideWithYValue:slideValue - 5];
}

- (void)resetVisibleRect
{
    [self slideWithYValue:0.0];
}

- (void)slideWithYValue:(float)value
{
    CGRect bounds = APP_FRAME;
    
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
    
    //To check if all field is entered
    if ([self validateTextField]) {
        [[RazaServiceManager sharedInstance] requestLoginWithUserName:self.emailTF.text withPassword:self.passwordTF.text withPhone:self.phoneTF.text withDeviceId:RAZA_APPDELEGATE.deviceID];
        [RazaDataModel sharedInstance].delegate = self;
    } else {
        [RAZA_APPDELEGATE showMessage:self.errorMessage withMode:MBProgressHUDModeText withDelay:1 withShortMessage:YES];
    }
}

-(BOOL)validateTextField {
    
    self.errorMessage = @"";
    if (![self.emailTF.text length] && ![self.passwordTF.text length] && ![self.phoneTF.text length]) {
        self.errorMessage = @"All fields are required";
        return NO;
    } else {
        if (![self.emailTF.text length]){
            //serverIV.hidden = YES;
            self.errorMessage = @"Email cannot be empty";
            return NO;
        }
        
        if (![self.passwordTF.text length]) {
            self.errorMessage = @"Password cannot be empty";
            return NO;
        }
        if (![self.phoneTF.text length]) {
            self.errorMessage = @"Phone number cannot be empty";
            return NO;
        }
    }
    
    return YES;
}

-(void)getDataFromModel:(NSDictionary *)info withResponseType:(NSString *)responseType {
    
    NSString *error = @"";
    
//    [RAZA_USERDEFAULTS setObject:[RazaLoginModel sharedInstance].sessionid forKey:@"sessionid"];
//    [RAZA_USERDEFAULTS setObject:[RazaLoginModel sharedInstance].status forKey:@"status"];
//    [RAZA_USERDEFAULTS setObject:[RazaLoginModel sharedInstance].memberid forKey:@"memberid"];
    
    BOOL network = [RAZA_APPDELEGATE checkNetworkPriorRequest];
    
    if (network) {
        
        loginInfo = [RAZA_USERDEFAULTS objectForKey:@"logininfo"];
        
        if ([responseType isEqualToString:@"LoginResult"]) {
            if ([loginInfo objectForKey:LOGIN_RESPONSE_STATUS] && [[loginInfo objectForKey:LOGIN_RESPONSE_STATUS] isEqualToString:@"1"]) {
                
               // RAZA_APPDELEGATE.isLoggedIn = [[loginInfo objectForKey:LOGIN_RESPONSE_STATUS] boolValue];
                
            //    [RAZA_APPDELEGATE showIndeterminateMessage:@"Logging in..." withShortMessage:NO];
                
                [self initialRequestBeforeAddressBook];
                
            }
            else
            {
                error = [info objectForKey:@"error"];
            }
        }
        
        if (error && [error length]) {
            
            [RAZA_APPDELEGATE showMessage:[info objectForKey:@"error"] withMode:MBProgressHUDModeText withDelay:1 withShortMessage:NO];
        }
    }
    
}

-(void)receivedDataFromService:(NSDictionary *)info withResponseType:(NSString *)responseType {
    if ([responseType isEqualToString:@"Does_FreeTrial_Exist_V1Result"]) {
        
        [RAZA_APPDELEGATE hideIndeterminateIndicator:YES];
        
        if (!([[info objectForKey:@"result"] isEqualToString:@"y"]) && !([[info objectForKey:@"status"] isEqualToString:@"1"])) {
            //do nothing
            //TOASK: Why do We need to call requestToGetBillingInfo on login why not on recharge pin
            //[[RazaServiceManager sharedInstance] requestToGetBillingInfo:[loginInfo objectForKey:@"id"]];
            //TODO: In old app after getting billing info; the Recharge_Pin_FreeTrial request was made.
        }
//        RazaTabBarController *tabbarController = [[RazaTabBarController alloc]initWithNibName:@"RazaTabBarController" bundle:nil];
//        [self.navigationController presentViewController:tabbarController animated:YES completion:nil];
    }
}

-(void)initialRequestBeforeAddressBook {
    //To check Free trial exist
    
    BOOL network = [RAZA_APPDELEGATE checkNetworkPriorRequest];
    
    if (network) {
        [[RazaServiceManager sharedInstance] requestFreeTrialExistWithMemberId:[loginInfo objectForKey:LOGIN_RESPONSE_ID]];
        [RazaServiceManager sharedInstance].delegate = self;
    }
    else {
        [RAZA_APPDELEGATE hideIndeterminateIndicator:YES];
    }
   
    
    //To check get pin balance
    
    //[[RazaServiceManager sharedInstance] requestToGetPinBalance:[loginInfo objectForKey:@"pin"]];
//    [RazaServiceManager sharedInstance].delegate = self;
}

-(void)updateView {
    
    [RAZA_APPDELEGATE hideIndeterminateIndicator:YES];
    
    if ([loginInfo objectForKey:LOGIN_RESPONSE_STATUS] && [[loginInfo objectForKey:LOGIN_RESPONSE_STATUS] isEqualToString:@"1"]) {
        
        //To check Free trial exist
        
        BOOL network = [RAZA_APPDELEGATE checkNetworkPriorRequest];
        if (network) {
            [[RazaServiceManager sharedInstance] requestFreeTrialExistWithMemberId:[RazaLoginModel sharedInstance].memberid];
        }
        
//        RazaTabBarController *tabbarController = [[RazaTabBarController alloc]initWithNibName:@"RazaTabBarController" bundle:nil];
//        [self.navigationController presentViewController:tabbarController animated:YES completion:nil];
    }
    else {
       
        [RAZA_APPDELEGATE showMessage:ERROR_USERNAME_PWD withMode:MBProgressHUDModeText withDelay:1 withShortMessage:YES];
    }
}
- (IBAction)actionForgotPassword:(id)sender
{}

@end
