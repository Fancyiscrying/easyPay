//
//  FPClient.h
//  FullPayApp
//
//  Created by mark zheng on 14-2-21.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"
#import "NSString+md5.h"

@interface FPClient : AFHTTPRequestOperationManager


+(NSString *)ServerAddress;
+(FPClient *)sharedClient;

//登录
-(NSDictionary *)userLogin:(NSString *)mobile password:(NSString*)passwd;

//更改登录密码
-(NSDictionary *)userChangeLoginPwd:(NSString *)memberNo
                             andPwd:(NSString *)pwd
                          andOrgPwd:(NSString *)orgPwd;
//更改支付密码
-(NSDictionary *)userChangePayPwd:(NSString *)memberNo
                           andPwd:(NSString *)pwd
                        andOrgPwd:(NSString *)orgPwd;

//重置登录密码
//-(NSDictionary *)userResetLoginPwd:(NSString *)mobileNo
//                        andSmsCode:(NSString *)smsCode
//                         andNewPwd:(NSString *)newPwd;
-(NSDictionary *)userResetLoginPwd:(NSString *)mobileNo
                    andProcessCode:(NSString *)processCode
                        andSmsCode:(NSString *)smsCode
                         andNewPwd:(NSString *)newPwd;
//重置支付密码
//-(NSDictionary *)userResetPayPwd:(NSString *)mobileNo
//                      andSmsCode:(NSString *)smsCode
//                       andNewPwd:(NSString *)newPwd;
//重置支付密码新接口
-(NSDictionary *)userResetPayPwd:(NSString *)memberNo
                     andMobileNo:(NSString *)mobileNo
                  andProcessCode:(NSString *)processCode
                      andSmsCode:(NSString *)smsCode
                       andNewPwd:(NSString *)newPwd;
//通过mobile查找个人会员是否存在
- (NSDictionary *)findPersonMemberExistByMobile:(NSString *)mobileNo;

//用户注册
-(NSDictionary *)userRegister:(NSString *)mobileNo
                  andPassword:(NSString *)passwd
                    andPayPwd:(NSString *)payPwd
                   andSmsCode:(NSString *)smsCode;
//用户注册新方法含短信验证随机码 personalRegisterProcessService
-(NSDictionary *)userRegister:(NSString *)mobileNo
                  andPassword:(NSString *)passwd
                    andPayPwd:(NSString *)payPwd
                   andSmsCode:(NSString *)smsCode
               andProcessCode:(NSString *)processCode;

//获取手机宝令
- (NSDictionary *)findSecretWithMobile:(NSString *)mobile
                           andMemberNo:(NSString *)memberNo;

//发送短信验证码
-(NSDictionary *)userSendSms:(NSString *)mobile withExpireSeconds:(NSString *)expireSeconds;
//验证短信验证码
-(NSDictionary *)userSmsCodeVerify:(NSString *)mobileNo andSmsCode:(NSString *)smsCode;
//注册短信验证带返回随机码
-(NSDictionary *)userSmsCodeVerify:(NSString *)mobileNo andSmsCode:(NSString *)smsCode andProcessFlag:(BOOL)processFlag;

//个人账户信息
-(NSDictionary *)userAccount:(NSString *)memberNo;

//查询优惠动态和私信的个数
- (NSDictionary *)findTheNewMarketingAndMessageCount:(NSString *)lastDate
                                         andSignDate:(NSDate *)signDate
                                                 and:(NSString *)memberNo;

//查询私信列表
- (NSDictionary *)findMineMessageInfoPage:(NSString *)start
                            andCreateDate:(NSDate *)createDate
                                 andLimit:(NSString *)limit
                              andMemberNo:(NSString *)memberNo;
//获取私信详情
- (NSDictionary *)findMessageInfoMessageId:(NSString *)messageId andMemberNo:(NSString *)memberNo andReaded:(BOOL)readed;

//账单分析查询
-(NSDictionary *)userTradeStatistics:(NSString *)memberNo;
-(NSDictionary *)userTradeQuery:(NSString *)memberNo
                       andLimit:(NSString *)limit
                       andStart:(NSString *)start
                      andCardNo:(NSString *)cardNo
                andBusinessType:(NSString *)businessType
                  andBusinessNo:(NSString *)businessNo
                   andBeginTime:(NSString *)beginTime
                     andEndTime:(NSString *)endTime;
//营销活动查询
-(NSDictionary *)userMarketingQuery:(NSString *)memberNo
                           andLimit:(NSString *)limit
                           andStart:(NSString *)start
                           andEmail:(NSString *)email
                    andActivityName:(NSString *)activityName
                    andActivityType:(NSString *)activityType
                  andActivityStatus:(NSString *)activityStatus
                       andBeginTime:(NSString *)beginTime
                         andEndTime:(NSString *)endTime;

/*
 更新个人注册手机
 */
