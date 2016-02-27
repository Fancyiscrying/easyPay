//
//  FPLotteryStruct.m
//  FullPayApp
//
//  Created by mark zheng on 13-11-18.
//  Copyright (c) 2013年 fullpay. All rights reserved.
//

#import "FPLotteryStruct.h"

@implementation FPLotteryObject

-(id)initWithDictionary:(NSDictionary *)dictObj
{
    self.modeCode = [dictObj objectForKey:@"modeCode"];
    self.modeName = [dictObj objectForKey:@"modeName"];
    self.desc1 = [dictObj objectForKey:@"desc1"];
    self.desc2 = [dictObj objectForKey:@"desc2"];
    self.resourceCode = [dictObj objectForKey:@"resourceCode"];
    self.resourceName = [dictObj objectForKey:@"resourceName"];
    self.redirectUri = [dictObj objectForKey:@"url"];
    self.seqNo = [dictObj objectForKey:@"seqNo"];
    
    return self;
}

@end

@implementation FPLotteryStruct

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
            
            NSArray *lotteryInfo = [object objectForKey:@"lotterylist"];
            if ([lotteryInfo count] > 0) {
                NSMutableArray *mutableLottery = [NSMutableArray arrayWithCapacity:[lotteryInfo count]];
                for (NSDictionary *dict in lotteryInfo) {
                    FPLotteryObject *lot = [[FPLotteryObject alloc] initWithDictionary:dict];
                    [mutableLottery addObject:lot];
                }
                self.lotteryList = mutableLottery;
            }
            
            lotteryInfo = [object objectForKey:@"othermode"];
            if ([lotteryInfo count] > 0) {
                NSMutableArray *mutableLottery = [NSMutableArray arrayWithCapacity:[lotteryInfo count]];
                for (NSDictionary *dict in lotteryInfo) {
                    FPLotteryObject *lot = [[FPLotteryObject alloc] initWithDictionary:dict];
                    [mutableLottery addObject:lot];
                }
                self.othermode = mutableLottery;
            }
            
            if ([object objectForKey:@"marketingInfo"] != [NSNull null]) {
                lotteryInfo = [object objectForKey:@"marketingInfo"];
                NSDictionary *dict = lotteryInfo[0];
                FPLotteryObject *lot = [[FPLotteryObject alloc] initWithDictionary:dict];
                
                self.marketingInfo = lot;
            }

        } else {
            _result = NO;
            _errorInfo = @"未查询到你所需要的信息";
        }
    } else {
        _errorInfo = [attributes objectForKey:@"errorInfo"];
    }
    
    return self;
}

+ (void)getLotteryWithBlock:(void(^)(FPLotteryStruct *lotteryInfo,NSError *error))block
{
    FPClient *urlClient = [FPClient sharedClient];
    NSDictionary *parameters = [urlClient userFindLottery];
    
    [urlClient POST:kFPPost parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"getLotteryWithBlock:%@",responseObject);
        FPLotteryStruct *lotteryData = [[FPLotteryStruct alloc] initWithAttributes:responseObject];
        if (block) {
            block(lotteryData,nil);
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(nil,error);
        }
    }];
}

@end
