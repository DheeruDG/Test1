//
//  RazaSettingsViewController.m
//  Raza
//
//  Created by Praveen S on 12/1/13.
//  Copyright (c) 2013 Raza. All rights reserved.
//

#import "RazaSettingsViewController.h"
//#import "RazaAccessNumberVC.h"
#import "RazaRewardPointVC.h"
#import "RazaPurchaseHistoryVC.h"
#import "RazaCallDetailsVC.h"
//#import "RazaPinlessSetupVC.h"
//#import "RazaQuickeysSetupVC.h"
//#import "RazaHomeViewController.h"
#import "RazaCreditCardController.h"
#import "RazaViewRatesController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "RazaServiceManager.h"
//#import "ImagePickerController.h"
//#import "iOSNgnStack.h"
#import "Raza_network_setting.h"
#import "PhoneMainView.h"

@interface RazaSettingsViewController ()

@end

@implementation RazaSettingsViewController
@synthesize imgView;

static NSString *CellIdentifier = @"SettingCell";

#pragma mark -
#pragma mark init methods

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        // self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Settings" image:[UIImage imageNamed:@"settings.png"] tag:5];
    }
    return self;
}

#pragma mark -
#pragma mark View methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    // [TODO:ios update]
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    
    // Do any additional setup after loading the view from its nib.
    //   self.scrollingView = [[UIScrollView alloc]init];
    //   [self.scrollingView addSubview:self.view];
    //    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    //
    [__scrollview setContentSize:CGSizeMake(__scrollview.bounds.size.width, __scrollview.bounds.size.height)];
    
    NSString *loggedInUser = [[RAZA_USERDEFAULTS objectForKey:@"logininfo"] objectForKey:LOGIN_RESPONSE_EMAIL];
    if (![loggedInUser length]) {
        loggedInUser=@"9900000000";
    }
    
    _labelWelcome.text = [@" " stringByAppendingString:loggedInUser];
    
    [self setUpDataSource];
    
    [_settingsTableView registerClass: [UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
    
    [_settingsTableView reloadData];
    _settingsTableView.separatorColor = [UIColor clearColor];
    
    UIBarButtonItem *signoutBarButton = [[UIBarButtonItem alloc]initWithTitle:@"Sign Out" style:UIBarButtonItemStylePlain target:self action:@selector(signout:)];
    
    self.navigationItem.rightBarButtonItem = signoutBarButton;
    //    if (iPhone4Or5oriPad==4) {
    //        _settingsTableView.frame= CGRectMake(0, 0, APP_FRAME.size.width, APP_FRAME.size.height);
    //    } else if (iPhone4Or5oriPad==5) {
    //        _settingsTableView.frame = CGRectMake(0, 0, APP_FRAME.size.width, APP_FRAME.size.height);
    //    }
    
    //
    //    self.view.backgroundColor =[UIColor colorWithRed:16/255.0f green:25/255.0f blue:10/255.0f alpha:.7f];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(Removeoverlayer:) name:@"Removeoverlaylayer" object:nil];
    
    // [self navigatetosidebar];
}
- (void)Removeoverlayer:(NSNotification *)notif
{
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    //    [self.navigationController popViewControllerAnimated:YES];
    [HUDforsignout hide:YES];
}
-(void)viewWillAppear:(BOOL)animated {
    self.headerViewTopConst.constant=-20;
    if ([[Razauser SharedInstance] getsidebar].length){
        [Razauser SharedInstance].sideBarIndex=7;
    }else{
        [Razauser SharedInstance].sideBarIndex=5;
    }
    
    CAGradientLayer *gradient = [BackgroundLayer navHeaderGradient];
    gradient.frame = self.headerView.bounds;
    gradient.startPoint = CGPointMake(0.0, 0.0);
    gradient.endPoint = CGPointMake(0.0, 1.0);
    gradient.locations = @[@0.0,@1.0];
    [self.headerView.layer insertSublayer:gradient atIndex:0];
    
    imgView.image =[UIImage imageNamed:@"#_big.png"];
    
    NSData* imageData = [[NSUserDefaults standardUserDefaults] objectForKey:RAZALOGGEDIMAGE];
    UIImage* image = [UIImage imageWithData:imageData];
    if (image) {
        imgView.image=image;
    }
    else
        [self setimages];
    
    // imgView.contentMode=UIViewContentModeScaleAspectFill;
    //[[NSUserDefaults standardUserDefaults] setObject:UIImagePNGRepresentation(image) forKey:RAZALOGGEDIMAGE];
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap:)];
    [imgView addGestureRecognizer:singleFingerTap];
    
    LinphoneProxyConfig *default_proxy = linphone_core_get_default_proxy_config(LC);
    if (default_proxy != NULL) {
        const LinphoneAddress *addr = linphone_proxy_config_get_identity_address(default_proxy);
        [ContactDisplay setDisplayNameLabel:_nameLbl forAddress:addr];
    } else {
        _nameLbl.text = linphone_core_get_proxy_config_list(LC) ? NSLocalizedString(@"No default account", nil) : NSLocalizedString(@"No account", nil);
    }
    if ([[[NSUserDefaults standardUserDefaults] stringForKey:Razatempraturemode] length]){
        self.tempTxt.text=@"Fahrenheit (°F)";
    }else{
        self.tempTxt.text=@"Celsius (°C)";
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -
#pragma mark Setup datasource methods

-(void)setUpDataSource {
    
    _datalist = [NSMutableArray array];
    _datalist1 = [NSMutableArray array];
    _datalist2 = [NSMutableArray array];
    _datalist3 = [NSMutableArray array];
    
    
    
    //    NSArray *keys = [NSArray arrayWithObjects:@"1", @"2", @"3", @"4", @"5" , @"6" , @"7" ,nil];
    //    NSArray *images = [NSArray arrayWithObjects:@"SMS.png", @"access_number_icn.png",
    //                       @"rewards_point_icn.png", @"purchase_history_icn.png", @"call_icon.png" , @"view_rates.png" , @"recharge.png" ,nil];
    //    NSArray *titles = [NSArray arrayWithObjects:@"Message", @"Access Numbers",
    //                       @"Rewards Points", @"Purchase History", @"Call Details" , @"View Rates" , @"Recharge", nil];
    
    //[TODO:ios update]
    NSArray *keys  = [NSArray arrayWithObjects: @"1", @"2", nil] ;
    NSArray *keys1 = [NSArray arrayWithObjects: @"1", @"2",nil];
    NSArray *keys2 = [NSArray arrayWithObjects: @"1", @"2",nil] ;
    //  NSArray *keys3 = [NSArray arrayWithObjects: @"1", @"2",@"3",nil];
    NSArray *keys3 = [NSArray arrayWithObjects: @"1", @"2",nil];
    NSArray *images  = [NSArray arrayWithObjects:@"view_rates.png",       @"purchase_history_icn.png",nil];
    NSArray *images1 = [NSArray arrayWithObjects:@"access_number_icn.png",@"rewards_point_icn.png",   nil];
    NSArray *images2 = [NSArray arrayWithObjects:@"call_type.png",        @"call_icon.png"  ,         nil];
    //  NSArray *images3 = [NSArray arrayWithObjects:@"mwall.png",   @"mringtone.png" ,  @"temp.png" ,    nil];
    
    NSArray *images3 = [NSArray arrayWithObjects:@"mwall.png",    @"temp.png" ,    nil];
    NSArray *titles = [NSArray arrayWithObjects:
                       @"View Rates",
                       @"Purchase History",nil];
    NSArray *titles1 = [NSArray arrayWithObjects:
                        @"Access Numbers",
                        @"Rewards Points",nil];
    NSArray *titles2 = [NSArray arrayWithObjects:
                        @"Call Types",
                        @"Call Details" ,nil];
    //    NSArray *titles3 = [NSArray arrayWithObjects:
    //                       @"Wallpaper" ,
    //                       @"Ringtone" ,@"Temperature",nil];
    
    NSArray *titles3 = [NSArray arrayWithObjects:
                        @"Wallpaper"
                        ,@"Temperature",nil];
    
    
    //NSDictionary *individual = [NSDictionary dictionary];
    
    NSDictionary *info = [NSDictionary dictionary];
    
    for (int i=0; i<[keys count]; i++) {
        
        NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:[images objectAtIndex:i], @"image", [titles objectAtIndex:i], @"title", nil];
        info = [NSDictionary dictionaryWithObject:dict forKey:[keys objectAtIndex:i]];
        [_datalist addObject:info];
    }
    NSDictionary *info1 = [NSDictionary dictionary];
    
    for (int i=0; i<[keys1 count]; i++) {
        
        NSDictionary *dict1 = [[NSDictionary alloc] initWithObjectsAndKeys:[images1 objectAtIndex:i], @"image", [titles1 objectAtIndex:i], @"title", nil];
        info1 = [NSDictionary dictionaryWithObject:dict1 forKey:[keys1 objectAtIndex:i]];
        [_datalist1 addObject:info1];
    }
    NSDictionary *info2 = [NSDictionary dictionary];
    
    for (int i=0; i<[keys2 count]; i++) {
        
        NSDictionary *dict2 = [[NSDictionary alloc] initWithObjectsAndKeys:[images2 objectAtIndex:i], @"image", [titles2 objectAtIndex:i], @"title", nil];
        info2 = [NSDictionary dictionaryWithObject:dict2 forKey:[keys2 objectAtIndex:i]];
        [_datalist2 addObject:info2];
    }
    NSDictionary *info3 = [NSDictionary dictionary];
    
    for (int i=0; i<[keys3 count]; i++) {
        
        NSDictionary *dict3 = [[NSDictionary alloc] initWithObjectsAndKeys:[images3 objectAtIndex:i], @"image", [titles3 objectAtIndex:i], @"title", nil];
        info3 = [NSDictionary dictionaryWithObject:dict3 forKey:[keys3 objectAtIndex:i]];
        [_datalist3 addObject:info3];
    }
}

