/* UIChatRoomCell.m
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
 *  GNU Library General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
 */

#import "UIChatBubbleTextCell.h"
#import "LinphoneManager.h"
#import "PhoneMainView.h"

#import <AssetsLibrary/ALAsset.h>
#import <AssetsLibrary/ALAssetRepresentation.h>

@implementation UIChatBubbleTextCell

#pragma mark - Lifecycle Functions

- (id)initWithIdentifier:(NSString *)identifier {
    if ((self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier]) != nil) {
        if ([identifier isEqualToString:NSStringFromClass(self.class)]) {
            NSArray *arrayOfViews =
            [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self.class) owner:self options:nil];
            // resize cell to match .nib size. It is needed when resized the cell to
            // correctly adapt its height too
            UIView *sub = ((UIView *)[arrayOfViews objectAtIndex:arrayOfViews.count - 1]);
            [self setFrame:CGRectMake(0, 0, sub.frame.size.width, sub.frame.size.height)];
            [self addSubview:sub];
        }
    }
    return self;
}

- (void)dealloc {
    [self setChatMessage:NULL and:NULL];
}

#pragma mark -

- (void)setChatMessage:(LinphoneChatMessage *)amessage and:(MSList*)mm {
    if (amessage == _message) {
        return;
    }
    messagelistout=mm;
    if (_message) {
        linphone_chat_message_unref(_message);
        CFBridgingRelease(linphone_chat_message_get_user_data(_message));
        linphone_chat_message_set_user_data(_message, NULL);
        linphone_chat_message_cbs_set_msg_state_changed(linphone_chat_message_get_callbacks(_message), NULL);
    }
    
    _message = amessage;
    if (amessage) {
        linphone_chat_message_ref(_message);
        linphone_chat_message_set_user_data(_message, (void *)CFBridgingRetain(self));
        linphone_chat_message_cbs_set_msg_state_changed(linphone_chat_message_get_callbacks(_message), message_status);
    }
}

+ (NSString *)TextMessageForChat:(LinphoneChatMessage *)message {
    const char *url = linphone_chat_message_get_external_body_url(message);
    const LinphoneContent *last_content = linphone_chat_message_get_file_transfer_information(message);
    // Last message was a file transfer (image) so display a picture...
    if (url || last_content) {
        return @"🗻";
    } else {
        const char *text = linphone_chat_message_get_text(message) ?: "";
        return [NSString stringWithUTF8String:text] ?: [NSString stringWithCString:text encoding:NSASCIIStringEncoding]
        ?: NSLocalizedString(@"(invalid string)", nil);
    }
}

+ (NSString *)ContactDateForChat:(LinphoneChatMessage *)message {
    /*return [NSString
     stringWithFormat:@"%@ - %@", [LinphoneUtils timeToString:linphone_chat_message_get_time(message)
     withFormat:LinphoneDateChatBubble],
     [FastAddressBook displayNameForAddress:linphone_chat_message_get_from_address(message)]];*/
    /* return [NSString
     stringWithFormat:@"%@",
     [FastAddressBook displayNameForAddress:linphone_chat_message_get_from_address(message)]];*/
    return nil;
}
+ (NSString *)ContactorgDateForChat:(LinphoneChatMessage *)message {
    return [NSString
            stringWithFormat:@"%@", [LinphoneUtils timeToString:linphone_chat_message_get_time(message)
                                                     withFormat:LinphoneDateChatBubble]];
    /*return [NSString
     stringWithFormat:@"%@",
     [FastAddressBook displayNameForAddress:linphone_chat_message_get_from_address(message)]];*/
}
- (NSString *)textMessage {
    return [self.class TextMessageForChat:_message];
}

