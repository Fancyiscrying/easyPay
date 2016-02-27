//
//  FPFutongCard.m
//  FullPayApp
//
//  Created by mark zheng on 14-2-26.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPFutongCard.h"

@implementation FPFutongCardItem

-(id)initWithDictionary:(NSDictionary *)attributes
{
    self.cardNo = [attributes objectForKey:@"cardNo"];
    self.memberNo = [attributes objectForKey:@"memberNo"];
    self.memberName = [attributes objectForKey:@"memberName"];
    self.bindDate = [attributes objectForKey:@"bindDate"];
    self.openDate = [attributes objectForKey:@"openDate"];
    self.cancelDate = [attributes objectForKey:@"cancelDate"];
    self.cardShape = [[attributes objectForKey:@"cardShape"] intValue];
    self.cardType = [[attributes objectForKey:@"cardType"] intValue];
    
    self.remark = [attributes objectForKey:@"remark"];
    self.cardStatus = [attributes objectForKey:@"cardStatus"];
    self.useDesc = [attributes objectForKey:@"useDesc"];

    return self;
}

@end

@implementation FPFutongCard
    
-(FPFutongCard *)initWithAttributes:(NSDictionary *)attributes
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

                for (NSDictionary *cardInfo in object) {
                    FPFutongCardItem *cardItem = [[FPFutongCardItem alloc] initWithDictionary:cardInfo];
                    if ([cardItem.cardStatus isEqualToString:@"CANCEL"]) {
                        self.cardsCount -= 1;
                    }
                    [cardsArray addObject:cardItem];
                }
                
                self.futongCard = cardsArray;
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

+ (void)getFPFutongCardWithBlock:(void(^)(FPFutongCard *cardInfo,NSError *error))block
{
    NSString *memberNo = [Config Instance].memberNo;
    
    FPClient *urlClient = [FPClient sharedClient];
    NSDictionary *parameters = [urlClient userCardsInfo:memberNo];
    
    [urlClient POST:kFPPost parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        FPDEBUG(@"getFPFutongCardWithBlock:%@",responseObject);
        FPFutongCard *futongCard = [[FPFutongCard alloc] initWithAttributes:responseObject];
        if (block) {
            block(futongCard,nil);
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(nil,error);
        }
    }];
}

@end
