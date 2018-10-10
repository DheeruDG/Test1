//
//  WebVC.h
//  linphone
//
//  Created by UMENIT on 1/23/17.
//
//

#import <UIKit/UIKit.h>

#import "UICompositeView.h"

@interface WebVC : UIViewController<UIWebViewDelegate,UICompositeViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
- (IBAction)backAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
-(void)setobject;
@end
