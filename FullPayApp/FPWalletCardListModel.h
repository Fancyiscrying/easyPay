//
//  FPWalletCardListModel.h
//  FullPayApp
//
//  Created by 刘通超 on 15/4/7.
//  Copyright (c) 2015年 fullpay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WalletCardDetilItem : NSObject


@property (nonatomic,strong) NSString *accountNo;
/**
 *  cardId 关联id
 */
@property (nonatomic,strong) NSString *cardNo;
@property (nonatomic,strong) NSString *changeStatus;
@property (nonatomic,assign) BOOL realFlag;
@property (nonatomic,assign) BOOL lossFlag;
@property (nonatomic,strong) NSString *statusName;
@property (nonatomic,strong) NSString *time;
@property (nonatomic,strong) NSString *tradeTime;
@property (nonatomic,assign) double balance;
@property (nonatomic,strong) NSString *cardId;
@property (nonatomic,assign) NSInteger lossStatus;

@end

@interface WalletCardListItem : NSObject

@property (nonatomic,strong) NSString *accountNo;
@property (nonatomic,strong) NSString *cardNo;
@property (nonatomic,assign) BOOL realFlag;
@property (nonatomic,assign) BOOL lossFlag;
@property (nonatomic,strong) NSString *cardId;

@end

@interface FPWalletCardListModel : NSObject

@property (nonatomic, strong) NSString *errorCode;
@property (nonatomic, strong) NSString *errorInfo;
@property (nonatomic, assign) BOOL result;
@property (nonatomic, strong) NSMutableArray *carList;

+(void)findCardRelate:(NSString *)memberNo andBlock:(void(^)(FPWalletCardListModel* cardListModel ,NSError *error))block;

@end
