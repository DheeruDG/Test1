//
//  RazaRedeemViewController.m
//  Raza
//
//  Created by Praveen S on 12/2/13.
//  Copyright (c) 2013 Raza. All rights reserved.
//

#import "RazaRedeemViewController.h"
#import "PhoneMainView.h"
//#import "RazaPersonInfoViewController.h"

@interface RazaRedeemViewController ()

@end

@implementation RazaRedeemViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (!self) {
        // Custom initialization
        return nil;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Redeem Now";
    
    // Do any additional setup after loading the view from its nib.
    
    _redeemPoints = [self getRewardPoints];
    
    [_buttonAmount setTitle:[_redeemPoints objectAtIndex:0] forState:UIControlStateNormal];
    
    NSDictionary *_redeemDict = [NSDictionary dictionaryWithObjects:_redeemPoints forKeys:_redeemPoints];
    
    _redeemPickerVC = [[RazaPickerViewController alloc] initWithDataDictionary:_redeemDict];
    _redeemPickerVC.razapickerdelegate = self;
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSMutableArray *)getRewardPoints {
    
    NSMutableArray* values=[[NSMutableArray alloc]init];
    
    NSString *rewardAmount = [RAZA_USERDEFAULTS stringForKey:@"rewardpoints"]; // @"4560";
    
	int limAmt=[rewardAmount intValue]/1000;
    
    if (limAmt > 0) {
        
        int amt;
        for(int cnt=1; cnt<=limAmt;cnt++ )
        {
            amt=cnt*10;
            NSString *amtString = [NSString stringWithFormat:@"%d",amt];
            
            [values addObject:amtString];
        }
    } else {
        [values addObject:@"0"];
    }
    
    return values;
}

- (IBAction)actionSelectAmount:(id)sender {
    
    _popoverRateList = [[PopoverViewController alloc] initWithFrame:CGRectMake(0, 0, APP_FRAME.size.width, APP_FRAME.size.height) withToolbar:NO];
    
    [_popoverRateList addPopoverContent:_redeemPickerVC];
    
    [_popoverRateList presentInViewController:self];
}

- (IBAction)actionRedeemNow:(id)sender {
    
    if ([RAZA_APPDELEGATE checkNetworkPriorRequest]) {
        
        [RAZA_APPDELEGATE showIndeterminateMessage:MESSAGE_FETCHING_BILLING_INFO withShortMessage:NO];
        
        NSDictionary *loginInfo = [RAZA_USERDEFAULTS objectForKey:@"logininfo"];
        
        [[RazaServiceManager sharedInstance] requestToGetBillingInfo:[loginInfo objectForKey:LOGIN_RESPONSE_ID]];
        [RazaDataModel sharedInstance].delegate = self;
    }
}

-(void)updateView {
   [RAZA_APPDELEGATE hideIndeterminateIndicator:YES];
    RazaPersonInfoViewController *view=VIEW(RazaPersonInfoViewController);
    view.rechargeAmount = _buttonAmount.titleLabel.text;
    view.isRedeem = YES;
    [PhoneMainView.instance changeCurrentView:view.compositeViewDescription];
}

#pragma mark -
#pragma mark RazaPickerViewDelegate methods

-(void)razaPickerViewSelected:(NSString *)selectedValue {
    
    [_buttonAmount setTitle:selectedValue forState:UIControlStateNormal];

    [_popoverRateList dismiss];
}
static UICompositeViewDescription *compositeDescription = nil;

+ (UICompositeViewDescription *)compositeViewDescription {
    if (compositeDescription == nil) {
        compositeDescription = [[UICompositeViewDescription alloc] init:self.class
                                                              statusBar:StatusBarView.class
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

@end
