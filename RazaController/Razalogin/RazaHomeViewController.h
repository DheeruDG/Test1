//
//  RazaHomeViewController.h
//  Raza
//
//  Created by Praveen S on 11/16/13.
//  Copyright (c) 2013 Raza. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
#import "RazaLinkLabel.h"
#import "MBProgressHUD.h"

typedef enum {
    
    EMAIL_TEXTFIELD = 0,
    PHONE_TEXTFIELD,
    PASSWORD_TEXTFIELD
    
} LoginTextField;


@interface RazaHomeViewController : UIViewController <NSConnectionProt, UIAlertViewDelegate, UITextFieldDelegate, ServiceManagerDelegate, RazaDataModelDelegate> {
    
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

@end
