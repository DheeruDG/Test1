//
//  RazaTemprateBaseViewController.m
//  Raza
//
//  Created by umenit on 8/31/16.
//  Copyright © 2016 Raza. All rights reserved.
//

#import "RazaTemprateBaseViewController.h"
#import "PhoneMainView.h"
@interface RazaTemprateBaseViewController ()

@end

@implementation RazaTemprateBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self->cellnib = [UINib nibWithNibName:@"RazaTempratureCell" bundle:nil];
    [self.tbltemp registerNib:self->cellnib forCellReuseIdentifier:@"RazaTempratureCellId"];
}
- (void)viewWillAppear:(BOOL)animated
{
    
    CAGradientLayer *gradient = [BackgroundLayer navHeaderGradient];
    gradient.frame = self.headerView.bounds;
    gradient.startPoint = CGPointMake(0.0, 0.0);
    gradient.endPoint = CGPointMake(0.0, 1.0);
    gradient.locations = @[@0.0,@1.0];
    [self.headerView.layer insertSublayer:gradient atIndex:0];
    
    if ([[[NSUserDefaults standardUserDefaults]
          stringForKey:Razatempraturemode] length])
        [_btnTemprature setTitle:@"Fahrenheit" forState:UIControlStateNormal];
    else
      [_btnTemprature setTitle:@"Celsius" forState:UIControlStateNormal];
    modeoftemp=[[NSUserDefaults standardUserDefaults]
stringForKey:Razatempraturemode];
        [self.tbltemp reloadData];
    
}
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

- (NSInteger)tableView:(UITableView *)tableview numberOfRowsInSection:(NSInteger)section
{
    
    return 2;
    
    
    
}

- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *Cellidentifier=@"RazaTempratureCellId";
    
    RazaTempratureCell  *cell = (RazaTempratureCell*)[_tableView dequeueReusableCellWithIdentifier: Cellidentifier];
    [cell cellof:cell andindexpath:indexPath andcolor:color andmodeoftemp:modeoftemp];

    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0){
        [self settempstring:@""];
        color=1;
    }
    else{
        color=2;
        [self settempstring:Razatempraturemode];
    }
    modeoftemp=[[NSUserDefaults standardUserDefaults]
                stringForKey:Razatempraturemode];
    [self.tbltemp reloadData];
}
-(void)settempstring:(NSString*)Tempstring
{
    [[NSUserDefaults standardUserDefaults] setObject:Tempstring forKey:Razatempraturemode];
    [[NSUserDefaults standardUserDefaults] synchronize];
   
}
- (IBAction)btnTempratureClicked:(id)sender {
    
    if ([[[NSUserDefaults standardUserDefaults]
         stringForKey:Razatempraturemode] length]) {
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:Razatempraturemode];
        [[NSUserDefaults standardUserDefaults] synchronize];
     
         [_btnTemprature setTitle:@"Cetigrate" forState:UIControlStateNormal];
    }
    else
    {
    [[NSUserDefaults standardUserDefaults] setObject:Razatempraturemode forKey:Razatempraturemode];
        [[NSUserDefaults standardUserDefaults] synchronize];
           [_btnTemprature setTitle:@"Forgenhight" forState:UIControlStateNormal];
    }
   
}
- (IBAction)btnTempratureforclicked:(id)sender {
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

- (IBAction)btnbackClicked:(id)sender {
  //  [PhoneMainView ]
   [PhoneMainView.instance popCurrentView];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshtempval" object:nil];
}
@end
