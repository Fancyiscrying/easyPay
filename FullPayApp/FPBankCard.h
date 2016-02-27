//
//  FPBankCard.h
//  FullPayApp
//
//  Created by mark zheng on 14-4-23.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FPBankCard : NSObject

@property (readonly) BOOL   result;
@property (readonly) NSString *errorInfo;

@property (nonatomic,strong) NSArray    *bankCard;
@property (nonatomic,assign) NSInteger cardsCount;

-(FPBankCard *)initWithAttributes:(NSDictionary *)attributes;
-(FPBankCard *)initWithAttributesMini:(NSDictionary *)attributes;

+ (void)getFPBankCardWithBlock:(void(^)(FPBankCard *cardInfo,NSError *error))block;
+ (void)delFPBankCardWithCardId:(NSString *)cardId andBlock:(void(^)(FPBankCard *cardInfo,NSError *error))block;

@end
