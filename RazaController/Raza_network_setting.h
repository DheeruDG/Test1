//
//  Raza_network_setting.h
//  Raza
//
//  Created by umenit on 6/11/15.
//  Copyright (c) 2015 Raza. All rights reserved.
//
#define APP_FRAME [UIScreen mainScreen].applicationFrame
#import <UIKit/UIKit.h>
#import "raza_network_cell.h"
#import "UICompositeView.h"

//#import "SWRevealViewController.h"
@interface Raza_network_setting : UIViewController<UITableViewDelegate,UITableViewDataSource,UICompositeViewDelegate>
{
    UINib *nib;
    
    
    NSString *path ;
    NSMutableDictionary *data ;
    BOOL btnswitchclk0;
    BOOL btnswitchclk1;
    BOOL btnswitchclk2;
    NSString *firstbtn;
    NSString *secondbtn;
    NSString *sthirdbtn;
}
- (IBAction)Donesetting:(id)sender;
- (IBAction)backsetting:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *tbl;
@property (weak, nonatomic) IBOutlet UIView *upperView;

@end
