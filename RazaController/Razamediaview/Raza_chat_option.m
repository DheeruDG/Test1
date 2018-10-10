//
//  Raza_chat_option.m
//  Raza
//
//  Created by umenit on 8/22/15.
//  Copyright (c) 2015 Raza. All rights reserved.
//

#import "Raza_chat_option.h"
#import "PhoneMainView.h"
@interface Raza_chat_option ()

@end

@implementation Raza_chat_option
@synthesize tbl;
- (void)viewDidLoad {
    [super viewDidLoad];
    // [TODO:ios update]
    self.tbl.separatorColor =[UIColor clearColor];
    
    tbl.delegate=self;
    tbl.dataSource=self;
    arr=[[NSMutableArray alloc]initWithObjects:@"Default Wall.png",@"Balloon.png",@"Carina-Nebula.png",@"Cute-Cat.png",@"Green-Nature-Trees.png",@"Harley-Davidson.png",@"Landscapes-Beach.png",@"Leaves-Plants.png",@"Light-Rainwater-Night.png",@"Play-on-the-Grass.png",@"Sunset-Sea-Nature.png", nil];
   
    self->cellnib = [UINib nibWithNibName:@"Raza_chat_option_cell" bundle:nil];
    [self.tbl registerNib:self->cellnib forCellReuseIdentifier:@"Raza_chat_option_cellID"];
    //[self navigatetosidebar];
    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillAppear:(BOOL)animated
{
    anwhich=6000;
    globalnetworkclass *dict=[[globalnetworkclass alloc]init];
    dictofchatwallpaper=[[NSMutableDictionary alloc]init];
    NSArray *arrof= [dict getchatcustomwallpaper];
    dictofchatwallpaper=[arrof objectAtIndex:0];
    dictofchatwallpaperpath=[arrof objectAtIndex:1];
     NSMutableArray *username_array =[[NSMutableArray alloc]initWithArray:[dictofchatwallpaper valueForKey:@"owner"]];
   NSMutableArray *userwallpaper_array =[[NSMutableArray alloc]initWithArray:[dictofchatwallpaper valueForKey:@"wallpaper"]];
    if (!([ _vcofuser length] == 0) &&  !([_vcofuser isEqualToString:@"Default"]))
    {
        NSArray *arrpp=[_vcofuser componentsSeparatedByString:@"@"];
        NSArray *arrkk=[[arrpp objectAtIndex:0] componentsSeparatedByString:@"sip:"];
        if ([username_array containsObject:[arrkk objectAtIndex:1]])
        {
            
             anwhich=(int)[username_array indexOfObject:[arrkk objectAtIndex:1]];
            imgname=[userwallpaper_array objectAtIndex:anwhich];
        }
    
      
    }
    else
    {
        anwhich=(int)[username_array indexOfObject:@"Default"];
        imgname=[userwallpaper_array objectAtIndex:anwhich];
        [tbl reloadData];
    }
   // [self updatedone];
    }
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableview numberOfRowsInSection:(NSInteger)section
{
 
        return [arr count];
  
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath   *)indexPath
{
 
        return 70;
    
}
- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *Cellidentifier=@"Raza_chat_option_cellID";
    
    Raza_chat_option_cell  *cell = (Raza_chat_option_cell*)[_tableView dequeueReusableCellWithIdentifier: Cellidentifier];
        cell.img.image=[UIImage imageNamed:[arr objectAtIndex:indexPath.row]];
    if ([[arr objectAtIndex:indexPath.row] isEqualToString:imgname])
    {
        cell.imgicon.hidden=NO;
    }
    else
        cell.imgicon.hidden=YES;
    NSRange replaceRange = [[arr objectAtIndex:indexPath.row] rangeOfString:@".png"];
    if (replaceRange.location != NSNotFound){
        NSString* result = [[arr objectAtIndex:indexPath.row] stringByReplacingCharactersInRange:replaceRange withString:@""];
        cell.imgname.text=result;
    }
    
   
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
   
       // raza_chat_imageViewController *vc = [[raza_chat_imageViewController alloc] init];
    if ([ _vcofuser length] == 0)
      _vcofuser=@"Default";
    NSMutableArray *arrtoupdatewallpaper=[[NSMutableArray alloc]initWithObjects:_vcofuser,[arr objectAtIndex:indexPath.row], nil];
     raza_chat_imageViewController *vc = VIEW(raza_chat_imageViewController);
        //vc.strofimg=arrtoupdatewallpaper;
    [vc setstrinmagearray:arrtoupdatewallpaper];
  //  setstrinmage
     [PhoneMainView.instance changeCurrentView:vc.compositeViewDescription];
  //  NSLog(@"%@---%ld====%@",arrtoupdatewallpaper,(long)indexPath.row,arr);
   //  [self.navigationController pushViewController:vc animated:YES];


}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)updateProgressBar:(NSTimer *)timer {
//    NSTimeInterval playTime = [self.player currentTime];
//    NSTimeInterval duration = [self.player duration];
//    float progress = playTime/duration;
//    [self.progressView setProgress:progress];
//}
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
    RazaSettingsViewController *view = VIEW(RazaSettingsViewController);
    [PhoneMainView.instance popToView:view.compositeViewDescription];
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

- (IBAction)btnbackclicked:(id)sender {
    [self gotoprev];
}
@end
