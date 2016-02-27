//
//  FPMarketing.m
//  FullPayApp
//
//  Created by mark zheng on 13-12-23.
//  Copyright (c) 2013年 fullpay. All rights reserved.
//

#import "FPMarketing.h"

@implementation MarketingItem

-(id)initWithDictionary:(NSDictionary *)attributes;
{
    self.activityBeginDate = [attributes objectForKey:@"activityBeginDate"];
    self.activityEndDate = [attributes objectForKey:@"activityEndDate"];
    self.activityName = [attributes objectForKey:@"activityName"];
    self.activityStatus = [attributes objectForKey:@"activityStatus"];
    
    if ([attributes objectForKey:@"applyStatus"] != [NSNull null]) {
        self.applyStatus = [attributes objectForKey:@"applyStatus"];
    }
    
    self.effectiveBegin = [attributes objectForKey:@"effectiveBegin"];
    self.effectiveEnd = [attributes objectForKey:@"effectiveEnd"];
    self.fullDayFlag = [[attributes objectForKey:@"fullDayFlag"] boolValue];
    
    self.merchantName = [attributes objectForKey:@"merchantName"];
    self.merchantNo = [attributes objectForKey:@"merchantNo"];
    self.remark = [attributes objectForKey:@"remark"];
    
    return self;
}

@end

@implementation FPMarketing

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
                            MarketingItem *lot = [[MarketingItem alloc] initWithDictionary:dict];
                            [mutableLottery addObject:lot];
                        }
                        self.marketings = mutableLottery;
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


+ (void)getMarketing:(NSString *)start andLimit:(NSString *)limit andBlock:(void(^)(FPMarketing *marketing,NSError *error))block
{
    NSString *memberNo = [Config Instance].memberNo;

    FPClient *urlClient = [FPClient sharedClient];
    NSDictionary *parameters = [urlClient userMarketingQuery:memberNo andLimit:limit andStart:start andEmail:nil andActivityName:nil andActivityType:nil andActivityStatus:nil andBeginTime:nil andEndTime:nil];
    
    [urlClient postPath:kFPPost parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"111:%@",responseObject);
        FPMarketing *marketingData = [[FPMarketing alloc] initWithAttributes:responseObject];
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
