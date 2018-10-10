//
//  RazaCallDetailsVC.h
//  Raza
//
//  Created by Praveen S on 12/2/13.
//  Copyright (c) 2013 Raza. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UICompositeView.h"
//#import "SWRevealViewController.h"
@interface RazaCallDetailsVC : UIViewController <RazaDataModelDelegate, UITableViewDataSource, UITableViewDelegate,UICompositeViewDelegate>{
    
    __weak IBOutlet UITableView *calldetailTableView;
    NSArray *_sections;
    NSMutableDictionary *_calllogs;
    __weak IBOutlet UILabel *_labelNoCallDetails;
    NSString *_flagName;


}

@end
