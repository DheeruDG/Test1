//
//  HistoryDetailsTableViewController.m
//  linphone
//
//  Created by Gautier Pelloux-Prayer on 27/07/15.
//
//

#import "HistoryDetailsTableView.h"
#import "LinphoneManager.h"
#import "Utils.h"
#define SCREENWIDTH  [UIScreen mainScreen].bounds.size.width

@implementation HistoryDetailsTableView

- (void)loadDataForAddress:(const LinphoneAddress *)peer {
	if (callLogs == nil) {
		callLogs = [[NSMutableArray alloc] init];
	} else {
		[callLogs removeAllObjects];
	}

	if (peer) {
//        const bctbx_list_t *logs = linphone_core_get_call_history_for_address(LC, peer);
//        while (logs != NULL) {
//            LinphoneCallLog *log = (LinphoneCallLog *)logs->data;
//            if (linphone_address_weak_equal(linphone_call_log_get_remote_address(log), peer)) {
//                [callLogs addObject:[NSValue valueWithPointer:log]];
//            }
//            logs = bctbx_list_next(logs);
//        }
        [self loadData:peer];
	}
	[[self tableView] reloadData];
}

- (void)loadData:(const LinphoneAddress *)peer {
    //  if (LC) {
    if (LC!=NULL) {
        // [LinphoneManager.instance createLinphoneCore];
        //[LinphoneManager.instance startLinphoneCore];
        
        
        for (id day in self.sections.allKeys) {
            for (id log in self.sections[day]) {
                linphone_call_log_unref([log pointerValue]);
            }
        }
        
        
        const bctbx_list_t *logs = linphone_core_get_call_history_for_address(LC, peer);
        self.sections = [NSMutableDictionary dictionary];
        while (logs != NULL) {
            LinphoneCallLog *log = (LinphoneCallLog *)logs->data;
            if (linphone_address_weak_equal(linphone_call_log_get_remote_address(log), peer)) {
                NSDate *startDate = [self
                                     dateAtBeginningOfDayForDate:[NSDate
                                                                  dateWithTimeIntervalSince1970:linphone_call_log_get_start_date(log)]];
                NSMutableArray *eventsOnThisDay = [self.sections objectForKey:startDate];
                if (eventsOnThisDay == nil) {
                    eventsOnThisDay = [NSMutableArray array];
                    [eventsOnThisDay addObject:[NSValue valueWithPointer:linphone_call_log_ref(log)]];
                    [self.sections setObject:eventsOnThisDay forKey:startDate];
                }else{
                    [eventsOnThisDay addObject:[NSValue valueWithPointer:linphone_call_log_ref(log)]];
                    [self.sections setObject:eventsOnThisDay forKey:startDate];
                }
                
                linphone_call_log_set_user_data(log, NULL);
                
                // if this contact was already the previous entry, do not add it twice
                LinphoneCallLog *prev = [eventsOnThisDay lastObject] ? [[eventsOnThisDay lastObject] pointerValue] : NULL;
                if (prev && linphone_address_weak_equal(linphone_call_log_get_remote_address(prev),
                                                        linphone_call_log_get_remote_address(log))) {
                    bctbx_list_t *list = linphone_call_log_get_user_data(prev);
                    list = bctbx_list_append(list, log);
                    linphone_call_log_set_user_data(prev, list);
                } else {
                    const LinphoneAddress *addr;
                    addr = linphone_call_log_get_to_address(log);
                    char *uri = linphone_address_as_string_uri_only(addr);
                    NSString *str=[NSString stringWithUTF8String:uri];
                    str=[[Razauser SharedInstance]getusername:str];
                    if (![str isEqualToString:RAZAPUSHCALLER]) {
                       // [eventsOnThisDay addObject:[NSValue valueWithPointer:linphone_call_log_ref(log)]];
                    }
                    
                }
            }
            
            logs = bctbx_list_next(logs);
        }
        
        [self computeSections];
        
    }
    
    if (LC==NULL)
        [LinphoneManager.instance createLinphoneCore];
}

