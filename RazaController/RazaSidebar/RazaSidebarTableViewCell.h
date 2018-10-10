//
//  RazaSidebarTableViewCell.h
//  Raza
//
//  Created by umenit on 8/3/16.
//  Copyright © 2016 Raza. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RazaSidebarTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblname;
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UIImageView *lblcounterimage;

@property (weak, nonatomic) IBOutlet UILabel *lblcounter;

@property (weak, nonatomic) IBOutlet UIButton *btnsignout;
@property (weak, nonatomic) IBOutlet UILabel *sideLineLbl;
@property (weak, nonatomic) IBOutlet UIView *upperView;

@end
