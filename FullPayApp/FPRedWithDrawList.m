//
//  FPRedWithDrawList.m
//  FullPayApp
//
//  Created by 刘通超 on 14/12/9.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPRedWithDrawList.h"

@implementation WithDrawCashItem

- (id)initWithArrtibutes:(NSDictionary *)attributes{
    self = [super init];
    if (self) {
        _amt = [attributes objectForKey:@"amt"];
        _beginTime = [attributes objectForKey:@"beginTime"];
        _endTime = [attributes objectForKey:@"endTime"];
        _tradeNo = [attributes objectForKey:@"tradeNo"];
        _tradeStatus = [attributes objectForKey:@"tradeStatus"];

    }
    return self;
    
}


@end

@implementation FPRedWithDrawList
- (id)initWithArrtibutes:(NSDictionary *)attributes{
    self = [super init];
    if (self) {
        
        _result = [[attributes objectForKey:@"result"] boolValue];
        if (_result) {
            if ([attributes objectForKey:@"returnObj"] != [NSNull null]) {
                NSDictionary *object = [attributes objectForKey:@"returnObj"];
                
                self.limit = (int)[[object objectForKey:@"limit"] integerValue];
                self.start = (int)[[object objectForKey:@"start"] integerValue];
                self.total = (int)[[object objectForKey:@"total"] integerValue];
                
                if ([object objectForKey:@"rows"] != [NSNull null]) {
                    NSArray *HotInfo = [object objectForKey:@"rows"];
                    if ([HotInfo count] > 0) {
                        NSMutableArray *mutableLottery = [NSMutableArray arrayWithCapacity:[HotInfo count]];
                        for (NSDictionary *dict in HotInfo) {
                            WithDrawCashItem *item = [[WithDrawCashItem alloc]initWithArrtibutes:dict];
                            [mutableLottery addObject:item];
                        }
                        self.withDrawItemList = mutableLottery;
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
        
        
    }
    
    return self;
}

+ (void)getRedPacketWithdrawFromAppWithMemberNo:(NSString *)memberNo
                                   andAccountNo:(NSString *)accountNo
                                       andLimit:(NSString *)limit
                                       andStart:(NSString *)start
                                       andBlock:(void(^)(FPRedWithDrawList *RedWithDrawList,NSError *error))block{
    FPClient *client = [FPClient sharedClient];
    
    NSDictionary *paramters = [client findRedPacketWithdrawFromAppWithMemberNo:memberNo andAccountNo:accountNo andLimit:limit andStart:start];
    [client POST:kFPPost parameters:paramters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        FPDEBUG(@"%@",responseObject);
        FPRedWithDrawList *RedWithDrawList = [[FPRedWithDrawList alloc]initWithArrtibutes:responseObject];
        if (block) {
            block(RedWithDrawList,nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(nil,error);
        }
    }];
    

}

@end
