/* ContactDetailsViewController.m
 *
 * Copyright (C) 2012  Belledonne Comunications, Grenoble, France
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
 */

#import "ContactDetailsView.h"
#import "PhoneMainView.h"
#import "UIContactDetailsCell.h"

@implementation ContactDetailsView

#pragma mark - Lifecycle Functions

- (id)init {
    self = [super initWithNibName:NSStringFromClass(self.class) bundle:[NSBundle mainBundle]];
    if (self != nil) {
        inhibUpdate = FALSE;
        [NSNotificationCenter.defaultCenter addObserver:self
                                               selector:@selector(onAddressBookUpdate:)
                                                   name:kLinphoneAddressBookUpdate
                                                 object:nil];
    }
    return self;
}

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

#pragma mark -

- (void)onAddressBookUpdate:(NSNotification *)k {
    if (!inhibUpdate && ![_tableController isEditing]) {
        [self resetData];
    }
}

- (void)resetData {
    if (self.isEditing) {
        [self setEditing:FALSE];
    }
    
    LOGI(@"Reset data to contact %p", _contact);
    [_avatarImage setImage:[FastAddressBook imageForContact:_contact thumbnail:NO] bordered:NO withRoundedRadius:YES];
    [_tableController setContact:_contact];
    _emptyLabel.hidden = YES;
    _avatarImage.hidden = !_emptyLabel.hidden;
    _deleteButton.hidden = !_emptyLabel.hidden;
    _editButton.hidden = !_emptyLabel.hidden;
}

- (void)removeContact {
    inhibUpdate = TRUE;
    [[Razauser SharedInstance]ShowWaitingshort:nil andtime:10.0];
    [[LinphoneManager.instance fastAddressBook] removeContact:_contact];
    inhibUpdate = FALSE;
    [PhoneMainView.instance popCurrentView];
}

- (void)saveData {
    if (_contact == NULL) {
        [PhoneMainView.instance popCurrentView];
        return;
    }
    
    if ((_contact.firstName||_contact.lastName)&&(_contact.phoneNumbers.count||_contact.sipAddresses.count)) {
        if (_contact.firstName.length && _contact.lastName.length) {
            _nameLabel.text=[NSString stringWithFormat:@"%@ %@",_contact.firstName,_contact.lastName];
        }else if (_contact.firstName.length && _contact.lastName.length==0) {
            _nameLabel.text=[NSString stringWithFormat:@"%@",_contact.firstName];
        }else if (_contact.firstName.length==0 && _contact.lastName.length) {
            _nameLabel.text=[NSString stringWithFormat:@"%@",_contact.lastName];
        }
        [[Razauser SharedInstance]ShowWaitingshort:nil andtime:10.0];
        [LinphoneManager.instance.fastAddressBook saveContact:_contact];
    }
    else
        [PhoneMainView.instance popCurrentView];
    // Add contact to book
    
}

- (void)selectContact:(Contact *)acontact andReload:(BOOL)reload {
    if (self.isEditing) {
        [self setEditing:FALSE];
    }
    
    _contact = acontact;
    _emptyLabel.hidden = (_contact != NULL);
    _avatarImage.hidden = !_emptyLabel.hidden;
    _deleteButton.hidden = !_emptyLabel.hidden;
    _editButton.hidden = !_emptyLabel.hidden;
    
    [_avatarImage setImage:[FastAddressBook imageForContact:_contact thumbnail:NO] bordered:NO withRoundedRadius:YES];
    [ContactDisplay setDisplayNameLabel:_nameLabel forContact:_contact];
    // if (_contact) {
    // _contact.phoneNumbers=[[[NSArray alloc]initWithObjects:@"4444", nil] mutableCopy];
    //}
    [_tableController setContact:_contact];
    [self showhidecallview];
    if (reload) {
        _viewcall.hidden=YES;
        [self setEditing:TRUE animated:FALSE];
    }else{
        _viewcall.hidden=NO;
    }
    
}

- (void)addCurrentContactContactField:(NSString *)address {
    LinphoneAddress *linphoneAddress = linphone_core_interpret_url(LC, address.UTF8String);
    NSString *username =
    linphoneAddress ? [NSString stringWithUTF8String:linphone_address_get_username(linphoneAddress)] : address;
    
    if (([username rangeOfString:@"@"].length > 0) &&
        ([LinphoneManager.instance lpConfigBoolForKey:@"show_contacts_emails_preference"] == true)) {
        [_tableController addEmailField:username];
    } else if ((linphone_proxy_config_is_phone_number(NULL, [username UTF8String])) &&
               ([LinphoneManager.instance lpConfigBoolForKey:@"save_new_contacts_as_phone_number"] == true)) {
        [_tableController addPhoneField:username];
    } else {
        [_tableController addPhoneField:username];
        //[_tableController addSipField:address];
    }
    if (linphoneAddress) {
        linphone_address_destroy(linphoneAddress);
    }
    [self setEditing:TRUE];
    [[_tableController tableView] reloadData];
}

- (void)newContact {
    _isAdding = TRUE;
    [self selectContact:[[Contact alloc] initWithPerson:ABPersonCreate()] andReload:YES];
}

- (void)newContact:(NSString *)address {
    [self selectContact:[[Contact alloc] initWithPerson:ABPersonCreate()] andReload:NO];
    [self addCurrentContactContactField:address];
    // force to restart server subscription to add new contact into the list
    [LinphoneManager.instance becomeActive];
}

- (void)editContact:(Contact *)acontact {
    [self selectContact:acontact andReload:YES];
}

