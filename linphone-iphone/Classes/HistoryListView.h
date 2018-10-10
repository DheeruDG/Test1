/* HistoryViewController.h
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
#import "HistoryListTableView.h"
#import "UIToggleButton.h"
#import "globalnetworkclass.h"
#import "CallOutgoingView.h"
@interface HistoryListView : UIViewController <UICompositeViewDelegate,RazaHelperDelegate,ServiceManagerDelegate,MinutscallwithDelegate> {
    
    /*--------raza-------*/
    NSString *chkforsimcard;
    UIView *actionsheet;
   
    NSMutableDictionary *datafornetwork ;
    UIView *backview;
        NSString *pathfornetwork ;
    globalnetworkclass *CHECKGLOBALNETWORK;
    /*----------*/
    NSString *callingphone;
    LinphoneAddress *Calledaddess;
}
@property(weak, nonatomic) IBOutlet UIBouncingView *unreadCountView;
@property (weak, nonatomic) IBOutlet UILabel *lblcounterchat;

@property(nonatomic, strong) IBOutlet HistoryListTableView *tableController;

@property(nonatomic, strong) IBOutlet UIButton *allButton;
@property(nonatomic, strong) IBOutlet UIButton *missedButton;
@property(weak, nonatomic) IBOutlet UIImageView *selectedButtonImage;

- (IBAction)onAllClick:(id)event;
- (IBAction)onMissedClick:(id)event;
- (IBAction)onDeleteClick:(id)event;
- (IBAction)segmentSwitchAction:(id)sender;
- (IBAction)onEditionChangeClick:(id)sender;
- (IBAction)btnbackClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *dialPadBtn;
- (void)makeacallparamhistorytest:(NSDictionary *)notif;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@end