- (void)update {
    if (_message == nil) {
        LOGW(@"Cannot update message room cell: null message");
        return;
    }
     BOOL outgoing = linphone_chat_message_is_outgoing(_message);
    UIColor *colorMsg=[UIColor darkGrayColor];
    if (outgoing) {
        colorMsg=[UIColor colorWithRed:11/255.0 green:32/255.0 blue:62/255.0  alpha:1];
        //_backgroundColorImage.backgroundColor=[UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0  alpha:1];
        _backgroundColorImage.layer.borderWidth=2.0;
        _backgroundColorImage.layer.borderColor=[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0  alpha:1].CGColor;
    } else {
        colorMsg=[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0  alpha:1];
        _backgroundColorImage.layer.borderWidth=0.0;
       // _backgroundColorImage.backgroundColor=[UIColor colorWithRed:233/255.0 green:246/255.0 blue:255/255.0  alpha:1];
    }
    
    _statusInProgressSpinner.accessibilityLabel = @"Delivery in progress";
    
    if (_messageText) {
        [_messageText setHidden:FALSE];
        /* We need to use an attributed string here so that data detector don't mess
         * with the text style. See http://stackoverflow.com/a/20669356 */
       
        NSAttributedString *attr_text =
        [[NSAttributedString alloc] initWithString:self.textMessage
                                        attributes:@{
                                                     NSFontAttributeName : _messageText.font,
                                                     NSForegroundColorAttributeName : colorMsg
                                                     }];
        _messageText.attributedText = attr_text;
    }
    
    LinphoneChatMessageState state = linphone_chat_message_get_state(_message);
   
    NSString *ss=   [FastAddressBook displayNameForAddress:linphone_chat_message_get_from_address(_message)];
    NSString *uppercase;
    UIImage *imgplot;
    if (ss.length) {
        uppercase =[[[ss substringToIndex:1] uppercaseString] stringByAppendingString:@".png"];
    }
    if ([uppercase isEqualToString:@"1.png"]||!(uppercase.length))
    {
        uppercase=nil;
    }
    imgplot=[UIImage imageNamed:uppercase];
    NSLog(@"%@--%@",ss,uppercase);
    if (outgoing) {
        if (imgplot)
            _avatarImage.image =imgplot;// [UIImage imageNamed:uppercase];//[LinphoneUtils selfAvatar];
        else
            _avatarImage.image = [LinphoneUtils selfAvatar];
        
        
    } else {
        if (imgplot)
            _avatarImage.image=imgplot;//[UIImage imageNamed:uppercase];
        else
            [_avatarImage setImage:[FastAddressBook imageForAddress:linphone_chat_message_get_peer_address(_message)
                                                          thumbnail:YES]
                          bordered:NO
                 withRoundedRadius:YES];
    }
    _contactDateLabel.text = [self.class ContactDateForChat:_message];
    _lblmsgdate.text = [self.class ContactorgDateForChat:_message];
    
    //       NSTimeInterval comparetime=[[RazaNotificationObject SharedInstance]compareTimeSlot:[pushdict objectForKey:@"pushtime"]];
    //    if(comparetime<=20||comparetime==NAN||isnan(comparetime))
    //    {
    //    }
    
   _backgroundColorImage.image = _bottomBarColor.image =[UIImage imageNamed:(outgoing ? @"color_G.png" : @"color_A.png")];
    //_contactDateLabel.textColor = [UIColor colorWithPatternImage:_backgroundColorImage.image];
    
    if (outgoing && state == LinphoneChatMessageStateInProgress) {
        _statusErrorImage.hidden = YES;
        [_statusInProgressSpinner startAnimating];
    }
    else if (outgoing &&
             (state == LinphoneChatMessageStateNotDelivered || state == LinphoneChatMessageStateFileTransferError)) {
        _statusErrorImage.hidden = YES;//TODO:UMENIT Before it was No
        [_statusInProgressSpinner stopAnimating];
        
        //		NSAttributedString *resend_text =
        //			[[NSAttributedString alloc] initWithString:NSLocalizedString(@"Resend", @"Resend")
        //											attributes:@{NSForegroundColorAttributeName : [UIColor redColor]}];
        //[_contactDateLabel setAttributedText:resend_text];//TODO:UMENIT Before it was open
        
        
    } else if (!outgoing && state == LinphoneChatMessageStateFileTransferError) {
        _statusErrorImage.hidden = YES;//TODO:UMENIT Before it was No
        [_statusInProgressSpinner stopAnimating];
    } else {
        _statusErrorImage.hidden = YES;
        [_statusInProgressSpinner stopAnimating];
    }
    
    if (outgoing) {
        [_messageText setAccessibilityLabel:@"Outgoing message"];
    } else {
        [_messageText setAccessibilityLabel:@"Incoming message"];
    }
}

