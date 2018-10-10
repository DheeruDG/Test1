//
//  RazaTemprateBaseViewController.h
//  Raza
//
//  Created by umenit on 8/31/16.
//  Copyright © 2016 Raza. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "RazaTempratureCell.h"
#import "UICompositeView.h"
@interface RazaTemprateBaseViewController : UIViewController<UICompositeViewDelegate>
{
    UINib *cellnib;
    NSString *modeoftemp;
    int color;
}
@property(strong,nonatomic) NSString *modeofshow;
@property (weak, nonatomic) IBOutlet UIButton *btnTemprature;
- (IBAction)btnTempratureClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnTempratureForegingight;
- (IBAction)btnTempratureforclicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *headerView;

@property (weak, nonatomic) IBOutlet UITableView *tbltemp;
- (IBAction)btnbackClicked:(id)sender;
@end
