//
//  RazaSignUpViewController.h
//  Raza
//
//  Created by Praveen S on 11/17/13.
//  Copyright (c) 2013 Raza. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RazaCountryFromModel.h"
#import "RazaAutoCountryCell.h"
#import "RazaAutoCountryVC.h"
#import "RazaCountryFromTableView.h"
#import "PopoverViewController.h"
#import "Razasignup_verification.h"
#import "UICompositeView.h"
//#import <MessageUI/MFMessageComposeViewController.h>
typedef enum : NSInteger {
	EMAIL = 0,
	PASSWORD,
    PHONE,
    ZIPCODE_TEXT,
    txtzip
} SignUpTextFieldTag;

typedef enum : NSInteger {
	COUNTRYTO_TABLE = 0,
	COUNTRYFROM_TABLE,
} TableTag;

@interface RazaSignUpViewController : UIViewController <UITextFieldDelegate,UIScrollViewDelegate,
                                                        RazaAutoCountryDelegate,
                                                        RazaCountryTableViewDelegate,
                                                        RazaDataModelDelegate, ServiceManagerDelegate,UICompositeViewDelegate> {
    
    UIToolbar *_keyboardToolbar;
    UIBarButtonItem *_previous, *_next, *_done;
    RazaCountryFromTableView *_countryTableView;
    UIView *_inputAccView;
    BOOL   keyboardVisible;
    CGSize keyboardSize;
    UITextField* activeField;
    //__weak IBOutlet UIButton *_buttonCountry;
    
    PopoverViewController *_popoverSignup;
 NSString *_flagName;
NSInteger mainvalue;
UIView *mainview;
                                                            
}
@property (nonatomic, weak) IBOutlet UIView *loginOverlay;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@property (weak, nonatomic) IBOutlet UITextField *zipcodeTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UIButton *countryFromButton;
@property (weak, nonatomic) IBOutlet UIButton *countryToButton;

@property (strong, nonatomic) IBOutlet UIImageView *countryimg;
@property (strong, nonatomic) IBOutlet UITextField *txtzipcode;

@property (weak, nonatomic) IBOutlet UITextField *countryFromTxt;
@property (weak, nonatomic) IBOutlet UITextField *countryToTxt;
@property (weak, nonatomic) IBOutlet UIButton *signupButton;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic)NSMutableArray *countryList;
//@property (nonatomic) IBOutlet RazaCountryFromTableView *countryTableView;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (nonatomic) RazaCountryFromModel *countryModel;
@property (weak, nonatomic) IBOutlet UINavigationItem *tableNavBar;

@property(nonatomic, strong)NSString *errorMessage;

- (IBAction)signupClicked:(id)sender;

- (IBAction)actionCountryFromButton:(id)sender;
- (IBAction)gobackBtn:(id)sender;

- (IBAction)actionCountryToButton:(id)sender;

@end
