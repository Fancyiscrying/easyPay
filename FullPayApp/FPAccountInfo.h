//
//  FPAccountInfo.h
//  FullPayApp
//
//  Created by mark zheng on 14-2-26.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 
 accountAmount = 98889616;
 cardsAccount = 1;
 memberNo = 1647375948596656495;
 
 */

@interface FPAccountInfoItem : NSObject

@property (nonatomic,copy) NSString *accountAmount;
@property (nonatomic,copy) NSString   *fumiCount;
@property (nonatomic,assign) NSInteger cardsAccount;
@property (nonatomic,assign) NSInteger bankCardCount;

-(id)initWithDictionary:(NSDictionary *)attributes;

@end

@interface FPAccountInfo : NSObject

@property (readonly) BOOL   result;
@property (readonly) NSString *errorInfo;

@property (nonatomic,strong) FPAccountInfoItem    *accountItem;

-(FPAccountInfo *)initWithAttributes:(NSDictionary *)attributes;
+ (void)getFPAccountInfoWithBlock:(void(^)(FPAccountInfo *cardInfo,NSError *error))block;

@end
