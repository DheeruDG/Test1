//
//  RazaRewardPointVC.h
//  Raza
//
//  Created by Praveen S on 12/2/13.
//  Copyright (c) 2013 Raza. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UICompositeView.h"

@interface RazaRewardPointVC : UIViewController <ServiceManagerDelegate,UICompositeViewDelegate,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,RazaDataModelDelegate> {
    
    __weak IBOutlet UIWebView *_webViewNotice;
    __weak IBOutlet UILabel *_labelRewardPoints;
    NSString *_rewardPoints;
    __weak IBOutlet UIView *_containerView;
    __weak IBOutlet UIView *_viewButton;
    __weak IBOutlet UIView *headerView;
    __weak IBOutlet UIButton *_buttonRedeemPoints;
    __weak IBOutlet UIButton *_buttonRedeemPoints1;
    NSMutableArray *pointRewardArray;
    
    NSString *rechargeAmount;
    
}
@property (weak, nonatomic) IBOutlet UIView *joinRazaView;
- (IBAction)actionRechargeFromPoints:(id)sender;
- (IBAction)actionPurchasePoints:(id)sender;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *selectAmountHeaderView;
@property (weak, nonatomic) IBOutlet UIView *selectAmountView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *redeemPointViewHTConst;//225
@property (weak, nonatomic) IBOutlet UILabel *joinPointsLbl;
@property (weak, nonatomic) IBOutlet UILabel *referFriendPointsLbl;
@property (weak, nonatomic) IBOutlet UILabel *rechargePointLbl;
@property (weak, nonatomic) IBOutlet UILabel *redeemPointsLbl;

@end
