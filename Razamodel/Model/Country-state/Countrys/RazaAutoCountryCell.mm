//
//  RazaAutoCountryCell.m
//  Raza
//
//  Created by Praveen S on 11/17/13.
//  Copyright (c) 2013 Raza. All rights reserved.
//

#import "RazaAutoCountryCell.h"

@implementation RazaAutoCountryCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.labelCountryName = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, APP_FRAME.size.width, 30)];
        self.labelCountryName.textAlignment=NSTextAlignmentCenter;
        [self.contentView addSubview:self.labelCountryName];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
