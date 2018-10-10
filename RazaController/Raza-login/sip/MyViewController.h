//
//  MyViewController.h
//  linphone
//
//  Created by umenit on 11/21/16.
//
//

#import <UIKit/UIKit.h>
#import "UICompositeView.h"
#import "RazaBaseClass.h"
@interface MyViewController : UIViewController<UICompositeViewDelegate>
{
    	LinphoneAccountCreator *account_creator;
    LinphoneProxyConfig *new_config;
    UIView *currentView;
    UIView *nextView;
    size_t number_of_configs_before;
}
@property(nonatomic) UICompositeViewDescription *outgoingView;
@property(nonatomic, strong) IBOutlet UIView *linphoneLoginView;
- (IBAction)LOGINCLICKED:(id)sender;
-(void)callfornotify;

@end
