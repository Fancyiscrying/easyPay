//
//  FPRedPacketList.h
//  FullPayApp
//
//  Created by 刘通超 on 14/12/3.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 {
 amt = 1;
 createTime = "2014-12-03 10:49:22";
 distributeId = 647417513364388274;
 distributeName = "\U5218\U901a\U8d85";
 distributeNo = 1647399171476383715;
 distributeRemark = "\U606d\U559c\U53d1\U8d22\Uff01";
 id = 647417571004572277;
 receiveName = "\U6797\U4e00";
 receiveNo = 1647413193514263969;
 receiveRemark = "";
 receiveTime = "2014-12-03 10:49:22";
 remark = "";
 updateTime = "2014-12-03 10:49:22";
 }

 */
@interface RedPacketListItem : NSObject
@property (nonatomic, assign) double   amt;
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) NSString *distributeId;
@property (nonatomic, strong) NSString *distributeMobile;
@property (nonatomic, strong) NSString *distributeName;
@property (nonatomic, strong) NSString *distributeNo;
@property (nonatomic, strong) NSString *distributeRemark;
@property (nonatomic, strong) NSString *redPacketId;
@property (nonatomic, strong) NSString *receiveName;
@property (nonatomic, strong) NSString *receiveNo;
@property (nonatomic, strong) NSString *receiveMobile;
@property (nonatomic, strong) NSString *receiveRemark;
@property (nonatomic, strong) NSString *receiveTime;
@property (nonatomic, strong) NSString *remark;
@property (nonatomic, strong) NSString *updateTime;

- (id)initWithArrtibutes:(NSDictionary *)attributes;

@end

@interface FPRedPacketList : NSObject
@property (nonatomic, strong) NSString *errorCode;
@property (nonatomic, strong) NSString *errorInfo;

@property (nonatomic, assign) BOOL result;

@property (nonatomic, assign) int limit;
@property (nonatomic, assign) int start;
@property (nonatomic, assign) int total;

@property (nonatomic, assign) int totalCount;
@property (nonatomic, assign) float totalAmt;


@property (nonatomic, strong) NSMutableArray *redPacketList;

- (id)initWithArrtibutes:(NSDictionary *)attributes;
+ (void)getDistributedRedPacketWithMemberNo:(NSString *)memberNo
                                   andLimit:(NSString *)limit
                                   andStart:(NSString *)start
                                   andBlock:(void(^)(FPRedPacketList *redPacketList,NSError *error))block;

+ (void)getReceivedRedPacketWithMemberNo:(NSString *)memberNo
                                andLimit:(NSString *)limit
                                andStart:(NSString *)start
                                andBlock:(void(^)(FPRedPacketList *redPacketList,NSError *error))block;
@end
