//
//  RazaCreditCardController.h
//  Raza
//
//  Created by Praveen S on 11/23/13.
//  Copyright (c) 2013 Raza. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RazaDatePickerView.h"
#import "RazaPickerViewController.h"
#import "PopoverViewController.h"
#import "globalnetworkclass.h"
#define MAX_LENGTH 20
#define validcreditcard @"CARD NUMBER VALID"
#define INvalidcreditcard @"CARD NUMBER INVALID"
#import "UICompositeView.h"
#import "RazaLoginModel.h"
//#import "SWRevealViewController.h"
typedef enum : NSInteger {
	AMOUNT_TEXT = 0,
	CREDIT_TEXT,
	MONTH_TEXT,
    YEAR_TEXT,
    CODE_TEXT,
} TextFieldTag;

typedef enum : NSInteger {
	MONTH = 1,
	YEAR,
} PickerTag;

@interface RazaCreditCardController : UIViewController <UITextFieldDelegate, RazaDataModelDelegate, RazaPickerViewDelegate,UICompositeViewDelegate,UITableViewDataSource,UITableViewDelegate> {
    
    UITextField *_activeTextField;
    __weak IBOutlet UIButton *_buttonViewCountry;
    __weak IBOutlet UITableView *_accountTableView;
    NSArray *_defaultAmounts;
    BOOL check;
    UIToolbar *_keyboardToolbar;
    UIBarButtonItem *_previous, *_next;
    UIView *_inputAccView;
    BOOL   keyboardVisible;
    CGSize keyboardSize;
    UIBarButtonItem *_deleteBarButton;
    UIBarButtonItem *navigationItemCompose;
    __weak IBOutlet UILabel *_labelSelectAmount;
    
    RazaPickerViewController *_ratePickerVC;
    
    PopoverViewController *_popoverRateList;
    
    globalnetworkclass *checkvalidcreditcard;
    UIBarButtonItem *donecreditcard;
    NSString *strofchkval;
    UIView *containerViewmy;
    BOOL isAutoFillEnroll;
    NSMutableArray *rechargeAmountArray;
}

-(void)clear;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIButton *buttonAmount;

@property (weak, nonatomic) IBOutlet UITextField *textFieldCreditCard;
@property (weak, nonatomic) IBOutlet UITextField *textFieldMonth;
@property (weak, nonatomic) IBOutlet UITextField *textFieldYear;
@property (weak, nonatomic) IBOutlet UITextField *textFieldSecurity;

@property (weak, nonatomic) IBOutlet UIButton *buttonSubmit;
@property (weak, nonatomic) IBOutlet RazaDatePickerView *pickerExpiration;
@property (weak, nonatomic) IBOutlet UILabel *checkBoxLabel;
@property (nonatomic) BOOL isPushFromViewRates;
@property (strong, nonatomic) IBOutlet UILabel *creditcardinfo;
@property (weak, nonatomic) IBOutlet UIView *cvvView;

- (IBAction)actionTerms:(id)sender;

- (IBAction)actionSubmit:(id)sender;
- (IBAction)actionAmount:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *headerView;
- (IBAction)buttonDone:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *autoRechargeBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *autoRechangeViewTopConst;
@property (weak, nonatomic) IBOutlet UILabel *selectedAmountLbl;
@property (weak, nonatomic) IBOutlet UIView *balanceView;
@property (weak, nonatomic) IBOutlet UILabel *balanceLbl;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nextBtnTopConst;
@property (weak, nonatomic) IBOutlet UIView *autoRechargeView;

@end
