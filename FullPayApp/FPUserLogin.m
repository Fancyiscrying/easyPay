//
//  FPUserLogin.m
//  FullPayApp
//
//  Created by mark zheng on 14-2-21.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPUserLogin.h"

@implementation FPUserLogin
- (id)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _result = [[attributes objectForKey:@"result"] boolValue];
    if (_result) {
        NSDictionary *object = [attributes objectForKey:@"returnObj"];
        _hasPayPwd = [[object objectForKey:@"hasPayPwd"] boolValue];
        _result1 = [[object objectForKey:@"result"] boolValue];
        _token = [object objectForKey:@"token"];
        [[Config Instance] setToken:_token];
        
        _appParams  = [[FPAppParams alloc] initWithAttributes:[object objectForKey:@"params"]];
        [[Config Instance] setAppParams:_appParams];
        
        _personMember = [[FPPersonMember alloc] initWithAttributes:[object objectForKey:@"personMember"]];
        [[Config Instance] setPersonMember:_personMember];
        
        [[Config Instance] setMemberNo:_personMember.memberNo];
        
        
    } else {
        _errorInfo = [attributes objectForKey:@"errorInfo"];
    }
    
    return self;
}

+ (void)globalUserLoginWithLoginId:(NSString *)loginId andPwd:(NSString *)pwd andBlock:(void(^)(FPUserLogin *userInfo,NSError *error))block
{
    FPClient *urlClient = [FPClient sharedClient];
    NSDictionary *parameters = [urlClient userLogin:loginId password:pwd];
    
    [urlClient POST:kFPPost parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        FPDEBUG(@"login:%@",responseObject);
        FPUserLogin *userLogin = [[FPUserLogin alloc] initWithAttributes:responseObject];
        
        //记录token有效期
        NSDate *now = [NSDate date];
        [FPTokenTool setLastLoginDate:now];
        
        //解决首次使用重复登录问题（由于启动的时候会判断后台记录的时间与现在的间隔）
        //故每次登录后会多记录一次时间
        [FPTokenTool setTokenBackgroundTime:now];
        
        if (block) {
            block(userLogin,nil);
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(nil,error);
        }
    }];
}

@end
