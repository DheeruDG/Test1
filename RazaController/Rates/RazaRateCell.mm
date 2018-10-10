//
//  RazaRateCell.m
//  Raza
//
//  Created by Praveen S on 22/11/13.
//  Copyright (c) 2013 Raza. All rights reserved.
//

#import "RazaRateCell.h"

@implementation RazaRateCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.labelCountryName = [[UILabel alloc]initWithFrame:CGRectMake(30, 5, SCREENWIDTH-130, 30)];
        self.labelRate = [[UILabel alloc]initWithFrame:CGRectMake(APP_FRAME.size.width-85, 5, 65, 30)];
        self.labelCountryName.font=self.labelRate.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:18.0];
        self.labelCountryName.textColor=self.labelRate.textColor=OxfordBlueColor;
        [self.contentView addSubview:self.labelCountryName];
        [self.contentView addSubview:self.labelRate];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