- (void)setEditing:(BOOL)editing {
    [self setEditing:editing animated:FALSE];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    _messageText.userInteractionEnabled = !editing;
    _resendRecognizer.enabled = !editing;
}

#pragma mark - Action Functions

- (IBAction)onDeleteClick:(id)event {
    if (_message != NULL) {
        UITableView *tableView = VIEW(ChatConversationView).tableController.tableView;
        NSIndexPath *indexPath = [tableView indexPathForCell:self];
        [tableView.dataSource tableView:tableView
                     commitEditingStyle:UITableViewCellEditingStyleDelete
                      forRowAtIndexPath:indexPath];
    }
}
- (IBAction)onDeleteClickout:(NSIndexPath*)event {
    if (_message != NULL) {
        UITableView *tableView = VIEW(ChatConversationView).tableController.tableView;
        NSIndexPath *indexPath = event;//[tableView indexPathForCell:self];
        [tableView.dataSource tableView:tableView
                     commitEditingStyle:UITableViewCellEditingStyleDelete
                      forRowAtIndexPath:indexPath];
    }
}
- (IBAction)onResendClick:(id)event {
    //	if (_message == nil || !linphone_chat_message_is_outgoing(_message))
    //		return;
    //
    //	LinphoneChatMessageState state = linphone_chat_message_get_state(_message);
    //	if (state == LinphoneChatMessageStateNotDelivered || state == LinphoneChatMessageStateFileTransferError) {
    //		if (linphone_chat_message_get_file_transfer_information(_message) != NULL) {
    //			NSString *localImage = [LinphoneManager getMessageAppDataForKey:@"localimage" inMessage:_message];
    //			NSURL *imageUrl = [NSURL URLWithString:localImage];
    //
    //			[self onDeleteClick:nil];
    //
    //			[LinphoneManager.instance.photoLibrary assetForURL:imageUrl
    //				resultBlock:^(ALAsset *asset) {
    //				  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, (unsigned long)NULL),
    //								 ^(void) {
    //								   UIImage *image = [[UIImage alloc] initWithCGImage:[asset thumbnail]];
    //								   [_chatRoomDelegate startImageUpload:image url:imageUrl];
    //								 });
    //				}
    //				failureBlock:^(NSError *error) {
    //				  LOGE(@"Can't read image");
    //				}];
    //		} else {
    //			[self onDeleteClick:nil];
    //
    //			double delayInSeconds = 0.4;
    //			dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    //			dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
    //			  [_chatRoomDelegate resendChat:self.textMessage withExternalUrl:nil];
    //			});
    //		}
    //	}
}
#pragma mark - State changed handling
static void message_status(LinphoneChatMessage *msg, LinphoneChatMessageState state) {
    LOGI(@"State for message [%p] changed to %s", msg, linphone_chat_message_state_to_string(state));
    ChatConversationView *view = VIEW(ChatConversationView);
    [view.tableController updateChatEntry:msg];
}

#pragma mark - Bubble size computing

+ (CGSize)computeBoundingBox:(NSString *)text size:(CGSize)size font:(UIFont *)font {
    if (!text || text.length == 0)
        return CGSizeMake(0, 0);
    
#pragma deploymate push "ignored-api-availability"
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7) {
        return [text boundingRectWithSize:size
                                  options:(NSStringDrawingUsesLineFragmentOrigin |
                                           NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading)
                               attributes:@{
                                            NSFontAttributeName : font
                                            }
                                  context:nil]
        .size;
    }
#endif
#pragma deploymate pop
    { return [text sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping]; }
}