- (void)editContact:(Contact *)acontact address:(NSString *)address {
    [self selectContact:acontact andReload:NO];
    [self addCurrentContactContactField:address];
}

- (void)setContact:(Contact *)acontact {
    [self selectContact:acontact andReload:NO];
}

#pragma mark - ViewController Functions

- (void)viewDidLoad {
    [super viewDidLoad];
    self.videoAudioCallBtnBGView.layer.borderColor=[UIColor colorWithRed:247.0/255.0f green:247.0/255.0f blue:247.0/255.0f alpha:1.0f].CGColor;
    self.videoAudioCallBtnBGView.layer.borderWidth=2.0f;
    // if we use fragments, remove back button
    if (IPAD) {
        _backButton.hidden = YES;
        _backButton.alpha = 0;
    }
    
    [self setContact:NULL];
    
    _tableController.tableView.accessibilityIdentifier = @"Contact table";
    
    [_editButton setImage:[UIImage imageNamed:@"valid_disabled.png"]
                 forState:(UIControlStateDisabled | UIControlStateSelected)];
    
    //	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
    //								   initWithTarget:self
    //								   action:@selector(dismissKeyboards)];
    //
    //	[self.view addGestureRecognizer:tap];
    
    _tableController.tableView.tableHeaderView=self.headerView;
    _tableController.tableView.tableFooterView=self.viewcall;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    CAGradientLayer *gradient = [BackgroundLayer navHeaderGradient];
    gradient.frame = self.topHeaderView.bounds;
    gradient.startPoint = CGPointMake(0.0, 0.0);
    gradient.endPoint = CGPointMake(0.0, 1.0);
    gradient.locations = @[@0.0,@1.0];
    [self.topHeaderView.layer insertSublayer:gradient atIndex:0];
    
    
    _editButton.hidden = ([ContactSelection getSelectionMode] != ContactSelectionModeEdit &&
                          [ContactSelection getSelectionMode] != ContactSelectionModeNone);
    [_tableController.tableView addObserver:self forKeyPath:@"contentSize" options:0 context:NULL];
    self.tmpContact = NULL;
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(deviceOrientationDidChange:)
                                                 name: UIDeviceOrientationDidChangeNotification
                                               object: nil];
    if (IPAD && self.contact == NULL) {
        _editButton.hidden = TRUE;
        _deleteButton.hidden = TRUE;
    }
    
    // Update presence for contact
    for (NSInteger j = 0; j < [self.tableController.tableView numberOfSections]; ++j) {
        for (NSInteger i = 0; i < [self.tableController.tableView numberOfRowsInSection:j]; ++i) {
            [(UIContactDetailsCell *)[self.tableController.tableView
                                      cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:j]] shouldHideLinphoneImageOfAddress];
        }
    }
    [self getloadcall];
    //  LinphoneAppDelegate *tlk=[[LinphoneAppDelegate alloc]init];
    // [tlk hidedurationcalling];
   // [RAZA_APPDELEGATE hidedurationcalling];
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(makeacallparamContactdetail:) name:@"makeacallviaRazaoutcontactdetailparam" object:nil];
    [self.tableController.tableView reloadData];
}


- (void)deviceOrientationDidChange:(NSNotification*)notif {
    if (IPAD) {
        if (self.contact == NULL || (self.contact.firstName == NULL && self.contact.lastName == NULL)) {
            if (! self.tableController.isEditing) {
                _editButton.hidden = TRUE;
                _deleteButton.hidden = TRUE;
                _avatarImage.hidden = TRUE;
                _emptyLabel.hidden = FALSE;
            }
        }
    }
    
    if (self.tableController.isEditing) {
        _backButton.hidden = TRUE;
        _cancelButton.hidden = FALSE;
    } else {
        if (!IPAD) {
            _backButton.hidden = FALSE;
        }
        _cancelButton.hidden = TRUE;
    }
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [_tableController.tableView removeObserver:self forKeyPath:@"contentSize"];
    [super viewWillDisappear:animated];
    if (self.tmpContact) {
        _contact.firstName = _tmpContact.firstName.copy;
        _contact.lastName = _tmpContact.lastName.copy;
        while (_contact.sipAddresses.count > 0) {
            [_contact removeSipAddressAtIndex:0];
            
        }
        NSInteger nbSipAd = 0;
        while (_tmpContact.sipAddresses.count > nbSipAd) {
            [_contact addSipAddress:_tmpContact.sipAddresses[nbSipAd]];
            nbSipAd++;
        }
        
        while (_contact.phoneNumbers.count > 0) {
            [_contact removePhoneNumberAtIndex:0];
            
        }
        NSInteger nbPhone = 0;
        while (_tmpContact.phoneNumbers.count> nbPhone) {
            [_contact addPhoneNumber:_tmpContact.phoneNumbers[nbPhone]];
            nbPhone++;
        }
        
        while (_contact.emails.count > 0) {
            [_contact removeEmailAtIndex:0];
            
        }
        NSInteger nbEmail = 0;
        while (_tmpContact.emails.count> nbEmail) {
            [_contact addEmail:_tmpContact.emails[nbEmail]];
            nbEmail++;
        }
        self.tmpContact = NULL;
        [self saveData];
    }
    LinphoneAppDelegate *tlk=[[LinphoneAppDelegate alloc]init];
    [tlk showdurationcalling];
}

#pragma mark - UICompositeViewDelegate Functions

static UICompositeViewDescription *compositeDescription = nil;

