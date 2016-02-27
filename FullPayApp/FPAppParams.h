//
//  FPAppParams.h
//  FullPayApp
//
//  Created by mark zheng on 14-2-21.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 params =         {
 allUserRgeMinAmount = 1000;
 customerServiceTelephone = "0755-27048606";
 noteLimitOff = 500000;
 noteLimitOn = 5000;
 realNameAcctMaxBalance = 100000;
 realNameBindCardLimit = 3;
 realNamePayMaxAmount = 30000;
 realNameRgeMaxAmount = 50000;
 unRealNameAcctMaxBalance = 50000;
 unRealNameBindCardLimit = 1;
 unRealNamePayMaxAmount = 10000;
 unRealNameRgeMaxAmount = 10000;
 };
 
 realNameRgeMaxAmount	实名用户单笔最大充值金额（分）
 unRealNameRgeMaxAmount	非实名用户单笔最大充值金额（分）
 allUserRgeMinAmount	所有用户单笔最小充值金额（分）
 realNameAcctMaxBalance	实名用户账户最大余额（分）
 unRealNameAcctMaxBalance	非实名用户账户最大余额（分）
 realNamePayMaxAmount	实名用户单笔最大支出金额（分）
 unRealNamePayMaxAmount	非实名用户单笔最大支出金额（分）
 realNameBindCardLimit	实名用户绑卡数量
 unRealNameBindCardLimit	非实名用户绑卡数量
 noPswAmountLimit	免密支付限额
 noteLimitOn	消费支出额度短信提醒开关打开（分）
 noteLimitOff	消费支出额度短信提醒开关关闭（分）
 customerServiceTelephone	客服电话
 
 offlineRgeMinAmount 富钱包卡充值最小金额
 offlineRgeMaxAmount 富钱包卡充值最大金额
 
 withdrawFee = 100;         *个人会员提现手续费
 withdrawFeeMode = COUNT;   *个人会员提现手续费收取类型：按笔收取COUNT、按费率收取RATE
 withdrawMaxFeeAmt = 20000; *个人会员提现最大手续费
 withdrawMinAmt = 1000;     *个人会员提现最小金额
 
 offlineLossEffectiveTime   *富钱包卡挂失生效时间（天）
 
 realNamePayAmountLimit     * 实名用户每天累计支出金额上限（分）
 unRealNamePayAmountLimit   * 非实名用户每天累计支出金额上限（分）
 */

@interface FPAppParams : NSObject

@property (nonatomic,strong) NSString *customerServiceTelephone;
@property (nonatomic,strong) NSString *noteLimitOn;
@property (nonatomic,strong) NSString *noteLimitOff;
@property (nonatomic,strong) NSString *allUserRgeMinAmount;
@property (nonatomic,strong) NSString *realNameAcctMaxBalance;
@property (nonatomic,strong) NSString *realNameBindCardLimit;
@property (nonatomic,strong) NSString *realNamePayMaxAmount;
@property (nonatomic,strong) NSString *realNameRgeMaxAmount;
@property (nonatomic,strong) NSString *unRealNameAcctMaxBalance;
@property (nonatomic,strong) NSString *unRealNameBindCardLimit;
@property (nonatomic,strong) NSString *noPswAmountLimit;
@property (nonatomic,strong) NSString *unRealNamePayMaxAmount;
@property (nonatomic,strong) NSString *unRealNameRgeMaxAmount;

@property (nonatomic,strong) NSString *realNamePayAmountLimit;
@property (nonatomic,strong) NSString *unRealNamePayAmountLimit;

@property (nonatomic,strong) NSString *offlineRgeMinAmount;
@property (nonatomic,strong) NSString *offlineRgeMaxAmount;

@property (nonatomic,strong) NSString *withdrawFee;
@property (nonatomic,strong) NSString *withdrawFeeMode;
@property (nonatomic,strong) NSString *withdrawMaxFeeAmt;
@property (nonatomic,strong) NSString *withdrawMinAmt;

@property (nonatomic,strong) NSString *offlineLossEffectiveTime;


- (id)initWithAttributes:(NSDictionary *)attributes;

@end
