//
//  FPWalletTradeList.h
//  FullPayApp
//
//  Created by lc on 14-8-13.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WalletTradeItem : NSObject

@property (nonatomic,strong) NSString *tradeOtherSide;
@property (nonatomic,strong) NSString *tradeStatus;
@property (nonatomic,strong) NSString *tradeType;
@property (nonatomic,assign) BOOL inFlag;
@property (nonatomic,strong) NSString *tradeTime;

@property (nonatomic,assign) double amt;

-(WalletTradeItem *)initWithDictionary:(NSDictionary *)noticeMsg;

@end

@interface FPWalletTradeList : NSObject

@property (readonly) BOOL   result;
@property (readonly) NSString *errorInfo;

@property (nonatomic,assign) NSInteger total;
@property (nonatomic,assign) NSInteger limit;
@property (nonatomic,assign) NSInteger start;

@property (nonatomic,strong) NSArray  *tradeList;

- (id)initWithAttributes:(NSDictionary *)attributes;

+ (void)getFPBillModelWithCardNo:(NSString *)cardNo
                     andMemberNo:(NSString *)memberNo
                        andStart:(NSString *)start 
                        andLimit:(NSString *)limit
                   andRecentDate:(NSString *)date
                        andBlock:(void(^)(FPWalletTradeList *billModel,NSError *error))block;
@end
