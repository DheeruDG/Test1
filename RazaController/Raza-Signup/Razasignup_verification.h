//
//  Razasignup_verification.h
//  Raza
//
//  Created by umenit on 8/3/15.
//  Copyright (c) 2015 Raza. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "RazaHomeViewController.h"
#import "MBProgressHUD.h"
#import "UICompositeView.h"
@interface Razasignup_verification : UIViewController<RazaDataModelDelegate, ServiceManagerDelegate,UITextFieldDelegate,UICompositeViewDelegate>
{
    NSMutableDictionary *dictForMemberId;
    MBProgressHUD *HUD;
}
- (IBAction)signupwithsms:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *smstext;
- (IBAction)btnResendSms:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *textWithPhoneLbl;
@property (weak, nonatomic) IBOutlet UIButton *verifyBtn;

@end
