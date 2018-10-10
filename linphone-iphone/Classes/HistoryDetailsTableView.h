//
//  HistoryDetailsTableViewController.h
//  linphone
//
//  Created by Gautier Pelloux-Prayer on 27/07/15.
//
//

#import <UIKit/UIKit.h>

#import "linphone/linphonecore.h"

@interface HistoryDetailsTableView : UITableViewController {
  @private
	NSMutableArray *callLogs;
}
- (void)loadDataForAddress:(const LinphoneAddress *)peer;
@property(strong, nonatomic) NSMutableDictionary *sections;
@property(strong, nonatomic) NSMutableArray *sortedDays;

@end
