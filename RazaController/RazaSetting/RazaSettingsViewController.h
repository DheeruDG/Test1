//
//  RazaSettingsViewController.h
//  Raza
//
//  Created by Praveen S on 12/1/13.
//  Copyright (c) 2013 Raza. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
//#import "Raza_chat_option.h"
//#import "Raza_chat_option_ring.h"
//#import "UIImageView+WebCache.h"
//#import "AFHTTPRequestOperation.h"
//#import "AFHTTPRequestOperationManager.h"
#import "MBProgressHUD.h"
#import "globalnetworkclass.h"
//#import "SWRevealViewController.h"
//#import "RazaTemprateBaseViewController.h"
#import "UICompositeView.h"
@interface RazaSettingsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UICompositeViewDelegate> {
 
    NSMutableArray *_datalist;
    NSMutableArray *_datalist1;

    NSMutableArray *_datalist2;

    NSMutableArray *_datalist3;

    
    __weak IBOutlet UITableView *_settingsTableView;
    __weak IBOutlet UILabel *_labelWelcome;
    MBProgressHUD *HUD;
    MBProgressHUD *HUDforsignout;
    globalnetworkclass *DELETENETWORKINFORMATION;
    

}
//@property (strong, nonatomic) IBOutlet UIScrollView *scrollingView;
@property (strong, nonatomic) IBOutlet UIScrollView *_scrollview;
@property (weak, nonatomic) IBOutlet UITextField *tempTxt;

@property BOOL newMedia;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIImageView *imgView;
- (IBAction)imgfromgallery:(id)sender;

- (IBAction)takePhoto:  (UIButton *)sender;
- (IBAction)selectPhoto:(UIButton *)sender;


- (IBAction)mainsetting:(id)sender;
- (IBAction)btnMenuClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerViewTopConst;

@end
