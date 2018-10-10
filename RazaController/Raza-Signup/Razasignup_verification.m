//
//  Razasignup_verification.m
//  Raza
//
//  Created by umenit on 8/3/15.
//  Copyright (c) 2015 Raza. All rights reserved.
//

#import "Razasignup_verification.h"
#import "PhoneMainView.h"
@interface Razasignup_verification ()

@end

@implementation Razasignup_verification

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    CAGradientLayer *gradient1 = [BackgroundLayer linearGradient];
    gradient1.frame = self.verifyBtn.bounds;
    gradient1.startPoint = CGPointMake(0.0,0.0);
    gradient1.endPoint = CGPointMake(1.0,0.0);
    [self.verifyBtn.layer insertSublayer:gradient1 atIndex:0];
    // Do any additional setup after loading the view from its nib.
    _smstext.delegate=self;

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
   // _smstext.text=[dictforsignupsms objectForKey:@"key_verifiedsms"];
    
    self.textWithPhoneLbl.attributedText=[self getAttributedText:@"A text message with your verification code has been sent to " secondStr:[NSString stringWithFormat:@"%@:",[dictforsignupsms objectForKey:@"key_mobile"]]];
    
}
-(void)issueNewPin:(NSDictionary *)info withResponseType:(NSString *)responseType {
    dictForMemberId  =[[NSMutableDictionary alloc]init];
    [dictForMemberId addEntriesFromDictionary:info];
    
    if ([[info objectForKey:@"ResponseCode"] isEqualToString:@"0"]) {
        [HUD hide:YES];
        [RAZA_APPDELEGATE showAlertWithMessage:[info objectForKey:@"ResponseMessage"] withTitle:@"Register" withCancelTitle:@"Ok"];
    }
    else {
        
        
       // HUD = [[MBProgressHUD alloc] initWithView:self.view];
        //[self.view addSubview:HUD];
          // [HUD show:YES];
        [RazaServiceManager sharedInstance].delegate = self;
        
        NSString *countryFromID = [dictforsignupsms objectForKey:@"key_countryfrom"];
        NSString *countryToID = [dictforsignupsms objectForKey:@"key_countryto"];
        NSString *phonenumber = [dictforsignupsms objectForKey:@"key_mobile"];
        
        //   [[RazaServiceManager sharedInstance] requestToIssueNewPin:self.emailTextField.text withPassword:self.pwdTextField.text withPhone:self.phoneTextField.text withCallingFromCountry:countryFromID withCallingToCountry:countryToID withDeviceId:RAZA_APPDELEGATE.deviceID];
        
        [[RazaServiceManager sharedInstance] requestToIssueNewPin:[info objectForKey:@"Id"] withPhone:phonenumber withCallingFromCountry:countryFromID withCallingToCountry:countryToID withCountry:countryFromID withDeviceId:RAZA_APPDELEGATE.deviceID];
    }
    
    
}

-(void)dismissKeyboard {
    [_smstext resignFirstResponder];
}


