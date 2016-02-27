//
//  FPBillModel.m
//  FullPayApp
//
//  Created by mark zheng on 14-2-24.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPBillModel.h"

@implementation FPBillItem

-(FPBillItem *)initWithDictionary:(NSDictionary *)noticeMsg
{
    self.businessNo = [noticeMsg objectForKey:@"businessNo"];
    self.businessName = [noticeMsg objectForKey:@"businessName"];
    self.businessStatus = [noticeMsg objectForKey:@"businessStatus"];
    self.businessStatusName = [noticeMsg objectForKey:@"businessStatusName"];
    self.businessType = [noticeMsg objectForKey:@"businessType"];
    self.businessTypeName = [noticeMsg objectForKey:@"businessTypeName"];
    self.inFlag = [[noticeMsg objectForKey:@"inFlag"] boolValue];
    self.memberNo = [noticeMsg objectForKey:@"memberNo"];
    self.memberCardName = [noticeMsg objectForKey:@"memberCardName"];
    self.tradeInfo = [noticeMsg objectForKey:@"tradeInfo"];
    self.tradeTime = [noticeMsg objectForKey:@"tradeTime"];
    
    self.amt = [[noticeMsg objectForKey:@"amt"] doubleValue];
    self.payableAmt = [[noticeMsg objectForKey:@"payableAmt"] doubleValue];
    self.fee = [[noticeMsg objectForKey:@"fee"]doubleValue];
    
    return self;
}

@end

@implementation FPBillModel

- (id)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _result = [[attributes objectForKey:@"result"] boolValue];
    if (_result) {
        if ([attributes objectForKey:@"returnObj"] != [NSNull null]) {
            NSDictionary *object = [attributes objectForKey:@"returnObj"];
            
            self.limit = [[object objectForKey:@"limit"] integerValue];
            self.start = [[object objectForKey:@"start"] integerValue];
            self.total = [[object objectForKey:@"total"] integerValue];
            
            if (self.total > 0 && self.start <= self.total) {
                if ([object objectForKey:@"rows"] != [NSNull null]) {
                    NSArray *lotteryInfo = [object objectForKey:@"rows"];
                    if ([lotteryInfo count] > 0) {
                        NSMutableArray *mutableLottery = [NSMutableArray arrayWithCapacity:[lotteryInfo count]];
                        for (NSDictionary *dict in lotteryInfo) {
                            FPBillItem *lot = [[FPBillItem alloc] initWithDictionary:dict];
                            [mutableLottery addObject:lot];
                        }
                        self.billItems = mutableLottery;
                    } else {
                        _result = NO;
                    }
                    
                } else {
                    _result = NO;
                }
            } else {
                _result = NO;
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


+ (void)getFPBillModel:(NSString *)start andLimit:(NSString *)limit andBlock:(void(^)(FPBillModel *billModel,NSError *error))block
{
    NSString *memberNo = [Config Instance].memberNo;
    
    FPClient *urlClient = [FPClient sharedClient];
    NSDictionary *parameters = [urlClient userTradeQuery:memberNo andLimit:limit andStart:start andCardNo:nil andBusinessType:nil andBusinessNo:nil andBeginTime:nil andEndTime:nil];
    
    [urlClient POST:kFPPost parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"getFPBillModel:%@",responseObject);
        FPBillModel *marketingData = [[FPBillModel alloc] initWithAttributes:responseObject];
        if (block) {
            block(marketingData,nil);
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(nil,error);
        }
    }];
}

@end
