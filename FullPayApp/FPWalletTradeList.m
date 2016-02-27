//
//  FPWalletTradeList.m
//  FullPayApp
//
//  Created by lc on 14-8-13.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//


#import "FPWalletTradeList.h"

@implementation WalletTradeItem
-(WalletTradeItem *)initWithDictionary:(NSDictionary *)noticeMsg{
    
    self.tradeStatus = [noticeMsg objectForKey:@"status"];
    self.tradeOtherSide = [noticeMsg objectForKey:@"tradeOtherSide"];
    self.tradeTime = [noticeMsg objectForKey:@"tradeTime"];
    self.tradeType = [noticeMsg objectForKey:@"tradeType"];
    self.amt = [[noticeMsg objectForKey:@"amt"] doubleValue];
    self.inFlag = [[noticeMsg objectForKey:@"inFlag"] boolValue];
    
    return self;
}
@end

@implementation FPWalletTradeList
- (id)initWithAttributes:(NSDictionary *)attributes{
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
                    NSArray *walletInfo = [object objectForKey:@"rows"];
                    if ([walletInfo count] > 0) {
                        NSMutableArray *mutableLottery = [NSMutableArray arrayWithCapacity:[walletInfo count]];
                        for (NSDictionary *dict in walletInfo) {
                            WalletTradeItem *lot = [[WalletTradeItem alloc] initWithDictionary:dict];
                            [mutableLottery addObject:lot];
                        }
                        self.tradeList = mutableLottery;
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

+ (void)getFPBillModelWithCardNo:(NSString *)cardNo
                     andMemberNo:(NSString *)memberNo
                        andStart:(NSString *)start
                        andLimit:(NSString *)limit
                   andRecentDate:(NSString *)date
                        andBlock:(void(^)(FPWalletTradeList *billModel,NSError *error))block{
    
    FPClient *client = [FPClient sharedClient];
    NSDictionary *paramters = [client findOfflineTradeCardNo:cardNo andMemberNo:memberNo andLimit:limit andStart:start andRecentDate:date];
    [client POST:kFPPost parameters:paramters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        FPDEBUG(@"%@",responseObject);
        FPWalletTradeList *marketingData = [[FPWalletTradeList alloc] initWithAttributes:responseObject];
        if (block) {
            block(marketingData,nil);
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(nil,error);
        }
    }];

}
@end