#pragma mark -
#pragma mark UITableViewDataSource methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //    if(section == 0){
    //        return [_datalist count];
    //    }
    //   else if(section == 1){
    //        return [_datalist1 count];
    //    }
    //    else if(section == 2){
    //        return [_datalist2 count];
    //    }
    //    else{
    return [_datalist3 count];
    // }
    // return 0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor colorWithRed:0.8f green:0.8f blue:0.8f alpha:1.0f];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    
    if(indexPath.section == 0){
        NSDictionary *info = [_datalist3 objectAtIndex:indexPath.row];
        NSDictionary *individualInfo = [info objectForKey:[NSString stringWithFormat:@"%d",(int)indexPath.row+1]];
        
        cell.imageView.image = [UIImage imageNamed:[individualInfo objectForKey:@"image"]];
        cell.textLabel.text = [individualInfo objectForKey:@"title"];
        cell.textLabel.font = RAZA_CELL_FONT_SETTINGS;
        cell.textLabel.textColor = kColorKeyboard;
        
        
    }
    else if(indexPath.section == 1){
        NSDictionary *info = [_datalist1 objectAtIndex:indexPath.row];
        NSDictionary *individualInfo1 = [info objectForKey:[NSString stringWithFormat:@"%d",(int)indexPath.row+1]];
        
        cell.imageView.image = [UIImage imageNamed:[individualInfo1 objectForKey:@"image"]];
        cell.textLabel.text = [individualInfo1 objectForKey:@"title"];
        cell.textLabel.font = RAZA_CELL_FONT_SETTINGS;
        cell.textLabel.textColor = kColorKeyboard;//[UIColor redColor];
        
    }
    else if(indexPath.section == 2){
        NSDictionary *info = [_datalist2 objectAtIndex:indexPath.row];
        NSDictionary *individualInfo2 = [info objectForKey:[NSString stringWithFormat:@"%d",(int)indexPath.row+1]];
        
        cell.imageView.image = [UIImage imageNamed:[individualInfo2 objectForKey:@"image"]];
        cell.textLabel.text = [individualInfo2 objectForKey:@"title"];
        cell.textLabel.font = RAZA_CELL_FONT_SETTINGS;
        
        
    }
    else{
        if(indexPath.section == 3){
            NSDictionary *info = [_datalist3 objectAtIndex:indexPath.row];
            NSDictionary *individualInfo3 = [info objectForKey:[NSString stringWithFormat:@"%d",(int)indexPath.row+1]];
            
            cell.imageView.image = [UIImage imageNamed:[individualInfo3 objectForKey:@"image"]];
            cell.textLabel.text = [individualInfo3 objectForKey:@"title"];
            cell.textLabel.font = RAZA_CELL_FONT_SETTINGS;
            
            
        }
    }
    
    cell.backgroundColor=kColordialpad;
    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate methods

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([RAZA_APPDELEGATE checkNetworkPriorRequest]) {
        NSDictionary *info;
        if (indexPath.section == 0) {
            info= [_datalist3 objectAtIndex:indexPath.row];
        }
        else if (indexPath.section == 1) {
            info= [_datalist1 objectAtIndex:indexPath.row];
        }
        else if (indexPath.section == 2) {
            info= [_datalist2 objectAtIndex:indexPath.row];
        }
        else {
            info= [_datalist3 objectAtIndex:indexPath.row];
        }
        
        
        NSDictionary *individualInfo = [info objectForKey:[NSString stringWithFormat:@"%d",(int)indexPath.row+1]];
        
        NSString *title = [individualInfo objectForKey:@"title"];
        
        
        if ([title isEqualToString:@"Call Types"]) {
            
            
            Raza_network_setting *testcontroller = [[Raza_network_setting alloc]initWithNibName:@"Raza_network_setting" bundle:nil];
            testcontroller.title = title;
            
            [self.navigationController pushViewController:testcontroller animated:YES];
            
            //             allltest *testcontroller = [[allltest alloc]initWithNibName:@"allltest" bundle:nil];
            //            testcontroller.title = title;
            //
            //            [self.navigationController pushViewController:testcontroller animated:YES];
            
        }
        
        
        if ([title isEqualToString:@"Rewards Points"]) {
            
            RazaRewardPointVC *rewardPointVC = [[RazaRewardPointVC alloc]initWithNibName:@"RazaRewardPointVC" bundle:nil];
            rewardPointVC.title = title;
            [self.navigationController pushViewController:rewardPointVC animated:YES];
            
        }
        if ([title isEqualToString:@"Purchase History"]) {
            
            RazaPurchaseHistoryVC *purchaseVC = [[RazaPurchaseHistoryVC alloc]initWithNibName:@"RazaPurchaseHistoryVC" bundle:nil];
            purchaseVC.title = title;
            [self.navigationController pushViewController:purchaseVC animated:YES];
            
        }
        if ([title isEqualToString:@"Call Details"]) {
            
            RazaCallDetailsVC *callDetailsVC = [[RazaCallDetailsVC alloc]initWithNibName:@"RazaCallDetailsVC" bundle:nil];
            callDetailsVC.title = title;
            [self.navigationController pushViewController:callDetailsVC animated:YES];
            
        }
        
        if ([title isEqualToString:@"View Rates"]) {
            RazaViewRatesController *viewRatesController = [[RazaViewRatesController alloc]initWithNibName:@"RazaViewRatesController" bundle:nil];
            viewRatesController.title = title;
            [self.navigationController pushViewController:viewRatesController animated:YES];
            
        }
        if ([title isEqualToString:@"Recharge"]) {
            RazaCreditCardController *creditCardController = [[RazaCreditCardController alloc]initWithNibName:@"RazaCreditCardController" bundle:nil];
            creditCardController.title = title;
            [self.navigationController pushViewController:creditCardController animated:YES];
            
        }
        
        if ([title isEqualToString:@"Wallpaper"])
        {
            //        Raza_chat_option *Raza_chat_option_wallpaper = [[Raza_chat_option alloc]initWithNibName:@"Raza_chat_option" bundle:nil];
            //          Raza_chat_option_wallpaper.title = title;
            //           [self.navigationController pushViewController:Raza_chat_option_wallpaper animated:YES];
            
            Raza_chat_option *view = VIEW(Raza_chat_option);
            [PhoneMainView.instance changeCurrentView:view.compositeViewDescription];
        }
        if ([title isEqualToString:@"Ringtone"]) {
            //                     Raza_chat_option_ring *Raza_chat_option_tone = [[Raza_chat_option_ring alloc]initWithNibName:@"Raza_chat_option_ring" bundle:nil];
            //                      Raza_chat_option_tone.title = title;
            //                   [self.navigationController pushViewController:Raza_chat_option_tone animated:YES];
            Raza_chat_option_ring *view = VIEW(Raza_chat_option_ring);
            [PhoneMainView.instance changeCurrentView:view.compositeViewDescription];
        }
        if ([title isEqualToString:@"Temperature"])
        {
            //            RazaTemprateBaseViewController *Raza_Temprature_object = [[RazaTemprateBaseViewController alloc]initWithNibName:@"RazaTemprateBaseViewController" bundle:nil];
            //            Raza_Temprature_object.title = title;
            //            [self.navigationController pushViewController:Raza_Temprature_object animated:YES];
            
            RazaTemprateBaseViewController *view = VIEW(RazaTemprateBaseViewController);
            [PhoneMainView.instance changeCurrentView:view.compositeViewDescription];
        }
    } else {
        [RAZA_APPDELEGATE showAlertWithMessage:@"" withTitle:NETWORK_UNAVAILABLE withCancelTitle:@"Dismiss"];
    }
    
    
    
}

