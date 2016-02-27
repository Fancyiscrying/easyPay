//
//  FPRedPacketList.m
//  FullPayApp
//
//  Created by 刘通超 on 14/12/3.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPRedPacketList.h"

@implementation RedPacketListItem

- (id)initWithArrtibutes:(NSDictionary *)attributes{
    self = [super init];
    if (self) {
        _amt = [[attributes objectForKey:@"amt"] doubleValue]/100;
        _createTime = [attributes objectForKey:@"createTime"];
        _distributeId = [attributes objectForKey:@"distributeId"];
        _distributeMobile = [attributes objectForKey:@"distributeMobile"];
        _distributeName = [attributes objectForKey:@"distributeName"];
        _distributeNo = [attributes objectForKey:@"distributeNo"];
        _distributeRemark = [attributes objectForKey:@"distributeRemark"];
        _redPacketId = [attributes objectForKey:@"id"];
        _receiveName = [attributes objectForKey:@"receiveName"];
        _receiveNo = [attributes objectForKey:@"receiveNo"];
        _receiveMobile = [attributes objectForKey:@"receiveMobile"];
        _receiveRemark = [attributes objectForKey:@"receiveRemark"];
        _receiveTime = [attributes objectForKey:@"receiveTime"];
        _remark = [attributes objectForKey:@"remark"];
        _updateTime = [attributes objectForKey:@"updateTime"];

    }
    
    return self;
}

@end

@implementation FPRedPacketList
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
                
                if ([object objectForKey:@"otherData"] != [NSNull null]) {
                    NSDictionary *otherData = [object objectForKey:@"otherData"];
                    self.totalAmt = [[otherData objectForKey:@"totalAmt"] floatValue];
                    self.totalCount = [[otherData objectForKey:@"totalCount"] intValue];
                }
                
                if ([object objectForKey:@"rows"] != [NSNull null]) {
                    NSArray *HotInfo = [object objectForKey:@"rows"];
                    if ([HotInfo count] > 0) {
                        NSMutableArray *mutableLottery = [NSMutableArray arrayWithCapacity:[HotInfo count]];
                        for (NSDictionary *dict in HotInfo) {
                            RedPacketListItem *item = [[RedPacketListItem alloc]initWithArrtibutes:dict];
                            [mutableLottery addObject:item];
                        }
                        self.redPacketList = mutableLottery;
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

+ (void)getDistributedRedPacketWithMemberNo:(NSString *)memberNo
                                   andLimit:(NSString *)limit
                                   andStart:(NSString *)start
                                   andBlock:(void(^)(FPRedPacketList *redPacketList,NSError *error))block{
    FPClient *client = [FPClient sharedClient];
    
    NSDictionary *paramters = [client findDistributedRedPacketWithMemberNo:memberNo andLimit:limit andStart:start];
    [client POST:kFPPost parameters:paramters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        FPDEBUG(@"%@",responseObject);
        FPRedPacketList *redPacketList = [[FPRedPacketList alloc]initWithArrtibutes:responseObject];
        if (block) {
            block(redPacketList,nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(nil,error);
        }
    }];
    

}

+ (void)getReceivedRedPacketWithMemberNo:(NSString *)memberNo
                                andLimit:(NSString *)limit
                                andStart:(NSString *)start
                                andBlock:(void(^)(FPRedPacketList *redPacketList,NSError *error))block{
    FPClient *client = [FPClient sharedClient];
    
    NSDictionary *paramters = [client findReceivedRedPacketWithMemberNo:memberNo andLimit:limit andStart:start];
    [client POST:kFPPost parameters:paramters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        FPDEBUG(@"%@",responseObject);
        FPRedPacketList *redPacketList = [[FPRedPacketList alloc]initWithArrtibutes:responseObject];
        if (block) {
            block(redPacketList,nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(nil,error);
        }
    }];
    
    
}
@end
