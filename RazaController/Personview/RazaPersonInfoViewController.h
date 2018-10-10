//
//  RazaPersonInfoViewController.h
//  Raza
//
//  Created by Praveen S on 11/24/13.
//  Copyright (c) 2013 Raza. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RazaDataModel.h"
#import "RazaAccountModel.h"
#import "PopoverViewController.h"
#import "RazaCountryFromTableView.h"
#import "RazaStateListTableView.h"
#import "UICompositeView.h"

@interface RazaPersonInfoViewController : UIViewController <UITextFieldDelegate, RazaDataModelDelegate, ServiceManagerDelegate, RazaCountryTableViewDelegate, RazaStateTableViewDelegate,UICompositeViewDelegate> {
    
    UITextField *_activeTextField;
    UIToolbar *_keyboardToolbar;
    UIBarButtonItem *_previous, *_next;
    UIView *_inputAccView;
    BOOL   keyboardVisible;
    CGSize keyboardSize;
    __weak IBOutlet UIScrollView *_containerScrollView;
    __weak IBOutlet UIView *_containerView;
    PopoverViewController *_popoverPersonInfo;
    RazaCountryFromTableView *_countryTableView;
    RazaStateListTableView *_stateTableView;
    __weak IBOutlet UIButton *_buttonState;
    //PopoverViewController *_popoverStateList;
    NSDictionary *stateInfo;
}
@property (weak, nonatomic) IBOutlet UITextField *stateTxt;
@property (weak, nonatomic) IBOutlet UITextField *countryTxt;

@property (weak, nonatomic) IBOutlet UITextField *textFirstName;
@property (weak, nonatomic) IBOutlet UITextField *textLastName;
@property (weak, nonatomic) IBOutlet UITextField *textStreet;
@property (weak, nonatomic) IBOutlet UITextField *textCity;
@property (weak, nonatomic) IBOutlet UITextField *textState;
@property (weak, nonatomic) IBOutlet UITextField *textZipCode;
@property (weak, nonatomic) IBOutlet UITextField *textCountry;
@property (weak, nonatomic) IBOutlet UIButton *countryFromButton;
@property (weak, nonatomic) IBOutlet UITextField *addressLine1Txt;
@property (weak, nonatomic) IBOutlet UITextField *addressLine2Txt;

@property (nonatomic) BOOL isRedeem;
@property (nonatomic) BOOL isAutoRefillEnroll;
@property (nonatomic)NSString *rechargeAmount;
//@property (nonatomic)NSString *couponamount;
- (IBAction)actionSubmit:(id)sender;
- (void)ensureVisible:(UITextField*)textField;
- (IBAction)actionCountryFromButton:(UIButton *)sender;
- (IBAction)actionButtonState:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *headerView;

@end
