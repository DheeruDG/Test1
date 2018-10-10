//
//  RazaLoginViewController.h
//  linphone
//
//  Created by umenit on 11/26/16.
//
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
#import "RazaLinkLabel.h"
#import "MBProgressHUD.h"
#import "UICompositeView.h"
///#import "RazaSipLoginModel.h"

typedef enum {
    
    EMAIL_TEXTFIELD = 0,
    PASSWORD_TEXTFIELD,
    PHONE_TEXTFIELD,
    VERIFY_TEXTFIELD
    
    
} LoginTextField;



@interface RazaLoginViewController : UIViewController
<NSConnectionProt, UIAlertViewDelegate, UITextFieldDelegate, ServiceManagerDelegate, RazaDataModelDelegate,UICompositeViewDelegate> {
    
    NetworkStatus internetConnectionStatus;
    NetworkStatus remoteHostStatus;
    Reachability* internetReach;
    //UIButton *_razaLinkButton;
    UITextField  *_alertTextField;
    UIAlertView *_passwordAlert;
    
    UIToolbar *_keyboardToolbar;
    UIBarButtonItem *_previous, *_next, *_done;
    UIView *_inputAccView;
    BOOL   keyboardVisible;
    CGSize keyboardSize;
    UITextField* activeField;
    NSDictionary *loginInfo;
    MBProgressHUD *HUD;
    
}

@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (nonatomic)BOOL isSignOut;
@property (strong, nonatomic) IBOutlet UIButton *razaLinkButton;

@property (nonatomic, weak) IBOutlet UIImageView *loginOverlay;
@property (weak, nonatomic) IBOutlet UITextField *emailTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (nonatomic) NSString *errorMessage;
@property (weak, nonatomic) IBOutlet UIView *viewVerify;
@property (weak, nonatomic) IBOutlet UITextField *txtverifytext;

- (IBAction)loginClicked:(id)sender;
- (IBAction)registerClicked:(id)sender;
- (IBAction)btnverifysmsclicked:(id)sender;
- (IBAction)btnViewVerifyHideClicked:(id)sender;
- (IBAction)btnbackclicked:(id)sender;
- (IBAction)btnRetrysmssend:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *verifyBtn;

//ForgotPassword
@property (weak, nonatomic) IBOutlet UIView *forgotPassView;
@property (weak, nonatomic) IBOutlet UITextField *emailForgotTxt;
@property (weak, nonatomic) IBOutlet UIButton *resetPassBtn;
@property (weak, nonatomic) IBOutlet UILabel *verifyScreenMsg;


@end
