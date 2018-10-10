//
//  RazaTermsViewController.m
//  linphone
//
//  Created by umenit on 12/28/16.
//
//

#import "RazaTermsViewController.h"
#import "PhoneMainView.h"

@interface RazaTermsViewController ()
@property (weak, nonatomic) IBOutlet UIView *headerView;

@end

@implementation RazaTermsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after
    CAGradientLayer *gradient = [BackgroundLayer navHeaderGradient];
    gradient.frame = self.headerView.bounds;
    gradient.startPoint = CGPointMake(0.0, 0.0);
    gradient.endPoint = CGPointMake(0.0, 1.0);
    gradient.locations = @[@0.0,@1.0];
    [self.headerView.layer insertSublayer:gradient atIndex:0];
    
    CAGradientLayer *gradient2 = [BackgroundLayer linearGradient];
    gradient2.frame = self.callBtn.bounds;
    gradient2.startPoint = CGPointMake(0.0,0.0);
    gradient2.endPoint = CGPointMake(1.0,0.0);
    [self.callBtn.layer insertSublayer:gradient2 atIndex:0];
    
    UIDevice *myDevice = [UIDevice currentDevice];
  //  NSString *deviceUDID = myDevice.uniqueIdentifier;
    //NSString *deviceName = myDevice.description;
    NSString *deviceSystemName = myDevice.systemName;
    NSString *deviceOSVersion = myDevice.systemVersion;
    NSString *deviceModel = myDevice.localizedModel;
     NSString *str1=[self deviceinfo];
    NSLog(@"%@-%@-%@-%@",str1,deviceSystemName,deviceOSVersion,deviceModel);
}
-(void)viewWillAppear:(BOOL)animated {
    
    if ([[Razauser SharedInstance] getsidebar].length){
        [Razauser SharedInstance].sideBarIndex=8;
    }else{
        [Razauser SharedInstance].sideBarIndex=6;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)btnBackClicked:(id)sender {
  
        UICompositeView *cvc = PhoneMainView.instance.mainViewController;
        [cvc hideSideMenu:(cvc.sideMenuView.frame.origin.x == 0)];

}

- (IBAction)faqAction:(id)sender {
    [[NSUserDefaults standardUserDefaults] setObject:@"FAQ" forKey:@"WEB"];
    [[NSUserDefaults standardUserDefaults] setObject:@"FAQ.html" forKey:@"HTML"];

    WebVC *view = VIEW(WebVC);
     [view setobject];
    [PhoneMainView.instance changeCurrentView:view.compositeViewDescription];
    
}

- (IBAction)reportIssueAction:(id)sender {
//    [[NSUserDefaults standardUserDefaults] setObject:@"Report Issue" forKey:@"WEB"];
//    WebVC *view = VIEW(WebVC);
//    [PhoneMainView.instance changeCurrentView:view.compositeViewDescription];

    if (![MFMailComposeViewController canSendMail]) {
        NSLog(@"Mail services are not available.");
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Alert!" message:@"Mail services are not available." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    else{
        LinphoneProxyConfig *default_proxy = linphone_core_get_default_proxy_config(LC);
        NSString *phoneNumber;
        if (default_proxy != NULL)
            phoneNumber = [NSString stringWithUTF8String:linphone_proxy_config_get_identity(default_proxy)];
            
        UIDevice *myDevice = [UIDevice currentDevice];
        //  NSString *deviceUDID = myDevice.uniqueIdentifier;
        //NSString *deviceName = myDevice.description;
        NSString *deviceSystemName = myDevice.systemName;
        NSString *deviceOSVersion = myDevice.systemVersion;
        NSString *deviceModel = myDevice.localizedModel;
        NSString *str1=[self deviceinfo];
        NSString *emailTitle = @"Report problem ";
        // Email Content
        NSString *messagesend;
        phoneNumber=[[Razauser SharedInstance]getusername:phoneNumber];
        if (phoneNumber.length)
           messagesend= [NSString stringWithFormat:@"\n\n\n\n\n******* Device Information *******\nDevice Name:%@\nDeviceSystemName:%@\nDeviceOSVersion:%@\nDeviceModel:%@\nPhonenumber:%@\n",str1,deviceSystemName,deviceOSVersion,deviceModel,phoneNumber];
       else
     messagesend= [NSString stringWithFormat:@"\n\n\n\n\n******* Device Information *******\nDevice Name:%@\nDeviceSystemName:%@\nDeviceOSVersion:%@\nDeviceModel:%@\n",str1,deviceSystemName,deviceOSVersion,deviceModel];
        
        NSString *messageBody =messagesend; //[NSString stringWithFormat:@"\n\n\n\n\n******* Device Information *******\nDevice Name:%@\nDeviceSystemName:%@\nDeviceOSVersion:%@\nDeviceModel:%@\n",str1,deviceSystemName,deviceOSVersion,deviceModel];
        // To address
        NSArray *toRecipents = [NSArray arrayWithObject:@"info@raza.com"];
        
        MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
        //[[UINavigationBar appearance] setBarTintColor:kColorHeader];
        [mc.navigationBar setTintColor:kColorHeader];
        mc.mailComposeDelegate = self;
        [mc setSubject:emailTitle];
        
        [mc setMessageBody:messageBody isHTML:NO];
        [mc setToRecipients:toRecipents];
        
        // Present mail view controller on screen
        [self presentViewController:mc animated:YES completion:NULL];
    }
    
}
-(NSString*)deviceinfo
{
    struct utsname systemInfo;
    uname(&systemInfo);
    
    return [NSString stringWithCString:systemInfo.machine
                              encoding:NSUTF8StringEncoding];
}
- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}