#pragma mark -
#pragma mark Signout methods

-(IBAction)signout:(id)sender {
    
    //[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"profileimg"];
    [self showalert];
}

- (void)deleteTokenfromServer:(NSString*)token
{
    
    NSString *urlStr = [[RazaHelper formValidURL:DEFAULT_SIP_ADDRESS] stringByAppendingString:API_DELETE_DEVICE];
    NSString *url_str=[NSString stringWithFormat:@"?from=%@&api_id=%@&token=%@",[[NSUserDefaults standardUserDefaults] stringForKey:@"localphone"],@"abcdef",token];
    url_str = [urlStr stringByAppendingString:url_str];
    url_str = [url_str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:url_str]];
    
    NSData *response = [NSURLConnection sendSynchronousRequest:request  returningResponse:nil error:nil];
    
    NSString *json_string = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    NSLog(@"%@",json_string);
    
    
}


//The event handling method
- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer
{
    //  CGPoint location = [recognizer locationInView:[recognizer.view superview]];
    
    //Do stuff here...
    NSData* imageData = [[NSUserDefaults standardUserDefaults] objectForKey:RAZALOGGEDIMAGE];
    if (imageData) {
        
        
        ImageView *view = VIEW(ImageView);
        [PhoneMainView.instance changeCurrentView:view.compositeViewDescription];
        // CGImageRef fullScreenRef = [[_messageImageView.fullImageUrl defaultRepresentation] fullScreenImage];
        
        UIImage* image = [UIImage imageWithData:imageData];
        UIImage *fullScreen = image;//[UIImage imageWithCGImage:fullScreenRef];
        [view setImage:fullScreen];
    }
}
- (IBAction)imgfromgallery:(id)sender {
    if ([RAZA_APPDELEGATE checkNetworkPriorRequest]){
        NSData* imageData = [[NSUserDefaults standardUserDefaults] objectForKey:RAZALOGGEDIMAGE];
        if (imageData) {
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                     delegate:self
                                                            cancelButtonTitle:@"Cancel"
                                                       destructiveButtonTitle:nil
                                                            otherButtonTitles:@"Choose existing",@"Take photo",@"Remove",nil];
            
            [actionSheet showInView:self.view];
        }
        else{
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                     delegate:self
                                                            cancelButtonTitle:@"Cancel"
                                                       destructiveButtonTitle:nil
                                                            otherButtonTitles:@"Choose existing",@"Take photo", nil];
            
            [actionSheet showInView:self.view];
        }
        
        
    }
    else{
        [RAZA_APPDELEGATE showMessage:ERROR_NO_NETWORK withMode:MBProgressHUDModeText withDelay:1.0 withShortMessage:NO];
    }
    
    
    
    
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        
        [self pickPhoto];
        
    }else if(buttonIndex==1) {
        
        [self cameraphoto];
    }
    else if(buttonIndex==2) {
        [[Razauser SharedInstance]ShowWaiting:nil];
        [self removeImage:[RAZA_USERDEFAULTS stringForKey:@"profilephone"]];
        
    }
}


