//
//  RazaCallReportCell.m
//  Raza
//
//  Created by UMENIT on 12/26/15.
//  Copyright © 2015 Raza. All rights reserved.
//

#import "RazaCallReportCell.h"

@implementation RazaCallReportCell
@synthesize labelDate,labelRate,labelTitle;


//- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
//{
//    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
//    if (self) {
//        // Initialization code
//        self.labelRate.textColor = [UIColor blueColor];
//        self.labelDate.textColor = [UIColor lightGrayColor];
//        
//        self.labelTitle.font = RAZA_CELL_FONT;
//        self.labelRate.font = RAZA_CELL_FONT;
//        self.labelDate.font = RAZA_CELL_FONT;
//        
//    }
//    return self;
//}


//- (void)awakeFromNib {
//    // Initialization code
////    CGRect screenRect=[[UIScreen mainScreen]bounds];
////    CGFloat screenWidth=screenRect.size.width;
////    self.labelTitle.frame=CGRectMake(10, 5, 150, 20);
////    self.labelDate.frame=CGRectMake(screenWidth-100, 10, 100, 20);
////    self.labelRate.frame=CGRectMake(10, 26, 150, 15);
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
