//
//  RazaTempratureCell.h
//  Raza
//
//  Created by umenit on 8/31/16.
//  Copyright © 2016 Raza. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RazaTempratureCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgtempicon;
@property (weak, nonatomic) IBOutlet UILabel *lbltempname;
-(void)cellof:(RazaTempratureCell*)cell andindexpath:(NSIndexPath*)indexPath andcolor:(int)color andmodeoftemp:(NSString*)modeoftemp;
@end
