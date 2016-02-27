//
//  FPTokenTool.h
//  FullPayApp
//
//  Created by 刘通超 on 15/2/26.
//  Copyright (c) 2015年 fullpay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FPTokenTool : NSObject

+ (BOOL)isUserUnuseLongTime;
+ (BOOL)isTokenIsAvailable;

+ (void)setLastLoginDate:(NSDate *)date;
+ (void)setTokenBackgroundTime:(NSDate *)date;

@end
