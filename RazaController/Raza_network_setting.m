//
//  Raza_network_setting.m
//  Raza
//
//  Created by umenit on 6/11/15.
//  Copyright (c) 2015 Raza. All rights reserved.
//

#import "Raza_network_setting.h"
#import "PhoneMainView.h"
#define iPhone4Or5oriPad ([[UIScreen mainScreen] bounds].size.height == 568 ? 5 : ([[UIScreen mainScreen] bounds].size.height == 480 ? 4 : 999))
@interface Raza_network_setting (){
    float xAxis,yAxis;
}
@property (weak, nonatomic) IBOutlet UIView *headerView;

@end

@implementation Raza_network_setting
@synthesize tbl;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tbl.rowHeight = UITableViewAutomaticDimension;
    self.tbl.estimatedRowHeight = 145.0;
    // Do any additional setup after loading the view from its nib.
    
    
    xAxis=APP_FRAME.size.width/2 - APP_FRAME.size.width/3;
    yAxis=APP_FRAME.size.height/2 - APP_FRAME.size.height/4;
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureRecognized:)];
    [self.tbl addGestureRecognizer:longPress];
    
    
    tbl.delegate=self;
    tbl.dataSource=self;
    self.editing = YES;
    self->nib = [UINib nibWithNibName:@"raza_network_cell" bundle:nil];
    [self.tbl registerNib:self->nib forCellReuseIdentifier:@"customcellofnetwork"];
    
    self.tbl.delaysContentTouches = NO;
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    CAGradientLayer *gradient = [BackgroundLayer navHeaderGradient];
    gradient.frame = self.headerView.bounds;
    gradient.startPoint = CGPointMake(0.0, 0.0);
    gradient.endPoint = CGPointMake(0.0, 1.0);
    gradient.locations = @[@0.0,@1.0];
    [self.headerView.layer insertSublayer:gradient atIndex:0];
    
    if ([[Razauser SharedInstance] getsidebar].length){
        [Razauser SharedInstance].sideBarIndex=2;
    }else{
        [Razauser SharedInstance].sideBarIndex=1;
    }
    
    NSTimeInterval timeInterval = 1.0f; // how long your view will last before hiding
    [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(hideView) userInfo:nil repeats:NO];
    //    UIView* view = [[UIView alloc] initWithFrame: CGRectMake(100, 100, 200, 30)];
    //    UILabel *lbl=[[UILabel alloc] initWithFrame: CGRectMake(0,0, 200, 10)];
    //    lbl.text=@"Drag to reorder";
    //    view.layer.cornerRadius=5;
    //    view.clipsToBounds=YES;
    //    [view setBackgroundColor: [UIColor yellowColor]];
    //    [view addSubview:lbl];
    //    [self.view addSubview: view];
    //    [UIView animateWithDuration:3 delay:2.0 options:0 animations:^{
    //        // Animate the alpha value of your imageView from 1.0 to 0.0 here
    //        view.alpha = 0.0f;
    //    } completion:^(BOOL finished) {
    //        // Once the animation is completed and the alpha has gone to 0.0, hide the view for good
    //        view.hidden = YES;
    //    }];
    //initData
    //[tbl reloadData];
    // NSMutableArray *dataFromPlist2 =[[NSMutableArray alloc]initWithArray:[data valueForKey:@"valueof"]];
    
    
    
    
    //  int checkhowmuch=[self checkforavailablevalue];
    //[self valuetoreplace:dataFromPlist2 :checkhowmuch];
    
    
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //1
    NSString *documentsDirectory = [paths objectAtIndex:0]; //2
    path = [documentsDirectory stringByAppendingPathComponent:@"network_update.plist"]; //3
    // NSLog(@"%@",path);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath: path]) //4
    {
        NSString *bundle = [[NSBundle mainBundle] pathForResource:@"network_update" ofType:@"plist"]; //5
        
        [fileManager copyItemAtPath:bundle toPath: path error:&error]; //6
    }
    
    data = [[NSMutableDictionary alloc] initWithContentsOfFile: path];
    
    
    
    dispatch_async(dispatch_get_main_queue(), ^(){
        //Add method, task you want perform on mainQueue
        //Control UIView, IBOutlet all here
        [self.tbl reloadData];
        
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)patchSelector{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)viewWillDisappear:(BOOL)animated
{
    /// [self.navigationController popToViewController:self animated:YES];
    // [self.navigationController popToRootViewControllerAnimated:YES];
    [self performSelector:@selector(patchSelector) withObject:nil afterDelay:0.3];
    
}
-(void) hideView {
    UIView* view = [[UIView alloc] initWithFrame: CGRectMake(xAxis, yAxis, 200, 30)];
    UILabel *lbl=[[UILabel alloc] initWithFrame: CGRectMake(40,5, 150, 18)];
    lbl.text=@"Drag to reorder";
    lbl.textColor = [UIColor whiteColor];
    view.layer.cornerRadius=10;
    view.clipsToBounds=YES;
    [lbl setBackgroundColor:[UIColor clearColor]];
    [view setBackgroundColor: [UIColor blackColor]];
    [view addSubview:lbl];
    [self.view addSubview: view];
    view.center=self.view.center;
    
    [UIView beginAnimations:@"fadeOut" context:nil];
    [UIView setAnimationDuration:5]; // add the value you want
    view.alpha = 0.0f;
    [UIView commitAnimations];
}
-(void) atleaseoneon {
    UIView* view = [[UIView alloc] initWithFrame: CGRectMake(xAxis, yAxis, 200, 60)];
    UILabel *lbl=[[UILabel alloc] initWithFrame: CGRectMake(10,0, 200, 60)];
    lbl.lineBreakMode = NSLineBreakByWordWrapping;
    lbl.numberOfLines = 0;
    lbl.text=@"You must have at least one call type enabled!";
    lbl.textColor = [UIColor whiteColor];
    view.layer.cornerRadius=10;
    view.clipsToBounds=YES;
    [lbl setBackgroundColor:[UIColor clearColor]];
    [view setBackgroundColor: [UIColor blackColor]];
    [view addSubview:lbl];
    [self.view addSubview: view];
    view.center=self.view.center;
    [UIView beginAnimations:@"fadeOut" context:nil];
    [UIView setAnimationDuration:1.5]; // add the value you want
    view.alpha = 0.0f;
    [UIView commitAnimations];
}
-(void)backone
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (NSInteger)tableView:(UITableView *)tableview numberOfRowsInSection:(NSInteger)section
{
    
    return [data count];
    
}

- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *Cellidentifier=@"customcellofnetwork";
    raza_network_cell  *cell = (raza_network_cell*)[_tableView dequeueReusableCellWithIdentifier: Cellidentifier];
    cell.lbl_name.text=[[data objectForKey:@"name"] objectAtIndex:indexPath.row];
    cell.lbl_desc.text=[[data objectForKey:@"order"] objectAtIndex:indexPath.row];
    cell.lbl_name.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:18];
    cell.lbl_number.text=[NSString stringWithFormat:@"%d",(int)indexPath.row+1];

    cell.btnswitch.tag=indexPath.row;
    UIImage *btnImageon = [UIImage imageNamed:@"on_switch.png"];
    UIImage *btnImageoff = [UIImage imageNamed:@"off_switch.png"];
    
    if (indexPath.row==0){
        if ([[[data objectForKey:@"valueof"] objectAtIndex:indexPath.row] isEqual:@"1"]){
            [cell.btnswitch setImage:btnImageon forState:UIControlStateNormal];
            firstbtn=@"yes";
        }else{
            [cell.btnswitch setImage:btnImageoff forState:UIControlStateNormal];
            firstbtn=@"no";
        }
    }else if (indexPath.row==1){
        if ([[[data objectForKey:@"valueof"] objectAtIndex:indexPath.row] isEqual:@"1"]){
            [cell.btnswitch setImage:btnImageon forState:UIControlStateNormal];
            secondbtn=@"yes";
        }else{
            secondbtn=@"no";
            [cell.btnswitch setImage:btnImageoff forState:UIControlStateNormal];
        }
    }else if (indexPath.row==2){
        if ([[[data objectForKey:@"valueof"] objectAtIndex:indexPath.row] isEqual:@"1"]){
            [cell.btnswitch setImage:btnImageon forState:UIControlStateNormal];
            sthirdbtn=@"yes";
        }else{
            [cell.btnswitch setImage:btnImageoff forState:UIControlStateNormal];
            sthirdbtn=@"no";
        }
    }
    [cell.btnswitch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventTouchUpInside];
    [cell updatecell:cell];
    return cell;
}
-(void)toshowforatleastone
{
    NSTimeInterval timeInterval = 0.1f; // how long your view will last before hiding
    [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(atleaseoneon) userInfo:nil repeats:NO];
}
//- (void) switchChanged:(id)sender
- (IBAction) switchChanged:(id)sender
{
    //UIButton *buttonClicked = (UIButton *)sender;
    int forvalue=(int)[sender tag];
    NSLog(@"kkkk--%ld",(long)[sender tag]);
    //[NSObject cancelPreviousPerformRequestsWithTarget:self];
    int a=[self checkforavailablevalue];
    //    if (2) {
    //        NSTimeInterval timeInterval = 0.1f; // how long your view will last before hiding
    //        [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(atleaseoneon) userInfo:nil repeats:NO];
    //    }
    
    
    //  UISwitch* switchControl = sender;
    CGPoint switchPositionPoint = [sender convertPoint:CGPointZero toView:[self tbl]];
    NSIndexPath *indexPath = [[self tbl] indexPathForRowAtPoint:switchPositionPoint];
    
    raza_network_cell *cell = (raza_network_cell*)[self.tbl cellForRowAtIndexPath:indexPath];
    
    //int tag=indexPath.row;
    
    
    //    switch ([sender tag])
    //    {
    //        case 0:
    //
    //            if (switchControl.on)
    //            {
    //                [self switchon:[sender tag]];
    //
    //
    //            }
    //            else
    //            {
    ////                if (a==1)
    ////                {
    ////                    switchControl.on=YES;
    ////                    [self toshowforatleastone];
    ////                }
    ////                else
    //                [self switchoff:[sender tag]];
    //
    //            }
    //            break;
    //        case 1:
    //            if (switchControl.on)
    //            {
    //
    //                [self switchon:[sender tag]];
    //            }
    //            else
    //            {
    ////                if (a==1)
    ////                {
    ////                    switchControl.on=YES;
    ////                     [self toshowforatleastone];
    ////                }
    ////                else
    //                [self switchoff:[sender tag]];
    //            }
    //            break;
    //        case 2:
    //            if (switchControl.on)
    //            {
    //
    //                [self switchon:[sender tag]];
    //
    //            }
    //            else
    //            {
    ////                if (a==1)
    ////                {
    ////                    switchControl.on=YES;
    ////                     [self toshowforatleastone];
    ////                }
    ////                else
    //                [self switchoff:[sender tag]];
    //            }
    //            break;
    //        default:
    //            break;
    //    }
    // firstbtn;
    // secondbtn;
    //sthirdbtn;
    //    switch (forvalue)
    //    {
    //        case 0:
    //            if ([firstbtn isEqual:@"yes"])
    //            {
    //                firstbtn=@"no";
    //            }
    //            else
    //            {
    //                firstbtn=@"yes";
    //            }
    //            break;
    //
    //        case 1:
    //            if ([secondbtn isEqual:@"yes"])
    //            {
    //                secondbtn=@"no";
    //            }
    //            else
    //            {
    //                secondbtn=@"yes";
    //            }
    //            break;
    //        case 2:
    //            if ([sthirdbtn isEqual:@"yes"])
    //            {
    //                sthirdbtn=@"no";
    //            }
    //            else
    //            {
    //                sthirdbtn=@"yes";
    //            }
    //            break;
    //
    //        default:
    //            break;
    //    }
    
    if (forvalue==0)
    {
        if ([firstbtn isEqual:@"no"])
        {
            [self switchon:forvalue];
            // firstbtn=@"no";
            
        }
        else if([firstbtn isEqual:@"yes"])
        {
            if (a==1)
            {
                //cell.uswich.on=YES;
                btnswitchclk0=YES;
                UIImage *btnImageoff = [UIImage imageNamed:@"on_switch.png"];
                [cell.btnswitch setImage:btnImageoff forState:UIControlStateNormal];
                [self toshowforatleastone];
            }
            else
                [self switchoff:forvalue];
        }
        
    }
    else if (forvalue==1)
    {
        if ([secondbtn isEqual:@"no"])
        {
            
            [self switchon:forvalue];
            
            
        }
        else  if ([secondbtn isEqual:@"yes"])
        {
            if (a==1)
            {
                // cell.uswich.on=YES;
                btnswitchclk1=YES;
                UIImage *btnImageoff = [UIImage imageNamed:@"on_switch.png"];
                [cell.btnswitch setImage:btnImageoff forState:UIControlStateNormal];
                [self toshowforatleastone];
            }
            else
            {
                [self switchoff:forvalue];
                UIImage *btnImageoff = [UIImage imageNamed:@"off_switch.png"];
                [cell.btnswitch setImage:btnImageoff forState:UIControlStateNormal];
            }
        }
        
    }
    else if (forvalue==2)
    {
        if ([sthirdbtn isEqual:@"no"])
        {
            [self switchon:forvalue];
            
            
        }
        else  if ([sthirdbtn isEqual:@"yes"])
        {
            if (a==1)
            {
                //cell.uswich.on=YES;
                btnswitchclk2=YES;
                UIImage *btnImageoff = [UIImage imageNamed:@"on_switch.png"];
                [cell.btnswitch setImage:btnImageoff forState:UIControlStateNormal];
                [self toshowforatleastone];
            }
            else
            {
                [self switchoff:forvalue];
                UIImage *btnImageoff = [UIImage imageNamed:@"off_switch.png"];
                [cell.btnswitch setImage:btnImageoff forState:UIControlStateNormal];
            }
        }
        
    }
    
}
- (void)switchon:(int)passtoswitch
{
    //  NSLog(@"%d====",passtoswitch);
    NSMutableArray *dataFromPlist2 =[[NSMutableArray alloc]initWithArray:[data valueForKey:@"valueof"]];
    
    [dataFromPlist2 replaceObjectAtIndex:passtoswitch withObject:@"1"];
    
    
    [data setObject:dataFromPlist2 forKey:@"valueof"];
    [data writeToFile: path atomically:YES];
    
    int checkhowmuch=[self checkforavailablevalue];
    [self valuetoreplaceon:dataFromPlist2 andindex:checkhowmuch];
    
    // NSLog(@"%@data",data);
    
    
}
-(int)checkforavailablevalue
{
    
    int occurrences = 0;
    for(NSString *string in [data valueForKey:@"valueof"])
    {
        occurrences += ([string isEqualToString:@"1"]?1:0); //certain object is @"Apple"
    }
    
    return occurrences;
}
- (void)switchoff:(int)passtoswitch
{
    // NSLog(@"%d====",passtoswitch);
    NSMutableArray *dataFromPlist2 =[[NSMutableArray alloc]initWithArray:[data valueForKey:@"valueof"]];
    
    [dataFromPlist2 replaceObjectAtIndex:passtoswitch withObject:@"0"];
    
    
    [data setObject:dataFromPlist2 forKey:@"valueof"];
    [data writeToFile: path atomically:YES];
    int checkhowmuch=[self checkforavailablevalue];
    [self valuetoreplaceoff:dataFromPlist2 andindex:checkhowmuch];
    //  NSLog(@"%@data",data);
    
}
-(void)valuetoreplaceoff:(NSArray*)dataFromPlist2 andindex:(int)checkhowmuch
{
    NSInteger index = [dataFromPlist2 indexOfObject:@"0"];
    NSInteger index2 = [dataFromPlist2 indexOfObject:@"1"];
    switch (checkhowmuch)
    {
        case 1:
            if (index2==1)
            {
                NSMutableArray *dataFromPlist =[[NSMutableArray alloc]initWithArray:[data valueForKey:@"name"]];
                
                [dataFromPlist exchangeObjectAtIndex:0 withObjectAtIndex:1];
                
                [data setObject:dataFromPlist forKey:@"name"];
                
                NSMutableArray *dataFromPlist1 =[[NSMutableArray alloc]initWithArray:[data valueForKey:@"order"]];
                [dataFromPlist1 exchangeObjectAtIndex:0 withObjectAtIndex:1];
                //[arrof exchangeObjectAtIndex:indexPath.row withObjectAtIndex:sourceIndexPath.row];
                // NSLog(@"%@===pullu after",dataFromPlist1);
                [data setObject:dataFromPlist1 forKey:@"order"];
                
                
                NSMutableArray *dataFromPlist2 =[[NSMutableArray alloc]initWithArray:[data valueForKey:@"valueof"]];
                
                [dataFromPlist2 exchangeObjectAtIndex:0 withObjectAtIndex:1];
                
                //  NSLog(@"%@===pullu after",dataFromPlist2);
                [data setObject:dataFromPlist2 forKey:@"valueof"];
                [data writeToFile: path atomically:YES];
                
            }
            else if (index2==2)
            {
                
                NSMutableArray *dataFromPlist =[[NSMutableArray alloc]initWithArray:[data valueForKey:@"name"]];
                
                [dataFromPlist exchangeObjectAtIndex:0 withObjectAtIndex:2];
                
                [data setObject:dataFromPlist forKey:@"name"];
                
                NSMutableArray *dataFromPlist1 =[[NSMutableArray alloc]initWithArray:[data valueForKey:@"order"]];
                [dataFromPlist1 exchangeObjectAtIndex:0 withObjectAtIndex:2];
                
                
                [data setObject:dataFromPlist1 forKey:@"order"];
                
                
                NSMutableArray *dataFromPlist2 =[[NSMutableArray alloc]initWithArray:[data valueForKey:@"valueof"]];
                
                [dataFromPlist2 exchangeObjectAtIndex:0 withObjectAtIndex:2];
                
                
                [data setObject:dataFromPlist2 forKey:@"valueof"];
                [data writeToFile: path atomically:YES];
                
                
            }
            break;
        case 2:
            if (index==0)
            {
                NSMutableArray *dataFromPlist =[[NSMutableArray alloc]initWithArray:[data valueForKey:@"name"]];
                // NSString *strname=[dataFromPlist objectAtIndex:2];
                [dataFromPlist exchangeObjectAtIndex:0 withObjectAtIndex:1];
                [dataFromPlist exchangeObjectAtIndex:1 withObjectAtIndex:2];
                //  [dataFromPlist exchangeObjectAtIndex:0 withObjectAtIndex:1];
                // [dataFromPlist exchangeObjectAtIndex:0 withObjectAtIndex:1];
                //[dataFromPlist replaceObjectAtIndex:1 withObject:strname];
                
                [data setObject:dataFromPlist forKey:@"name"];
                
                NSMutableArray *dataFromPlist1 =[[NSMutableArray alloc]initWithArray:[data valueForKey:@"order"]];
                [dataFromPlist1 exchangeObjectAtIndex:0 withObjectAtIndex:1];
                [dataFromPlist1 exchangeObjectAtIndex:1 withObjectAtIndex:2];
                //[arrof exchangeObjectAtIndex:indexPath.row withObjectAtIndex:sourceIndexPath.row];
                // NSLog(@"%@===pullu after",dataFromPlist1);
                [data setObject:dataFromPlist1 forKey:@"order"];
                
                
                NSMutableArray *dataFromPlist2 =[[NSMutableArray alloc]initWithArray:[data valueForKey:@"valueof"]];
                
                [dataFromPlist2 exchangeObjectAtIndex:0 withObjectAtIndex:1];
                [dataFromPlist2 exchangeObjectAtIndex:1 withObjectAtIndex:2];
                
                // NSLog(@"%@===pullu after",dataFromPlist2);
                [data setObject:dataFromPlist2 forKey:@"valueof"];
                [data writeToFile: path atomically:YES];
                
            }
            else if (index==1)
            {
                
                NSMutableArray *dataFromPlist =[[NSMutableArray alloc]initWithArray:[data valueForKey:@"name"]];
                
                [dataFromPlist exchangeObjectAtIndex:1 withObjectAtIndex:2];
                
                [data setObject:dataFromPlist forKey:@"name"];
                
                NSMutableArray *dataFromPlist1 =[[NSMutableArray alloc]initWithArray:[data valueForKey:@"order"]];
                [dataFromPlist1 exchangeObjectAtIndex:1 withObjectAtIndex:2];
                
                
                [data setObject:dataFromPlist1 forKey:@"order"];
                
                
                NSMutableArray *dataFromPlist2 =[[NSMutableArray alloc]initWithArray:[data valueForKey:@"valueof"]];
                
                [dataFromPlist2 exchangeObjectAtIndex:1 withObjectAtIndex:2];
                
                
                [data setObject:dataFromPlist2 forKey:@"valueof"];
                [data writeToFile: path atomically:YES];
                
                
            }
            //            else if (index==2)
            //            {
            //
            //                NSMutableArray *dataFromPlist =[[NSMutableArray alloc]initWithArray:[data valueForKey:@"name"]];
            //
            //                [dataFromPlist exchangeObjectAtIndex:0 withObjectAtIndex:1];
            //
            //                [data setObject:dataFromPlist forKey:@"name"];
            //
            //                NSMutableArray *dataFromPlist1 =[[NSMutableArray alloc]initWithArray:[data valueForKey:@"order"]];
            //                [dataFromPlist1 exchangeObjectAtIndex:0 withObjectAtIndex:1];
            //
            //
            //                [data setObject:dataFromPlist1 forKey:@"order"];
            //
            //
            //                NSMutableArray *dataFromPlist2 =[[NSMutableArray alloc]initWithArray:[data valueForKey:@"valueof"]];
            //
            //                [dataFromPlist2 exchangeObjectAtIndex:0 withObjectAtIndex:1];
            //
            //
            //                [data setObject:dataFromPlist2 forKey:@"valueof"];
            //                [data writeToFile: path atomically:YES];
            //
            //
            //            }
            break;
            //            case 3:
            //            if (index2==0)
            //            {
            //
            //                NSMutableArray *dataFromPlist =[[NSMutableArray alloc]initWithArray:[data valueForKey:@"name"]];
            //
            //                [dataFromPlist exchangeObjectAtIndex:0 withObjectAtIndex:2];
            //
            //                [data setObject:dataFromPlist forKey:@"name"];
            //
            //                NSMutableArray *dataFromPlist1 =[[NSMutableArray alloc]initWithArray:[data valueForKey:@"order"]];
            //                [dataFromPlist1 exchangeObjectAtIndex:0 withObjectAtIndex:2];
            //
            //
            //                [data setObject:dataFromPlist1 forKey:@"order"];
            //
            //
            //                NSMutableArray *dataFromPlist2 =[[NSMutableArray alloc]initWithArray:[data valueForKey:@"valueof"]];
            //
            //                [dataFromPlist2 exchangeObjectAtIndex:0 withObjectAtIndex:2];
            //
            //
            //                [data setObject:dataFromPlist2 forKey:@"valueof"];
            //                [data writeToFile: path atomically:YES];
            //
            //
            //            }
            //            break;
        default:
            break;
    }
    [self.tbl reloadData];
}
-(void)valuetoreplaceon:(NSArray*)dataFromPlist2 andindex:(int)checkhowmuch
{
    NSInteger index = [dataFromPlist2 indexOfObject:@"0"];
    NSInteger index2 = [dataFromPlist2 indexOfObject:@"1"];
    switch (checkhowmuch)
    {
            //        case 1:
            //            if (index2==1)
            //            {
            //                NSMutableArray *dataFromPlist =[[NSMutableArray alloc]initWithArray:[data valueForKey:@"name"]];
            //
            //                [dataFromPlist exchangeObjectAtIndex:0 withObjectAtIndex:1];
            //
            //                [data setObject:dataFromPlist forKey:@"name"];
            //
            //                NSMutableArray *dataFromPlist1 =[[NSMutableArray alloc]initWithArray:[data valueForKey:@"order"]];
            //                [dataFromPlist1 exchangeObjectAtIndex:0 withObjectAtIndex:1];
            //                //[arrof exchangeObjectAtIndex:indexPath.row withObjectAtIndex:sourceIndexPath.row];
            //                // NSLog(@"%@===pullu after",dataFromPlist1);
            //                [data setObject:dataFromPlist1 forKey:@"order"];
            //
            //
            //                NSMutableArray *dataFromPlist2 =[[NSMutableArray alloc]initWithArray:[data valueForKey:@"valueof"]];
            //
            //                [dataFromPlist2 exchangeObjectAtIndex:0 withObjectAtIndex:1];
            //
            //                //  NSLog(@"%@===pullu after",dataFromPlist2);
            //                [data setObject:dataFromPlist2 forKey:@"valueof"];
            //                [data writeToFile: path atomically:YES];
            //
            //            }
            //            else if (index2==2)
            //            {
            //
            //                NSMutableArray *dataFromPlist =[[NSMutableArray alloc]initWithArray:[data valueForKey:@"name"]];
            //
            //                [dataFromPlist exchangeObjectAtIndex:0 withObjectAtIndex:2];
            //
            //                [data setObject:dataFromPlist forKey:@"name"];
            //
            //                NSMutableArray *dataFromPlist1 =[[NSMutableArray alloc]initWithArray:[data valueForKey:@"order"]];
            //                [dataFromPlist1 exchangeObjectAtIndex:0 withObjectAtIndex:2];
            //
            //
            //                [data setObject:dataFromPlist1 forKey:@"order"];
            //
            //
            //                NSMutableArray *dataFromPlist2 =[[NSMutableArray alloc]initWithArray:[data valueForKey:@"valueof"]];
            //
            //                [dataFromPlist2 exchangeObjectAtIndex:0 withObjectAtIndex:2];
            //
            //
            //                [data setObject:dataFromPlist2 forKey:@"valueof"];
            //                [data writeToFile: path atomically:YES];
            //
            //
            //            }
            //            break;
        case 2:
            if (index==0)
            {
                NSMutableArray *dataFromPlist =[[NSMutableArray alloc]initWithArray:[data valueForKey:@"name"]];
                //  NSString *strname=[dataFromPlist objectAtIndex:2];
                [dataFromPlist exchangeObjectAtIndex:0 withObjectAtIndex:1];
                [dataFromPlist exchangeObjectAtIndex:2 withObjectAtIndex:1];
                //  [dataFromPlist exchangeObjectAtIndex:0 withObjectAtIndex:1];
                // [dataFromPlist exchangeObjectAtIndex:0 withObjectAtIndex:1];
                //[dataFromPlist replaceObjectAtIndex:1 withObject:strname];
                
                [data setObject:dataFromPlist forKey:@"name"];
                
                NSMutableArray *dataFromPlist1 =[[NSMutableArray alloc]initWithArray:[data valueForKey:@"order"]];
                [dataFromPlist1 exchangeObjectAtIndex:0 withObjectAtIndex:1];
                [dataFromPlist1 exchangeObjectAtIndex:2 withObjectAtIndex:1];
                //[arrof exchangeObjectAtIndex:indexPath.row withObjectAtIndex:sourceIndexPath.row];
                // NSLog(@"%@===pullu after",dataFromPlist1);
                [data setObject:dataFromPlist1 forKey:@"order"];
                
                
                NSMutableArray *dataFromPlist2 =[[NSMutableArray alloc]initWithArray:[data valueForKey:@"valueof"]];
                
                [dataFromPlist2 exchangeObjectAtIndex:0 withObjectAtIndex:1];
                [dataFromPlist2 exchangeObjectAtIndex:2 withObjectAtIndex:1];
                // NSLog(@"%@===pullu after",dataFromPlist2);
                [data setObject:dataFromPlist2 forKey:@"valueof"];
                [data writeToFile: path atomically:YES];
                
            }
            else if (index==1)
            {
                
                NSMutableArray *dataFromPlist =[[NSMutableArray alloc]initWithArray:[data valueForKey:@"name"]];
                
                
                [dataFromPlist exchangeObjectAtIndex:2 withObjectAtIndex:1];
                [data setObject:dataFromPlist forKey:@"name"];
                
                NSMutableArray *dataFromPlist1 =[[NSMutableArray alloc]initWithArray:[data valueForKey:@"order"]];
                
                [dataFromPlist1 exchangeObjectAtIndex:2 withObjectAtIndex:1];
                
                [data setObject:dataFromPlist1 forKey:@"order"];
                
                
                NSMutableArray *dataFromPlist2 =[[NSMutableArray alloc]initWithArray:[data valueForKey:@"valueof"]];
                
                
                [dataFromPlist2 exchangeObjectAtIndex:2 withObjectAtIndex:1];
                
                [data setObject:dataFromPlist2 forKey:@"valueof"];
                [data writeToFile: path atomically:YES];
                
                
            }
            else if (index==2)
            {
                
                //                NSMutableArray *dataFromPlist =[[NSMutableArray alloc]initWithArray:[data valueForKey:@"name"]];
                //
                //                [dataFromPlist exchangeObjectAtIndex:0 withObjectAtIndex:1];
                //
                //                [data setObject:dataFromPlist forKey:@"name"];
                //
                //                NSMutableArray *dataFromPlist1 =[[NSMutableArray alloc]initWithArray:[data valueForKey:@"order"]];
                //                [dataFromPlist1 exchangeObjectAtIndex:0 withObjectAtIndex:1];
                //
                //
                //                [data setObject:dataFromPlist1 forKey:@"order"];
                //
                //
                //                NSMutableArray *dataFromPlist2 =[[NSMutableArray alloc]initWithArray:[data valueForKey:@"valueof"]];
                //
                //                [dataFromPlist2 exchangeObjectAtIndex:0 withObjectAtIndex:1];
                //
                //
                //                [data setObject:dataFromPlist2 forKey:@"valueof"];
                //                [data writeToFile: path atomically:YES];
                
                
            }
            break;
        case 3:
            if (index2==0)
            {
                
                //                NSMutableArray *dataFromPlist =[[NSMutableArray alloc]initWithArray:[data valueForKey:@"name"]];
                //
                //                [dataFromPlist exchangeObjectAtIndex:0 withObjectAtIndex:2];
                //                [dataFromPlist exchangeObjectAtIndex:2 withObjectAtIndex:1];
                //                [data setObject:dataFromPlist forKey:@"name"];
                //
                //                NSMutableArray *dataFromPlist1 =[[NSMutableArray alloc]initWithArray:[data valueForKey:@"order"]];
                //                [dataFromPlist1 exchangeObjectAtIndex:0 withObjectAtIndex:2];
                //                [dataFromPlist1 exchangeObjectAtIndex:2 withObjectAtIndex:1];
                //
                //                [data setObject:dataFromPlist1 forKey:@"order"];
                //
                //
                //                NSMutableArray *dataFromPlist2 =[[NSMutableArray alloc]initWithArray:[data valueForKey:@"valueof"]];
                //
                //                [dataFromPlist2 exchangeObjectAtIndex:0 withObjectAtIndex:2];
                //                [dataFromPlist2 exchangeObjectAtIndex:2 withObjectAtIndex:1];
                //
                //                [data setObject:dataFromPlist2 forKey:@"valueof"];
                //                [data writeToFile: path atomically:YES];
                
                
            }
            break;
        default:
            break;
    }
    [self.tbl reloadData];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return UITableViewAutomaticDimension;
}


