//
//  SideMenuTableViewController.h
//  linphone
//
//  Created by Gautier Pelloux-Prayer on 28/07/15.
//
//

#import <UIKit/UIKit.h>
#import "RazaSidebarTableViewCell.h"
// the block to execute when an entry tapped
typedef void (^SideMenuEntryBlock)(void);

@interface SideMenuEntry : NSObject {
  
  @public
	NSString *title;
	SideMenuEntryBlock onTapBlock;
    
};
@end

@interface SideMenuTableView : UITableViewController

@property (strong,nonatomic) NSMutableArray *sidebarimagename;
@property(nonatomic, retain) NSMutableArray *sideMenuEntries;

@end
