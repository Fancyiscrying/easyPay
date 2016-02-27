//
//  FPTelGesturePWD.h
//  FullPayApp
//
//  Created by lc on 14-6-14.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FPTelGesture : NSObject

@property (copy, nonatomic)NSString *telNumber;
@property (copy, nonatomic)NSString *gesturePWD;

@end

@interface FPTelGesturePWD : NSObject

@property (strong, nonatomic) FPTelGesture *telGesture;


+ (NSString *)objectValueForKey:(NSString *)telNumber;

//检验是否已经登录过
+ (BOOL)isFirstLaunch:(NSString *)telNmuber;

+ (BOOL)addTelGesturePassword:(NSString *)PWD andTelNumber:(NSString *)telNumber;

//修改手势密码
+ (BOOL)resetGesturePassword:(NSString *)PWD andTelNumber:(NSString *)telNumber;

@end
