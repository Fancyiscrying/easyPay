//
//  FPBillModel.h
//  FullPayApp
//
//  Created by mark zheng on 14-2-24.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 "amt":"100","businessNo":"701374239325751549","businessStatus":"TRADE_SUCCESS","businessStatusName":"交易成功","businessType":"TRS_ACCT","businessTypeName":"转账","memberCardName":"孙俊","memberNo":"1601372665254585996","payableAmt":"100","tradeInfo":"","tradeTime":"2013-07-19 21:09:00"}
 
 "amt":"704","businessNo":"601374561028234775","businessStatus":"TRADE_SUCCESS","businessStatusName":"交易成功","businessType":"CSE_PAY","businessTypeName":"消费","memberCardName":"名典咖啡","memberNo":"2601371180167436270","payableAmt":"800","tradeInfo":"全场八八折","tradeTime":"2013-07-23 14:30:28"
 
 */

@interface FPBillItem : NSObject

@property (nonatomic,strong) NSString *businessNo;
@property (nonatomic,strong) NSString *businessName;
@property (nonatomic,strong) NSString *businessStatus;
@property (nonatomic,strong) NSString *businessStatusName;
@property (nonatomic,strong) NSString *businessType;
@property (nonatomic,strong) NSString *businessTypeName;
@property (nonatomic,assign) BOOL inFlag;
@property (nonatomic,strong) NSString *memberNo;
@property (nonatomic,strong) NSString *memberCardName;
@property (nonatomic,strong) NSString *tradeInfo;
@property (nonatomic,strong) NSString *tradeTime;

@property (nonatomic,assign) double amt;
@property (nonatomic,assign) double payableAmt;
@property (nonatomic,assign) double fee;

-(FPBillItem *)initWithDictionary:(NSDictionary *)noticeMsg;
@end

@interface FPBillModel : NSObject

@property (readonly) BOOL   result;
@property (readonly) NSString *errorInfo;

@property (nonatomic,assign) NSInteger total;
@property (nonatomic,assign) NSInteger limit;
@property (nonatomic,assign) NSInteger start;

@property (nonatomic,strong) NSArray    *billItems;

- (id)initWithAttributes:(NSDictionary *)attributes;

+ (void)getFPBillModel:(NSString *)start andLimit:(NSString *)limit andBlock:(void(^)(FPBillModel *billModel,NSError *error))block;

@end
