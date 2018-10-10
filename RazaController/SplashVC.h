//
//  SplashVC.h
//  linphone
//
//  Created by umenit on 12/20/16.
//
//

#import <UIKit/UIKit.h>
#import "UICompositeView.h"
#import <MediaPlayer/MediaPlayer.h>
@interface SplashVC : UIViewController<UICompositeViewDelegate, ServiceManagerDelegate, RazaDataModelDelegate>{
    UIImageView *iv;
    int btnval;

}
@property (strong,nonatomic)NSDictionary *obj;
@property (weak, nonatomic) IBOutlet UIImageView *spashimage;
@property (strong, nonatomic) MPMoviePlayerController *moviePlayer;
- (IBAction)ratingbtnClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnsubmit;
@property (weak, nonatomic) IBOutlet UILabel *lblname;

- (IBAction)btnSubmitClicked:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *btnone;
@property (weak, nonatomic) IBOutlet UIButton *btntwo;
@property (weak, nonatomic) IBOutlet UIButton *btnthree;
@property (weak, nonatomic) IBOutlet UIButton *btnfour;
@property (weak, nonatomic) IBOutlet UIButton *btnsix;
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UIView *viewstar;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgHTConst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgWTConst;//190
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgTOPConst;

@end
