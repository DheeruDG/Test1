//
//  CallDetailsCell.m
//  Raza
//
//  Created by UMENIT on 23/01/18.
//

#import "CallDetailsCell.h"

@implementation CallDetailsCell
@synthesize mobileLbl,dateTimeLbl,ratesLbl,minsLbl;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        mobileLbl = [[UILabel alloc]initWithFrame:CGRectMake(30, 0, SCREENWIDTH-120, 25)];
        minsLbl = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH-110, 0, 80, 25)];
        dateTimeLbl = [[UILabel alloc]initWithFrame:CGRectMake(30, 25, SCREENWIDTH-130, 20)];
        ratesLbl = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH-110, 25, 80, 20)];
        minsLbl.textAlignment=ratesLbl.textAlignment=NSTextAlignmentRight;
        ratesLbl.font=mobileLbl.font =dateTimeLbl.font=minsLbl.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:18.0];
        ratesLbl.font=dateTimeLbl.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:16.0];

        mobileLbl.textColor=minsLbl.textColor=OxfordBlueColor;
        dateTimeLbl.textColor=ratesLbl.textColor=[UIColor colorWithRed:141.0/255.0f green:151.0/255.0f blue:165.0/255.0f alpha:1.0f];

        
        [self.contentView addSubview:mobileLbl];
        [self.contentView addSubview:ratesLbl];
        [self.contentView addSubview:dateTimeLbl];
        [self.contentView addSubview:minsLbl];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
