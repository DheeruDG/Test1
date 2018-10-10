//
//  RazaSipLoginModel.h
//  linphone
//
//  Created by umenit on 11/26/16.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UICompositeView.h"

@interface RazaSipLoginModel : NSObject
{
    LinphoneAccountCreator *account_creator;
    LinphoneProxyConfig *new_config;
    UIView *currentView;
    UIView *nextView;
    size_t number_of_configs_before;
    
}
@property(nonatomic, strong) IBOutlet UIView *linphoneLoginView;
@property(nonatomic) UICompositeViewDescription *outgoingView;
-(void)setupforlogin;
@end
