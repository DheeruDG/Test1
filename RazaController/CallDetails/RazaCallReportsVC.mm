//
//  RazaCallReportsVC.m
//  Raza
//
//  Created by Praveen S on 12/2/13.
//  Copyright (c) 2013 Raza. All rights reserved.
//

#import "RazaCallReportsVC.h"
#import "RazaCallReportCell.h"
#import "PhoneMainView.h"

@interface RazaCallReportsVC ()
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UILabel *phoneHeader;
@property (strong, nonatomic) IBOutlet UILabel *durationHeader;
@end

@implementation RazaCallReportsVC

@synthesize headerView,phoneHeader,durationHeader;



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
  //  static NSString *cellIdentifier = @"RazaCallReportCellID";
    [super viewDidLoad];
    // [TODO:ios update]
    callReportTableView.separatorColor = [UIColor clearColor];
    
   self->cellnib = [UINib nibWithNibName:@"RazaCallReportCell" bundle:nil];
   [callReportTableView registerNib:self->cellnib forCellReuseIdentifier:@"RazaCallReportCellID"];
    
    //headerView.frame=CGRectMake(self.headerView.frame.origin.x,self.headerView.frame.origin.y , self.view.frame.size.width, self.headerView.frame.size.height);

    //callReportTableView.tableHeaderView = headerView;
    
    //phoneHeader.frame=CGRectMake(10, 10, 150, 20);
    phoneHeader.font = RAZA_CELL_FONT;
    phoneHeader.text=@"Date Time/Cost";
    
    //durationHeader.frame=CGRectMake(self.view.frame.size.width-100, 10, 100, 20);
    durationHeader.font = RAZA_CELL_FONT;
    durationHeader.text=@"Duration";

    // Do any additional setup after loading the view from its nib.
    
    //[callReportTableView registerClass: [RazaCallReportCell class] forCellReuseIdentifier:cellIdentifier];
    NSLog(@"%@",_callreports);
    [self updatedone];
}
- (void)viewWillAppear:(BOOL)animated
{
    [callReportTableView reloadData];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.callreports count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

//- (UIView *)tableView:(UITableView *)TableView viewForHeaderInSection:(NSInteger)section
//{
//    
//    UIView *headerView = [[UIView alloc]init];
//    headerView.backgroundColor = UIColorFromRGBA(158, 187, 234, 1);
//    
//    UILabel *phoneHeader = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, 20)];
//    phoneHeader.font = RAZA_CELL_FONT;
//    phoneHeader.text=@"Date/Time";
//    phoneHeader.textAlignment = NSTextAlignmentCenter;
//    [headerView addSubview:phoneHeader];
//    
//    UILabel *durationHeader = [[UILabel alloc]initWithFrame:CGRectMake(90, 0, 320, 20)];
//    durationHeader.font = RAZA_CELL_FONT;
//    durationHeader.text=@"Duration";
//    durationHeader.textAlignment = NSTextAlignmentCenter;
//    [headerView addSubview:durationHeader];
//    
//    return headerView;
//}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    RazaCallReportCell *cell = (RazaCallReportCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
//    if (!cell)
//    {
//       //cell = [[RazaCallReportCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//      // cell = (RazaCallReportCell *)[[[NSBundle mainBundle] loadNibNamed:@"RazaCallReportCell" owner:self options:nil] lastObject];
//        cell.backgroundColor = [UIColor colorWithRed:0.8f green:0.8f blue:0.8f alpha:1.0f];
//    }
    
    RazaCallReportCell  *cell = (RazaCallReportCell*)[tableView dequeueReusableCellWithIdentifier: @"RazaCallReportCellID"];
    if (cell == nil)
    {
        cell = [[RazaCallReportCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RazaCallReportCellID"];
    }
    
    NSDictionary *callinfo = [self.callreports objectAtIndex:indexPath.row];
    
    cell.labelTitle.text = [callinfo objectForKey:@"date"];
    cell.labelDate.text = [callinfo objectForKey:@"duration"];
    cell.labelRate.text = [callinfo objectForKey:@"cost"];
    
    return cell;
}
static UICompositeViewDescription *compositeDescription = nil;

+ (UICompositeViewDescription *)compositeViewDescription {
    if (compositeDescription == nil) {
        compositeDescription = [[UICompositeViewDescription alloc] init:self.class
                                                              statusBar:nil
                                                                 tabBar:nil
                                                               sideMenu:nil
                                                             fullscreen:false
                                                         isLeftFragment:NO
                                                           fragmentWith:nil];
    }
    return compositeDescription;
}

- (UICompositeViewDescription *)compositeViewDescription {
    return self.class.compositeViewDescription;
}
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
    RazaCallDetailsVC *view = VIEW(RazaCallDetailsVC);
    [PhoneMainView.instance popToView:view.compositeViewDescription];
}
@end