-(NSDictionary *)userMobileUpdate:(NSString *)memberNo
                      andMobileNo:(NSString *)mobileNo
                        andPayPsw:(NSString *)payPsw;
/*个人账户额度设置*/
-(NSDictionary *)userInformationUpdate:(NSString *)memberNo
                         andNoPswLimit:(NSString *)noPswLimit
                           andPayLimit:(NSString *)payLimit
                           andNoteList:(NSString *)noteLimit;
/*个人支付额度开关设置*/
-(NSDictionary *)userInformationUpdate:(NSString *)memberNo
                       andNoPswLimitOn:(BOOL)noPswLimitOn
                         andPayLimitOn:(BOOL)payLimitOn
                         andNoteListOn:(BOOL)noteLimitOn;
/*上传个人图片*/
-(NSDictionary *)userImageUpload:(NSString *)memberNo;
//-(void)uploadImage:(NSData *)imageData andParameter:parameters;

-(NSDictionary *)userInformation:(NSString *)mobileNo;
-(NSDictionary *)userCardsInfo:(NSString *)memberNo;
-(NSDictionary *)userCardStatus:(NSString *)cardNo withCardStatus:(NSString *)cardStatus;

//修改卡备注信息
-(NSDictionary *)userCardRemark:(NSString *)cardNo andUserDesc:(NSString *)remark;

//实名认证
-(NSDictionary *)userIdentityVerification:(NSString *)memberNo
                            andMemberName:(NSString*)memberName
                                andCertNo:(NSString *)certNo
                          andCertTypeCode:(NSString *)certTypeCode;
//实名认证新接口
-(NSDictionary *)userStaffCheck:(NSString *)memberNo
                  andMemberName:(NSString*)memberName
               andJobNumFoxconn:(NSString *)jobNumFoxconn;

-(NSDictionary *)userCertCheck:(NSString *)memberNo
                     andCertNo:(NSString*)certNo
               andCertTypeCode:(NSString *)certTypeCode;

-(NSDictionary *)userIdCheckSubmit:(NSString *)memberNo
                     andMemberName:(NSString*)memberName
                         andCertNo:(NSString *)certNo
                   andCertTypeCode:(NSString *)certTypeCode
                  andJobNumFoxconn:(NSString *)jobNumFoxconn
                         andPayPwd:(NSString *)payPwd;

/*卡校验*/
-(NSDictionary *)userCardBindCheck:(NSString *)memberNo
                         andCardNo:(NSString *)cardNo
                       andSignCode:(NSString *)signCode;
/*卡绑定*/
-(NSDictionary *)userCardBinding:(NSString *)memberNo
                       andCardNo:(NSString *)cardNo
                     andSignCode:(NSString *)signCode
                   andCardRemark:(NSString *)cardRemark;

-(NSDictionary *)userCardNoPasswordAmount:(NSString *)cardNo withNopwdAmt:(NSString *)nopwdAmt;

//转账
-(NSDictionary *)userTransfer:(NSString *)memberNo
                andInMemberNo:(NSString *)inMemberNo
                       andAmt:(NSString *)amt
                  andPassword:(NSString *)password
                    andRemark:(NSString *)remark;

-(NSDictionary *)userSupportBankList:(NSString *)memberNo;
-(NSDictionary *)userAddBankCard:(NSString *)memberNo
                   andBankCardNo:(NSString *)bankcardNo
                     andBankCode:(NSString *)bankCode
                     andBankName:(NSString *)bankName;
-(NSDictionary *)userDelBankCard:(NSString *)memberNo andCardId:(NSString *)cardId;
-(NSDictionary *)userBankCardList:(NSString *)memberNo;

//转账到银行卡
-(NSDictionary *)userWithdrawWithMemberNo:(NSString *)memberNo
                                   andAmt:(NSString *)amt
                              andPassword:(NSString *)password
                      andMemberBankCardId:(NSString*)memberBankCardId;

//充值
-(NSDictionary *)userRechargeByPINGAN:(NSString *)memberNo andAmt:(NSString *)amt andBankCardId:(NSString *)bankCardId;

//手机版本检查
-(NSDictionary*)userMobileVersion:(NSString *)mobileVersion andOpenFlag:(BOOL)flag;

//充话费-通过手机号获取运营商等信息
-(NSDictionary *)userMobileFee:(NSString *)mobileNo;

//充话费-根据用户选择进行充值
-(NSDictionary *)userRechargeMobileFee:(NSString *)memberNo andMobileNo:(NSString *)mobileNo andOptionId:(NSInteger)optionId andPayPwd:(NSString *)payPwd;
//彩票接口
-(NSDictionary *)userFindLottery;
-(NSDictionary *)userLotteryGenerateSign:(NSString *)memberNo;
- (NSDictionary *)findGpcLotteryResource;

/**大礼包接口**/
- (NSDictionary *)userfulllifeService;


