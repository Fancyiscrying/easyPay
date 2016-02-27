//
//  FPMobileRechargeModel.h
//  FullPayApp
//
//  Created by mark zheng on 14-4-23.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MobileOption : NSObject

@property (nonatomic,assign) NSInteger optionId;
@property (nonatomic,assign) float payAmount;
@property (nonatomic,assign) float rechargeAmount;
@property (nonatomic,strong) NSString *remark;
@property (nonatomic,assign) BOOL status;

-(id)initWithDictionary:(NSDictionary*)dict;

@end

@interface FPMobileRechargeModel : NSObject


@property (readonly) BOOL   result;
@property (readonly) NSString *errorInfo;

@property (nonatomic,strong) NSArray    *telecomRechargeOptions;

@property (nonatomic,strong) NSString   *userPhoneTelecom;

-(FPMobileRechargeModel *)initWithAttributes:(NSDictionary *)attributes;
+ (void)getTelecomRechargeOptionsWithMobileNo:(NSString *)mobileNo andBlock:(void(^)(FPMobileRechargeModel *dataInfo,NSError *error))block;
+ (void)userRechargeMobileFeeWithMobileNo:(NSString *)mobileNo andOptionId:(NSInteger)optionId andPayPwd:(NSString *)payPwd andBlock:(void(^)(FPMobileRechargeModel *dataInfo,NSError *error))block;

@end
