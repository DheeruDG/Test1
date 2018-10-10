//
//  raza_network_cell.m
//  Raza
//
//  Created by umenit on 6/11/15.
//  Copyright (c) 2015 Raza. All rights reserved.
//

#import "raza_network_cell.h"

@implementation raza_network_cell

//- (void)awakeFromNib {
//    // Initialization code
//    [super awakeFromNib];
//    self.lbl_view.layer.cornerRadius = self.lbl_view.frame.size.width / 2;
//    self.lbl_view.clipsToBounds = YES;
//    self.lbl_number.layer.cornerRadius = self.lbl_number.frame.size.width / 2;
//    self.lbl_number.clipsToBounds = YES;
//    self.lbl_desc.editable=NO;
//}
-(void)updatecell:(raza_network_cell*)cell
{
    cell.lbl_view.layer.cornerRadius = cell.lbl_view.frame.size.width / 2;
    cell.lbl_view.clipsToBounds = YES;
    cell.lbl_number.layer.cornerRadius = cell.lbl_number.frame.size.width / 2;
    cell.lbl_number.clipsToBounds = YES;
    cell.lbl_desc.editable=NO;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (IBAction)changes:(id)sender {
//    if (tag==0) {
//        if (cell.uswich.on)
//        {
//            [self switchon:tag];
//            
//            
//        }
//        else
//        {
//            if (a==1)
//            {
//                cell.uswich.on=YES;
//                [self toshowforatleastone];
//            }
//            else
//                [self switchoff:tag];
//        }
//        
//    }
//    else if (tag==1)
//    {
//        if (cell.uswich.on)
//        {
//            
//            [self switchon:tag];
//            
//            
//        }
//        else
//        {
//            if (a==1)
//            {
//                cell.uswich.on=YES;
//                [self toshowforatleastone];
//            }
//            else
//                [self switchoff:tag];
//        }
//        
//    }
//    else if (tag==2)
//    {
//        if (cell.uswich.on)
//        {
//            [self switchon:tag];
//            
//            
//        }
//        else
//        {
//            if (a==1)
//            {
//                cell.uswich.on=YES;
//                [self toshowforatleastone];
//            }
//            else
//                [self switchoff:tag];
//        }
//        
//    }

}
@end
