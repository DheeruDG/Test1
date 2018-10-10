//
//  Raza_chat_option_ring.h
//  Raza
//
//  Created by umenit on 8/22/15.
//  Copyright (c) 2015 Raza. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "Raza_chat_option_ringcellTableViewCell.h"
#import "globalnetworkclass.h"
#import "UICompositeView.h"
@interface Raza_chat_option_ring : UIViewController<UITableViewDataSource,UITableViewDelegate,UICompositeViewDelegate>
{
    NSMutableArray *arraudio;
    AVAudioPlayer *audioPlayer;
    
    UINib *cellnib;
    UIBarButtonItem *doneButton;
    NSMutableDictionary *dictofchatringtone;
    NSString *dictofchatringtonepath;
    NSString *ringtonetoselect;
    NSString *ringname;
}
@property (strong, nonatomic) IBOutlet UITableView *tbl;
@property (strong,nonatomic) NSString *stringofuser;
- (IBAction)btnBackClicked:(id)sender;
- (IBAction)btndoneclicked:(id)sender;

@end
