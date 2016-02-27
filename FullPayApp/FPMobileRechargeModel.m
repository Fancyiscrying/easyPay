//
//  FPMobileRechargeModel.m
//  FullPayApp
//
//  Created by mark zheng on 14-4-23.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPMobileRechargeModel.h"

@implementation MobileOption

-(id)initWithDictionary:(NSDictionary *)dict
{
    if (self = [super init]) {
        self.optionId = [dict[@"id"] integerValue];
        self.payAmount = [dict[@"payAmount"] floatValue]/100;
        self.rechargeAmount = [dict[@"rechargeAmount"] floatValue]/100;
        self.remark = dict[@"remark"];
        self.status = [dict[@"status"] boolValue];
    }
    return self;
}

@end

@implementation FPMobileRechargeModel

-(FPMobileRechargeModel *)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _result = [[attributes objectForKey:@"result"] boolValue];
    if (_result) {
        if ([attributes objectForKey:@"returnObj"] != [NSNull null]) {
            
            NSDictionary *object = [attributes objectForKey:@"returnObj"];
            if ([object count] > 0) {
                self.userPhoneTelecom = object[@"userPhoneTelecom"];
                
                NSArray *array = object[@"telecomRechargeOptions"];
                if ([array count] > 0) {
                    NSMutableArray *mutable = [NSMutableArray arrayWithCapacity:[array count]];
                    for (NSDictionary *dict in array) {
                        MobileOption *option = [[MobileOption alloc] initWithDictionary:dict];
                        [mutable addObject:option];
                    }
                    self.telecomRechargeOptions = mutable;
                }
            }
        } else {
            _result = NO;
        }
        
        if (_result == NO) {
            _errorInfo = @"未查询到你所需要的信息";
        }
        
    } else {
        _errorInfo = [attributes objectForKey:@"errorInfo"];
    }
    
    return self;
}

-(FPMobileRechargeModel *)initWithAttributesMini:(NSDictionary *)attributes
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _result = [[attributes objectForKey:@"result"] boolValue];
    if (_result) {
        
    } else {
        _errorInfo = [attributes objectForKey:@"errorInfo"];
    }
    
    return self;
}

+ (void)getTelecomRechargeOptionsWithMobileNo:(NSString *)mobileNo andBlock:(void(^)(FPMobileRechargeModel *dataInfo,NSError *error))block
{
    FPClient *urlClient = [FPClient sharedClient];
    NSDictionary *parameters = [urlClient userMobileFee:mobileNo];;
    
    [urlClient POST:kFPPost parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        FPDEBUG(@"getTelecomRechargeOptionsWithBlock:%@",responseObject);
        FPMobileRechargeModel *resultInfo = [[FPMobileRechargeModel alloc] initWithAttributes:responseObject];
        if (block) {
            block(resultInfo,nil);
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(nil,error);
        }
    }];
}

+ (void)userRechargeMobileFeeWithMobileNo:(NSString *)mobileNo andOptionId:(NSInteger)optionId andPayPwd:(NSString *)payPwd andBlock:(void(^)(FPMobileRechargeModel *dataInfo,NSError *error))block
{
    NSString *memberNo = [Config Instance].memberNo;
    FPClient *urlClient = [FPClient sharedClient];
    NSDictionary *parameters = [urlClient userRechargeMobileFee:memberNo andMobileNo:mobileNo andOptionId:optionId andPayPwd:payPwd];
    
    [urlClient POST:kFPPost parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        FPDEBUG(@"userRechargeMobileFeeWithMobileNo:%@",responseObject);
        FPMobileRechargeModel *resultInfo = [[FPMobileRechargeModel alloc] initWithAttributesMini:responseObject];
        if (block) {
            block(resultInfo,nil);
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(nil,error);
        }
    }];
}

@end
