//
//  Raza_chat_option_ring.m
//  Raza
//
//  Created by umenit on 8/22/15.
//  Copyright (c) 2015 Raza. All rights reserved.
//

#import "Raza_chat_option_ring.h"
#import "PhoneMainView.h"
@interface Raza_chat_option_ring ()

@end

@implementation Raza_chat_option_ring
@synthesize tbl;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // [TODO:ios update]
    self.tbl.separatorColor = [UIColor clearColor];
    tbl.delegate=self;
    tbl.dataSource=self;
    arraudio=[[NSMutableArray alloc]initWithObjects:@"Default_ring",@"Raza_ring1",@"Raza_ring2",@"Raza_ring3",@"Raza_ring4",@"Raza_ring5",@"Raza_ring6", nil];
    self->cellnib = [UINib nibWithNibName:@"Raza_chat_option_ringcellTableViewCell" bundle:nil];
    [self.tbl registerNib:self->cellnib forCellReuseIdentifier:@"Raza_chat_option_ringcellTableViewCellID"];
   // doneButton = [[UIBarButtonItem alloc] initWithTitle:@"   Done" style:UIBarButtonItemStyleBordered target:self action:@selector(doneringtone)];
   // self.navigationItem.rightBarButtonItem = doneButton;
    //[self navigatetosidebar];
}
- (void)viewWillAppear:(BOOL)animated
{
    self.navigationItem.rightBarButtonItem = nil;
    globalnetworkclass *dict=[[globalnetworkclass alloc]init];
    dictofchatringtone=[[NSMutableDictionary alloc]init];
    NSArray *arr= [dict getchatcustomringtone];
    dictofchatringtone=[arr objectAtIndex:0];
    dictofchatringtonepath=[arr objectAtIndex:1];
    NSMutableArray *username_array =[[NSMutableArray alloc]initWithArray:[dictofchatringtone valueForKey:@"owner"]];
    NSMutableArray *username_ringtone =[[NSMutableArray alloc]initWithArray:[dictofchatringtone valueForKey:@"audio"]];
    if ([_stringofuser length]&& !([_stringofuser isEqualToString:@"Default"]))
    {
        NSArray *arrpp=[_stringofuser componentsSeparatedByString:@"@"];
        NSArray *arrkk=[[arrpp objectAtIndex:0] componentsSeparatedByString:@"sip:"];
        NSString *strtocompare;
        if ([arrkk count]>1) {
           strtocompare =[arrkk objectAtIndex:1];
        }
        else
            strtocompare=[arrkk objectAtIndex:0];
        _stringofuser=strtocompare;
        
        if ([username_array containsObject:strtocompare])
        {
            
           int anwhich=(int)[username_array indexOfObject:strtocompare];
            ringname=[username_ringtone objectAtIndex:anwhich];
        }
    }
    else
    {
        _stringofuser=@"Default";
        int anwhich2=(int)[username_array indexOfObject:@"Default"];
        ringname=[username_ringtone objectAtIndex:anwhich2];
    }
    [self.tbl reloadData];
    
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableview numberOfRowsInSection:(NSInteger)section
{
    
    return [arraudio count];

    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath   *)indexPath
{
    
    return 50;
    
}
- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *Cellidentifier=@"Raza_chat_option_ringcellTableViewCellID";
    Raza_chat_option_ringcellTableViewCell  *cell = (Raza_chat_option_ringcellTableViewCell*)[_tableView dequeueReusableCellWithIdentifier: Cellidentifier];
    cell.lbl.text=[arraudio objectAtIndex:indexPath.row];
    cell.lbl.font = RAZA_CELL_FONT_SETTINGS;
    if ([[arraudio objectAtIndex:indexPath.row] isEqualToString:ringname])
    {
        cell.imgicon.hidden=NO;
    }
    else
        cell.imgicon.hidden=YES;
    cell.pgbar.hidden=YES;
 
    // cell.lbl_name.text=[[data objectForKey:@"name"] objectAtIndex:indexPath.row];
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.navigationItem.rightBarButtonItem = doneButton;
    Raza_chat_option_ringcellTableViewCell  *cell = (Raza_chat_option_ringcellTableViewCell*)[self.tbl cellForRowAtIndexPath:indexPath];
    cell.pgbar.hidden=NO;
    
        NSString *path = [[NSBundle mainBundle]
                          pathForResource:[arraudio objectAtIndex:indexPath.row] ofType:@"mp3"];
        audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:
                       [NSURL fileURLWithPath:path] error:NULL];
        NSLog(@"%f",audioPlayer.duration);
    ringtonetoselect=[arraudio objectAtIndex:indexPath.row];
   // 
        [audioPlayer play];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:nil];//
 
}
-(void)doneringtone
{
    NSMutableArray *username_array =[[NSMutableArray alloc]initWithArray:[dictofchatringtone valueForKey:@"owner"]];
    NSMutableArray *username_ringtone =[[NSMutableArray alloc]initWithArray:[dictofchatringtone valueForKey:@"audio"]];
    
    globalnetworkclass *dictfor=[[globalnetworkclass alloc]init];
    [dictfor setringtone:_stringofuser globalusername_array:username_array globalusername_wallpaper:username_ringtone chatring:ringtonetoselect globaldictofchatwallpaper:dictofchatringtone pathtochange:dictofchatringtonepath];
    //[self.navigationController popToRootViewControllerAnimated:YES];
//    NSArray *array = [self.navigationController viewControllers];
//    if ([array count]>2)
//    {
//        [self.navigationController popToViewController:[array objectAtIndex:1] animated:YES];
//    }
//    else
//        [self.navigationController popToRootViewControllerAnimated:YES];
    [self performSelector:@selector(gotoprev) withObject:nil afterDelay:0.3];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillDisappear:(BOOL)animated
{
    //if([self.navigationController.visibleViewController isKindOfClass:[yourcontroller class]])
    //{
//NSArray *viewControllers = [self.navigationController viewControllers];
    //}
    [audioPlayer stop];
}
-(void)gotoprev
{
   // RazaSettingsViewController *view = VIEW(RazaSettingsViewController);
   // [PhoneMainView.instance popToView:view.compositeViewDescription];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btnBackClicked:(id)sender {
    [self gotoprev];
}

- (IBAction)btndoneclicked:(id)sender {
    [self doneringtone];
}
@end
