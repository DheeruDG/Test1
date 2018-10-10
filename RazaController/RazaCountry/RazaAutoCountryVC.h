//
//  RazaAutoCountryVC.h
//  Raza
//
//  Created by Praveen S on 11/17/13.
//  Copyright (c) 2013 Raza. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MBProgressHUD.h"
#import "RazaCountryToModel.h"

@protocol RazaAutoCountryDelegate <NSObject>

-(void)updateCountryToTextField:(RazaCountryToModel *)countryToModel;

@end

@interface RazaAutoCountryVC : UIViewController <UITableViewDelegate, UITableViewDataSource, MBProgressHUDDelegate, UISearchBarDelegate> {
    
    BOOL _searchMode;
    __weak IBOutlet UISearchBar *_searchCountryBar;
    BOOL shouldBeginEditing;
}
@property (weak, nonatomic) IBOutlet UITableView *autoCountryTableView;
@property (nonatomic) NSMutableArray *countryList;
@property (nonatomic)NSMutableArray *searchCountryList;
@property (nonatomic, weak) id <RazaAutoCountryDelegate> delegate;

- (IBAction)buttonDismiss:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *headerView;

@end