//富钱包
//1、查询富钱包卡交易
- (NSDictionary *)findOfflineTradeCardNo:(NSString *)cardNo andMemberNo:(NSString *)memberNo andLimit:(NSString *)limit
                                andStart:(NSString *)start andRecentDate:(NSString *)date;
//2、富钱包卡充值请求
- (NSDictionary *)rechargeRequestWithCardNo:(NSString *)cardNo andAmt:(NSString *)amt andMemberNo:(NSString *)memberNo;

//#pragma mark 3、富钱包卡充值请求后支付
- (NSDictionary *)rechargePaymentWithTradeNo:(NSString*)tradeNo andPassword:(NSString *)password;

//查询关联钱包卡
- (NSDictionary *)findCardRelateWithMemberNo:(NSString *)memberNo;

//会员关联卡详情
- (NSDictionary *)findCardRelateDetailWithCardNo:(NSString *)cardNo;

//添加钱包卡
- (NSDictionary *)addCardRelateWithMemberNo:(NSString *)memberNo andCardNo:(NSString *)cardNo;

//删除钱包卡
- (NSDictionary *)deleteCardRelateWithCardId:(NSString *)cardId;

//实名卡申请
- (NSDictionary *)applyCardWithMemberNo:(NSString *)memberNo;

//实名卡挂失
- (NSDictionary *)lossCardWithCardNo:(NSString *)cardNo andPayPwd:(NSString *)payPwd;

//实名卡解挂
- (NSDictionary *)removeLossCardWithCardNo:(NSString *)cardNo andPayPwd:(NSString *)payPwd;

//实名卡解绑
- (NSDictionary *)unBindCardWithCardNo:(NSString *)cardNo andPayPwd:(NSString *)payPwd;

//实名卡补卡
- (NSDictionary *)changeCardWithCardNo:(NSString *)cardNo andPayPwd:(NSString *)payPwd andChangeCardNo:(NSString *)changeCardNo;

//查询实名卡申请
- (NSDictionary *)findCardApplyWithMemberNo:(NSString *)memberNo;

/**
 *  查询会员可转入余额的实名卡卡号列表
 *
 *  @param memberNo 挂失的卡号
 *
 *  @return 参数字典
 */
- (NSDictionary *)findCanChangeCardWithMemberNo:(NSString *)memberNo;

//收支明细统计
- (NSDictionary *)findMonthStsWithAccountNo:(NSString *)accountNo andStart:(NSString*)start;

//关于红包
//#pragma mark 查询用户当前红包状态，包括当前红包派发信息、红包余额
- (NSDictionary *)findCurrentRePacketInfoWithMemberNo:(NSString *)memberNo;
//#pragma mark 查询发出的红包
- (NSDictionary *)findDistributedRedPacketWithMemberNo:(NSString *)memberNo
                                              andLimit:(NSString *)limit
                                              andStart:(NSString *)start;
//#pragma mark 查询领到的红包
- (NSDictionary *)findReceivedRedPacketWithMemberNo:(NSString *)memberNo
                                           andLimit:(NSString *)limit
                                           andStart:(NSString *)start;
//#pragma mark 提现
- (NSDictionary *)withdrawWithAccountNo:(NSString *)accountNo;
//#pragma mark 提现记录查询
- (NSDictionary *)findRedPacketWithdrawFromAppWithMemberNo:(NSString *)memberNo
                                              andAccountNo:(NSString *)accountNo
                                                  andLimit:(NSString *)limit
                                                  andStart:(NSString *)start;
//#pragma mark 派发红包
- (NSDictionary *)distributeWithMemberNo:(NSString *)memberNo
                           andTotalCount:(NSString *)totalCount
                                  andAmt:(NSString *)amt
                            andAddRemark:(NSString *)addRemark;
//#pragma mark 7、支付派发红包所需金额
- (NSDictionary *)distributePayWithDistributeId:(NSString *)distributeId andPassword:(NSString *)password;
//#pragma mark 8、终止派发红包
- (NSDictionary *)stopDistributeWithDistributeId:(NSString *)distributeId;
//#pragma mark 9、领取红包
- (NSDictionary *)receiveWithReceiveNo:(NSString *)receiveNo andMemberNo:(NSString *)memberNo;
//#pragma mark 10、领取红包后答谢留言
- (NSDictionary *)receiveRemarkWithRedPacketId:(NSString *)redPacketId andRemark:(NSString *)remark;
//#pragma mark 11、用户获取新红包编号
- (NSDictionary *)getNewRedPacketToDistributeWithCurrentRePacketId:(NSString *)currentRePacketId;
//#pragma mark 12、根据会员编号获取会员头像
- (NSDictionary *)headImageByMember:(NSString *)headMemberNo;
//关于消息推送
//注册推送账号
- (NSDictionary *)addBoundInfoChannelId:(NSString *)channelId andUserId:(NSString *)userId andAppId:(NSString *)appId andMemberNo:(NSString *)memberNo;


@end
