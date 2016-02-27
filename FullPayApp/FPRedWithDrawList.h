//
//  FPRedWithDrawList.h
//  FullPayApp
//
//  Created by 刘通超 on 14/12/9.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

/*
 rows =         (
 {
 amt = 101;
 beginTime = "2014-12-09 16:47:20";
 endTime = "2014-12-09 16:47:21";
 tradeNo = 647418114840517234;
 tradeStatus = SUCCESS;
 }
 );
 */

#import <Foundation/Foundation.h>

@interface WithDrawCashItem : NSObject
@property (nonatomic, strong) NSString *amt;
@property (nonatomic, strong) NSString *beginTime;
@property (nonatomic, strong) NSString *endTime;
@property (nonatomic, strong) NSString *tradeNo;
@property (nonatomic, strong) NSString *tradeStatus;

- (id)initWithArrtibutes:(NSDictionary *)attributes;

@end

@interface FPRedWithDrawList : NSObject
@property (nonatomic, strong) NSString *errorCode;
@property (nonatomic, strong) NSString *errorInfo;

@property (nonatomic, assign) BOOL result;

@property (nonatomic, assign) int limit;
@property (nonatomic, assign) int start;
@property (nonatomic, assign) int total;

@property (nonatomic, strong) NSMutableArray *withDrawItemList;

- (id)initWithArrtibutes:(NSDictionary *)attributes;

+ (void)getRedPacketWithdrawFromAppWithMemberNo:(NSString *)memberNo
                                   andAccountNo:(NSString *)accountNo
                                       andLimit:(NSString *)limit
                                       andStart:(NSString *)start
                                       andBlock:(void(^)(FPRedWithDrawList *RedWithDrawList,NSError *error))block;

@end
