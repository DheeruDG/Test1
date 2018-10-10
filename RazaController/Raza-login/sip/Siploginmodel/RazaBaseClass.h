//
//  RazaBaseClass.h
//  linphone
//
//  Created by umenit on 11/22/16.
//
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"
@interface RazaBaseClass : NSObject
+(RazaBaseClass*)SharedInstance;
- (MBProgressHUD *)ShowWaiting:(NSString *)title;
- (void)HideWaiting;
@end