+ (UICompositeViewDescription *)compositeViewDescription {
    if (compositeDescription == nil) {
        compositeDescription = [[UICompositeViewDescription alloc] init:self.class
                                                              statusBar:nil
                                                                 tabBar:nil
                                                               sideMenu:SideMenuView.class
                                                             fullscreen:false
                                                         isLeftFragment:NO
                                                           fragmentWith:ContactsListView.class];
    }
    return compositeDescription;
}

- (UICompositeViewDescription *)compositeViewDescription {
    return self.class.compositeViewDescription;
}

#pragma mark -

- (void)setEditing:(BOOL)editing {
    [self setEditing:editing animated:NO];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    if (editing) {
        _editButton.hidden = FALSE;
        _deleteButton.hidden = FALSE;
        _avatarImage.hidden = FALSE;
    } else {
        _editButton.hidden = TRUE;
        _deleteButton.hidden = TRUE;
        _avatarImage.hidden = TRUE;
    }
    
    if (animated) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:1.0];
    }
    [_tableController setEditing:editing animated:animated];
    if (editing) {
        [_editButton setOn];
    } else {
        [_editButton setOff];
    }
    _cancelButton.hidden = !editing;
    _backButton.hidden = editing;
    _nameLabel.hidden = NO;
    [ContactDisplay setDisplayNameLabel:_nameLabel forContact:_contact];
    if (_nameLabel.text.length>0) {
        _nameLabel.text=@"Add contact";//add_profile_image@2x.png
        _avatarImage.image=[UIImage imageNamed:@"add_profile_image.png"];
    }
    
    if ([self viewIsCurrentlyPortrait]) {
        //		CGRect frame = _tableController.tableView.frame;
        //		frame.origin.y = _avatarImage.frame.size.height + _avatarImage.frame.origin.y;
        //		if (!editing) {
        //			frame.origin.y += _nameLabel.frame.size.height;
        //		}
        //
        //		frame.size.height = _tableController.tableView.contentSize.height;
        //		_tableController.tableView.frame = frame;
        //		[self recomputeContentViewSize];
    }
    
    if (animated) {
        [UIView commitAnimations];
    }
}
-(void)showdetailpic:(UIImage*)imgdata
{
    // NSData* imageData = [[NSUserDefaults standardUserDefaults] objectForKey:RAZALOGGEDIMAGE];
    if (imgdata) {
        
        
        ImageView *view = VIEW(ImageView);
        [PhoneMainView.instance changeCurrentView:view.compositeViewDescription];
        // CGImageRef fullScreenRef = [[_messageImageView.fullImageUrl defaultRepresentation] fullScreenImage];
        
        UIImage* image =imgdata; //[UIImage imageWithData:imgdata];
        UIImage *fullScreen = image;//[UIImage imageWithCGImage:fullScreenRef];
        [view setImage:fullScreen];
    }
}
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    //	CGRect frame = _tableController.tableView.frame;
    //	frame.size = _tableController.tableView.contentSize;
    //	_tableController.tableView.frame = frame;
    //[self recomputeContentViewSize];
}

- (void)recomputeContentViewSize {
    //	_contentView.contentSize =
    //		CGSizeMake(_tableController.tableView.frame.size.width + _tableController.tableView.frame.origin.x,
    //				   _tableController.tableView.frame.size.height + _tableController.tableView.frame.origin.y);
}

#pragma mark - Action Functions

- (IBAction)onCancelClick:(id)event {
    
    [self dismissKeyboards];
    if (!_isAdding) {
        _contact.firstName = _tmpContact.firstName.copy;
        _contact.lastName = _tmpContact.lastName.copy;
        while (_contact.sipAddresses.count > 0) {
            [_contact removeSipAddressAtIndex:0];
        }
        NSInteger nbSipAd = 0;
        while (_tmpContact.sipAddresses.count > nbSipAd) {
            [_contact addSipAddress:_tmpContact.sipAddresses[nbSipAd]];
            nbSipAd++;
        }
        
        while (_contact.phoneNumbers.count > 0) {
            [_contact removePhoneNumberAtIndex:0];
        }
        NSInteger nbPhone = 0;
        while (_tmpContact.phoneNumbers.count> nbPhone) {
            [_contact addPhoneNumber:_tmpContact.phoneNumbers[nbPhone]];
            nbPhone++;
        }
        
        while (_contact.emails.count > 0) {
            [_contact removeEmailAtIndex:0];
        }
        NSInteger nbEmail = 0;
        while (_tmpContact.emails.count> nbEmail) {
            [_contact addEmail:_tmpContact.emails[nbEmail]];
            nbEmail++;
        }
        [self saveData];
        [self.tableController.tableView reloadData];
    }
    
    [self setEditing:FALSE];
    if (IPAD) {
        _emptyLabel.hidden = !_isAdding;
        _avatarImage.hidden = !_emptyLabel.hidden;
        _deleteButton.hidden = !_emptyLabel.hidden;
        _editButton.hidden = !_emptyLabel.hidden;
    } else {
        if (_isAdding) {
            [PhoneMainView.instance popCurrentView];
        } else {
            _avatarImage.hidden = FALSE;
            _deleteButton.hidden = FALSE;
            _editButton.hidden = FALSE;
        }
    }
    
    self.tmpContact = NULL;
    _isAdding = FALSE;
    _viewcall.hidden=NO;
    [self showhidecallview];
}

