//
//  RazaPurchaseHistoryVC.h
//  Raza
//
//  Created by Praveen S on 12/2/13.
//  Copyright (c) 2013 Raza. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "SWRevealViewController.h"
#import "UICompositeView.h"
@interface RazaPurchaseHistoryVC : UIViewController < UITableViewDataSource, UITableViewDelegate,RazaDataModelDelegate,UICompositeViewDelegate> {
    UINib *cellnib;

    __weak IBOutlet UITableView *purchaseTableView;
    NSArray *_purchaseHistoryList;
}
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UILabel *phoneHeader;
@property (strong, nonatomic) IBOutlet UILabel *durationHeader;



@end
