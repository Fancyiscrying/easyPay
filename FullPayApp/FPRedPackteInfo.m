//
//  FPRedPackteInfo.m
//  FullPayApp
//
//  Created by 刘通超 on 14/12/2.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPRedPackteInfo.h"

@implementation RedPackteItem

- (id)initWithArrtibutes:(NSDictionary *)attributes{
    self = [super init];
    if (self) {
        _addRemark = [attributes objectForKey:@"addRemark"];
        _amt = [[attributes objectForKey:@"amt"] doubleValue]/100;
        _businessNo = [attributes objectForKey:@"businessNo"];
        _createTime = [attributes objectForKey:@"createTime"];
        _distributeStatus = [attributes objectForKey:@"distributeStatus"];
        _distributedAmt = [[attributes objectForKey:@"distributedAmt"]doubleValue]/100;
        _distributedCount = [attributes objectForKey:@"distributedCount"];
        _redPackteId = [attributes objectForKey:@"id"];
        _memberName = [attributes objectForKey:@"memberName"];
        _memberNo = [attributes objectForKey:@"memberNo"];
        _remark = [attributes objectForKey:@"remark"];
        _stopBusinessNo = [attributes objectForKey:@"stopBusinessNo"];
        _stopTime = [attributes objectForKey:@"stopTime"];
        _surplusAmt = [[attributes objectForKey:@"surplusAmt"]doubleValue]/100;
        _surplusCount = [attributes objectForKey:@"surplusCount"];
        _totalAmt = [[attributes objectForKey:@"totalAmt"]doubleValue]/100;
        _totalCount = [attributes objectForKey:@"totalCount"];
        _updateTime = [attributes objectForKey:@"updateTime"];
        _validTime = [attributes objectForKey:@"validTime"];
        
    }
    
    return self;
}

@end

@implementation FPRedPackteInfo
- (id)initWithArrtibutes:(NSDictionary *)attributes{
    self = [super init];
    if (self) {
        _accountBalance = [[attributes objectForKey:@"accountBalance"] doubleValue];
        _accountNo = [attributes objectForKey:@"accountNo"];
        _haveRedPacketDistribute = [[attributes objectForKey:@"haveRedPacketDistribute"] boolValue];
        if (_haveRedPacketDistribute) {
            NSDictionary *paramter = [attributes objectForKey:@"distribute"];
            _distributeItem = [[RedPackteItem alloc]initWithArrtibutes:paramter];
        }
    }
    
    return self;
}

@end
