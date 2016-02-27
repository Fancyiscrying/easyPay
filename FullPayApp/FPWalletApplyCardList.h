//
//  FPWalletApplyCardList.h
//  FullPayApp
//
//  Created by 刘通超 on 15/4/10.
//  Copyright (c) 2015年 fullpay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ApplyItem : NSObject

@property (nonatomic, strong) NSString *applyDate;
@property (nonatomic, strong) NSString *applyTime;
@property (nonatomic, strong) NSString *cardNo;
@property (nonatomic, assign) int status;
@property (nonatomic, strong) NSString *statusName;

@end

@interface ApplyTotalItem : NSObject
@property (nonatomic, strong) NSString *applyCount;
@property (nonatomic, strong) NSString *drawCount;
@property (nonatomic, strong) NSString *totalCount;

@end

@interface FPWalletApplyCardList : NSObject

@property (nonatomic, strong) NSString *errorCode;
@property (nonatomic, strong) NSString *errorInfo;
@property (nonatomic, assign) BOOL result;
@property (nonatomic, strong) ApplyTotalItem *totalItem;
@property (nonatomic, strong) NSArray *applyList;


+ (void)getCardApplyWithMemberNo:(NSString *)memberNo andBlock:(void(^)(FPWalletApplyCardList *applyCardList, NSError *error))block;

@end