- (IBAction)onBackClick:(id)event {
    if ([ContactSelection getSelectionMode] == ContactSelectionModeEdit) {
        [ContactSelection setSelectionMode:ContactSelectionModeNone];
    }
    
    ContactsListView *view = VIEW(ContactsListView);
    [PhoneMainView.instance popToView:view.compositeViewDescription];
}

- (IBAction)onEditClick:(id)event {
    
    if (_tableController.isEditing) {
        _viewcall.hidden=NO;
        [self showhidecallview];
        [self setEditing:FALSE];
        [self saveData];
        _isAdding = FALSE;
        self.tmpContact = NULL;
        _avatarImage.hidden = FALSE;
        _deleteButton.hidden = FALSE;
        _editButton.hidden = FALSE;
    } else {
        _viewcall.hidden=YES;
        [self showhidecallview];
        _tmpContact = [[Contact alloc] initWithPerson:ABPersonCreate()];
        _tmpContact.firstName = _contact.firstName.copy;
        _tmpContact.lastName = _contact.lastName.copy;
        _tmpContact.sipAddresses = _contact.sipAddresses.copy;
        _tmpContact.emails = _contact.emails.copy;
        _tmpContact.phoneNumbers = _contact.phoneNumbers.copy;
        [self setEditing:TRUE];
    }
}

- (IBAction)onDeleteClick:(id)sender {
    NSString *msg = NSLocalizedString(@"Do you want to delete selected contact?", nil);
    [UIConfirmationDialog ShowWithMessage:msg
                            cancelMessage:nil
                           confirmMessage:nil
                            onCancelClick:nil
                      onConfirmationClick:^() {
                          if (_tableController.isEditing) {
                              [self onCancelClick:sender];
                          }
                          [self removeContact];
                      }];
}

- (IBAction)onAvatarClick:(id)sender {
    [LinphoneUtils findAndResignFirstResponder:self.view];
    
    if (_contact.phoneNumbers.count) {
        NSString *basephone= [RazaHelper getValidPhoneNumberWithString:[_contact.phoneNumbers objectAtIndex:0] ];
        if ([[[Razauser SharedInstance]getRazauser] containsObject:basephone]) {
            [[Razauser SharedInstance]ShowWaiting:nil];
            NSURL *urluser=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@.png",RAZA_PROFILE,basephone]];
            [[Razauser SharedInstance] downloadImageWithURL:urluser completionBlock:^(BOOL succeeded, UIImage *image) {
                if (image)
                {
                    NSData *imageData =[[Razauser SharedInstance] compressImage:image];
                    UIImage *img=[UIImage imageWithData:imageData];
                    [[Razauser SharedInstance]HideWaiting];
                    [self showdetailpic:img];
                    // imgview.image=img;
                    //[imgview setImage:img bordered:NO withRoundedRadius:YES];
                    // [self setAvatarforraza:img andcontact:razacontact];
                    //  cellinfo.image=image;
                }
                else
                {
                    [[Razauser SharedInstance]HideWaiting];
                    //  [self showdetailpic:_avatarImage.image];
                    //avatar_male.png
                }
            }];
            
        }
    }
    
    
    
    if (_tableController.isEditing) {
        [ImagePickerView SelectImageFromDevice:self atPosition:_avatarImage inView:self.view];
    }
}

- (void)dismissKeyboards {
    NSArray *cells = [self.tableController.tableView visibleCells];
    for (UIContactDetailsCell *cell in cells) {
        UIView * txt = cell.editTextfield;
        if ([txt isKindOfClass:[UITextField class]] && [txt isFirstResponder]) {
            [txt resignFirstResponder];
        }
    }
}

#pragma mark - Image picker delegate

