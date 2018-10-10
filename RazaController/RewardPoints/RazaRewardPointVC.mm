//
//  RazaRewardPointVC.m
//  Raza
//
//  Created by Praveen S on 12/2/13.
//  Copyright (c) 2013 Raza. All rights reserved.
//

#import "RazaRewardPointVC.h"
#import "RazaRedeemViewController.h"
#import "PhoneMainView.h"
//#import "RazaCreditCardController.h"

@interface RazaRewardPointVC ()

@end

static NSString *alertTitle = @"Reward Point";

@implementation RazaRewardPointVC

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
    
    pointRewardArray=[[NSMutableArray alloc]init];
    [self.tableView registerClass: [UITableViewCell class] forCellReuseIdentifier:@"PointsCell"];
    
    // Do any additional setup after loading the view from its nib.

    if (!IS_IPHONE_5) {
        
        _viewButton.frame = CGRectMake(_viewButton.frame.origin.x, _viewButton.frame.origin.y - 90, _viewButton.frame.size.width, _viewButton.frame.size.height);
    }
    //[RAZA_APPDELEGATE hideIndeterminateIndicator:YES];
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    CAGradientLayer *gradient = [BackgroundLayer navHeaderGradient];
    gradient.frame = headerView.bounds;
    gradient.startPoint = CGPointMake(0.0, 0.0);
    gradient.endPoint = CGPointMake(0.0, 1.0);
    gradient.locations = @[@0.0,@1.0];
    [headerView.layer insertSublayer:gradient atIndex:0];
    
    CAGradientLayer *gradient12 = [BackgroundLayer navHeaderGradient];
    gradient12.frame = self.selectAmountHeaderView.bounds;
    gradient12.startPoint = CGPointMake(0.0, 0.0);
    gradient12.endPoint = CGPointMake(0.0, 1.0);
    gradient12.locations = @[@0.0,@1.0];
    [self.selectAmountHeaderView.layer insertSublayer:gradient12 atIndex:0];
    
    CAGradientLayer *gradient1 = [BackgroundLayer linearGradient];
    gradient1.frame = _buttonRedeemPoints.bounds;
    gradient1.startPoint = CGPointMake(0.0,0.0);
    gradient1.endPoint = CGPointMake(1.0,0.0);
    [_buttonRedeemPoints.layer insertSublayer:gradient1 atIndex:0];
    
    CAGradientLayer *gradient2 = [BackgroundLayer linearGradient];
    gradient2.frame = _buttonRedeemPoints1.bounds;
    gradient2.startPoint = CGPointMake(0.0,0.0);
    gradient2.endPoint = CGPointMake(1.0,0.0);
    [_buttonRedeemPoints1.layer insertSublayer:gradient2 atIndex:0];
    
    if ([[Razauser SharedInstance] getsidebar].length){
        [Razauser SharedInstance].sideBarIndex=3;
    }else{
        [Razauser SharedInstance].sideBarIndex=2;
    }
    BOOL isConnected = [RAZA_APPDELEGATE checkNetworkPriorRequest];
    
    if (isConnected)
    {
        
        [RAZA_APPDELEGATE showIndeterminateMessage:@"" withShortMessage:NO];
        
        NSString *noticeMessage = [self noticeForRewardPoints];
        
        [_webViewNotice loadHTMLString:noticeMessage baseURL:nil];
        
        NSDictionary *loginInfo = [RAZA_USERDEFAULTS objectForKey:@"logininfo"];
        [[RazaServiceManager sharedInstance] GetRewardSignUpStatus:[loginInfo objectForKey:LOGIN_RESPONSE_ID] withDelegate:self];
        
        // [[RazaServiceManager sharedInstance] requestToGetRewardPoints:[loginInfo objectForKey:LOGIN_RESPONSE_ID] withDelegate:self];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSString *)noticeForRewardPoints {
    
    NSString* beforeBody = @"<html><head><link type=\"text/css\" rel=\"stylesheet\" media=\"only screen and (max-device-width: 480px)\" href=\"terms-styles.css\" /> </head><body>";
    NSString* afterBody = @"</div></body></html>";
    
    NSString *bodyContent = @"<div><font face=Poppins-Regular size=2px><b>Raza Rewards points can be redeemed against  your purchases. Every 1000 points = Free $10.</b><br><br>Raza Rewards  program gives you points for all  recharges, purchases and referrals! For every $1"\
    @"you spend, you will receive 4 reward points. For instance if you recharge or purchase for $100 you will get 400 Raza Rewards. For every Friend Referral you will earn 250 points! </br>"\
    
    @"Raza Rewards  points never expire and hence you can keep accumulating your points on your valid plan and exchange the points for minutes points for minutes anytime. </br>"\
    
    @" Raza Rewards points will be credited to a customer's account within 2 weeks of the qualifying purchase. </br>"\
    
    @"</font>";
    
    NSString *htmlDefn = [beforeBody stringByAppendingString:bodyContent];
    
    htmlDefn = [htmlDefn stringByAppendingString:afterBody];
    
    return htmlDefn;
}



