//
//  UIChatCreateCellViewTableViewCell.h
//  linphone
//
//  Created by Gautier Pelloux-Prayer on 12/10/15.
//
//

#import <UIKit/UIKit.h>

@interface UIChatCreateCell : UITableViewCell
@property(weak, nonatomic) IBOutlet UILabel *displayNameLabel;
@property(weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIRoundedImageView *avatarImgView;

- (id)initWithIdentifier:(NSString *)identifier;

@end