- (void)computeSections {
    NSArray *unsortedDays = [self.sections allKeys];
    _sortedDays = [[NSMutableArray alloc]
                   initWithArray:[unsortedDays sortedArrayUsingComparator:^NSComparisonResult(NSDate *d1, NSDate *d2) {
        return [d2 compare:d1]; // reverse order
    }]];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return _sortedDays.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *logs = [_sections objectForKey:_sortedDays[section]];
    return logs.count;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    CGRect frame = CGRectMake(0, 0, tableView.frame.size.width, 35);
    UIView *tempView = [[UIView alloc] initWithFrame:frame];
    tempView.backgroundColor = [UIColor whiteColor];
    
    UILabel *tempLabel = [[UILabel alloc] initWithFrame:frame];
    tempLabel.backgroundColor = [UIColor clearColor];
    tempLabel.alpha=0.3;
    tempLabel.font=[UIFont fontWithName:@"SourceSansPro-Regular" size:12.0f];
    tempLabel.textColor = [UIColor colorWithRed:128/255.0 green:128/255.0 blue:128/255.0  alpha:1];
    NSDate *eventDate = _sortedDays[section];
    NSDate *currentDate = [self dateAtBeginningOfDayForDate:[NSDate date]];
    if ([eventDate isEqualToDate:currentDate]) {
        tempLabel.text = NSLocalizedString(@"TODAY", nil);
    } else if ([eventDate isEqualToDate:[currentDate dateByAddingTimeInterval:-3600 * 24]]) {
        tempLabel.text = NSLocalizedString(@"YESTERDAY", nil);
    } else {
        tempLabel.text = [LinphoneUtils timeToString:eventDate.timeIntervalSince1970 withFormat:LinphoneDateHistoryList]
        .uppercaseString;
    }
    tempLabel.textAlignment = NSTextAlignmentCenter;
    tempLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [tempView addSubview:tempLabel];
    
    return tempView;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *kCellId = @"UITableViewCell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellId];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] init];
	}
    cell.textLabel.font=[UIFont fontWithName:@"SourceSansPro-Regular" size:18];
    id logId = [_sections objectForKey:_sortedDays[indexPath.section]][indexPath.row];
    LinphoneCallLog *log = [logId pointerValue];
  //  LinphoneCallLog *log = [[callLogs objectAtIndex:[indexPath section]] pointerValue];
    //int duration = linphone_call_log_get_duration(log);
    time_t callTime = linphone_call_log_get_start_date(log);
    //cell.textLabel.textAlignment = NSTextAlignmentCenter;
//    [cell.textLabel
//        setText:[NSString stringWithFormat:@"%@ - %@",
//                                           [LinphoneUtils timeToString:callTime withFormat:LinphoneDateHistoryDetails],
//                                           [LinphoneUtils durationToString:duration]]];
    [cell.textLabel
     setText:[NSString stringWithFormat:@"%@%@",
              [[LinphoneUtils timeToString:callTime withFormat:LinphoneDateHistoryDetails] lowercaseString],
              @""]];
    BOOL outgoing = (linphone_call_log_get_dir(log) == LinphoneCallOutgoing);

    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH-50, 15, 20, 20)];
    imageView.backgroundColor = [UIColor clearColor];

    if (linphone_call_log_get_status(log) == LinphoneCallMissed) {
        cell.textLabel.textColor=[UIColor redColor];
        //cell.imageView.image = [UIImage imageNamed:@"Missed Call.png"];
        [imageView setImage:[UIImage imageNamed:@"Missed Call.png"]];
    } else if (outgoing) {
        cell.textLabel.textColor=OxfordBlueColor;
        //cell.imageView.image = [UIImage imageNamed:@"Outgoing Call.png"];
        [imageView setImage:[UIImage imageNamed:@"Outgoing Call.png"]];
    } else {
        cell.textLabel.textColor=OxfordBlueColor;
        //cell.imageView.image = [UIImage imageNamed:@"Incoming Call.png"];
        [imageView setImage:[UIImage imageNamed:@"Incoming Call.png"]];
    }
    [cell.contentView addSubview:imageView];

	return cell;
}

- (NSDate *)dateAtBeginningOfDayForDate:(NSDate *)inputDate {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    [calendar setTimeZone:timeZone];
    NSDateComponents *dateComps =
    [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:inputDate];
    
    dateComps.hour = dateComps.minute = dateComps.second = 0;
    return [calendar dateFromComponents:dateComps];
}

@end
