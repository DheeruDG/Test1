/* ContactDetailsViewController.h
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

#import <UIKit/UIKit.h>

#import "UICompositeView.h"
#import "UIToggleButton.h"
#import "ContactDetailsTableView.h"
#import "UIRoundedImageView.h"
#import "ImagePickerView.h"
/*-------razaout framework------*/
#import<CoreTelephony/CTCallCenter.h>
#import<CoreTelephony/CTCall.h>
#import<CoreTelephony/CTCarrier.h>
#import<CoreTelephony/CTTelephonyNetworkInfo.h>
#import "Raza_calltype_class.h"
#import "LinphoneAppDelegate.h"
#import "CallOutgoingView.h"
/*--------end---------*/
#define kTagActionSheetTextMessage				1
#define kTagActionSheetVideoCall				2
#define kTagActionSheetAddToFavorites			3
#define kTagActionSheetChooseFavoriteMediaType	4
#define kTagActionSheetAudioCall				5
@interface ContactDetailsView : TPMultiLayoutViewController <UICompositeViewDelegate, ImagePickerDelegate,UIActionSheetDelegate,RazaHelperDelegate, ServiceManagerDelegate,MFMessageComposeViewControllerDelegate,MinutscallwithDelegate,UITableViewDelegate,UITableViewDataSource> {
	BOOL inhibUpdate;
    NSMutableArray *arrofphonetomultipleuser;
    
    /*---------razaout -------*/
    NSString *pathfornetwork ;
    NSString *chkforsimcard ;
    NSMutableDictionary *datafornetwork ;
    NSString *phonenumbercalled;
}

@property(nonatomic, assign, setter=setContact:) Contact *contact;
@property(nonatomic) Contact *tmpContact;
@property(nonatomic, strong) IBOutlet ContactDetailsTableView *tableController;
@property(nonatomic, strong) IBOutlet UIToggleButton *editButton;
@property(nonatomic, strong) IBOutlet UIButton *backButton;
@property(nonatomic, strong) IBOutlet UIButton *cancelButton;
@property(weak, nonatomic) IBOutlet UIRoundedImageView *avatarImage;
@property(weak, nonatomic) IBOutlet UILabel *nameLabel;
@property(weak, nonatomic) IBOutlet UIToggleButton *deleteButton;
@property(weak, nonatomic) IBOutlet UIScrollView *contentView;
@property(weak, nonatomic) IBOutlet UILabel *emptyLabel;
@property BOOL isAdding;

- (IBAction)onBackClick:(id)event;
- (IBAction)onCancelClick:(id)event;
- (IBAction)onEditClick:(id)event;
- (IBAction)onDeleteClick:(id)sender;
- (IBAction)onAvatarClick:(id)sender;

- (void)newContact;
- (void)newContact:(NSString *)address;
- (void)editContact:(Contact *)contact;
- (void)editContact:(Contact *)contact address:(NSString *)address;
@property (weak, nonatomic) IBOutlet UIView *headerView;
- (void)setContact:(Contact *)contact;
@property (weak, nonatomic) IBOutlet UIView *viewcall;
- (IBAction)btnchatClicked:(id)sender;
- (IBAction)btncallclicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnchat;
@property (weak, nonatomic) IBOutlet UIButton *btncall;
@property (weak, nonatomic) IBOutlet UIButton *btninvite;
- (IBAction)btninviteClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnvideo;
- (IBAction)btnvideoclicked:(id)sender;
- (void)makeacallparamContactdetail:(NSString *)notif;
@property (weak, nonatomic) IBOutlet UIView *topHeaderView;
@property (weak, nonatomic) IBOutlet UIView *videoAudioCallBtnBGView;
@property (weak, nonatomic) IBOutlet UIButton *razaOutBtn;
@property (weak, nonatomic) IBOutlet UIView *razaOutContactListView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *razaOutContactListInsiderView;
@property (weak, nonatomic) IBOutlet UIView *audioVideoLblView;

@end