-(void) pickPhoto
{
    
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.navigationBar.tintColor=[UIColor whiteColor];
    picker.navigationBar.barTintColor=[UIColor whiteColor];
    CAGradientLayer *gradient = [BackgroundLayer navHeaderGradient];
    gradient.frame = picker.navigationBar.bounds;
    gradient.startPoint = CGPointMake(0.0, 0.0);
    gradient.endPoint = CGPointMake(0.0, 1.0);
    gradient.locations = @[@0.0,@1.0];
    [picker.navigationBar.layer insertSublayer:gradient atIndex:0];
   // [[UIApplication sharedApplication] setStatusBarHidden:YES];

    [self presentViewController:picker animated:YES completion:NULL];
    
}


-(void) cameraphoto
{
    
    
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
       // [[UIApplication sharedApplication] setStatusBarHidden:YES];

        [self presentViewController:picker animated:YES completion:NULL];
    }
    
    
}


-(void)image:(UIImage *)image finishedSavingWithError:(NSError *)error
 contextInfo:(void *)contextInfo
{
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Save failed"
                              message: @"Failed to save image"
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        alert.tag=2;
        [alert show];
    }
}




- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{

    
    UIImage *imag = info[UIImagePickerControllerEditedImage];
    //self.imgView.image = imag;
    //imgView.image = imag;
    [picker dismissViewControllerAnimated:YES completion:NULL];
    //     dispatch_async(dispatch_get_main_queue(), ^{
    //         [self setimgval:imag];
    //     });
    imgforprofile=imag;
    
    
    
    [[NSUserDefaults standardUserDefaults] setObject:UIImagePNGRepresentation(imag) forKey:@"profileimg"];
    
    
    
    
    // [[NSUserDefaults standardUserDefaults] setObject:imageData forKey:@"userimage"];
    //  NSData *filePath = [[NSUserDefaults standardUserDefaults] objectForKey:@"userimage"];
    //imgView.image=imgname;
    [[Razauser SharedInstance]ShowWaiting:nil];
    [self profileimgupload:imag userowner:[RAZA_USERDEFAULTS stringForKey:@"profilephone"]];
    // [self profileimgupload:imag userowner:[RAZA_USERDEFAULTS stringForKey:@"profilephone"]];
    // HUD = [[MBProgressHUD alloc] initWithView:self.view];
    // [imgView addSubview:HUD];
    
    // [HUD show:YES];
    
    
    //    NSString* path = [NSHomeDirectory() stringByAppendingString:@"/Documents/myImage.png"];
    //
    //    BOOL ok = [[NSFileManager defaultManager] createFileAtPath:path
    //                                                      contents:nil attributes:nil];
    //    if (!ok)
    //    {
    //        NSLog(@"Error creating file %@", path);
    //    }
    //    else
    //    {
    //
    //        NSFileHandle* myFileHandler = [NSFileHandle fileHandleForWritingAtPath:path];
    //        [myFileHandler writeData:UIImagePNGRepresentation(imag)];
    //        [myFileHandler closeFile];
    //    }
    //
    
    [self dismissViewControllerAnimated:YES completion:^{
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        self.headerViewTopConst.constant=0;
    }];
    
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:^{
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        self.headerViewTopConst.constant=0;

    }];
    
    
}

