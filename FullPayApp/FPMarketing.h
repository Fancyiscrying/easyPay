//
//  FPMarketing.h
//  FullPayApp
//
//  Created by mark zheng on 13-12-23.
//  Copyright (c) 2013年 fullpay. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 queryMarketing:{
 errorCode = "";
 errorInfo = "";
 result = 1;
 returnObj =     {
 limit = 1;
 otherData =         {
 auditCount = 0;
 cancelCount = 0;
 effectiveCount = 3;
 expiredCount = 0;
 suspendCount = 0;
 totalCount = 3;
 };
 rows =         (
 {
 activityBeginDate = "2013-12-23 00:00:00";
 activityEndDate = "2013-12-31 00:00:00";
 activityName = "\U8425\U9500\U6d4b\U8bd53";
 activityStatus = EFFECTIVE;
 activityType = "LIMIT_DISCOUNT";
 applyStatus = "<null>";
 createTime = "2013-12-23 16:14:02";
 detailList =                 (
 {
 activityId = 73877864423991;
 activityType = "LIMIT_DISCOUNT";
 id = "";
 key = "";
 value = "";
 }
 );
 effectiveBegin = "08:00";
 effectiveEnd = "17:59";
 fullDayFlag = 0;
 id = 73877864423991;
 level = 103;
 merchantName = "\U5bcc\U652f\U4ed8\U5927\U5356\U573a";
 merchantNo = 837577692085638;
 remark = "\U5168\U573a85\U6298";
 updateTime = "2013-12-23 16:14:14";
 }
 );
 start = 0;
 total = 3;
 };
 validateCode = "";
 }
 */
@interface MarketingItem : NSObject

@property (nonatomic,strong) NSString *activityBeginDate;
@property (nonatomic,strong) NSString *activityEndDate;
@property (nonatomic,strong) NSString *activityName;
@property (nonatomic,strong) NSString *activityStatus;
@property (nonatomic,strong) NSString *applyStatus;

@property (nonatomic,strong) NSString *effectiveBegin;
@property (nonatomic,strong) NSString *effectiveEnd;
@property (nonatomic,assign) BOOL fullDayFlag;

@property (nonatomic,strong) NSString *merchantName;
@property (nonatomic,strong) NSString *merchantNo;
@property (nonatomic,strong) NSString *remark;

-(id)initWithDictionary:(NSDictionary *)attributes;

@end

@interface FPMarketing : NSObject

@property (readonly) BOOL   result;
@property (readonly) NSString *errorInfo;

@property (nonatomic,assign) NSInteger total;
@property (nonatomic,assign) NSInteger limit;
@property (nonatomic,assign) NSInteger start;

@property (nonatomic,strong) NSArray    *marketings;

- (id)initWithAttributes:(NSDictionary *)attributes;

+ (void)getMarketing:(NSString *)start andLimit:(NSString *)limit andBlock:(void(^)(FPMarketing *marketing,NSError *error))block;

@end