- (IBAction)longPressGestureRecognized:(id)sender {
    
    UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)sender;
    UIGestureRecognizerState state = longPress.state;
    
    CGPoint location = [longPress locationInView:self.tbl];
    NSIndexPath *indexPath = [self.tbl indexPathForRowAtPoint:location];
    
    static UIView       *snapshot = nil;        ///< A snapshot of the row user is moving.
    static NSIndexPath  *sourceIndexPath = nil; ///< Initial index path, where gesture begins.
    
    switch (state) {
        case UIGestureRecognizerStateBegan: {
            if (indexPath) {
                sourceIndexPath = indexPath;
                
                UITableViewCell *cell = [self.tbl cellForRowAtIndexPath:indexPath];
                
                // Take a snapshot of the selected row using helper method.
                snapshot = [self customSnapshoFromView:cell];
                
                // Add the snapshot as subview, centered at cell's center...
                __block CGPoint center = cell.center;
                snapshot.center = center;
                snapshot.alpha = 0.0;
                [self.tbl addSubview:snapshot];
                [UIView animateWithDuration:0.25 animations:^{
                    
                    // Offset for gesture location.
                    center.y = location.y;
                    snapshot.center = center;
                    snapshot.transform = CGAffineTransformMakeScale(1.05, 1.05);
                    snapshot.alpha = 0.98;
                    cell.alpha = 0.0;
                    
                } completion:^(BOOL finished) {
                    
                    cell.hidden = YES;
                    
                }];
            }
            break;
        }
            
        case UIGestureRecognizerStateChanged: {
            CGPoint center = snapshot.center;
            center.y = location.y;
            snapshot.center = center;
            
            // Is destination valid and is it different from source?
            if (indexPath && ![indexPath isEqual:sourceIndexPath])
            {
                
                // ... update data source.
                
                
                NSMutableArray *dataFromPlist =[[NSMutableArray alloc]initWithArray:[data valueForKey:@"name"]];
                // NSLog(@"%@===pullu before",dataFromPlist);
                [dataFromPlist exchangeObjectAtIndex:indexPath.row withObjectAtIndex:sourceIndexPath.row];
                //[arrof exchangeObjectAtIndex:indexPath.row withObjectAtIndex:sourceIndexPath.row];
                //NSLog(@"%@===pullu after",dataFromPlist);
                [data setObject:dataFromPlist forKey:@"name"];
                
                NSMutableArray *dataFromPlist1 =[[NSMutableArray alloc]initWithArray:[data valueForKey:@"order"]];
                NSLog(@"%@===pullu before",dataFromPlist1);
                [dataFromPlist1 exchangeObjectAtIndex:indexPath.row withObjectAtIndex:sourceIndexPath.row];
                //[arrof exchangeObjectAtIndex:indexPath.row withObjectAtIndex:sourceIndexPath.row];
                // NSLog(@"%@===pullu after",dataFromPlist1);
                [data setObject:dataFromPlist1 forKey:@"order"];
                
                
                NSMutableArray *dataFromPlist2 =[[NSMutableArray alloc]initWithArray:[data valueForKey:@"valueof"]];
                //  NSLog(@"%@===pullu before",dataFromPlist);
                [dataFromPlist2 exchangeObjectAtIndex:indexPath.row withObjectAtIndex:sourceIndexPath.row];
                //[arrof exchangeObjectAtIndex:indexPath.row withObjectAtIndex:sourceIndexPath.row];
                // NSLog(@"%@===pullu after",dataFromPlist2);
                [data setObject:dataFromPlist2 forKey:@"valueof"];
                [data writeToFile: path atomically:YES];
                // NSLog(@"%@ab",data);
                
                [self.tbl moveRowAtIndexPath:sourceIndexPath toIndexPath:indexPath];
                
                
                sourceIndexPath = indexPath;
                
                
                [tbl reloadData];
                
            }
            break;
        }
            
        default: {
            // Clean up.
            UITableViewCell *cell = [self.tbl cellForRowAtIndexPath:sourceIndexPath];
            cell.hidden = NO;
            cell.alpha = 0.0;
            
            [UIView animateWithDuration:0.25 animations:^{
                
                snapshot.center = cell.center;
                snapshot.transform = CGAffineTransformIdentity;
                snapshot.alpha = 0.0;
                cell.alpha = 1.0;
                
            } completion:^(BOOL finished) {
                [tbl reloadData];
                sourceIndexPath = nil;
                [snapshot removeFromSuperview];
                snapshot = nil;
                
            }];
            
            break;
        }
    }
    
}

- (UIView *)customSnapshoFromView:(UIView *)inputView {
    
    // Make an image from the input view.
    UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, NO, 0);
    [inputView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // Create an image view.
    UIView *snapshot = [[UIImageView alloc] initWithImage:image];
    snapshot.layer.masksToBounds = NO;
    snapshot.layer.cornerRadius = 0.0;
    snapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0);
    snapshot.layer.shadowRadius = 5.0;
    snapshot.layer.shadowOpacity = 0.4;
    
    return snapshot;
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)Donesetting:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)backsetting:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
//-(void)navigatetosidebar
//{
//    self.navigationItem.title = @"Call Type";
//    SWRevealViewController *revealController = [self revealViewController];
//    
//    
//    [revealController panGestureRecognizer];
//    [revealController tapGestureRecognizer];
//    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"sidebaricon.png"]
//                                                                         style:UIBarButtonItemStylePlain target:revealController action:@selector(revealToggle:)];
//    
//    self.navigationItem.leftBarButtonItem = revealButtonItem;
//    
//    revealController.delegate = self;
//}
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