- (void)imagePickerDelegateImage:(UIImage *)image info:(NSDictionary *)info {
    // When getting image from the camera, it may be 90° rotated due to orientation
    // (image.imageOrientation = UIImageOrientationRight). Just rotate it to be face up.
    if (image.imageOrientation != UIImageOrientationUp) {
        UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale);
        [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    // Dismiss popover on iPad
    if (IPAD) {
        [VIEW(ImagePickerView).popoverController dismissPopoverAnimated:TRUE];
    }
    
    [_contact setAvatar:image];
    
    [_avatarImage setImage:[FastAddressBook imageForContact:_contact thumbnail:NO] bordered:NO withRoundedRadius:YES];
}


- (IBAction)btnchatClicked:(id)sender {
    [self presentmultiplecallchat:@"message"];
}

- (IBAction)btncallclicked:(id)sender {
    [self checkWiFiAndData];
    [self presentmultiplecallchat:@"call"];
}
- (IBAction)btnvideoclicked:(id)sender {
    [self checkWiFiAndData];
    [self presentmultiplecallchat:@"vcall"];
}
-(void)checkWiFiAndData{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    NetworkStatus status = [reachability currentReachabilityStatus];
    if (status == ReachableViaWiFi){
        [Razauser SharedInstance].callModeType=@"WIFI CALL";
    }
    else if (status == ReachableViaWWAN){
        [Razauser SharedInstance].callModeType=@"DATA CALL";
    }
}

-(NSArray*)getcounterofshow
{
    NSMutableArray *arr1=[[NSMutableArray alloc]init];
    NSArray *arr= [[Razauser SharedInstance]getRazauser];
    int count=0; //= [self.contact.phoneNumbers count];
    for (NSString *phone in _contact.phoneNumbers) {
        NSString *basephone= [RazaHelper getValidPhoneNumberWithString:phone];
        if ([arr containsObject:basephone])
        {
            [arr1 addObject:basephone];
            count=count+1;
        }
    }
    return arr1;
    
}

-(void)presentmultiplecallchat:(NSString*)mode{
    
    
    if ([RAZA_APPDELEGATE checkNetworkPriorRequest]){
        NSString *texttilte;
        if ([mode isEqualToString:@"call"])
            texttilte=@"Make Call!";
        else if ([mode isEqualToString:@"vcall"])
            texttilte=@"Make Video Call!";
        else
            texttilte=@"Send a text message!";
        UIActionSheet *sheet = nil;
        NSArray *count;
        if(self.contact){
            count=[self getcounterofshow];
            if(count.count > 1){
                sheet = [[UIActionSheet alloc] initWithTitle:texttilte
                                                    delegate:self
                                           cancelButtonTitle:nil
                                      destructiveButtonTitle:nil
                                           otherButtonTitles:nil];
                if ([mode isEqualToString:@"call"])
                    sheet.tag = kTagActionSheetAudioCall;
                else if ([mode isEqualToString:@"vcall"])
                    sheet.tag = kTagActionSheetVideoCall;
                else
                    sheet.tag = kTagActionSheetTextMessage;
            }
            else if(count.count == 1){
                
                
                if ([mode isEqualToString:@"call"])
                    [self Makeaudiocall:[count objectAtIndex:0]];
                else if ([mode isEqualToString:@"vcall"])
                    [self Makevaudiocall:[count objectAtIndex:0]];
                else
                    //  [RAZA_APPDELEGATE showAlertWithMessage:@"chat only one" withTitle:NETWORK_UNAVAILABLE withCancelTitle:@"Dismiss"];
                    [self makechat:[count objectAtIndex:0]];
            }
            else
                [RAZA_APPDELEGATE showAlertWithMessage:@"No Raza User!" withTitle:NETWORK_UNAVAILABLE withCancelTitle:@"Dismiss"];
        }
        if(sheet){
            sheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
            
            switch (sheet.tag) {
                case kTagActionSheetTextMessage:
                case kTagActionSheetVideoCall:
                case kTagActionSheetAudioCall:
                case kTagActionSheetAddToFavorites:
                {
                    arrofphonetomultipleuser=[[NSMutableArray alloc]init];
                    for(NSString* phoneNumber in count){
                        [arrofphonetomultipleuser addObject:phoneNumber];
                        [sheet addButtonWithTitle: phoneNumber];
                        //[arrofphonetomultipleuser addObject:struser];
                    }
                }
                    break;
            }
            
        }
        
        int cancelIdex = (int)[sheet addButtonWithTitle: @"Cancel"];
        sheet.cancelButtonIndex = cancelIdex;
        
        [sheet showInView:self.parentViewController.tabBarController.view];
    }
    
    else{

        [RAZA_APPDELEGATE showAlertWithMessage:@"There is no network connection available, enable WIFI or WWAN prior to place a call" withTitle:@"Network Error" withCancelTitle:@"OK"];
        
    }
    
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex != actionSheet.cancelButtonIndex){
        switch (actionSheet.tag) {
                
            case kTagActionSheetAudioCall:
            {
                
                NSLog(@"%@",[arrofphonetomultipleuser objectAtIndex:buttonIndex]);
                [self Makeaudiocall:[arrofphonetomultipleuser objectAtIndex:buttonIndex]];
                break;
            }
            case kTagActionSheetVideoCall:
            {
                
                NSLog(@"%@",[arrofphonetomultipleuser objectAtIndex:buttonIndex]);
                [self Makevaudiocall:[arrofphonetomultipleuser objectAtIndex:buttonIndex]];
                break;
            }
            case kTagActionSheetTextMessage:
            {
                
                NSLog(@"%@",[arrofphonetomultipleuser objectAtIndex:buttonIndex]);
                [self makechat:[arrofphonetomultipleuser objectAtIndex:buttonIndex]];
                break;
            }
                
                
            default:
                break;
        }
    }
}
-(void)Makeaudiocall:(NSString*)phonenumber
{
    NSString *address=phonenumber;//@"*9999";
    if ([address length] > 0) {
        selectedmoderazavideooraodio=nil;
        LinphoneAddress *addr = [LinphoneUtils normalizeSipOrPhoneAddress:address];
        [LinphoneManager.instance call:addr andmodeVideoAudio:FALSE];
        if (addr)
            linphone_address_destroy(addr);
    }
    
}
-(void)Makevaudiocall:(NSString*)phonenumber
{
    NSString *address=phonenumber;//@"*9999";
    if ([address length] > 0) {
        selectedmoderazavideooraodio=@"videocall";
        LinphoneAddress *addr = [LinphoneUtils normalizeSipOrPhoneAddress:address];
        [LinphoneManager.instance call:addr andmodeVideoAudio:TRUE];
        if (addr)
            linphone_address_destroy(addr);
    }
    
}
-(void)makechat:(NSString*)phonenumber
{
    
    NSString  *callno=[NSString stringWithFormat:@"sip:%@@%@",phonenumber,MAINRAZASIPURL];
    
    //callno=[NSString stringWithFormat:@"sip:@%@",callno];
    /* LinphoneChatRoom *room = linphone_core_get_chat_room_from_uri(
     LC, ((NSString *)[_contacts.allKeys objectAtIndex:indexPath.row]).UTF8String);*/
    LinphoneChatRoom *room = linphone_core_get_chat_room_from_uri(
                                                                  LC, ((NSString *)callno).UTF8String);
    if (!room) {
        [PhoneMainView.instance popCurrentView];
        UIAlertController *errView = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Invalid address", nil)
                                                                         message:NSLocalizedString(@"Please specify the entire SIP address for the chat",
                                                                                                   nil)
                                                                  preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK"
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [errView addAction:defaultAction];
        [self presentViewController:errView animated:YES completion:nil];
    } else {
        ChatConversationView *view = VIEW(ChatConversationView);
        [view setChatRoom:room];
        // [PhoneMainView.instance popCurrentView];
        [PhoneMainView.instance changeCurrentView:view.compositeViewDescription];
        // refresh list of chatrooms if we are using fragment
        if (IPAD) {
            ChatsListView *listView = VIEW(ChatsListView);
            [listView.tableController loadData];
        }
    }
}
-(void)showhidecallview
{
    if ([[self getcounterofshow] count]) {
        _btnchat.hidden=NO;
        _btncall.hidden=NO;
        _btnvideo.hidden=NO;
        _btninvite.hidden=YES;
        _videoAudioCallBtnBGView.hidden=NO;
        _audioVideoLblView.hidden=NO;
    }
    else
    {
        _btnvideo.hidden=YES;
        _btnchat.hidden=YES;
        _btncall.hidden=YES;
        _btninvite.hidden=NO;
        _videoAudioCallBtnBGView.hidden=YES;
        _audioVideoLblView.hidden=YES;
    }
    
}


