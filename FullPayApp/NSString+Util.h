//
//  NSString+Util.h
//  FullPayApp
//
//  Created by mark zheng on 13-8-29.
//  Copyright (c) 2013年 fullpay. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface NSString (Util)

//校验是否是数字
-(BOOL)checkNumber;
- (NSString *)iphoneFormat;
- (NSString *)formatPhoneNumber;
- (BOOL)checkTel;
- (BOOL)checkPwd;
- (BOOL)checkCaptcha;
- (NSString *)trimSpace;
-(NSString *)trimOnlySpace;

-(BOOL)checkPayPwd;
-(BOOL)checkLoginPwd;
-(BOOL)checkRealName;
-(BOOL)checkIdCard;
-(BOOL)checkAmt;
-(BOOL)checkRechargeAmt;

-(BOOL)checkPrepayCardNo;
-(BOOL)checkRegisterCode;

-(NSString *)formateCardNo;

-(NSString *)changeMoblieToFormatMoblie;

//设置文本中数字的颜色
-(NSMutableAttributedString *)transformNumberColorOfString:(UIColor *)color;

//元转成分
- (NSString *)transformYuanToCents;
//分转成元
- (NSString *)transformCentsToYuan;

//分  转化为简化元  1000 --》 10.00 --》10
+ (NSString *)simpMoney:(double)money;

- (float)getTextHeightWithSystemFontSize:(float)fontSize andTextWidth:(float)width;
- (CGFloat)getHeightWithFontSize:(CGFloat)fontsize andWidth:(CGFloat)width;
@end
