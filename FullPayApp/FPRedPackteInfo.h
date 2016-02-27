//
//  FPRedPackteInfo.h
//  FullPayApp
//
//  Created by 刘通超 on 14/12/2.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 distribute =         {
 addRemark = Dghd;
 amt = 1;
 businessNo = 647417505519816349;
 createTime = "2014-12-02 15:31:46";
 distributeStatus = VALID;
 distributedAmt = 0;
 distributedCount = 0;
 id = 647417505506866459;
 memberName = "\U5218\U901a\U8d85";
 memberNo = 1647399171476383715;
 remark = "";
 stopBusinessNo = "";
 stopTime = "2014-12-02 15:31:46";
 surplusAmt = 10;
 surplusCount = 10;
 totalAmt = 10;
 totalCount = 10;
 updateTime = "2014-12-02 15:32:00";
 validTime = "2014-12-02 15:31:46";
 };

 */

@interface RedPackteItem : NSObject
@property (nonatomic, strong) NSString     *addRemark;
@property (nonatomic, assign) double       amt;
@property (nonatomic, strong) NSString     *businessNo;
@property (nonatomic, strong) NSString     *createTime;
@property (nonatomic, strong) NSString     *distributeStatus;
@property (nonatomic, assign) double       distributedAmt;
@property (nonatomic, strong) NSString     *distributedCount;
@property (nonatomic, strong) NSString     *redPackteId;
@property (nonatomic, strong) NSString     *memberName;
@property (nonatomic, strong) NSString     *memberNo;
@property (nonatomic, strong) NSString     *remark;
@property (nonatomic, strong) NSString     *stopBusinessNo;
@property (nonatomic, strong) NSString     *stopTime;
@property (nonatomic, assign) double       surplusAmt;
@property (nonatomic, strong) NSString     *surplusCount;
@property (nonatomic, assign) double       totalAmt;
@property (nonatomic, strong) NSString     *totalCount;
@property (nonatomic, strong) NSString     *updateTime;
@property (nonatomic, strong) NSString     *validTime;

- (id)initWithArrtibutes:(NSDictionary *)attributes;

@end

@interface FPRedPackteInfo : NSObject
@property (nonatomic, assign) BOOL          haveRedPacketDistribute;
@property (nonatomic        ) double        accountBalance;
@property (nonatomic, strong) NSString      *accountNo;
@property (nonatomic, strong) RedPackteItem *distributeItem;
- (id)initWithArrtibutes:(NSDictionary *)attributes;

@end
