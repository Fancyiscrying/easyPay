//
//  UtilTool.h
//  FullPayApp
//
//  Created by mark zheng on 14-2-21.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FPDefaultView.h"
/*
 金额比例宏定义
 */
#define kAMT_PROPORTION @"100"

@interface UtilTool : NSObject

//获取系统版本号
+ (float)getIOSVersion;

+ (void)showHUD:(NSString *)text andView:(UIView *)view andHUD:(MBProgressHUD *)hud;

+ (NSString *)decimalNumberMutiplyWithString:(NSString *)multiplierValue andValue:(NSString *)multiplicandValue;

+ (void)showToastToView:(UIView *)view andMessage:(NSString *)message;

+ (void)showToastToViewAtHead:(UIView *)view andMessage:(NSString *)message;
+ (void)showToastViewBase:(UIView *)view andMessage:(NSString *)message Offset:(CGFloat)offset;

+ (UIView *)getDefaultView:(CGRect)frame;

+ (void)setRootViewController:(UIViewController *)viewController;

+ (void)setLoginViewRootController;

+ (void)setHomeViewRootController;

//本地化富钱包卡号
+ (void)saveFullWalletCardNo:(NSString *)cardNo;
+ (NSString *)getFullWalletCardNo;

//本地化手机充值手机号
+ (void)saveRechargePhoneNum:(NSString *)phoneNo;
+ (NSString *)getRechargePhoneNum;

@end
