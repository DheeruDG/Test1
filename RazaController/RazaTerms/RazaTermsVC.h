//
//  RazaTermsVC.h
//  Raza
//
//  Created by Praveen S on 11/24/13.
//  Copyright (c) 2013 Raza. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UICompositeView.h"
@interface RazaTermsVC : UIViewController <UIWebViewDelegate,UICompositeViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webViewTerms;
- (IBAction)btnActionBack:(id)sender;

@end