- (IBAction)customerServiceAction:(id)sender {
    self.callView.hidden=NO;
//    [[NSUserDefaults standardUserDefaults] setObject:@"Customer Service" forKey:@"WEB"];
//    WebVC *view = VIEW(WebVC);
//    [PhoneMainView.instance changeCurrentView:view.compositeViewDescription];
    
//    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
//
//    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
//
//        // Cancel button tappped.
//        [self dismissViewControllerAnimated:YES completion:^{
//        }];
//    }]];
//
//    [actionSheet addAction:[UIAlertAction actionWithTitle:@"USA" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//
//        NSString *phNo = @"1-877-463-4233";
//        NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"telprompt:%@",phNo]];
//
//        if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
//               [Razauser SharedInstance].modeofview=@"no";
//            [[UIApplication sharedApplication] openURL:phoneUrl];
//        } else
//        {
//            UIAlertView*  calert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Call facility is not available!!!" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
//            [calert show];
//        }
//
//    }]];
//
//    [actionSheet addAction:[UIAlertAction actionWithTitle:@"CANADA" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//
//
//        NSString *phNo = @"1-800-550-3501";
//        NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"telprompt:%@",phNo]];
//
//        if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
//               [Razauser SharedInstance].modeofview=@"no";
//            [[UIApplication sharedApplication] openURL:phoneUrl];
//        } else
//        {
//          UIAlertView*  calert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Call facility is not available!!!" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
//            [calert show];
//        }
//    }]];
//
//    // Present action sheet.
//    [self presentViewController:actionSheet animated:YES completion:nil];

}

- (IBAction)termsAction:(id)sender {
    [[NSUserDefaults standardUserDefaults] setObject:@"Terms and Conditions" forKey:@"WEB"];
    [[NSUserDefaults standardUserDefaults] setObject:@"Terms.html" forKey:@"HTML"];

    WebVC *view = VIEW(WebVC);
    [view setobject];
    [PhoneMainView.instance changeCurrentView:view.compositeViewDescription];

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
- (IBAction)callToUSAAction:(id)sender {
    NSString *phNo = @"1-877-463-4233";
    NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"telprompt:%@",phNo]];
    
    if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
        [Razauser SharedInstance].modeofview=@"no";
        [[UIApplication sharedApplication] openURL:phoneUrl];
    } else
    {
        UIAlertView*  calert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Call facility is not available!!!" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [calert show];
    }
}
- (IBAction)callToCanadaAction:(id)sender {
    NSString *phNo = @"1-800-550-3501";
    NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"telprompt:%@",phNo]];
    
    if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
        [Razauser SharedInstance].modeofview=@"no";
        [[UIApplication sharedApplication] openURL:phoneUrl];
    } else
    {
        UIAlertView*  calert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Call facility is not available!!!" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [calert show];
    }
}
- (IBAction)closeCallViewAction:(id)sender {
    self.callView.hidden=YES;
}

@end
