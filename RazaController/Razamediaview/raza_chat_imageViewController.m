//
//  raza_chat_imageViewController.m
//  Raza
//
//  Created by umenit on 8/22/15.
//  Copyright (c) 2015 Raza. All rights reserved.
//

#import "raza_chat_imageViewController.h"
#import "PhoneMainView.h"
#define ZOOM_STEP 1.5
@interface raza_chat_imageViewController ()

@end

@implementation raza_chat_imageViewController
@synthesize  imageView,strofimg;

- (void)viewDidLoad {
    [super viewDidLoad];
   // UIBarButtonItem *newcallvideo = [[UIBarButtonItem alloc] initWithTitle:@"   Done" style:UIBarButtonItemStyleBordered target:self action:@selector(addtouserwallpaper)];
   // self.navigationItem.rightBarButtonItem=newcallvideo;
    
    globalnetworkclass *dict=[[globalnetworkclass alloc]init];
    dictofchatwallpaper=[[NSMutableDictionary alloc]init];
    NSArray *arr= [dict getchatcustomwallpaper];
    dictofchatwallpaper=[arr objectAtIndex:0];
    dictofchatwallpaperpath=[arr objectAtIndex:1];
    //CGRect screenRect = [[UIScreen mainScreen] bounds];
   // CGFloat screenWidth = screenRect.size.width;
   // CGFloat screenHeight = screenRect.size.height;
    
    // Do any additional setup after loading the view from its nib.
   
}
-(void)setstrinmagearray:(NSArray*)strimage
{
    strofimg=  strimage;
    imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 44, SCREENWIDTH, SCREENHIGHT-44)];
    UIImage *img= [UIImage imageNamed:[strofimg objectAtIndex:1]];
    imageView.image =img;
    
    NSLog(@"Navframe Height=%f",
          self.navigationController.navigationBar.frame.size.height);
    [self.view addSubview:imageView];
      //[self updatedone];
   
}
- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"%@--",dictofchatwallpaper);
}

-(void)addtouserwallpaper
{
   NSMutableArray *username_array =[[NSMutableArray alloc]initWithArray:[dictofchatwallpaper valueForKey:@"owner"]];
    NSMutableArray *username_wallpaper =[[NSMutableArray alloc]initWithArray:[dictofchatwallpaper valueForKey:@"wallpaper"]];

    globalnetworkclass *dictfor=[[globalnetworkclass alloc]init];
    [dictfor setwallper:[strofimg objectAtIndex:0] forTime:username_array forTime2:username_wallpaper forTime3:[strofimg objectAtIndex:1] forTime4:dictofchatwallpaper forTime5:dictofchatwallpaperpath];
     [self performSelector:@selector(patchSelector) withObject:nil afterDelay:0.3];
   
}
-(void)patchSelector{
//    NSArray *array = [self.navigationController viewControllers];
//    if ([array count]>1) {
//        // [TODO:ios update]
//        [self.navigationController popToViewController:[array objectAtIndex:1] animated:YES];
//    }
//    else
//       [self.navigationController popToRootViewControllerAnimated:YES];
    
    [self gotoprev];
    
}
#pragma mark TapDetectingImageViewDelegate methods

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)updatedone
{
    containerViewmy = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 44)];
    [containerViewmy setBackgroundColor:kColorHeader];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self
               action:@selector(gotoprev)
     forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundImage:[UIImage imageNamed:@"back_default.png"] forState:UIControlStateNormal];
    //[button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal ];
    // [button setTitle:@"Done" forState:UIControlStateNormal];
    button.frame = CGRectMake(10, 5, 30, 30);
    [containerViewmy addSubview:button];
    [self.view addSubview:containerViewmy];
}
-(void)gotoprev
{
  //  Raza_chat_option *view = VIEW(Raza_chat_option);
  //  [PhoneMainView.instance popToView:view.compositeViewDescription];
    [PhoneMainView.instance popCurrentView];
}

static UICompositeViewDescription *compositeDescription = nil;

+ (UICompositeViewDescription *)compositeViewDescription {
    if (compositeDescription == nil) {
        compositeDescription = [[UICompositeViewDescription alloc] init:self.class
                                                              statusBar:nil
                                                                 tabBar:nil
                                                               sideMenu:SideMenuView.class
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

- (IBAction)bntbackClicked:(id)sender {
    [self gotoprev];
}

- (IBAction)btnchooseclicked:(id)sender {
    [self addtouserwallpaper];
}
@end
