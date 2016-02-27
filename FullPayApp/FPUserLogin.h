//
//  FPUserLogin.h
//  FullPayApp
//
//  Created by mark zheng on 14-2-21.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FPPersonMember.h"
#import "FPAppParams.h"

/*
 2013-11-12 15:35:28.354 FullPayApp[19528:907] {
 errorCode = "";
 errorInfo = "";
 result = 1;
 returnObj =     {
 hasPayPwd = 1;
 params =         {}
 personMember =         {}
 result = 1;
 token = "001384241759996xVtSmxpC8Vzr4Ve+9UgH0P361UD07AjefGMN7LMeVfQ=";
 };
 validateCode = "";
 }
 */

//@class FPPersonMember;

@interface FPUserLogin : NSObject

@property (readonly) BOOL   result;
@property (readonly) NSString *errorInfo;
@property (readonly) BOOL hasPayPwd;

@property (nonatomic) FPAppParams   *appParams;
@property (nonatomic) FPPersonMember *personMember;
@property (readonly) BOOL result1;
@property (readonly) NSString *token;

- (id)initWithAttributes:(NSDictionary *)attributes;

+ (void)globalUserLoginWithLoginId:(NSString *)loginId andPwd:(NSString *)pwd andBlock:(void(^)(FPUserLogin *userInfo,NSError *error))block;

@end
