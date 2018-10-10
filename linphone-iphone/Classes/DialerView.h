/* DialerViewController.h
 *
 * Copyright (C) 2009  Belledonne Comunications, Grenoble, France
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
 */
#define RAZABASERECENTOBJECT @"recentobject"
#define RAZARECENTTEMPRATE @"Recent"
#define RAZAALLTEMPRATE @"All"
#define APIKEY @"0cca8d83ac8b1742"
#define RazaCountry_name @"name"
#define RazaCountry_Code @"code"
#define RazaStdcodeName @"Code"
#define RazaCountry_City @"city"
#import <UIKit/UIKit.h>

#import "UICompositeView.h"

#import "UICamSwitch.h"
#import "UICallButton.h"
#import "UIDigitButton.h"
#import "RazaTempratureObject.h"
#import "UIBouncingView.h"
@interface DialerView
: TPMultiLayoutViewController <UITextFieldDelegate, UICompositeViewDelegate, MFMailComposeViewControllerDelegate,CLLocationManagerDelegate,UITableViewDelegate,UITableViewDataSource,ServiceManagerDelegate,RazaDataModelDelegate,MinutscallwithDelegate> {
    int valtocheckofpopup;
    UIButton* aButton0;
    UIButton* aButton1;
    UIButton* aButton2;
    NSString *pathfornetwork ;
    NSMutableDictionary *datafornetwork ;
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
    NSString *_current_Country;
    NSArray *countryarray;
    NSArray *tblcountryrecent;
    NSString *mode;
    NSString *_current_State;
    UIView *_inputAccView;;
    UIToolbar *_keyboardToolbar;
    UIBarButtonItem  *_done;;
    
    /*----------3 button*---------*/
    BOOL contactFlag;
    NSMutableDictionary *dataforglobalplist ;
    BOOL chkboxvalue;
    NSString *pathforglobalplist ;
    BOOL isClickToPopup;
    int stringMissedbadge;
}
@property(weak, nonatomic) IBOutlet UIBouncingView *unreadCountView;
@property(weak, nonatomic) IBOutlet UIBouncingView *unreadCountrecentView;
@property(nonatomic, strong) IBOutlet UITextField *addressField;
@property(nonatomic, strong) IBOutlet UIButton *addContactButton;
@property(nonatomic, strong) IBOutlet UICallButton *callButton;
@property(nonatomic, strong) IBOutlet UIButton *backButton;
@property(weak, nonatomic) IBOutlet UIIconButton *backspaceButton;

@property(nonatomic, strong) IBOutlet UIDigitButton *oneButton;
@property(nonatomic, strong) IBOutlet UIDigitButton *twoButton;
@property(nonatomic, strong) IBOutlet UIDigitButton *threeButton;
@property(nonatomic, strong) IBOutlet UIDigitButton *fourButton;
@property(nonatomic, strong) IBOutlet UIDigitButton *fiveButton;
@property(nonatomic, strong) IBOutlet UIDigitButton *sixButton;
@property(nonatomic, strong) IBOutlet UIDigitButton *sevenButton;
@property(nonatomic, strong) IBOutlet UIDigitButton *eightButton;
@property(nonatomic, strong) IBOutlet UIDigitButton *nineButton;
@property(nonatomic, strong) IBOutlet UIDigitButton *starButton;
@property(nonatomic, strong) IBOutlet UIDigitButton *zeroButton;
@property(nonatomic, strong) IBOutlet UIDigitButton *hashButton;
@property(nonatomic, strong) IBOutlet UIView *backgroundView;
@property(nonatomic, strong) IBOutlet UIView *videoPreview;
@property(nonatomic, strong) IBOutlet UICamSwitch *videoCameraSwitch;
@property(weak, nonatomic) IBOutlet UIView *padView;

- (IBAction)onAddContactClick:(id)event;
- (IBAction)onBackClick:(id)event;
- (IBAction)onAddressChange:(id)sender;
- (IBAction)onBackspaceClick:(id)sender;

- (void)setAddress:(NSString *)address;
@property (weak, nonatomic) IBOutlet UIView *uiviewtabbar;

//@property (weak, nonatomic) IBOutlet UIView *uiviewofmain;
- (IBAction)btnofmainclicked:(id)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomchk;
@property (weak, nonatomic) IBOutlet UITableView *lblcountry;
@property (weak, nonatomic) IBOutlet UIButton *downBtn;
@property (weak, nonatomic) IBOutlet UIView *downview;
- (IBAction)chatbuttonClickede:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnDialPad;
- (IBAction)btnDialPadClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnChat;
- (IBAction)btnChatClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnRecent;
@property (weak, nonatomic) IBOutlet UIButton *btnContact;
- (IBAction)btnContactClicked:(id)sender;
- (IBAction)btnrecentClicked:(id)sender;
//@property (weak, nonatomic) IBOutlet UIView *viewaddressbook;
@property (weak, nonatomic) IBOutlet UISearchBar *searchCountry;
- (IBAction)btnmainbackClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *maintitleview;
@property (weak, nonatomic) IBOutlet UIView *mainrightbar;
@property (weak, nonatomic) IBOutlet UIButton *btndial;
@property (weak, nonatomic) IBOutlet UILabel *lblcounterchat;
-(void)updatechatreadunreadcounter:(int)total;
/*-------button 3----------*/
@property (strong,nonatomic) UIView *viewwindow;
@property (strong,nonatomic) UIButton *btnofcheckbox;
- (ABRecordRef)buildContactDetails:(NSString *)number;
@property (weak, nonatomic) IBOutlet UILabel *lblbalance;
@property (weak, nonatomic) IBOutlet UIButton *sidebutton;
@property (weak, nonatomic) IBOutlet UILabel *lblrecentcounter;
-(void)updatechatrecent:(int)total;
@property (weak, nonatomic) IBOutlet UIView *openDownBGView;
@property (weak, nonatomic) IBOutlet UIView *searchheaderView;
@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;
@property (weak, nonatomic) IBOutlet UIView *topView;

@property (weak, nonatomic) IBOutlet UIView *headerView;
@end
