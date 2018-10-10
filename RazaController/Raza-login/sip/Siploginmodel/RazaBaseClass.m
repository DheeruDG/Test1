//
//  RazaBaseClass.m
//  linphone
//
//  Created by umenit on 11/22/16.
//
//

#import "RazaBaseClass.h"

@implementation RazaBaseClass
+(RazaBaseClass*)SharedInstance
{
    static RazaBaseClass *__instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __instance=[[RazaBaseClass alloc]init];
    });
    return __instance;
}
- (MBProgressHUD *)ShowWaiting:(NSString *)title {
    UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
    hud.labelText = title;
    [hud hide:YES afterDelay:20.0];
    return hud;
}
- (void)HideWaiting {
    UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
    [MBProgressHUD hideHUDForView:window animated:YES];
}
@end
