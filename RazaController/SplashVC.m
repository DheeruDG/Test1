//
//  SplashVC.m
//  linphone
//
//  Created by umenit on 12/20/16.
//
//

#import "SplashVC.h"
#import "PhoneMainView.h"
@interface SplashVC ()

@end

@implementation SplashVC
@synthesize spashimage,moviePlayer;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setStatusBarBackgroundColor:[UIColor clearColor]];
    for (UIButton* subview in _viewstar.subviews)
    {
        [subview setImage:[UIImage imageNamed:@"unstar"] forState:UIControlStateNormal];
    }
    // Do any additional setup after loading the view from its nib.
    //
    //    NSString *path = [[NSBundle mainBundle]pathForResource:
    //                      @"raza AppV1" ofType:@"mov"];
    //
    //    moviePlayer = [[MPMoviePlayerController alloc]initWithContentURL:[NSURL fileURLWithPath:path]];
    //    [moviePlayer.view setFrame:CGRectMake(0, 0, 375, 667)];
    //
    //    // [self presentMoviePlayerViewControllerAnimated:moviePlayer.view];
    //
    //    moviePlayer.controlStyle=MPMovieControlStyleNone;
    //    UIImage *thumbnail = [moviePlayer thumbnailImageAtTime:0.7
    //                                                timeOption:MPMovieTimeOptionNearestKeyFrame];
    //
    //    iv = [[UIImageView alloc] initWithImage:thumbnail];
    //    iv.userInteractionEnabled = YES;
    //    iv.frame = moviePlayer.view.frame;
    //    [self.view addSubview:iv];
    //
    //    [self performSelector:@selector(play) withObject:self afterDelay:0.3000];
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    if (iPhone4Or5oriPad==5) {
        self.imgHTConst.constant=self.imgWTConst.constant=100;
        self.imgTOPConst.constant=25;
    }
    
    CAGradientLayer *gradient = [BackgroundLayer linearGradient];
    gradient.frame = _btnsubmit.bounds;
    gradient.startPoint = CGPointMake(0.0,0.0);
    gradient.endPoint = CGPointMake(1.0,0.0);
    [_btnsubmit.layer insertSublayer:gradient atIndex:0];
    [_btnsubmit bringSubviewToFront:_btnsubmit.imageView];

    for (UIButton* subview in _viewstar.subviews)
    {
        [subview setImage:[UIImage imageNamed:@"unstar"] forState:UIControlStateNormal];
    };
    [_btnsubmit setTitle:@"Cancel" forState:UIControlStateNormal];
    [_btnsubmit setImage:[UIImage imageNamed:@"closeRating.png"] forState:UIControlStateNormal];
    
    //if (self.obj==nil) {
    self.obj=[Razauser SharedInstance].ratingDetailDic;
   // }
    self.img.layer.cornerRadius = self.imgHTConst.constant / 2;
    self.img.clipsToBounds = YES;
    UIImage *imgval=[self.obj valueForKey:@"MODEIMG"];
    if(imgval)
        self.img.image=imgval;
    else
        self.img.image=[UIImage imageNamed:@"muser"];
    //self.lblname.text=[self.obj valueForKey:@"MODENAME"];
    //reverseObjectEnumerator
    NSArray *array = [[Razauser SharedInstance].ratingUserNameDetailSet allObjects];
    NSString * result = [[array valueForKey:@"description"] componentsJoinedByString:@","];
    NSLog(@"nameStr %@", result);
    self.lblname.text=result;
 
}
-(void)play{
    iv.hidden = YES;
    [moviePlayer play];
    [self.view addSubview:moviePlayer.view];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hidecontrol)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:moviePlayer];
    
}
- (void) hidecontrol {
    [self performSelector:@selector(setcontroller) withObject:self afterDelay:0.0000];
    
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


-(void)setcontroller
{
    [self setStatusBarBackgroundColor:kColorHeader];
    
    [PhoneMainView.instance popCurrentView];
    if ([Razauser SharedInstance].modeofview.length) {
        RazaLoginViewController *view = VIEW(RazaLoginViewController);
        
        [PhoneMainView.instance changeCurrentView:view.compositeViewDescription];
    }
    else
    {
        DialerView *view = VIEW(DialerView);
        [PhoneMainView.instance changeCurrentView:view.compositeViewDescription];
        //[PhoneMainView.instance changeCurrentView:DialerView.compositeViewDescription];
    }
    
}


- (void)setStatusBarBackgroundColor:(UIColor *)color {
    
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
}

- (IBAction)ratingbtnClicked:(id)sender {
    UIButton *btn = (UIButton *) sender;
     btnval=(int)btn.tag;
    
    for (UIButton* subview in _viewstar.subviews)
    {
        if ((int)subview.tag<=btnval) {
            [subview setImage:[UIImage imageNamed:@"star_icon"] forState:UIControlStateNormal];
        }
        else
            [subview setImage:[UIImage imageNamed:@"unstar"] forState:UIControlStateNormal];
    }
    
    NSLog(@"%ld",(long)btn.tag);
    
    [_btnsubmit setTitle:@"Done" forState:UIControlStateNormal];
    [_btnsubmit setImage:[UIImage imageNamed:@"tickRating.png"] forState:UIControlStateNormal];
}

- (IBAction)btnSubmitClicked:(id)sender {
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd-yyyy HH:mm:ss"];

    NSString *memberid = [[RAZA_USERDEFAULTS objectForKey:@"logininfo"] objectForKey:LOGIN_RESPONSE_ID];
    NSString *userpin = [[RAZA_USERDEFAULTS objectForKey:@"logininfo"] objectForKey:LOGIN_RESPONSE_PIN];

    
    if ([_btnsubmit.titleLabel.text isEqualToString:@"Done"]) {
        [[Razauser SharedInstance]ShowWaitingshort:nil andtime:20.0];
        
        [[RazaServiceManager sharedInstance] SaveAPIRating:memberid pin:userpin callDateTime:[dateFormatter stringFromDate:[NSDate date]] destinationNumber:[self.obj objectForKey:@"MODEPHONE"] starRating:btnval];
        [RazaServiceManager sharedInstance].delegate = self;

        [RazaDataModel sharedInstance].delegate = self;
    }
    else{
        [Razauser SharedInstance].ratingDetailDic=[[NSDictionary alloc]init];
        [Razauser SharedInstance].ratingUserNameDetailSet=[NSMutableSet set];
        [PhoneMainView.instance popCurrentView];

    }
    
}

-(void)receivedDataFromService:(NSDictionary *)info withResponseType:(NSString *)responseType {

    [[Razauser SharedInstance]HideWaiting];
    [Razauser SharedInstance].ratingUserNameDetailSet=[NSMutableSet set];
    [Razauser SharedInstance].ratingDetailDic=[[NSDictionary alloc]init];
     [PhoneMainView.instance popCurrentView];
    [RAZA_APPDELEGATE showAlertWithMessage:@"Thank you for rating the call, this will help us to make your calling experience even better." withTitle:@"Rating" withCancelTitle:@"Ok"];

//    if ([[info objectForKey:@"status"] isEqualToString:@"1"]) {
//        [RAZA_APPDELEGATE showAlertWithMessage:@"Thank you for rating with Raza. This will help us improve our call quality." withTitle:@"Rating" withCancelTitle:@"Ok"];
//    }
//    else{
//         [RAZA_APPDELEGATE showAlertWithMessage:@"Error" withTitle:nil withCancelTitle:@"Ok"];
//    }
}
@end
