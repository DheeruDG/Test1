//
//  RazaTermsVC.m
//  Raza
//
//  Created by Praveen S on 11/24/13.
//  Copyright (c) 2013 Raza. All rights reserved.
//

#import "RazaTermsVC.h"
#import "PhoneMainView.h"
@interface RazaTermsVC ()

@end

@implementation RazaTermsVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *htmlString = [self getHtmlContent];
    self.webViewTerms.delegate = self;
    [self.webViewTerms loadHTMLString:htmlString baseURL:nil];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.title = @"Terms & Conditions";
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSString *)getHtmlContent {
    
    NSString* beforeBody = @"<html><head><link type=\"text/css\" rel=\"stylesheet\" media=\"only screen and (max-device-width: 480px)\" href=\"terms-styles.css\" /> </head><body><div>";
    
    NSString *bodyContent = @"<font size=2px>By clicking Agree, you agree to be bound by the <b>Raza Mobile Privacy Policy and Terms of Use.</b></font>"\
                            @"<h3>Raza Communications</h3><font size=2px> makes no warranties or representations expressed, whether by fact or by otherwise, included but not limited to any warranties of merchantability and/or fitness for a particular use or purpose regarding this application, the Accuracy and Completeness of any information presented in this application, any product or service sold or purchased through this application.Customer is solely responsible of using the Access numbers. There will be extra charges for using 800 Toll-Free access numbers."\
        @"Calling rates, billing increments, fees, taxes, and other charges are subject to change any time, without any further notice. RAZA Communications will not be responsible or liable for any change in calling rates, billing increments, fees, taxes, and other charges. In addition the Promotional duration could change any time without any prior notice.</font>"\
            @"<h3>Raza Communications</h3> <font size=2px>does not guarantee call quality or connectivity, and will not be responsible or liable for reimbursement of lost minutes or reduction in the stored value of any prepaid plan. Connection to a wrong number is a valid call.</font>";
    
    NSString* afterBody = @"</div></body></html>";
    
    NSString *htmlDefn = [beforeBody stringByAppendingString:bodyContent];
    
    htmlDefn = [htmlDefn stringByAppendingString:afterBody];
    
    return htmlDefn;
}
static UICompositeViewDescription *compositeDescription = nil;

+ (UICompositeViewDescription *)compositeViewDescription {
    if (compositeDescription == nil) {
        compositeDescription = [[UICompositeViewDescription alloc] init:self.class
                                                              statusBar:nil
                                                                 tabBar:nil
                                                               sideMenu:nil
                                                             fullscreen:false
                                                         isLeftFragment:YES
                                                           fragmentWith:nil];
        compositeDescription.darkBackground = true;
    }
    return compositeDescription;
}
- (UICompositeViewDescription *)compositeViewDescription {
    return self.class.compositeViewDescription;
}
- (IBAction)btnActionBack:(id)sender {
    [PhoneMainView.instance popCurrentView];
    
}
@end
