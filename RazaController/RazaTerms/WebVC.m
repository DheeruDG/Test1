//
//  WebVC.m
//  linphone
//
//  Created by UMENIT on 1/23/17.
//
//

#import "WebVC.h"
#import "PhoneMainView.h"

@interface WebVC ()
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIView *topView;

@end

@implementation WebVC


- (void)viewDidLoad {
    [super viewDidLoad];
    
    CAGradientLayer *gradient = [BackgroundLayer navHeaderGradient];
    gradient.frame = self.headerView.bounds;
    gradient.startPoint = CGPointMake(0.0, 0.0);
    gradient.endPoint = CGPointMake(0.0, 1.0);
    gradient.locations = @[@0.0,@1.0];
    [self.headerView.layer insertSublayer:gradient atIndex:0];
    
    CAGradientLayer *gradient1 = [BackgroundLayer superViewGradient];
    gradient1.frame = self.topView.bounds;
    gradient1.startPoint = CGPointMake(0.0, 0.0);
    gradient1.endPoint = CGPointMake(0.0, 1.0);
    gradient1.locations = @[@0.7,@1.0];
    [self.topView.layer insertSublayer:gradient1 atIndex:0];
  
}
-(void)setobject
{
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.hidesWhenStopped = YES;
    self.activityIndicator = activityIndicator;
    [self.view addSubview:activityIndicator];
    
    self.titleLbl.text=[[NSUserDefaults standardUserDefaults] stringForKey:@"WEB"];
    NSString *html=[[NSUserDefaults standardUserDefaults] stringForKey:@"HTML"];
    
    NSString *path = [NSString stringWithFormat:@"%@/%@/%@",Raza_terms,@"api",html];
    NSLog(@"%@",path);
    // Do any additional setup after loading the view from its nib.
    //path
    
    NSURL *url = [NSURL URLWithString:path];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:requestObj];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.activityIndicator.center = self.view.center;
}

-(void)webViewDidStartLoad:(UIWebView *)webView{
    [self.activityIndicator startAnimating];
    NSLog(@"started");
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [self.activityIndicator stopAnimating];
    
    NSLog(@"finished");
}



- (IBAction)backAction:(id)sender {
[PhoneMainView.instance popCurrentView];//popToView:RazaTermsViewController.compositeViewDescription

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

@end
