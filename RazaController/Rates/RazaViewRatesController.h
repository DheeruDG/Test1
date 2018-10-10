//
//  RazaViewRatesController.h
//  Raza
//
//  Created by Praveen S on 11/21/13.
//  Copyright (c) 2013 Raza. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UICompositeView.h"
//#import "SWRevealViewController.h"
@interface RazaViewRatesController : UIViewController <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, RazaDataModelDelegate, UISearchBarDelegate,UICompositeViewDelegate> {
    BOOL _searchMode;
    NSArray *_sections;
    __weak IBOutlet UISearchBar *_searchCountryBar;
    BOOL shouldBeginEditing;
    NSMutableDictionary *_mData;
}

@property (weak, nonatomic) IBOutlet UITableView *rateCountryTableView;
@property (nonatomic) NSMutableArray *countryList;
@property (nonatomic)NSMutableArray *searchCountryList;
@property (weak, nonatomic) IBOutlet UILabel *labelNoResult;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableTopConst;//56

@end
