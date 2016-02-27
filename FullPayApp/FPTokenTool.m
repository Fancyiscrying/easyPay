//
//  FPTokenTool.m
//  FullPayApp
//
//  Created by 刘通超 on 15/2/26.
//  Copyright (c) 2015年 fullpay. All rights reserved.
//

#import "FPTokenTool.h"

// TOKEN_VALUE_TIME_DAY *24*60*60

@implementation FPTokenTool
+ (BOOL)isUserUnuseLongTime{

    NSDate *now = [NSDate date];
    NSDate *backgroundDate = [self getTokenBackgroundTime];
    double timeInterval = [now timeIntervalSinceDate:backgroundDate];
    if (timeInterval < TOKEN_VALUE_TIME_DAY*24*60*60-2*60*60) {
        //TOKEN_VALUE_TIME_DAY*24*60*60-2*60*60
        
        return NO;
    }else{
        return YES;
    }
}

+ (BOOL)isTokenIsAvailable{
    
    NSDate *now = [NSDate date];
    NSDate *loginDate = [self getLastLoginDate];
    double timeInterval = [now timeIntervalSinceDate:loginDate];
    if (timeInterval < TOKEN_VALUE_TIME_DAY *24*60*60) {
        return YES;
    }else{
        return NO;
    }
}

+ (void)setLastLoginDate:(NSDate *)date{
    if (date != nil) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults removeObjectForKey:LOGIN_TIME];
        
        [defaults setObject:date forKey:LOGIN_TIME];
        [defaults synchronize];
    }
    
}

+ (NSDate *)getLastLoginDate{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDate *date = [defaults objectForKey:LOGIN_TIME];
    
    return date;
}

+ (void)setTokenBackgroundTime:(NSDate *)date{
    if (date != nil) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults removeObjectForKey:TOKEN_BACKGROUND_TIME];
        
        [defaults setObject:date forKey:TOKEN_BACKGROUND_TIME];
        [defaults synchronize];
    }
}

+ (NSDate *)getTokenBackgroundTime{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDate *date = [defaults objectForKey:TOKEN_BACKGROUND_TIME];
    
    return date;
}


@end
