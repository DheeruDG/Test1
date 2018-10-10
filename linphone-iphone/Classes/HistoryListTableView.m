/* HistoryTableViewController.m
 *
 * Copyright (C) 2009  Belledonne Comunications, Grenoble, France
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

#import "HistoryListTableView.h"
#import "UIHistoryCell.h"
#import "LinphoneManager.h"
#import "PhoneMainView.h"
#import "Utils.h"

@implementation HistoryListTableView

@synthesize missedFilter;

#pragma mark - Lifecycle Functions

- (void)initHistoryTableViewController {
	missedFilter = false;
}

- (id)init {
	self = [super init];
	if (self) {
		[self initHistoryTableViewController];
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
	self = [super initWithCoder:decoder];
	if (self) {
		[self initHistoryTableViewController];
	}
	return self;
}

#pragma mark - ViewController Functions

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[NSNotificationCenter.defaultCenter addObserver:self
										   selector:@selector(loadData)
											   name:kLinphoneAddressBookUpdate
											 object:nil];

	[NSNotificationCenter.defaultCenter addObserver:self
										   selector:@selector(coreUpdateEvent:)
											   name:kLinphoneCoreUpdate
											 object:nil];
	[self loadData];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];

	[NSNotificationCenter.defaultCenter removeObserver:self name:kLinphoneAddressBookUpdate object:nil];

	[NSNotificationCenter.defaultCenter removeObserver:self name:kLinphoneCoreUpdate object:nil];
}

#pragma mark - Event Functions

- (void)coreUpdateEvent:(NSNotification *)notif {
	// Invalid all pointers
	[self loadData];
}

#pragma mark - Property Functions

- (void)setMissedFilter:(BOOL)amissedFilter {
	if (missedFilter == amissedFilter) {
		return;
	}
	missedFilter = amissedFilter;
	[self loadData];
}

#pragma mark - UITableViewDataSource Functions

- (NSDate *)dateAtBeginningOfDayForDate:(NSDate *)inputDate {
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
	[calendar setTimeZone:timeZone];
	NSDateComponents *dateComps =
		[calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:inputDate];

	dateComps.hour = dateComps.minute = dateComps.second = 0;
	return [calendar dateFromComponents:dateComps];
}

- (void)loadData {
  //  if (LC) {
    if (LC!=NULL) {
       // [LinphoneManager.instance createLinphoneCore];
        //[LinphoneManager.instance startLinphoneCore];
    

	for (id day in self.sections.allKeys) {
		for (id log in self.sections[day]) {
			linphone_call_log_unref([log pointerValue]);
		}
	}
    
        
  
	const bctbx_list_t *logs = linphone_core_get_call_logs(LC);
	self.sections = [NSMutableDictionary dictionary];
	while (logs != NULL) {
		LinphoneCallLog *log = (LinphoneCallLog *)logs->data;
		if (!missedFilter || linphone_call_log_get_status(log) == LinphoneCallMissed) {
			NSDate *startDate = [self
				dateAtBeginningOfDayForDate:[NSDate
												dateWithTimeIntervalSince1970:linphone_call_log_get_start_date(log)]];
			NSMutableArray *eventsOnThisDay = [self.sections objectForKey:startDate];
			if (eventsOnThisDay == nil) {
				eventsOnThisDay = [NSMutableArray array];
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
                    [eventsOnThisDay addObject:[NSValue valueWithPointer:linphone_call_log_ref(log)]];
                }
				
			}
		}
		logs = bctbx_list_next(logs);
	}

	[self computeSections];

	[super loadData];

	if (IPAD) {
		if (![self selectFirstRow]) {
			HistoryDetailsView *view = VIEW(HistoryDetailsView);
			[view setCallLogId:nil];
		}
	}
          }
    
    if (LC==NULL)
       [LinphoneManager.instance createLinphoneCore];
       // [LinphoneManager.instance startLinphoneCore];
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
	static NSString *kCellId = @"UIHistoryCell";
	UIHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellId];
	if (cell == nil) {
		cell = [[UIHistoryCell alloc] initWithIdentifier:kCellId];
	}
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

	id logId = [_sections objectForKey:_sortedDays[indexPath.section]][indexPath.row];
	LinphoneCallLog *log = [logId pointerValue];
   // [self setrazauserimage:log andcell:cell];
	[cell setCallLog:log];
	[super accessoryForCell:cell atPath:indexPath];
	return cell;
}

#pragma mark - UITableViewDelegate Functions

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[super tableView:tableView didSelectRowAtIndexPath:indexPath];
	if (![self isEditing]) {
		id log = [_sections objectForKey:_sortedDays[indexPath.section]][indexPath.row];
		LinphoneCallLog *callLog = [log pointerValue];
		if (callLog != NULL && linphone_call_log_get_call_id(callLog) != NULL) {
			if (IPAD) {
				UIHistoryCell *cell = (UIHistoryCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
				[cell onDetails:self];
			} else {
				LinphoneAddress *addr = linphone_call_log_get_remote_address(callLog);
                
                NSDictionary *dict=[[Razauser SharedInstance]getRazauserORnotWithPhonenumber:addr];
//                BOOL isuser=[[dict objectForKey:@"RAZAUSER"]boolValue];
//              /*  LinphoneAddress *isuser2=nil;
//                NSData *newData = [dict objectForKey:@"RAZAADDRESS"];
//                [newData getBytes:&isuser2];
//                */
//                
//                if (isuser) {
                
                 HistoryListView *view = VIEW(HistoryListView);
                [view makeacallparamhistorytest:dict];
                  //  [[NSNotificationCenter defaultCenter] postNotificationName:@"makeacallviaRazaouthistoryparam" object:dict];
                //[[NSNotificationCenter defaultCenter] removeObserver:@"makeacallviaRazaouthistoryparam"];
                   // [self makeCall];
                   // [LinphoneManager.instance call:addr];
                //}
                //else
                   // NSLog(@"no raza");
			}
		}
	}
}

