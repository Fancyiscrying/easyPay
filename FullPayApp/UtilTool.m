//
//  UtilTool.m
//  FullPayApp
//
//  Created by mark zheng on 14-2-21.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "UtilTool.h"
#import "FPAppDelegate.h"
#import "FPNavLoginViewController.h"
#import "FPLoginViewController.h"
#import "FPTabBarViewController.h"

@implementation UtilTool

+ (float)getIOSVersion
{
    return [[[UIDevice currentDevice] systemVersion] floatValue];
}

+ (void)showHUD:(NSString *)text andView:(UIView *)view andHUD:(MBProgressHUD *)hud
{
    [view addSubview:hud];
    hud.labelText = text;
    //    hud.dimBackground = YES;
    hud.square = YES;
    [hud show:YES];
}


+(NSString *)decimalNumberMutiplyWithString:(NSString *)multiplierValue andValue:(NSString *)multiplicandValue

{
    
    NSDecimalNumber *multiplierNumber = [NSDecimalNumber decimalNumberWithString:multiplierValue];
    
    NSDecimalNumber *multiplicandNumber = [NSDecimalNumber decimalNumberWithString:multiplicandValue];
    
    NSDecimalNumber *product = [multiplicandNumber decimalNumberByMultiplyingBy:multiplierNumber];
    
    return [product stringValue];
    
}

+ (void)showToastToView:(UIView *)view andMessage:(NSString *)message
{
    [self showToastViewBase:view andMessage:message Offset:100.0f];
}

+ (void)showToastToViewAtHead:(UIView *)view andMessage:(NSString *)message
{
    [self showToastViewBase:view andMessage:message Offset:-150.0f];
}

+ (void)showToastViewBase:(UIView *)view andMessage:(NSString *)message Offset:(CGFloat)offset
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    
	// Configure for text only and offset down
	hud.mode = MBProgressHUDModeText;
	hud.labelText = message;
    hud.labelFont = [UIFont systemFontOfSize:12.0f];
	hud.margin = 10.f;
	hud.yOffset = offset;
	hud.removeFromSuperViewOnHide = YES;
    
	[hud hide:YES afterDelay:2];
}

+ (UIView *)getDefaultView:(CGRect)frame
{
    FPDefaultView *defaultView = [[FPDefaultView alloc] initWithFrame:frame];
    
    return defaultView;
}

+ (void)setRootViewController:(UIViewController *)viewController{
    FPAppDelegate *delegate = (FPAppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.window.rootViewController = viewController;
}

+ (void)setLoginViewRootController{
    FPLoginViewController *login = [[FPLoginViewController alloc]init];
    login.isToRoot = YES;
    FPNavLoginViewController *nav = [[FPNavLoginViewController alloc]initWithRootViewController:login];
    [self setRootViewController:nav];
}

+ (void)setHomeViewRootController{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    FPTabBarViewController   *controller = [storyBoard instantiateViewControllerWithIdentifier:@"FPTabBarView"];
    [self setRootViewController:controller];
}

+ (void)saveFullWalletCardNo:(NSString *)cardNo{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:cardNo forKey:FULL_WALLET_CARDNO];
    [defaults synchronize];
}
+ (NSString *)getFullWalletCardNo{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *cardNo = [defaults objectForKey:FULL_WALLET_CARDNO];
    
    return cardNo;
}

//本地化手机充值手机号
+ (void)saveRechargePhoneNum:(NSString *)phoneNo{
    if (phoneNo.length == 13) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        [defaults setObject:phoneNo forKey:RECHARGE_PHONE_NUM];
        [defaults synchronize];
    }
}
+ (NSString *)getRechargePhoneNum{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *phoneNo = [defaults objectForKey:RECHARGE_PHONE_NUM];
    
    return phoneNo;
}



@end