/*----------for three call----------*/

-(void)getloadcall
{
    NSError *error;
    NSArray *pathsofplistlocal = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //1
    NSString *documentsDirectorylocal = [pathsofplistlocal objectAtIndex:0]; //2
    pathfornetwork = [documentsDirectorylocal stringByAppendingPathComponent:@"network_update.plist"]; //3
    // NSLog(@"%@",path);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath: pathfornetwork]) //4
    {
        NSString *bundle = [[NSBundle mainBundle] pathForResource:@"network_update" ofType:@"plist"]; //5
        
        [fileManager copyItemAtPath:bundle toPath: pathfornetwork error:&error]; //6
    }
    
    
    datafornetwork = [[NSMutableDictionary alloc] initWithContentsOfFile: pathfornetwork];
}

/*---------several condition--------*/
-(void)generateviaindexpath:(NSString*)phonenumber
{
    //[self checkavailablenetwork];
    [self chkforavlsim];
    
    Raza_calltype_class *clkclass=[[Raza_calltype_class alloc]init];
    NSString *strreturntype=[clkclass passaccordingnetwork:datafornetwork networktype:chkforsimcard chkforsimvle:checkfor_availablenetwork];
    NSLog(@"detaillist%@",strreturntype);
    if ([strreturntype isEqual:@"callRazaout"])
    {
        [self callMadeViaVOIPfromImage:phonenumber];
    }
    else if([strreturntype isEqual:@"callMadeViaCarrier"])
    {
        [self callMadeViaCarrierrazaout:phonenumber];
    }
    else if([strreturntype isEqual:@"showalertofsimcard"])
    {
        [self showalertofsimcard];
        
    }
    else
    {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Warning!"
                                                          message:@"please select atlease single carrier from setting"
                                                         delegate:self
                                                cancelButtonTitle:nil
                                                otherButtonTitles:@"ok",nil];
        
        [message show];
    }
}
-(void)chkforavlsim
{
    CTTelephonyNetworkInfo* info = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier* carrier = info.subscriberCellularProvider;
    
    if(carrier.mobileNetworkCode == nil || [carrier.mobileNetworkCode isEqualToString:@""])
    {
        chkforsimcard=@"not found";
    }
}
-(void)showalertofsimcard
{
    
    if ([chkforsimcard isEqual:@"not found"])
    {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Warning!"
                                                          message:@"No sim card detected"
                                                         delegate:self
                                                cancelButtonTitle:nil
                                                otherButtonTitles:@"ok",nil];
        
        [message show];
    }
    else
    {
        
        //        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Warning!"
        //                                                          message:@"No network carrier"
        //                                                         delegate:self
        //                                                cancelButtonTitle:nil
        //                                                otherButtonTitles:@"ok",nil];
        //
        //        [message show];
        NSString *str2;
        if ([checkfor_availablenetwork isEqual:@"3"])
        {
            str2=@"Wi-Fi not available.Please turn it on from your phone’s settings";
        }
        else if([checkfor_availablenetwork isEqual:@"1"])
        {
            str2=@"Please turn off Wi-Fi to be able to make a call using your data plan";
        }
        else
            str2=@"No Network";
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Warning!"
                                                          message:[NSString stringWithFormat:@"%@",str2]
                                                         delegate:self
                                                cancelButtonTitle:nil
                                                otherButtonTitles:@"ok",nil];
        
        [message show];
        
    }
}
-(void)callMadeViaVOIPfromImage: (NSString*)phonenumber {
    
    RazaTempratureObject *baseobj=[[RazaTempratureObject alloc]init];
    [baseobj checkvalforTemp:phonenumber callback:^(NSDictionary *result) {
        
        [Razauser SharedInstance].tempdict=result;
        NSLog(@"%@", [Razauser SharedInstance].tempdict);
        
        userMode=@"Raza out";
        //[self makeAudioCallWithRemoteParty:selectedCallNumber andSipStack:[mSipService getSipStack]];
        
        LinphoneAddress *addr = [LinphoneUtils normalizeSipOrPhoneAddress:phonenumber];
        [LinphoneManager.instance call:addr andmodeVideoAudio:FALSE];
        if (addr)
            linphone_address_destroy(addr);
        
    }];
    
    
}
-(void)callMadeViaCarrierrazaout: (NSString*)phonenumber {
    
    /*============I Made======*/
    //    NSLog(@"tag number is = %d",[sender tag]);
    //
    //    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[sender tag] inSection:0];
    //    //  UITableViewCell *cell = [tblView cellForRowAtIndexPath:indexPath];
    //
    //    phoneno = ((NgnPhoneNumber*)[self.contact.phoneNumbers objectAtIndex:indexPath.row]).number;
    /*===================*/
    
    // to make a call, the accessnumber is required.
    // request to get the access number, if the local access number is nil.
    
    // NSIndexPath *indexPath = myindex;
    [[Razauser SharedInstance]ShowWaiting:nil];
    NSString *phoneno=phonenumber;
    phonenumbercalled=phonenumber;
    NSString *localSetAccessNumber = [RAZA_USERDEFAULTS objectForKey:@"accessnumber"];
    
    if (!localSetAccessNumber || IS_EMPTY(localSetAccessNumber)) {
        
        [[Razauser SharedInstance]HideWaiting];
        [RAZA_APPDELEGATE showAlertWithMessage:ERROR_NO_ACCESS_NUMBER_TO_DIAL withTitle:@"Access number!" withCancelTitle:@"Ok"];
    }
    else {
        
        [self sendDestination:phoneno withAccessNumber:localSetAccessNumber];
    }
    
}
-(void)sendDestination:(NSString*)number withAccessNumber:(NSString *)accessnumber {
    
    number = [number stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSString *userpin = [[RAZA_USERDEFAULTS objectForKey:@"logininfo"] objectForKey:LOGIN_RESPONSE_PIN];
    
    BOOL network = [RAZA_APPDELEGATE checkNetworkPriorRequest];
    
    if (network) {
        
        if (userpin && [userpin length]) {
            //addCallToDatabase
            [[Razauser SharedInstance]addCallToDatabase:@"OUTGOING" andsender:number];
            [[RazaServiceManager sharedInstance] requestToSetDestinationWithPin:userpin withAccessNo:accessnumber withPhoneNo:number withDelegate:self];
            
        } else {
            [[Razauser SharedInstance]HideWaiting];
            [RAZA_APPDELEGATE showAlertWithMessage:ERROR_NO_USER_PIN withTitle:@"" withCancelTitle:@"Ok"];
        }
        
    } else {
        [[Razauser SharedInstance]HideWaiting];
        [RAZA_APPDELEGATE showAlertWithMessage:NETWORK_UNAVAILABLE withTitle:@"" withCancelTitle:@"Dismiss"];
    }
    
}
-(void)receivedDataFromService:(NSDictionary *)info withResponseType:(NSString *)responseType {
    
    if( ([[info objectForKey:@"status"] isEqualToString:@"1"]) && ([[info objectForKey:@"accessno"] length]) ) {
        
        NSString *accessnumber = [info objectForKey:@"accessno"];
        
        if (!accessnumber ||
            [accessnumber isEqualToString:@"null"] ||
            IS_EMPTY(accessnumber)) {
            [[Razauser SharedInstance]HideWaiting];
            //[RAZA_APPDELEGATE showMessage:ERROR_NO_ACCESS_NUMBER withMode:MBProgressHUDModeText withDelay:2 withShortMessage:NO];
            //            [RAZA_APPDELEGATE showAlertWithMessage:ERROR_NO_ACCESS_NUMBER_TO_DIAL withTitle:alertTitle withCancelTitle:@"Ok"];
        }
        else {
            [[Razauser SharedInstance]HideWaiting];
            DialerView *avc = [[DialerView alloc]init];
            [avc buildContactDetails:accessnumber];
            
            if ([[Razauser SharedInstance]chkforsimGlobal]) {
                if (!(phonenumbercalled.length>10)) {
                    [Razauser SharedInstance].modeofview=@"no";
                    NSString *test =[@"tel:" stringByAppendingString:accessnumber];//[@"tel:" stringByAppendingString:[NSString stringWithFormat:@"001%@",accessnumber]];//[@"tel:" stringByAppendingString:accessnumber];
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:test]];
                }
                else
                    [self showTempratureoutgoingcall:phonenumbercalled andaccessnumber:accessnumber];
            }
            else
                [RAZA_APPDELEGATE showAlertWithMessage:REQUEST_WITHOUT_SIM withTitle:nil
                                       withCancelTitle:@"Ok"];
            
            
        }
    }
    else {
        
        //        RazaSqlQuery *sqlQuery = [[RazaSqlQuery alloc]init];
        //
        //        NSDictionary *callInfo = [self getCurrentDateTimeWithPhoneInfo];
        //
        //        [sqlQuery deleteRecentCallRecordWithDate:[callInfo objectForKey:@"date"] withPhoneNo:[callInfo objectForKey:@"phoneno"] withDelegate:nil];
        [[Razauser SharedInstance]HideWaiting];
        [RAZA_APPDELEGATE showAlertWithMessage:[info objectForKey:@"error"] withTitle:@"Error!" withCancelTitle:@"Ok"];
    }
    
}
- (void)makeacallparamContactdetail:(NSString *)notif
{
    [self generateviaindexpath:notif];
}
//- (void)makeacallparamContactdetail:(NSNotification *)notif
//{
//    [self generateviaindexpath:notif.object];
//}
-(void)checkavailablenetwork{
    
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    
    NetworkStatus status = [reachability currentReachabilityStatus];
    
    if(status == NotReachable)
    {
        //No internet
        checkfor_availablenetwork=@"4";
    }
    else if (status == ReachableViaWiFi)
    {
        checkfor_availablenetwork=@"0";
    }
    else if (status == ReachableViaWWAN)
    {
        checkfor_availablenetwork=@"2";
    }
}
/*normal delegate*------*/
-(void)callMadeViaCarrier
{
    
}

