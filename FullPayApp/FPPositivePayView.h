//
//  FPPositivePayView.h
//  FullPayApp
//
//  Created by 刘通超 on 14/11/24.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactsInfo.h"
#import "FPPassCodeView.h"

@protocol FPPositivePayViewDelegate <NSObject>
@optional
- (void)positivePayViewHasPayAway;
- (void)positivePayViewHasPayAwayWithButtonIndex:(NSInteger)buttonIndex;
@end

@interface FPPositivePayView : UIView<UITableViewDataSource,UITableViewDelegate,FPPassCodeViewDelegate>

@property (nonatomic,strong) ContactsInfo  *transferData;
@property (nonatomic,strong) id<FPPositivePayViewDelegate> delegate;

//输入密码支付
- (id)initWithInputPassWordView:(BOOL)hasPass andWithRemark:(BOOL)hasMark;
//红包支付
- (id)initWithRedPackteTypeWithParamters:(NSDictionary *)paramters andHasPass:(BOOL)hasPass;
//富钱包卡充值
- (id)initWithFullWalletTypeWithParamters:(NSDictionary *)paramters andHasPass:(BOOL)hasPass;
//手机充值
- (id)initWithMobileRechargeTypeWithParamters:(NSDictionary *)paramters andHasPass:(BOOL)hasPass;
//转账到银行卡
- (id)initWithWithdrawTypeWithParamters:(NSDictionary *)paramters andHasPass:(BOOL)hasPass;
@end
