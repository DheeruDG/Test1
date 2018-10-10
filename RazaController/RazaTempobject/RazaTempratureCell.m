//
//  RazaTempratureCell.m
//  Raza
//
//  Created by umenit on 8/31/16.
//  Copyright © 2016 Raza. All rights reserved.
//

#import "RazaTempratureCell.h"

@implementation RazaTempratureCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)cellof:(RazaTempratureCell*)cell andindexpath:(NSIndexPath*)indexPath andcolor:(int)color andmodeoftemp:(NSString*)modeoftemp
{
    if (indexPath.row==0)
    cell.lbltempname.text=@"Celsius";
    else
    cell.lbltempname.text=@"Fahrenheit";
    if (![modeoftemp length])
    {
        if (indexPath.row==0)
        cell.imgtempicon.image=[UIImage imageNamed:@"celciush.png"];
        else
        cell.imgtempicon.image=[UIImage imageNamed:@"fahrenheit.png"];
    }
    else
    {
        if (indexPath.row==0)
        
        cell.imgtempicon.image=[UIImage imageNamed:@"celcius.png"];
        else
        cell.imgtempicon.image=[UIImage imageNamed:@"fahrenheith.png"];
    }
    if (color==1)
    {
        if (indexPath.row==0)
        cell.backgroundColor=[UIColor colorWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1.0f];
        else
        cell.backgroundColor=[UIColor clearColor];
    }
    else if (color==2)
    {
        if (indexPath.row==0)
        cell.backgroundColor=[UIColor clearColor];
        else
        cell.backgroundColor=[UIColor colorWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1.0f];
    }
    else
    cell.backgroundColor=[UIColor clearColor];
}
@end
