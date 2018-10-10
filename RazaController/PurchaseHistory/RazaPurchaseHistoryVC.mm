//
//  RazaPurchaseHistoryVC.m
//  Raza
//
//  Created by Praveen S on 12/2/13.
//  Copyright (c) 2013 Raza. All rights reserved.
//

#import "RazaPurchaseHistoryVC.h"
#import "RazaPurchaseHistoryCell.h"
#import "PhoneMainView.h"
@interface RazaPurchaseHistoryVC ()
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UILabel *noPurchasehistoryLbl;

@end

@implementation RazaPurchaseHistoryVC
@synthesize headerView,durationHeader,phoneHeader;

static NSString *CellIdentifier = @"RazaPurchaseHistoryCellID";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
   
    
    // [TODO:ios update]
    purchaseTableView.separatorColor = [UIColor clearColor];
    
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
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
    
    [Razauser SharedInstance].sideBarIndex=4;
    
    BOOL network = [RAZA_APPDELEGATE checkNetworkPriorRequest];
    
    if (network) {
        //[[Razauser SharedInstance]ShowWaitingshort:@"" andtime:5];
        [RAZA_APPDELEGATE showIndeterminateMessage:@"" withShortMessage:NO];

        NSDictionary *loginInfo = [RAZA_USERDEFAULTS objectForKey:@"logininfo"];
        [[RazaServiceManager sharedInstance] requestToGetOrderHistory:[loginInfo objectForKey:LOGIN_RESPONSE_ID]];
        [RazaDataModel sharedInstance].delegate = self;
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateView {
    
    [RAZA_APPDELEGATE hideIndeterminateIndicator:YES];
    
    _purchaseHistoryList = [RazaDataModel sharedInstance].purchaseHistories;
    if (_purchaseHistoryList) {
        self.noPurchasehistoryLbl.hidden=YES;
        [purchaseTableView reloadData];
    }else{
        self.noPurchasehistoryLbl.hidden=NO;
    }
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_purchaseHistoryList count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RazaPurchaseHistoryCell *cell = (RazaPurchaseHistoryCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell){
        cell = (RazaPurchaseHistoryCell *)[[[NSBundle mainBundle] loadNibNamed:@"RazaPurchaseHistoryCell" owner:self options:nil] lastObject];
    }
    
    NSString *info = [_purchaseHistoryList objectAtIndex:indexPath.section];
    
    NSArray *individual = [info componentsSeparatedByString:@"|"];
    //cell.labelRate.frame=CGRectMake(cell.frame.size.width-100, 10, 100, 20);
    cell.labelTitle.text = [[individual objectAtIndex:0] capitalizedString];
    cell.labelDate.text = [individual objectAtIndex:1];
    cell.labelRate.text = [individual objectAtIndex:2];
    
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 20)];
    headerView.backgroundColor=[UIColor clearColor];
    return headerView;
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

@end
