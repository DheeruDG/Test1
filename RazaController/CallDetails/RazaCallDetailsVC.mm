//
//  RazaCallDetailsVC.m
//  Raza
//
//  Created by Praveen S on 12/2/13.
//  Copyright (c) 2013 Raza. All rights reserved.
//

#import "RazaCallDetailsVC.h"
#import "RazaCallReportsVC.h"
#import "PhoneMainView.h"
#import "CallDetailsCell.h"


@interface RazaCallDetailsVC ()
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UILabel *phoneHeader;
@property (strong, nonatomic) IBOutlet UILabel *durationHeader;
@property (weak, nonatomic) IBOutlet UIView *topView;

@end

@implementation RazaCallDetailsVC
@synthesize headerView,phoneHeader,durationHeader;

static NSString *CellIdentifier = @"CallLogCell";

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
    
    [calldetailTableView registerClass: [CallDetailsCell class] forCellReuseIdentifier:CellIdentifier];
    
    // Do any additional setup after loading the view from its nib.
   
    
    calldetailTableView.separatorColor = [UIColor clearColor];
    phoneHeader.text=@"Destination#";

    durationHeader.text=@"Info";
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
    
    if ([[Razauser SharedInstance] getsidebar].length){
        [Razauser SharedInstance].sideBarIndex=5;
    }else{
        [Razauser SharedInstance].sideBarIndex=3;
    }
    BOOL network = [RAZA_APPDELEGATE checkNetworkPriorRequest];
    
    if (network) {
        
        [RAZA_APPDELEGATE showIndeterminateMessage:@"" withShortMessage:NO];
        
        NSDictionary *loginInfo = [RAZA_USERDEFAULTS objectForKey:@"logininfo"];
        
        [[RazaServiceManager sharedInstance] requestToGetCallHistory:[loginInfo objectForKey:LOGIN_RESPONSE_PIN]];
        [RazaDataModel sharedInstance].delegate = self;
        
 
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateView {
    
    NSLog(@"self.callLogsArray %@",[RazaDataModel sharedInstance].callLogsArray);
    [RAZA_APPDELEGATE hideIndeterminateIndicator:YES];
    
//    if ([[RazaDataModel sharedInstance].callKeys count]) {
//
//        [self showErrorLabel:NO];
//
//        _sections = [RazaDataModel sharedInstance].callKeys;
//        _calllogs = [RazaDataModel sharedInstance].callLogs;
//        [calldetailTableView reloadData];
//    }
    if ([[RazaDataModel sharedInstance].callLogsArray count]) {
        
        [self showErrorLabel:NO];
        
        _sections = [RazaDataModel sharedInstance].callLogsArray;
        [calldetailTableView reloadData];
    }
    else {
        
        [self showErrorLabel:YES];
    }
}

-(void)showErrorLabel:(BOOL)flag {
    
    calldetailTableView.hidden = flag;
    _labelNoCallDetails.hidden = !flag;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_sections count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CallDetailsCell *cell = (CallDetailsCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (!cell){
        cell = [[CallDetailsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    NSString *phoneNumber = [[_sections objectAtIndex:indexPath.section] objectAtIndex:1];
    NSString *date = [[_sections objectAtIndex:indexPath.section] objectAtIndex:0];
    NSString *rate = [[_sections objectAtIndex:indexPath.section] objectAtIndex:3];
    NSString *mins = [[_sections objectAtIndex:indexPath.section] objectAtIndex:2];

  //  cell.accessoryType = UITableViewCellAccessoryDetailButton;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.mobileLbl.text = phoneNumber;
    cell.dateTimeLbl.text = date;
    cell.ratesLbl.text = [NSString stringWithFormat:@"$%@",rate];
    cell.minsLbl.text = mins;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
//    NSArray *callreports = [_calllogs objectForKey:[_sections objectAtIndex:indexPath.row]];
//
//    RazaCallReportsVC *view = VIEW(RazaCallReportsVC);
//    view.callreports = callreports;
//    [PhoneMainView.instance changeCurrentView:view.compositeViewDescription];
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