-(void)receivedDataFromService:(NSDictionary *)info withResponseType:(NSString *)responseType {
    self.scrollView.hidden=NO;
    if ([responseType isEqualToString:@"RewardSignUp"]) {
        if ([[info objectForKey:@"ResponseCode"] isEqualToString:@"1"]) {
            [RAZA_APPDELEGATE showAlertWithMessage:@"Successfully signed up!" withTitle:@"Rewards Signup" withCancelTitle:@"OK"];
            
            NSDictionary *loginInfo = [RAZA_USERDEFAULTS objectForKey:@"logininfo"];
            [[RazaServiceManager sharedInstance] GetRewardSignUpStatus:[loginInfo objectForKey:LOGIN_RESPONSE_ID] withDelegate:self];
        }else{
            [RAZA_APPDELEGATE showAlertWithMessage:[info objectForKey:@"ResponseMessage"] withTitle:@"Rewards Signup Error" withCancelTitle:@"OK"];
        }

    }else if ([responseType isEqualToString:@"GetRewardSignUpStatus"]) {
        [RAZA_APPDELEGATE hideIndeterminateIndicator:YES];
        if ([[info objectForKey:@"ResponseCode"] isEqualToString:@"1"]) {
            NSDictionary *RewardSummaryDic=[info objectForKey:@"RewardSummary"];
            
            _joinPointsLbl.text=[RewardSummaryDic objectForKey:@"SignUpPoints"];
            _rechargePointLbl.text=[RewardSummaryDic objectForKey:@"PurchasePoints"];
            _referFriendPointsLbl.text=[RewardSummaryDic objectForKey:@"RefereFriendPoints"];
            _redeemPointsLbl.text=[NSString stringWithFormat:@"-%@",[RewardSummaryDic objectForKey:@"RedeemedPoints"]];
            
            _rewardPoints=[NSString stringWithFormat:@"%d",[_joinPointsLbl.text intValue]+[_referFriendPointsLbl.text intValue]+[_rechargePointLbl.text intValue]-[[RewardSummaryDic objectForKey:@"RedeemedPoints"] intValue]];
            
            _labelRewardPoints.text = _rewardPoints;
            [RAZA_USERDEFAULTS setObject:_rewardPoints forKey:@"rewardpoints"];
            self.joinRazaView.hidden=YES;
            
            if ([_rewardPoints intValue] >= 1000){
                // _redeemPointViewHTConst.constant=225;
                // _buttonRedeemPoints.enabled = YES;
                int rewardPoint = [_rewardPoints intValue] / 1000;
                rechargeAmount=[NSString stringWithFormat:@"%d",rewardPoint*10];
                NSLog(@"%d",rewardPoint);
                for (int modVal=1; modVal<=rewardPoint; modVal++) {
                    NSString *sectionTextValue=[NSString stringWithFormat:@"$%d (%d points)",modVal*10,modVal*1000];
                    [pointRewardArray addObject:sectionTextValue];
                }
                [self.tableView reloadData];
            }else{
                //_redeemPointViewHTConst.constant=180;
            }
        }else{
            [RAZA_APPDELEGATE showAlertWithMessage:[info objectForKey:@"ResponseMessage"] withTitle:@"Rewards Signup Error" withCancelTitle:@"OK"];
            self.joinRazaView.hidden=NO;
        }
        
    }else if ([responseType isEqualToString:@"Get_Reward_Points_V1Result"]) {
        [RAZA_APPDELEGATE hideIndeterminateIndicator:YES];
        
        if ([[info objectForKey:@"status"] isEqualToString:@"1"]){
            self.scrollView.hidden=NO;
            
            _rewardPoints = [info objectForKey:@"point"];
            _labelRewardPoints.text = _rewardPoints;
            [RAZA_USERDEFAULTS setObject:_rewardPoints forKey:@"rewardpoints"];
            //[hud hide:YES];
            if ([_rewardPoints intValue] >= 1000)
            {
                self.joinRazaView.hidden=YES;
                // _buttonRedeemPoints.enabled = YES;
                int rewardPoint = [@"5100" intValue] / 1000;
                rechargeAmount=[NSString stringWithFormat:@"%d",rewardPoint*10];
                NSLog(@"%d",rewardPoint);
                for (int modVal=1; modVal<=rewardPoint; modVal++) {
                    NSString *sectionTextValue=[NSString stringWithFormat:@"$%d (%d points)",modVal*10,modVal*1000];
                    [pointRewardArray addObject:sectionTextValue];
                }
                [self.tableView reloadData];
            }
            
        }
    }
    
}

#pragma mark -
#pragma mark UIButton action methods

- (IBAction)actionRechargeFromPoints:(id)sender {
    [RAZA_APPDELEGATE showIndeterminateMessage:@"" withShortMessage:NO];
    NSDictionary *loginInfo = [RAZA_USERDEFAULTS objectForKey:@"logininfo"];
    [[RazaServiceManager sharedInstance] RewardSignUp:[loginInfo objectForKey:LOGIN_RESPONSE_ID] withDelegate:self];
    
}

