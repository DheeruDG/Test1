//
//  raza_network_cell.h
//  Raza
//
//  Created by umenit on 6/11/15.
//  Copyright (c) 2015 Raza. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface raza_network_cell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *lbl_name;
@property (strong, nonatomic) IBOutlet UITextView *lbl_desc;
@property (strong, nonatomic) IBOutlet UIView *lbl_view;
@property (strong, nonatomic) IBOutlet UILabel *lbl_number;
@property (strong, nonatomic) IBOutlet UISwitch *uswich;

- (IBAction)changes:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnswitch;
-(void)updatecell:(raza_network_cell*)cell;
@end