-(void)lalaphoto
{
    // NSUInteger selectedIndex = [self.tabBarController.viewControllers indexOfObject:self];
    //     NSLog(@"%d=====",selectedIndex);
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Notice"
                                                              message:@"Device has no camera"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        myAlertView.tag=3;
        [myAlertView show];
        
    }
    else
        
    {
        //NSUInteger selectedIndex = [self.tabBarController.viewControllers indexOfObject:self];
        //
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [[[[[UIApplication sharedApplication] delegate] window] rootViewController] presentViewController:picker animated:YES completion:nil];
        // [self.view.window.rootViewController presentViewController:picker animated:YES completion:nil];
        //  RazaAppDelegate* appDel = (RazaAppDelegate*)[[UIApplication sharedApplication] delegate];
        //        [self addChildViewController:picker];
        //        [self.view addSubview:picker.view];
        //        [self.navigationController presentViewController:picker animated:NO completion:nil];
        //[appDel.tabViewController presentViewController:picker animated:YES];
        // [appDel.navcontroller presentViewController:picker animated:YES completion:nil];
        
        //   NSLog(@"%@allll",[self.tabBarController.viewControllers objectAtIndex:3]);
        // [[[RazaAppDelegate sharedInstance] tabViewController]
        // presentViewController:picker animated:YES completion:nil];
        //  [[self window] setRootViewController:picker];
        //[self presentViewController:picker animated:YES completion:NULL];
        // show the navigation controller modally
        //[self.navigationController pushViewController:picker animated:YES];
        //          [[[RazaAppDelegate sharedInstance] tabViewController]
        //             presentViewController:picker animated:YES completion:nil];
        //  [self presentViewController:picker animated:YES completion:nil];
        /* UIViewController *vc = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
         UINavigationController      *navigationController = [[UINavigationController alloc] initWithRootViewController:vc];
         
         [navigationController presentViewController:picker animated:YES completion:nil];*/
        
        //[self.tabBarController setCustomizableViewControllers:[[NSArray alloc]initWithObjects:picker,self,nil]];
        //        [[[RazaAppDelegate sharedInstance] tabViewController]
        //         presentViewController:picker animated:YES completion:nil];
        
        //[self addChildViewController:picker];
        //[self presentViewController:picker animated:YES completion:nil];
        //[self.navigationController pushViewController:picker animated:YES];
        //[self presentViewController:picker animated:YES completion:NULL];
        /*[self addChildViewController:picker];
         picker.view.frame = CGRectMake(0, 44, 320, 320);
         [self.view addSubview:picker.view];
         [picker didMoveToParentViewController:self];*/
        
        //[self.view.window.rootViewController.navigationController pushViewController:picker animated:YES];
        //        [[self rootController] presentViewController:controller animated:YES completion:^{
        //
        //            [self window].rootViewController = picker;
        //
        //            [[self window] makeKeyAndVisible];}];
        //   [[self view.window setRootViewController:picker];
        
        // [self.parentViewController presentViewController:picker animated:YES completion:nil];
        // [self.view.window.rootViewController presentViewController:picker animated:YES completion:nil];
        // [self dismissViewControllerAnimated:YES completion:nil];
        // [self presentViewController:picker animated:YES completion:NULL];
        
        /*[self addChildViewController:picker];
         [self.view addSubview:picker.view];
         [picker didMoveToParentViewController:self];*/
        
        // UIViewController* controller = [self.storyboard instantiateViewControllerWithIdentifier:@"test"];
        /*  [self addChildViewController:picker];
         picker.view.frame = CGRectMake(0, 44, 320, 320);
         [self.view addSubview:picker.view];
         [picker didMoveToParentViewController:self];*/
    }
    
}