- (void)tableView:(UITableView *)tableView
	commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
	 forRowAtIndexPath:(NSIndexPath *)indexPath {
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		[tableView beginUpdates];
		id log = [_sections objectForKey:_sortedDays[indexPath.section]][indexPath.row];
		LinphoneCallLog *callLog = [log pointerValue];
		MSList *count = linphone_call_log_get_user_data(callLog);
		while (count) {
			linphone_core_remove_call_log(LC, count->data);
			count = count->next;
		}
		linphone_core_remove_call_log(LC, callLog);
		linphone_call_log_unref(callLog);
		[[_sections objectForKey:_sortedDays[indexPath.section]] removeObject:log];
		if (((NSArray *)[_sections objectForKey:_sortedDays[indexPath.section]]).count == 0) {
			[_sections removeObjectForKey:_sortedDays[indexPath.section]];
			[_sortedDays removeObjectAtIndex:indexPath.section];
			[tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section]
					 withRowAnimation:UITableViewRowAnimationFade];
		}

		[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
						 withRowAnimation:UITableViewRowAnimationFade];
		[tableView endUpdates];
        [tableView reloadData];

	}
}

- (void)removeSelectionUsing:(void (^)(NSIndexPath *))remover {
	[super removeSelectionUsing:^(NSIndexPath *indexPath) {
	  id log = [_sections objectForKey:_sortedDays[indexPath.section]][indexPath.row];
	  LinphoneCallLog *callLog = [log pointerValue];
	  MSList *count = linphone_call_log_get_user_data(callLog);
	  while (count) {
		  linphone_core_remove_call_log(LC, count->data);
		  count = count->next;
	  }
	  linphone_core_remove_call_log(LC, callLog);
	  linphone_call_log_unref(callLog);
	  [[_sections objectForKey:_sortedDays[indexPath.section]] removeObject:log];
	  if (((NSArray *)[_sections objectForKey:_sortedDays[indexPath.section]]).count == 0) {
		  [_sections removeObjectForKey:_sortedDays[indexPath.section]];
		  [_sortedDays removeObjectAtIndex:indexPath.section];
	  }
	}];
}
/*----------condition for raza  user---------------*/

-(void)setrazauserimage:(LinphoneCallLog*)addr2 andcell:(UIHistoryCell*)cellinfo
{
 const LinphoneAddress *addr1 = NULL;
  
        addr1 = linphone_call_log_get_to_address(addr2);
  
    
    char *uri = linphone_address_as_string_uri_only(addr1);
    NSString *str=[NSString stringWithUTF8String:uri];
    
    str=[[Razauser SharedInstance]getusername:str];
    NSLog(@"%@",str);
//    BOOL contactfound=NO;
//    NSString *userphone;
//    for (NSString *phonenumber in razacontact.phoneNumbers) {
//        NSString *numberKey = [RazaHelper getValidPhoneNumberWithString:phonenumber];
//        if ([[[Razauser SharedInstance]getRazauser] containsObject:numberKey]) {
//            contactfound=YES;
//            userphone=numberKey;
//            break;
//        }
//    }
//    
//    if (contactfound) {
//        
    
        // char *cr_from_string1 = linphone_address_as_string_uri_only(imageadd);
        //  NSString *str=[NSString stringWithUTF8String:cr_from_string1];
        //  NSString *phone=[[Razauser SharedInstance]getusername:userphone];
        
        NSURL *urluser=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@.png",RAZA_PROFILE,str]];
        [[Razauser SharedInstance] downloadImageWithURL:urluser completionBlock:^(BOOL succeeded, UIImage *image) {
            if (image)
            {
                NSData *imageData =[[Razauser SharedInstance] compressImage:image];
                UIImage *img=[UIImage imageWithData:imageData];
                [cellinfo.avatarImage setImage:img bordered:NO withRoundedRadius:YES];
               // [self setAvatarforraza:img andcontact:razacontact];
                //  cellinfo.image=image;
            }
//            else
//                //[cellinfo setImage:[FastAddressBook imageForAddress:razacontact thumbnail:YES] bordered:NO withRoundedRadius:YES];
//            {
//                UIImage *image = [FastAddressBook imageForContact:razacontact thumbnail:true];
//                [cellinfo.avatarImage setImage:image bordered:NO withRoundedRadius:YES];
//                
//            }
            
        }];
//    }
//    else
//    {
//        UIImage *image = [FastAddressBook imageForContact:razacontact thumbnail:true];
//        [cellinfo.avatarImage setImage:image bordered:NO withRoundedRadius:YES];
//    }
}

- (void)setAvatarforraza:(UIImage *)avatar andcontact:(Contact*)person {
    
    CFErrorRef error = NULL;
    if (!ABPersonRemoveImageData(person.person, &error)) {
        LOGW(@"Can't remove entry: %@", [(__bridge NSError *)error localizedDescription]);
    }
    NSData *dataRef = UIImageJPEGRepresentation(avatar, 0.9f);
    CFDataRef cfdata = CFDataCreate(NULL, [dataRef bytes], [dataRef length]);
    
    if (!ABPersonSetImageData(person.person, cfdata, &error)) {
        LOGW(@"Can't add entry: %@", [(__bridge NSError *)error localizedDescription]);
    }
    
    CFRelease(cfdata);
    
}

@end
