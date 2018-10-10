//
//  Raza_chat_option.h
//  Raza
//
//  Created by umenit on 8/22/15.
//  Copyright (c) 2015 Raza. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Raza_chat_option_cell.h"
//#import "globalnetworkclass.h"
#import "raza_chat_imageViewController.h"
//#import "SWRevealViewController.h"
#import "UICompositeView.h"
@interface Raza_chat_option : UIViewController<UITableViewDataSource,UITableViewDelegate,UICompositeViewDelegate>
{
    UINib *cellnib;
    NSMutableArray *arr;
    NSMutableDictionary *dictofchatwallpaper;
    NSString *dictofchatwallpaperpath;
    int anwhich;
    NSString *imgname;
    UIView *containerViewmy;
}
@property (strong, nonatomic) IBOutlet UITableView *tbl;
@property (strong,nonatomic) NSString *vcofuser;
- (IBAction)btnbackclicked:(id)sender;

@end
