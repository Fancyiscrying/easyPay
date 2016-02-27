//
//  FPPersonMember.h
//  FullPayApp
//
//  Created by mark zheng on 14-2-21.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 personMember =         {
 address = "";
 age = 0;
 certNo = 111111111111111111;
 certTypeCode = "I_CARD";
 certValidBeginDate = "";
 certValidEndDate = "";
 createDate = "2013-08-08 15:56:36";
 createId = "";
 cycleLoginFailTimes = 0;
 email = "";
 gender = "";
 headAddress = 50b390a61b594dcb8e346b2994065342;
 id = 1;
 job = "";
 lastLoginDate = "";
 lockStatus = NORMAL;
 loginName = "";
 memberName = Journal;
 memberNo = 1647375948596656495;
 memberSrc = "";
 mobile = 18718867802;
 nameAuthFlag = Y;
 nationalCode = "";
 nickName = "";
 noPswLimit = 2000;
 noPswLimitOn = 1;
 noteLimit = 5000;
 noteLimitOn = 1;
 payLimit = 100000;
 payLimitOn = 1;
 pwd = aa58992f0b5bfc10caeb1f316ea5d394;
 remark = "";
 safeFlag = BASIC;
 status = NORMAL;
 telephone = "";
 updateDate = "2013-10-15 09:57:56";
 updateId = "";
 };
 */
@interface FPPersonMember : NSObject

@property (nonatomic, retain) NSString *address;
@property (nonatomic, retain) NSString *age;
@property (nonatomic, retain) NSString *certNo;
@property (nonatomic, retain) NSString *certTypeCode;
@property (nonatomic, retain) NSString *certValidBeginDate;
@property (nonatomic, retain) NSString *certValidEndDate;
@property (nonatomic, strong) NSDate *createDate;
@property (nonatomic, retain) NSString *createId;
@property (nonatomic) NSInteger cycleLoginFailTimes;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *gender;
@property (nonatomic, retain) NSString *headAddress;
@property (nonatomic) NSInteger memberId;
@property (nonatomic, retain) NSString *job;
@property (nonatomic, retain) NSString *jobNumFoxconn;
@property (nonatomic, retain) NSString *lastLoginDate;
@property (nonatomic, retain) NSString *lockStatus;
@property (nonatomic, retain) NSString *loginName;
@property (nonatomic, retain) NSString *memberName;
@property (nonatomic, retain) NSString *memberNo;
@property (nonatomic, retain) NSString *memberSrc;
@property (nonatomic, retain) NSString *mobile;
@property (nonatomic) BOOL  nameAuthFlag;
@property (nonatomic, retain) NSString *nationalCode;
@property (nonatomic, retain) NSString *nickName;
@property (nonatomic) BOOL noPswLimitOn;
@property (nonatomic) BOOL noteLimitOn;
//@property (nonatomic) BOOL payLimitOn;
@property (nonatomic, retain) NSString *noPswLimit;
@property (nonatomic, retain) NSString *noteLimit;
@property (nonatomic, retain) NSString *payLimit;
@property (nonatomic, retain) NSString *remark;
@property (nonatomic, retain) NSString *safeFlag;
@property (nonatomic, retain) NSString *status;

- (id)initWithAttributes:(NSDictionary *)attributes;

@end

