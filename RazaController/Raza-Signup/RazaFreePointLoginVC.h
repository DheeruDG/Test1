//
//  RazaFreePointLoginVC.h
//  Raza
//
//  Created by Praveen S on 11/17/13.
//  Copyright (c) 2013 Raza. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

#import "RazaDataModel.h"
#import "RazaServiceManager.h"


@interface RazaFreePointLoginVC : UIViewController <UITextFieldDelegate, RazaDataModelDelegate, ServiceManagerDelegate>{
    
    UIToolbar *_keyboardToolbar;
    UIBarButtonItem *_previous, *_next;
    UIView *_inputAccView;
    BOOL   keyboardVisible;
    CGSize keyboardSize;
    UITextField* activeField;
    NSDictionary *loginInfo;
    
}

@property (nonatomic, weak) IBOutlet UIView *loginOverlay;
@property (weak, nonatomic) IBOutlet UITextField *emailTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (nonatomic) NSString *errorMessage;

- (IBAction)loginClicked:(id)sender;
- (IBAction)actionForgotPassword:(id)sender;

@end