static const CGFloat CELL_MIN_HEIGHT = 60.0f;
static const CGFloat CELL_MIN_WIDTH = 150.0f;
static const CGFloat CELL_MESSAGE_X_MARGIN = 78 + 10.0f;
static const CGFloat CELL_MESSAGE_Y_MARGIN = 44;
static const CGFloat CELL_IMAGE_HEIGHT = 130.0f;
//static const CGFloat CELL_IMAGE_WIDTH = 100.0f;

+ (CGSize)ViewHeightForMessage:(LinphoneChatMessage *)chat withWidth:(int)width {
    NSString *messageText = [UIChatBubbleTextCell TextMessageForChat:chat];
    static UIFont *messageFont = nil;
    if (!messageFont) {
        UIChatBubbleTextCell *cell =
        [[UIChatBubbleTextCell alloc] initWithIdentifier:NSStringFromClass(UIChatBubbleTextCell.class)];
        messageFont = cell.messageText.font;
        
    }
    //	UITableView *tableView = VIEW(ChatConversationView).tableController.tableView;
    //	if (tableView.isEditing)
    width -= 40; /*checkbox */
    CGSize size;
    const char *url = linphone_chat_message_get_external_body_url(chat);
    if (url == nil && linphone_chat_message_get_file_transfer_information(chat) == NULL) {
        size = [self computeBoundingBox:messageText
                                   size:CGSizeMake(width - CELL_MESSAGE_X_MARGIN - 4, CGFLOAT_MAX)
                                   font:messageFont];
    } else {
        //NSString *localImage = [LinphoneManager getMessageAppDataForKey:@"localimage" inMessage:chat];
       // size = (localImage != nil) ? CGSizeMake(CELL_IMAGE_WIDTH, CELL_IMAGE_HEIGHT) : CGSizeMake(50, 50);
        size = CGSizeMake([UIScreen mainScreen].bounds.size.width - 160.0f, CELL_IMAGE_HEIGHT);
    }
    size.width = MAX(size.width + CELL_MESSAGE_X_MARGIN, CELL_MIN_WIDTH);
    size.height = MAX(size.height + CELL_MESSAGE_Y_MARGIN, CELL_MIN_HEIGHT+10);
    return size;
}
+ (CGSize)ViewSizeForMessage:(LinphoneChatMessage *)chat withWidth:(int)width {
    static UIFont *dateFont = nil;
    static CGSize dateViewSize;
    
    if (!dateFont) {
        UIChatBubbleTextCell *cell =
        [[UIChatBubbleTextCell alloc] initWithIdentifier:NSStringFromClass(UIChatBubbleTextCell.class)];
        dateFont = cell.contactDateLabel.font;
        dateViewSize = cell.contactDateLabel.frame.size;
        dateViewSize.width = CGFLOAT_MAX;
    }
    
    CGSize messageSize = [self ViewHeightForMessage:chat withWidth:width];
    CGSize dateSize = [self computeBoundingBox:[self ContactDateForChat:chat] size:dateViewSize font:dateFont];
    messageSize.width = MAX(MAX(messageSize.width, MIN(dateSize.width + CELL_MESSAGE_X_MARGIN, width)), CELL_MIN_WIDTH);
    
    return messageSize;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (_message != nil) {
        UITableView *tableView = VIEW(ChatConversationView).tableController.tableView;
        BOOL is_outgoing = linphone_chat_message_is_outgoing(_message);
        CGRect bubbleFrame = _bubbleView.frame;
        int available_width = self.frame.size.width;
        int origin_x;
        
        bubbleFrame.size = [self.class ViewSizeForMessage:_message withWidth:available_width];
        
        if (tableView.isEditing) {
            origin_x = 0;
        } else {
            origin_x = (is_outgoing ? self.frame.size.width - bubbleFrame.size.width : 0);
        }
        
        bubbleFrame.origin.x = origin_x;
        _bubbleView.frame = bubbleFrame;
    }
}
-(int)checkout:(LinphoneChatMessage*)messageno
{
    NSString *st;
    size_t count = bctbx_list_size(messagelistout);
    for (int i=0; i<count; i++) {
        LinphoneChatMessage *chat = bctbx_list_nth_data(messagelistout, i);
        if (chat==messageno) {
            st=@"rt";
            return i;
        }
    }
    return 123;
}
@end
