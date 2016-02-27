//
//  FPBankCard.m
//  FullPayApp
//
//  Created by mark zheng on 14-4-23.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPBankCard.h"

@implementation FPBankCard

-(FPBankCard *)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _result = [[attributes objectForKey:@"result"] boolValue];
    if (_result) {
        if ([attributes objectForKey:@"returnObj"] != [NSNull null]) {
            
            NSArray *object = [attributes objectForKey:@"returnObj"];
            self.cardsCount = [object count];
            FPDEBUG(@"count:%ld",(long)self.cardsCount);
            if (self.cardsCount > 0) {
                NSMutableArray *cardsArray = [NSMutableArray arrayWithCapacity:self.cardsCount];
                
//                for (NSDictionary *cardInfo in object) {
//                    FPFutongCardItem *cardItem = [[FPFutongCardItem alloc] initWithDictionary:cardInfo];
//                    if ([cardItem.cardStatus isEqualToString:@"CANCEL"]) {
//                        self.cardsCount -= 1;
//                    }
//                    [cardsArray addObject:cardItem];
//                }
                
                self.bankCard = cardsArray;
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
    
    return self;
}

-(FPBankCard *)initWithAttributesMini:(NSDictionary *)attributes
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _result = [[attributes objectForKey:@"result"] boolValue];
    if (_result) {
        
    } else {
        _errorInfo = [attributes objectForKey:@"errorInfo"];
    }
    
    return self;
}

+ (void)getFPBankCardWithBlock:(void(^)(FPBankCard *cardInfo,NSError *error))block
{
    NSString *memberNo = [Config Instance].memberNo;
    
    FPClient *urlClient = [FPClient sharedClient];
    NSDictionary *parameters = [urlClient userBankCardList:memberNo];
    
    [urlClient POST:kFPPost parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        FPDEBUG(@"getFPBankCardWithBlock:%@",responseObject);
        FPBankCard *resultInfo = [[FPBankCard alloc] initWithAttributes:responseObject];
        if (block) {
            block(resultInfo,nil);
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(nil,error);
        }
    }];
}

+ (void)delFPBankCardWithCardId:(NSString *)cardId andBlock:(void(^)(FPBankCard *cardInfo,NSError *error))block
{
    NSString *memberNo = [Config Instance].memberNo;
    
    FPClient *urlClient = [FPClient sharedClient];
    NSDictionary *parameters = [urlClient userDelBankCard:memberNo andCardId:cardId];
    
    [urlClient POST:kFPPost parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        FPDEBUG(@"delFPBankCardWithCardId:%@",responseObject);
        FPBankCard *resultInfo = [[FPBankCard alloc] initWithAttributesMini:responseObject];
        if (block) {
            block(resultInfo,nil);
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(nil,error);
        }
    }];
}

@end