- (UIViewController *)backViewController2 {
    NSArray * stack = self.navigationController.viewControllers;
    
    for (int i=(int)stack.count-1; i > 0; --i)
        if (stack[i] == self)
            return stack[i-1];
    
    return nil;
}
- (IBAction)takePhoto:(UIButton *)sender {
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Notice"
                                                              message:@"Device has no camera"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        myAlertView.tag=1;
        [myAlertView show];
        
    }
    else
        
    {
        //NSUInteger selectedIndex = [self.tabBarController.viewControllers indexOfObject:self];
        //      NSLog(@"%d=====",selectedIndex);
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        //[self.view.window.rootViewController.navigationController pushViewController:picker animated:YES];
        //        [[self rootController] presentViewController:controller animated:YES completion:^{
        //
        //            [self window].rootViewController = picker;
        //
        //            [[self window] makeKeyAndVisible];}];
        //   [[self view.window setRootViewController:picker];
        
        // [self.parentViewController presentViewController:picker animated:YES completion:nil];
        // [self.view.window.rootViewController presentViewController:picker animated:YES completion:nil];
        // [self dismissViewControllerAnimated:YES completion:nil];
        // [self presentViewController:picker animated:YES completion:NULL];
        
        /*[self addChildViewController:picker];
         [self.view addSubview:picker.view];
         [picker didMoveToParentViewController:self];*/
        
        // UIViewController* controller = [self.storyboard instantiateViewControllerWithIdentifier:@"test"];
        /*  [self addChildViewController:picker];
         picker.view.frame = CGRectMake(0, 44, 320, 320);
         [self.view addSubview:picker.view];
         [picker didMoveToParentViewController:self];*/
        
    }
}
-(void)dismissModalStack {
    UIViewController *vc = self.presentingViewController;
    while (vc.presentingViewController) {
        vc = vc.presentingViewController;
    }
    [vc dismissViewControllerAnimated:YES completion:NULL];
}
- (IBAction)selectPhoto:(UIButton *)sender {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
    
    
}

- (IBAction)mainsetting:(id)sender {
    Raza_network_setting *add = [[Raza_network_setting alloc]
                                 initWithNibName:@"Raza_network_setting" bundle:nil];
    [self presentViewController:add animated:YES completion:nil];
}

