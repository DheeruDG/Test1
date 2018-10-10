//
//  RazaCallReportsVC.h
//  Raza
//
//  Created by Praveen S on 12/2/13.
//  Copyright (c) 2013 Raza. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UICompositeView.h"
@interface RazaCallReportsVC : UIViewController <UITableViewDataSource, UITableViewDelegate,UICompositeViewDelegate> {
    
    __weak IBOutlet UITableView *callReportTableView;
    UINib *cellnib;
    UIView *containerViewmy;

}

@property (nonatomic)NSArray *callreports;;

@end
