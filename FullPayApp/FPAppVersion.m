//
//  FPAppVersion.m
//  FullPayApp
//
//  Created by mark zheng on 13-11-11.
//  Copyright (c) 2013年 fullpay. All rights reserved.
//

#import "FPAppVersion.h"

@implementation FPAppVersion

-(id)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _result = [[attributes objectForKey:@"result"] boolValue];
    if (_result) {
        NSDictionary *object = [attributes objectForKey:@"returnObj"];
        _clientVersion = [object objectForKey:@"clientVersion"];
        _forceUpdate = [[object objectForKey:@"forceUpdate"] boolValue];
        _needUpdate = [[object objectForKey:@"needUpdate"] boolValue];
        _serverVersion = [object objectForKey:@"serverVersion"];
        _updateUrl = [object objectForKey:@"updateUrl"];
        
        NSDictionary *dictMethod = [object objectForKey:@"functionMap"];
        if (![dictMethod isEqual:[NSNull null]] && [dictMethod count] > 0) {
            _methodMap = [[FPMethodMap alloc] initWithAttributes:[object objectForKey:@"functionMap"]];
            [[Config Instance] setMethodMap:_methodMap];
        }
    } else {
        _errorInfo = [attributes objectForKey:@"errorInfo"];
    }
    
    return self;
}

+ (void)checkAppVersion:(BOOL)funcFlag andBlock:(void(^)(FPAppVersion *appVersion,NSError *error))block
{
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    FPClient *urlClient = [FPClient sharedClient];
    NSDictionary *parameters = [urlClient userMobileVersion:appVersion andOpenFlag:funcFlag];
   
    [urlClient POST:kFPPost parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        FPDEBUG(@"checkAppVersion:%@",responseObject);
        
        FPAppVersion *version = [[FPAppVersion alloc] initWithAttributes:responseObject];
        if (block) {
            block(version,nil);
        }
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(nil,error);
        }
    }];
}

@end