- (IBAction)btnMenuClicked:(id)sender {
    UICompositeView *cvc = PhoneMainView.instance.mainViewController;
    [cvc hideSideMenu:(cvc.sideMenuView.frame.origin.x == 0)];
    self.headerViewTopConst.constant=-20;

}

- (IBAction)clkme:(id)sender
{
    /* UIImagePickerController *picker = [[UIImagePickerController alloc] init];
     picker.delegate = self;
     picker.allowsEditing = YES;
     picker.sourceType = UIImagePickerControllerSourceTypeCamera;
     
     [self presentViewController:picker animated:YES completion:NULL];*/
    
}
-(void)profileimgupload:(UIImage *)image userowner:(NSString*)userownernumber
{
    self.headerViewTopConst.constant=0;

    //http://54.149.13.57/ios/ios.php
    //http://54.149.13.57/profile/file.php
    //    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //
    //    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //
    //    AFHTTPRequestOperation *requestOperation =   [manager POST:@"http://54.149.13.57/profile/profileUpload.php" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
    //                                                  {
    //                                                      // NSArray* arrayOfStrings = [dataoffound componentsSeparatedByString:@"UplodedFile/"];
    //
    //
    //                                                      NSData *imageData = UIImageJPEGRepresentation(image,0.5);
    //                                                      NSLog(@"File size is : %.2f MB",(float)imageData.length/1024.0f/1024.0f);
    //                                                      [formData appendPartWithFileData:imageData name:@"image" fileName:[NSString stringWithFormat:@"%@.png",userownernumber] mimeType:@"image/jpeg"];
    //
    //
    //                                                  }
    //                                                       success:^(AFHTTPRequestOperation *operation, id responseObject)
    //                                                  {
    //                                                      NSString *imgpic=[NSString stringWithFormat:@"http://54.149.13.57/profile/profile-images/%@.png",userownernumber];
    //                                                      [[SDImageCache sharedImageCache] removeImageForKey:imgpic fromDisk:YES];
    //                                                       [HUD hide:YES];
    //                                                      //[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"MyKey"];
    //                                                      NSLog(@"file-upload-success");
    ////                                                      [self.imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@.png",RAZA_PROFILE,[RAZA_USERDEFAULTS stringForKey:@"profilephone"]]]placeholderImage:[UIImage imageNamed:@"#_big.png"] options:SDWebImageRefreshCached];
    //                                                      [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    //
    //                                                  }
    //                                                       failure:^(AFHTTPRequestOperation *operation, NSError *error)
    //                                                  {
    //                                                      [HUD hide:YES];
    //
    //                                                     // imgforprofile=nil;
    //
    //
    //                                                      [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"profileimg"];
    //                                                      NSLog(@"file-upload-failure");
    //                                                      //  NSLog(@"faliore block called at inedex %ld %@",(long)index,error);
    //                                                      [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    //                                                  }];
    //
    //    [requestOperation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite)
    //     {
    //
    //
    //     }];
    // NSData *imageData = UIImageJPEGRepresentation(image,0.5);
    NSData *imageData = [[Razauser SharedInstance]compresstest:image];
    //#define RAZA_PROFILE @"http://54.149.13.57/profile/profile-images/"
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:RAZA_UPLOADPROFILE_IMAGE parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        // [formData appendPartWithFileURL:[NSURL fileURLWithPath:@"file://path/to/image.jpg"] name:@"file" fileName:@"filename.jpg" mimeType:@"image/jpeg" error:nil];
        [formData appendPartWithFileData:imageData name:@"image" fileName:[NSString stringWithFormat:@"%@.png",userownernumber] mimeType:@"image/jpeg"];
    } error:nil];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSURLSessionUploadTask *uploadTask;
    uploadTask = [manager
                  uploadTaskWithStreamedRequest:request
                  progress:^(NSProgress * _Nonnull uploadProgress) {
                      // This is not called back on the main queue.
                      // You are responsible for dispatching to the main queue for UI updates
                      dispatch_async(dispatch_get_main_queue(), ^{
                          //Update the progress view
                          //  [progressView setProgress:uploadProgress.fractionCompleted];
                      });
                  }
                  completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                      if (error) {
                          NSLog(@"Error: %@", error);
                          [[Razauser SharedInstance]HideWaiting];
                      } else {
                          NSLog(@"%@ %@", response, responseObject);
                          [self setimages];
                      }
                  }
                  // [HUD show:YES];
                  
                  ];
    
    [uploadTask resume];
    
}
-(void)showalert
{
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Raza Signout!"
                                                      message:@"Are you sure?"
                                                     delegate:self
                                            cancelButtonTitle:nil
                                            otherButtonTitles:@"Yes",@"No",nil];
    message.tag=4;
    [message show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 4)
    {
        if (buttonIndex==0) {
            [self callforsignout];
        }
        
    }
}
-(void)callforsignout
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:ShowHidePopup];
    [[NSUserDefaults standardUserDefaults] synchronize];
    STRUSER=[[RAZA_USERDEFAULTS objectForKey:@"logininfo"] objectForKey:LOGIN_RESPONSE_EMAIL];
    
    HUDforsignout = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUDforsignout];
    
    [HUDforsignout show:YES];
    
    NSString *localtoken = [RAZA_APPDELEGATE deviceToken];
    
    [self deleteTokenfromServer:localtoken];
    
    
    [RAZA_USERDEFAULTS setObject:[NSString stringWithFormat:@"signout"] forKey:@"status"];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"MessageStatus" object:nil];
    NSDictionary *recentCallDetails = [RAZA_USERDEFAULTS objectForKey:@"calldetails"];
    NSDictionary *olddaterecords = [RAZA_USERDEFAULTS objectForKey:@"callwithdates"];
    
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [RAZA_USERDEFAULTS removePersistentDomainForName:appDomain];
    [RAZA_USERDEFAULTS removeObjectForKey:@"profilephone"];
    
    // Set the recent call list back to UserDefaults on logout
    [RAZA_USERDEFAULTS setObject:recentCallDetails forKey:@"calldetails"];
    [RAZA_USERDEFAULTS setObject:olddaterecords forKey:@"callwithdates"];
    
    [self.navigationController popToRootViewControllerAnimated:NO];
    
    //UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:[NSBundle mainBundle]];
    // RazaHomeViewController *vc =[storyboard instantiateInitialViewController];
    // vc.isSignOut = YES;
    //NSLog(@"vc.navigationController %@",vc.navigationController);
    
    // UINavigationController *tempNav = [[UINavigationController alloc]initWithRootViewController:vc];
    
    // RAZA_APPDELEGATE.window.rootViewController = tempNav;
    
    [[NSUserDefaults standardUserDefaults] setObject:@"loggedout"  forKey:@"logoutstatus"];
    
    //  [[NgnEngine sharedInstance].sipService unRegisterIdentity];
    
    // [[NgnEngine sharedInstance] stop];
    
    //  [RAZA_APPDELEGATE setDeviceToken:localtoken];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"profileimg"];
    
    [RAZA_USERDEFAULTS setObject:Razaonlineuser forKey:@"GETRAZAUSER"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DELETEHISTORY" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DELETERECENTHISTORY" object:nil];
    
    DELETENETWORKINFORMATION=[[globalnetworkclass alloc]init];
    [DELETENETWORKINFORMATION DELETENETWORKINFORMATIONALL:@"network_keypad.plist"];
    [DELETENETWORKINFORMATION DELETENETWORKINFORMATIONALL:@"network_update.plist"];
    
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
-(void)setimages
{
    LinphoneProxyConfig *default_proxy = linphone_core_get_default_proxy_config(LC);
    NSString *phoneNumber;
    if (default_proxy != NULL)
    {
        // const LinphoneAddress *addr = linphone_proxy_config_get_identity_address(default_proxy);
        phoneNumber = [NSString stringWithUTF8String:linphone_proxy_config_get_identity(default_proxy)];
        
        NSString *logged=[[Razauser SharedInstance]getusername:phoneNumber];
        NSURL *urluser=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@.png",RAZA_PROFILE,logged]];
        [[Razauser SharedInstance] downloadImageWithURL:urluser completionBlock:^(BOOL succeeded, UIImage *image) {
            self.headerViewTopConst.constant=0;
            [[Razauser SharedInstance]HideWaiting];
            if (image)
            {
                imgView.image =image;
                [[NSUserDefaults standardUserDefaults] setObject:UIImagePNGRepresentation(image) forKey:RAZALOGGEDIMAGE];
            }
            else
                // [LinphoneUtils selfAvatar];
                imgView.image =[UIImage imageNamed:@"#_big.png"];
        }];
    }
}

-(void)removeImage:(NSString*)phonemuber
{
    
    
    NSURL *uri=[NSURL URLWithString:[NSString stringWithFormat:@"%@?profile_image_name=%@.png",RAZA_REMOVE_IMAGE,phonemuber]];
    
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:uri cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:0];
    
    
    
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //NSURL *URL = [NSURL URLWithString:@"http://httpbin.org/get"];
    //  NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:theRequest completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        [[Razauser SharedInstance]HideWaiting];
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            NSLog(@"%@ %@", response, responseObject);
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:RAZALOGGEDIMAGE];
            NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:&error];
            if ([[jsonDict valueForKey:@"success"] isEqualToString:@"true"]) {
                imgView.image =[UIImage imageNamed:@"#_big.png"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:RAZALOGGEDIMAGE];
                NSLog(@"%@",jsonDict);
            }
            
            
        }
    }];
    [dataTask resume];
    
}

- (IBAction)tempChangeAction:(id)sender {
    RazaTemprateBaseViewController *view = VIEW(RazaTemprateBaseViewController);
    [PhoneMainView.instance changeCurrentView:view.compositeViewDescription];
}

@end
