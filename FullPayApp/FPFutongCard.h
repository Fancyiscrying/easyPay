//
//  FPFutongCard.h
//  FullPayApp
//
//  Created by mark zheng on 14-2-26.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 
 approveCode = bb139cb0;
 areaCode = 27;
 bindDate = "2013-07-18 19:58:59";
 bindFlag = 1;
 cancelDate = "";
 cardAccount =             {
 accountNo = "";
 cardNo = 1027000000000018;
 createTime = "";
 };
 cardNo = 1027000000000018;
 cardShape = 01;
 cardStatus = NORMAL;
 cardType = 10;
 memberName = "\U90d1\U6587\U8d85";
 memberNo = 1601372835567163984;
 nopwdAmt = "";
 openDate = "2013-07-18 16:08:54";
 remark = "";
 seqNo = dd2571e4;
 signCode = 98504960;
 updateTime = "2013-07-18 19:58:59";
 useDesc = "\U6d4b\U8bd5\U5361";
 */

@interface FPFutongCardItem : NSObject

@property (nonatomic,copy) NSString *cardNo;
@property (nonatomic,copy) NSString *memberNo;
@property (nonatomic,copy) NSString *memberName;
@property (nonatomic,copy) NSString *bindDate;
@property (nonatomic,copy) NSString *openDate;
@property (nonatomic,copy) NSString *cancelDate;
@property (nonatomic,assign) NSInteger cardShape;
@property (nonatomic,assign) NSInteger cardType;
@property (nonatomic,copy) NSString *remark;
@property (nonatomic,copy) NSString *cardStatus;
@property (nonatomic,copy) NSString *useDesc;

-(id)initWithDictionary:(NSDictionary *)attributes;

@end

@interface FPFutongCard : NSObject

@property (readonly) BOOL   result;
@property (readonly) NSString *errorInfo;

@property (nonatomic,strong) NSArray    *futongCard;
@property (nonatomic,assign) NSInteger cardsCount;

-(FPFutongCard *)initWithAttributes:(NSDictionary *)attributes;
+ (void)getFPFutongCardWithBlock:(void(^)(FPFutongCard *cardInfo,NSError *error))block;

@end
