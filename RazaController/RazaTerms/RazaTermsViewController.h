//
//  RazaTermsViewController.h
//  linphone
//
//  Created by umenit on 12/28/16.
//
//

#import <UIKit/UIKit.h>
#import "UICompositeView.h"
#import <MessageUI/MessageUI.h>
#import <sys/utsname.h>

@interface RazaTermsViewController : UIViewController<UICompositeViewDelegate,MFMailComposeViewControllerDelegate>{
    MFMailComposeViewController *mailComposer;
}
- (IBAction)btnBackClicked:(id)sender;
- (IBAction)faqAction:(id)sender;
- (IBAction)reportIssueAction:(id)sender;
- (IBAction)customerServiceAction:(id)sender;
- (IBAction)termsAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *callBtn;
@property (weak, nonatomic) IBOutlet UIView *callView;

@end