- (IBAction)actionPurchasePoints:(id)sender {
    //    RazaRedeemViewController *view = VIEW(RazaRedeemViewController);
    //    [PhoneMainView.instance changeCurrentView:view.compositeViewDescription];
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
        // Cancel button tappped.
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"USA" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        NSString *phNo = @"1-877-463-4233";
        NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"telprompt:%@",phNo]];
        
        if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
            [Razauser SharedInstance].modeofview=@"no";
            [[UIApplication sharedApplication] openURL:phoneUrl];
        } else
        {
            UIAlertView*  calert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Call facility is not available!!!" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
            [calert show];
        }
        
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"CANADA" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        
        NSString *phNo = @"1-800-550-3501";
        NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"telprompt:%@",phNo]];
        
        if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
            [Razauser SharedInstance].modeofview=@"no";
            [[UIApplication sharedApplication] openURL:phoneUrl];
        } else
        {
            UIAlertView*  calert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Call facility is not available!!!" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
            [calert show];
        }
    }]];
    
    // Present action sheet.
    [self presentViewController:actionSheet animated:YES completion:nil];
    
    //
    //    if (rechargeAmount.length>0) {
    //        if ([RAZA_APPDELEGATE checkNetworkPriorRequest]) {
    //
    //            [RAZA_APPDELEGATE showIndeterminateMessage:MESSAGE_FETCHING_BILLING_INFO withShortMessage:NO];
    //
    //            NSDictionary *loginInfo = [RAZA_USERDEFAULTS objectForKey:@"logininfo"];
    //
    //            [[RazaServiceManager sharedInstance] requestToGetBillingInfo:[loginInfo objectForKey:LOGIN_RESPONSE_ID]];
    //            [RazaDataModel sharedInstance].delegate = self;
    //        }
    //    }else{
    //
    //    }
}


-(void)updateView {
    [RAZA_APPDELEGATE hideIndeterminateIndicator:YES];
    RazaPersonInfoViewController *view=VIEW(RazaPersonInfoViewController);
    view.rechargeAmount = rechargeAmount;
    view.isRedeem = YES;
    [PhoneMainView.instance changeCurrentView:view.compositeViewDescription];
}



static UICompositeViewDescription *compositeDescription = nil;

+ (UICompositeViewDescription *)compositeViewDescription {
    if (compositeDescription == nil) {
        compositeDescription = [[UICompositeViewDescription alloc] init:self.class
                                                              statusBar:nil//StatusBarView.class
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

- (IBAction)btnMenuClicked:(id)sender {
    
    UICompositeView *cvc = PhoneMainView.instance.mainViewController;
    [cvc hideSideMenu:(cvc.sideMenuView.frame.origin.x == 0)];
}

#pragma mark -
#pragma mark UITableView delegate & datasource methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [pointRewardArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"PointsCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.textColor=OxfordBlueColor;
    cell.textLabel.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:18];
    cell.textLabel.text=pointRewardArray[indexPath.row];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    rechargeAmount=[NSString stringWithFormat:@"%d",((int)indexPath.row+1)*10];
    _redeemPointsLbl.text=[NSString stringWithFormat:@"-%d",((int)indexPath.row+1)*1000];
    
    [self selectionAmountViewHide];
}
- (IBAction)rewardPointsListOpenAction:(id)sender {
    //    if ([_rewardPoints intValue] >= 1000){
    //        [self selectionAmountViewShow];
    //    }
}

-(void)selectionAmountViewShow{
    self.scrollView.hidden=YES;
    self.selectAmountView.hidden=NO;
    CGRect napkinBottomFrame = self.selectAmountView.frame;
    napkinBottomFrame.origin.x = SCREENWIDTH;
    self.selectAmountView.frame = napkinBottomFrame;
    
    [UIView animateWithDuration:0.3 delay:0.0 options: UIViewAnimationOptionCurveEaseOut animations:^{
        CGRect napkinBottomFrame = self.selectAmountView.frame;
        napkinBottomFrame.origin.x = 0;
        self.selectAmountView.frame = napkinBottomFrame;
    } completion:^(BOOL finished){/*done*/}];
    
    
}

-(void)selectionAmountViewHide{
    self.scrollView.hidden=NO;
    
    CGRect napkinBottomFrame = self.selectAmountView.frame;
    napkinBottomFrame.origin.x = 0;
    self.selectAmountView.frame = napkinBottomFrame;
    
    [UIView animateWithDuration:0.3 delay:0.0 options: UIViewAnimationOptionCurveEaseOut animations:^{
        CGRect napkinBottomFrame = self.selectAmountView.frame;
        napkinBottomFrame.origin.x = SCREENWIDTH;
        self.selectAmountView.frame = napkinBottomFrame;
    } completion:^(BOOL finished){
        self.selectAmountView.hidden=YES;
    }];
    
}
- (IBAction)backSectionAmountView:(id)sender {
    [self selectionAmountViewHide];
}

@end