-(void)callMadeViaVOIP
{
    
}

-(void)callMadeViaCarrierWithParam:(NSString *)remotedestnumber
{
    
}
- (IBAction)btninviteClicked:(id)sender {
    
    if (_contact.phoneNumbers.count) {
        [RAZA_APPDELEGATE hidedurationcalling];
        MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
        if([MFMessageComposeViewController canSendText])
        {
            NSString *num = [[NSUserDefaults standardUserDefaults] stringForKey:@"SBFormattedPhoneNumber"];
            controller.body = @"Hey, I started using RAZA. It's an awesome free app for free phone calls and text messages! https://itunes.apple.com/in/app/razacom/id474407332?mt=8";
            controller.recipients = [NSArray arrayWithObjects:[_contact.phoneNumbers objectAtIndex:0], num, nil];
            controller.messageComposeDelegate = self;
            
            controller.wantsFullScreenLayout = NO;
            [self presentModalViewController:controller animated:YES];
          //  [self presentViewController:controller animated:YES completion:nil];
        }
    }
    else
        [RAZA_APPDELEGATE showAlertWithMessage:@"No contact found!" withTitle:nil withCancelTitle:@"Ok"];
    
}
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [RAZA_APPDELEGATE showdurationcalling];
    switch (result) {
        case MessageComposeResultCancelled:
            NSLog(@"Message was cancelled");
            [self dismissViewControllerAnimated:YES completion:NULL];
            break;
        case MessageComposeResultFailed:
            NSLog(@"Message failed");
            [self dismissViewControllerAnimated:YES completion:NULL];
            break;
        case MessageComposeResultSent:
            NSLog(@"Message was sent");
            [self dismissViewControllerAnimated:YES completion:NULL];
            break;
        default:
            break;
    }
}
-(void)showTempratureoutgoingcall:(NSString*)callingphone andaccessnumber:(NSString*)callingaccessnumber
{
    //SplashVC *view = VIEW(SplashVC);
    //view.obj=obj;
    //[PhoneMainView.instance changeCurrentView:view.compositeViewDescription];
    
    //
    RazaTempratureObject *baseobj=[[RazaTempratureObject alloc]init];
    [baseobj checkvalforTemp:callingphone callback:^(NSDictionary *result) {
        
        [Razauser SharedInstance].tempdict=result;
        NSLog(@"%@", [Razauser SharedInstance].tempdict);
        
        
        CallOutgoingView *view = VIEW(CallOutgoingView);
        
        view.delegateforminuts=self;
        view.phoneNumber=callingphone;//@"+919716432545";//
        view.Accessnumber=callingaccessnumber;
        [PhoneMainView.instance changeCurrentView:view.compositeViewDescription];
        
    }];
    
}
-(void)MinutscallwithDelegateMethod:(NSString *)data
{
    if (data.length) {
        [Razauser SharedInstance].modeofview=@"no";
        NSString *test =[@"tel:" stringByAppendingString:data];//[@"tel:" stringByAppendingString:[NSString stringWithFormat:@"001%@",accessnumber]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:test]];
    }
}
- (IBAction)razaOutBtnAction:(id)sender {
    [Razauser SharedInstance].callModeType=@"RAZA MINUTES CALL";
    NSLog(@"%@",_contact.phoneNumbers);
    if (_contact.phoneNumbers.count==1) {
        [self makeacallparamContactdetail:[_contact.phoneNumbers objectAtIndex:0]];
    }else{
        self.razaOutContactListView.hidden=NO;
        self.razaOutContactListInsiderView.frame=CGRectMake(0, SCREENHIGHT-((_contact.phoneNumbers.count*60)+110), SCREENWIDTH, (_contact.phoneNumbers.count*60)+110);
        [self.tableView reloadData];
    }
//    if (self.tableController.phone.length) {
//        ContactDetailsView *view = VIEW(ContactDetailsView);
//        [view makeacallparamContactdetail:self.tableController.phone];
//    }else{
//        [RAZA_APPDELEGATE showAlertWithMessage:@"Please select phone number" withTitle:@"" withCancelTitle:ERROR_OK];
//
//    }
//    NSLog(@"%@",self.tableController.phone);
}
- (IBAction)closeRazaOutContactListViewAction:(id)sender {
    self.razaOutContactListView.hidden=YES;
}
#pragma mark -
#pragma mark UITableView delegate & datasource methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _contact.phoneNumbers.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 60;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *kCellId = @"UIContactDetailsCell";
    UIContactDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellId];
    if (cell == nil) {
        cell = [[UIContactDetailsCell alloc] initWithIdentifier:kCellId];
    }
    cell.contentView.backgroundColor=cell.defaultView.backgroundColor =  [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    cell.noOfCellCountLbl.text=[NSString stringWithFormat:@"%d",(int)indexPath.row+1];
    cell.indexPath = indexPath;
    [cell hideDeleteButton:NO];
    [cell setAddress:_contact.phoneNumbers[indexPath.row]];

    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.razaOutContactListView.hidden=YES;
    [self makeacallparamContactdetail:[_contact.phoneNumbers objectAtIndex:indexPath.row]];
}

@end