- (void)viewWillAppear:(BOOL)animated
{
    [[self navigationController] setNavigationBarHidden:YES animated:YES];

}
-(void)backtohome
{
    
    // [self.navigationController popViewControllerAnimated:YES];
    RazaSignUpViewController *view = VIEW(RazaSignUpViewController);
    [PhoneMainView.instance popToView:view.compositeViewDescription];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)signupwithsms:(id)sender {
    [_smstext resignFirstResponder];
    if ([_smstext.text length])
    {
        [RazaServiceManager sharedInstance].delegate = self;
        
        
        if ([RAZA_APPDELEGATE checkNetworkPriorRequest])
        {


            // "key_countryfrom" = 1;
            HUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:HUD];
            [HUD show:YES];

            
            //requestToCustomer_SignUp_V1
            [[RazaServiceManager sharedInstance]CustomerSignUp_V2:[dictforsignupsms objectForKey:@"key_emailid"] withPhone:[dictforsignupsms objectForKey:@"key_mobile"] withCountrycode:[dictforsignupsms objectForKey:@"key_countryfrom"] withVerificationcode:_smstext.text withDevice_PhoneNumber:[dictforsignupsms objectForKey:@"key_mobile"] withDeviceIP_Address:RAZA_APPDELEGATE.getIPAddress withDeviceIMEI_Number:@"" withClientDateTime:RAZA_APPDELEGATE.getTime withDeviceLongitude_Latitude:RAZA_APPDELEGATE.latitudelongitude];
            [RazaDataModel sharedInstance].delegate = self;
        }

    }
    else if ([_smstext.text isEqualToString:@""])
    {
         [RAZA_APPDELEGATE showAlertWithMessage:@"Please verify verification code" withTitle:@"signup" withCancelTitle:@"Ok"];
       
 
    }
    else
    {
        [RAZA_APPDELEGATE showAlertWithMessage:@"Invalid verification code" withTitle:@"signup" withCancelTitle:@"Ok"];
    }
    
    
}
-(void)getDataFromModelforsignup:(NSDictionary *)info withResponseType:(NSString *)responseType {
    
    if ([info objectForKey:@"error"]) {
        
        [RAZA_APPDELEGATE showAlertWithMessage:[info objectForKey:@"error"] withTitle:@"signup" withCancelTitle:@"Ok"];
    }
    else {
      
//        [RazaDataModel sharedInstance].delegate = self;
//     
//        
//                [RazaHelper registerAccountToSIPServerWithEmail:[dictforsignupsms objectForKey:@"key_emailid"] withPassword:[dictforsignupsms objectForKey:@"key_password"] withPhoneNumber:[dictforsignupsms objectForKey:@"key_mobile"]];
//        
//                [UIView animateWithDuration:0.5f
//                                 animations:^{
//        
//                                     [RAZA_APPDELEGATE showAlertWithMessage:MESSAGE_REGISTERED_SUCCESS withTitle:@"Register" withCancelTitle:@"Proceed to Login"];
//        
//                                 }
//                                 completion:^(BOOL finished) {
//                                     if (finished) {
//        
////                                         UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:[NSBundle mainBundle]];
////                                         RazaHomeViewController *vc =[storyboard instantiateInitialViewController];
////        
////                                         RAZA_APPDELEGATE.navcontroller = [[UINavigationController alloc] initWithRootViewController:vc];
////                                         RAZA_APPDELEGATE.window.rootViewController = RAZA_APPDELEGATE.navcontroller;
//                                         
//                                            [RAZA_APPDELEGATE setcontroller:@"Main_iPhone"];
//                                     }
//                                 }];
        
        /*for login---------*/
    
        
       
       
    }
}
-(void)getDataFromModel:(NSDictionary *)info withResponseType:(NSString *)responseType {
       [HUD hide:YES];
    if ([info objectForKey:@"error"]) {
        
        [RAZA_APPDELEGATE showAlertWithMessage:[info objectForKey:@"error"] withTitle:@"signup" withCancelTitle:@"Ok"];
    }
    else {
        
        // [RazaDataModel sharedInstance].delegate = self;
        
        
        //     [RazaHelper registerAccountToSIPServerWithEmail:[dictforsignupsms objectForKey:@"key_emailid"] withPassword:[dictforsignupsms objectForKey:@"key_password"] withPhoneNumber:[dictforsignupsms objectForKey:@"key_mobile"]];
//        
//        [UIView animateWithDuration:0.5f
//                         animations:^{
//                             
//                             [RAZA_APPDELEGATE showAlertWithMessage:MESSAGE_REGISTERED_SUCCESS withTitle:@"Register" withCancelTitle:@"Proceed to Login"];
//                             
//                         }
//                         completion:^(BOOL finished) {
//                             if (finished) {
//                                 
//                                 UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:[NSBundle mainBundle]];
//                                 RazaHomeViewController *vc =[storyboard instantiateInitialViewController];
//                                 
//                                 RAZA_APPDELEGATE.navcontroller = [[UINavigationController alloc] initWithRootViewController:vc];
//                                 RAZA_APPDELEGATE.window.rootViewController = RAZA_APPDELEGATE.navcontroller;
//                             }
//                         }];
        [[NSUserDefaults standardUserDefaults] setObject:[dictforsignupsms objectForKey:@"key_emailid"] forKey:@"callaftersignupemail"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[NSUserDefaults standardUserDefaults] setObject:[dictforsignupsms objectForKey:@"key_verifiedsms"] forKey:@"callaftersignuppassword"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[NSUserDefaults standardUserDefaults] setObject:[dictforsignupsms objectForKey:@"key_mobile"] forKey:@"callaftersignupphone"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"callaftersignup" object:nil];
    }
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
- (IBAction)btnResendSms:(id)sender {
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"RESENDSMSSIGNUP"
     object:self];
}
- (IBAction)backAction:(id)sender {
    [self.view endEditing:YES];
    RazaSignUpViewController *view = VIEW(RazaSignUpViewController);
    [PhoneMainView.instance popToView:view.compositeViewDescription];
}

-(NSMutableAttributedString*)getAttributedText:(NSString*)first  secondStr:(NSString*)secondStr{
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@",first,secondStr]];
    [attrStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"SourceSansPro-Regular" size:18] range:NSMakeRange(0, [first length])];
    [attrStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"SourceSansPro-Bold" size:18] range:NSMakeRange([first length]+1, [secondStr length])];
    
    return attrStr;
}

@end
