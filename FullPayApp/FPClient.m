//
//  FPClient.m
//  FullPayApp
//
//  Created by mark zheng on 14-2-21.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPClient.h"

#ifdef DEBUG
#ifdef CAIPIAOTEST
static NSString *const kFPBaseUrl = @"http://test.futongcard.com:6082";
#else
static NSString *const kFPBaseUrl = @"http://10.146.65.80";
#endif
#else
static NSString *const kFPBaseUrl = @"http://mobile.futongcard.com";
static NSString *const kFPHighLotteryUrl = @"http://polariszi.eicp.net:18223/lottery-wap/loginverity/FULLPAY.htm";
#endif

const NSInteger kRemarkLen = 10;

@implementation FPClient

+(NSString *)ServerAddress
{
    return kFPBaseUrl;
}

+(FPClient *)sharedClient
{
    static FPClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[[self class] alloc] initWithBaseURL:[NSURL URLWithString:kFPBaseUrl]];
        _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    });
    
    return _sharedClient;
}

-(id)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if (!self) {    
        return nil;
    }
    
    [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [self.requestSerializer setTimeoutInterval:10];
    
    return self;
}

#pragma mark //转账

-(NSDictionary *)userTransfer:(NSString *)memberNo
                andInMemberNo:(NSString *)inMemberNo
                       andAmt:(NSString *)amt
                  andPassword:(NSString *)password
                    andRemark:(NSString *)remark
{
    NSString *serviceName = @"transferService";
    NSString *token = [Config Instance].token;
    
    NSLog(@"amt=%@password=%@remark=%@",amt,password,remark);
    
    NSString *jsonStr = nil;
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:memberNo forKey:@"memberNo"];
    NSLog(@"inMemberNo=%@",inMemberNo);
    
    if (inMemberNo.length > 0 || inMemberNo != NULL) {
        [userInfo setObject:inMemberNo forKey:@"inMemberNo"];
    }
    [userInfo setObject:amt forKey:@"amt"];
    if (![password isEqualToString:@""] && password.length>0) {
        NSString *passwordmd5 = [password md5Twice:@"timessharing"];
        [userInfo setObject:passwordmd5 forKey:@"password"];
    }
    [userInfo setObject:@"IOS" forKey:@"businessSource"];
    if (remark != nil) {
        [userInfo setObject:remark forKey:@"remark"];
    }
    [userInfo setObject:token forKey:@"token"];
    if ([NSJSONSerialization isValidJSONObject:userInfo]) {
        NSError *error;
        NSData *userData = [NSJSONSerialization dataWithJSONObject:userInfo options:kNilOptions error:&error];
        
        jsonStr = [[NSString alloc] initWithData:userData encoding:NSUTF8StringEncoding];
        
        FPDEBUG(@"user Json:%@",jsonStr);
    }
    
    NSDictionary *parameters = [self makeParameter:serviceName withJson:jsonStr];
    
    FPDEBUG(@"%@",parameters);
    
    return parameters;
}

#pragma mark //多少金额需要输入密码
/*
 多少金额需要输入密码：
 cardNoPasswordAmountService
 cardNo:
 nopwdAmt:
 */
-(NSDictionary *)userCardNoPasswordAmount:(NSString *)cardNo withNopwdAmt:(NSString *)nopwdAmt
{
    NSString *serviceName = @"cardNoPasswordAmountService";
    NSString *jsonStr = nil;
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:cardNo,@"cardNo",nopwdAmt,@"nopwdAmt",nil];
    if ([NSJSONSerialization isValidJSONObject:userInfo]) {
        NSError *error;
        NSData *userData = [NSJSONSerialization dataWithJSONObject:userInfo options:kNilOptions error:&error];
        
        jsonStr = [[NSString alloc] initWithData:userData encoding:NSUTF8StringEncoding];
        
        FPDEBUG(@"user Json:%@",jsonStr);
    }
    
    NSDictionary *parameters = [self makeParameter:serviceName withJson:jsonStr];
    
    FPDEBUG(@"%@",parameters);
    
    return parameters;
}

#pragma mark // /*卡校验*/
-(NSDictionary *)userCardBindCheck:(NSString *)memberNo
                         andCardNo:(NSString *)cardNo
                       andSignCode:(NSString *)signCode
{
    NSString *bindType = @"preBind";
    
    return [self cardBinding:bindType andMemberNo:memberNo andCardNo:cardNo andSignCode:signCode andBusinessSource:nil andOperatorNo:nil andCardRemark:nil];
}

#pragma mark // /*卡绑定*/
-(NSDictionary *)userCardBinding:(NSString *)memberNo
                       andCardNo:(NSString *)cardNo
                     andSignCode:(NSString *)signCode
                   andCardRemark:(NSString *)cardRemark
{
    NSString *bindType = @"bind";
    NSString *businessSource = @"IOS";
    NSString *operatorNo = @"mark";
    
    return [self cardBinding:bindType andMemberNo:memberNo andCardNo:cardNo andSignCode:signCode andBusinessSource:businessSource andOperatorNo:operatorNo andCardRemark:cardRemark];
}

#pragma mark // 卡绑定(通用，使用于卡校验和卡绑定)

/*
 卡绑定(通用，使用于卡校验和卡绑定)
 */
-(NSDictionary *)cardBinding:(NSString *)bindType
                 andMemberNo:(NSString *)memberNo
                   andCardNo:(NSString *)cardNo
                 andSignCode:(NSString *)signCode
           andBusinessSource:(NSString *)businessSource
               andOperatorNo:(NSString *)operatorNo
               andCardRemark:(NSString *)cardRemark
{
    NSString *serviceName = @"cardBindingService";
    NSString *token = [Config Instance].token;
    NSString *jsonStr = nil;
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:bindType forKey:@"bindType"];
    [userInfo setObject:cardNo forKey:@"cardNo"];
    [userInfo setObject:signCode forKey:@"signCode"];
    [userInfo setObject:memberNo forKey:@"memberNo"];
    if ([bindType isEqualToString:@"bind"]) {
        [userInfo setObject:businessSource forKey:@"businessSource"];
        [userInfo setObject:operatorNo forKey:@"operatorNo"];
        if (cardRemark != nil && cardRemark.length > 0) {
            if (cardRemark.length > kRemarkLen) {
                [userInfo setObject:[cardRemark substringToIndex:kRemarkLen] forKey:@"cardRemark"];
            } else {
                [userInfo setObject:cardRemark forKey:@"cardRemark"];
            }
        }
    }
    [userInfo setObject:token forKey:@"token"];
    
    if ([NSJSONSerialization isValidJSONObject:userInfo]) {
        NSError *error;
        NSData *userData = [NSJSONSerialization dataWithJSONObject:userInfo options:kNilOptions error:&error];
        
        jsonStr = [[NSString alloc] initWithData:userData encoding:NSUTF8StringEncoding];
        
        FPDEBUG(@"user Json:%@",jsonStr);
    }
    
    NSDictionary *parameters = [self makeParameter:serviceName withJson:jsonStr];
    
    FPDEBUG(@"%@",parameters);
    
    return parameters;
}
#pragma mark //卡状态操作：
/*
 卡状态操作：
 cardStatusService
 cardNo:
 cardStatus:
 
 * 正常
 NORMAL("正常"),
 
 * 冻结
 FREEZE("冻结"),
 
 * 挂失
 LOSS("挂失"),
 
 * 注销（卡只有在与会员绑定，变成实名卡后才允许被注销）
 CANCEL("已注销");
 */

-(NSDictionary *)userCardStatus:(NSString *)cardNo withCardStatus:(NSString *)cardStatus
{
    NSString *serviceName = @"cardStatusService";
    NSString *token = [Config Instance].token;
    NSString *jsonStr = nil;
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:cardNo,@"cardNo",cardStatus,@"cardStatus",token,@"token",nil];
    if ([NSJSONSerialization isValidJSONObject:userInfo]) {
        NSError *error;
        NSData *userData = [NSJSONSerialization dataWithJSONObject:userInfo options:kNilOptions error:&error];
        
        jsonStr = [[NSString alloc] initWithData:userData encoding:NSUTF8StringEncoding];
        
        FPDEBUG(@"user Json:%@",jsonStr);
    }
    
    NSDictionary *parameters = [self makeParameter:serviceName withJson:jsonStr];
    
    FPDEBUG(@"%@",parameters);
    
    return parameters;
}

#pragma mark // /*修改卡备注信息*/
-(NSDictionary *)userCardRemark:(NSString *)cardNo andUserDesc:(NSString *)remark
{
    NSString *serviceName = @"modifyCardRemarkService";
    NSString *token = [Config Instance].token;
    NSString *jsonStr = nil;
    NSString *strRemark = remark;
    if (remark.length > kRemarkLen) {
        strRemark = [remark substringToIndex:kRemarkLen];
    }
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:cardNo,@"cardNo",strRemark,@"useDesc",token,@"token",nil];
    if ([NSJSONSerialization isValidJSONObject:userInfo]) {
        NSError *error;
        NSData *userData = [NSJSONSerialization dataWithJSONObject:userInfo options:kNilOptions error:&error];
        
        jsonStr = [[NSString alloc] initWithData:userData encoding:NSUTF8StringEncoding];
        
        FPDEBUG(@"user Json:%@",jsonStr);
    }
    
    NSDictionary *parameters = [self makeParameter:serviceName withJson:jsonStr];
    
    FPDEBUG(@"%@",parameters);
    
    return parameters;
}
#pragma mark //  查用户绑定的卡信息
/*
 查用户绑定的卡信息
 cardsInfoService
 memberNo:
 */
-(NSDictionary *)userCardsInfo:(NSString *)memberNo
{
    NSString *serviceName = @"cardsInfoService";
    NSString *token = [Config Instance].token;
    NSString *jsonStr = nil;
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:memberNo,@"memberNo",token,@"token",nil];
    if ([NSJSONSerialization isValidJSONObject:userInfo]) {
        NSError *error;
        NSData *userData = [NSJSONSerialization dataWithJSONObject:userInfo options:kNilOptions error:&error];
        
        jsonStr = [[NSString alloc] initWithData:userData encoding:NSUTF8StringEncoding];
        
        FPDEBUG(@"user Json:%@",jsonStr);
    }
    
    NSDictionary *parameters = [self makeParameter:serviceName withJson:jsonStr];
    
    FPDEBUG(@"%@",parameters);
    
    return parameters;
}
#pragma mark // 更新个人账户额度设置
/*
 更新个人账户额度设置
 */
-(NSDictionary *)userInformationUpdate:(NSString *)memberNo
                         andNoPswLimit:(NSString *)noPswLimit
                           andPayLimit:(NSString *)payLimit
                           andNoteList:(NSString *)noteLimit
{
    NSString *serviceName = @"personalInfoService";
    NSString *token = [Config Instance].token;
    NSString *jsonStr = nil;
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:memberNo forKey:@"memberNo"];
    [userInfo setObject:@"yes" forKey:@"needUpdate"];
    if (noPswLimit != nil && [noPswLimit isEqualToString:@""] != YES) {
        [userInfo setObject:noPswLimit forKey:@"noPswLimit"];
    }
    if (payLimit != nil && [payLimit isEqualToString:@""] != YES) {
        [userInfo setObject:payLimit forKey:@"payLimit"];
    }
    if (noteLimit != nil && [noteLimit isEqualToString:@""] != YES) {
        [userInfo setObject:noteLimit forKey:@"noteLimit"];
    }
    
    [userInfo setObject:token forKey:@"token"];
    
    if ([NSJSONSerialization isValidJSONObject:userInfo]) {
        NSError *error;
        NSData *userData = [NSJSONSerialization dataWithJSONObject:userInfo options:kNilOptions error:&error];
        
        jsonStr = [[NSString alloc] initWithData:userData encoding:NSUTF8StringEncoding];
        
        FPDEBUG(@"user Json:%@",jsonStr);
    }
    
    NSDictionary *parameters = [self makeParameter:serviceName withJson:jsonStr];
    
    FPDEBUG(@"%@",parameters);
    
    return parameters;
}
#pragma mark // 更新个人支付额度开关设置
/*
 更新个人支付额度开关设置
 */
-(NSDictionary *)userInformationUpdate:(NSString *)memberNo
                       andNoPswLimitOn:(BOOL)noPswLimitOn
                         andPayLimitOn:(BOOL)payLimitOn
                         andNoteListOn:(BOOL)noteLimitOn
{
    NSString *serviceName = @"personalInfoService";
    NSString *token = [Config Instance].token;
    NSString *jsonStr = nil;
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:memberNo forKey:@"memberNo"];
    [userInfo setObject:@"yes" forKey:@"needUpdate"];
    NSNumber *switchOn;
    if ((int)noPswLimitOn != -1) {
        switchOn = [NSNumber numberWithBool:noPswLimitOn];
        [userInfo setObject:switchOn forKey:@"noPswLimitOn"];
    }
    if ((int)payLimitOn != -1) {
        switchOn = [NSNumber numberWithBool:payLimitOn];
        [userInfo setObject:switchOn forKey:@"payLimitOn"];
    }
    if ((int)noteLimitOn != -1) {
        switchOn = [NSNumber numberWithBool:noteLimitOn];
        [userInfo setObject:switchOn forKey:@"noteLimitOn"];
    }
    
    [userInfo setObject:token forKey:@"token"];
    
    if ([NSJSONSerialization isValidJSONObject:userInfo]) {
        NSError *error;
        NSData *userData = [NSJSONSerialization dataWithJSONObject:userInfo options:kNilOptions error:&error];
        
        jsonStr = [[NSString alloc] initWithData:userData encoding:NSUTF8StringEncoding];
        
        FPDEBUG(@"user Json:%@",jsonStr);
    }
    
    NSDictionary *parameters = [self makeParameter:serviceName withJson:jsonStr];
    
    FPDEBUG(@"%@",parameters);
    
    return parameters;
}
#pragma mark // 更新个人注册手机

/*
 更新个人注册手机
 */
-(NSDictionary *)userMobileUpdate:(NSString *)memberNo
                      andMobileNo:(NSString *)mobileNo
                        andPayPsw:(NSString *)payPsw
{
    NSString *serviceName = @"personalService";
    NSString *serviceFunction = @"updatePersonMobile";
    NSString *token = [Config Instance].token;
    NSString *jsonStr = nil;
    NSString *pwdStr = [payPsw md5Twice:@"timessharing"];
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:memberNo forKey:@"memberNo"];
    //[userInfo setObject:@"yes" forKey:@"needUpdate"];
    [userInfo setObject:mobileNo forKey:@"mobile"];
    [userInfo setObject:pwdStr forKey:@"payPsw"];
    [userInfo setObject:token forKey:@"token"];
    [userInfo setObject:serviceFunction forKey:@"serviceFunction"];
    
    if ([NSJSONSerialization isValidJSONObject:userInfo]) {
        NSError *error;
        NSData *userData = [NSJSONSerialization dataWithJSONObject:userInfo options:kNilOptions error:&error];
        
        jsonStr = [[NSString alloc] initWithData:userData encoding:NSUTF8StringEncoding];
        
        FPDEBUG(@"user Json:%@",jsonStr);
    }
    
    NSDictionary *parameters = [self makeParameter:serviceName withJson:jsonStr];
    
    FPDEBUG(@"%@",parameters);
    
    return parameters;
}
#pragma mark // 个人账户
/*
 个人账户
 personalInfoService
 mobileNo
 */
-(NSDictionary *)userInformation:(NSString *)mobileNo
{
    NSString *serviceName = @"personalInfoService";
    NSString *token = [Config Instance].token;
    NSString *jsonStr = nil;
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:mobileNo,@"mobileNo",@"no",@"needUpdate",token,@"token",nil];
    if ([NSJSONSerialization isValidJSONObject:userInfo]) {
        NSError *error;
        NSData *userData = [NSJSONSerialization dataWithJSONObject:userInfo options:kNilOptions error:&error];
        
        jsonStr = [[NSString alloc] initWithData:userData encoding:NSUTF8StringEncoding];
        
        FPDEBUG(@"user Json:%@",jsonStr);
    }
    
    NSDictionary *parameters = [self makeParameter:serviceName withJson:jsonStr];
    
    FPDEBUG(@"%@",parameters);
    
    return parameters;
}
#pragma mark 二进制png图像
/*
 personInfoService
 needUpdate:yes
 head:(二进制png图像)
 memberNo:
 */
-(NSDictionary *)userImageUpload:(NSString *)memberNo
{
    NSString *serviceName = @"personalInfoService";
    NSString *token = [Config Instance].token;
    
    NSString *jsonStr = nil;
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:memberNo,@"memberNo",@"yes",@"needUpdate",token,@"token",nil];
    if ([NSJSONSerialization isValidJSONObject:userInfo]) {
        NSError *error;
        NSData *userData = [NSJSONSerialization dataWithJSONObject:userInfo options:kNilOptions error:&error];
        
        jsonStr = [[NSString alloc] initWithData:userData encoding:NSUTF8StringEncoding];
        
        FPDEBUG(@"user Json:%@",jsonStr);
    }
    
    NSDictionary *parameters = [self makeParameter:serviceName withJson:jsonStr];
    
    FPDEBUG(@"%@",parameters);
    
    return parameters;
}
#pragma mark //统计信息，
/*
 tradeStatisticsService
 统计信息，
 memberNo
 */
-(NSDictionary *)userTradeStatistics:(NSString *)memberNo
{
    NSString *serviceName = @"tradeStatisticsService";
    NSString *token = [Config Instance].token;
    NSString *jsonStr = nil;
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:memberNo,@"memberNo",token,@"token",nil];
    if ([NSJSONSerialization isValidJSONObject:userInfo]) {
        NSError *error;
        NSData *userData = [NSJSONSerialization dataWithJSONObject:userInfo options:kNilOptions error:&error];
        
        jsonStr = [[NSString alloc] initWithData:userData encoding:NSUTF8StringEncoding];
        
        FPDEBUG(@"user Json:%@",jsonStr);
    }
    
    NSDictionary *parameters = [self makeParameter:serviceName withJson:jsonStr];
    
    FPDEBUG(@"%@",parameters);
    
    return parameters;
}

#pragma mark // //交易记录和账单查询
/*
 memberNo       Xsd:String	会员号
 limit          Xsd:String	一页最多多少条
 start          Xsd:String	起始点，其值为（页数-1）乘以limit
 cardNo         Xsd:String	卡号（可选）
 businessType	Xsd:String	业务类型（可选）
 businessNo     Xsd:String	业务编号（可选）
 beginTime      Xsd:String	交易时间-从（可选）
 endTime        Xsd:String	交易时间-到（可选）
 
 */
-(NSDictionary *)userTradeQuery:(NSString *)memberNo
                       andLimit:(NSString *)limit
                       andStart:(NSString *)start
                      andCardNo:(NSString *)cardNo
                andBusinessType:(NSString *)businessType
                  andBusinessNo:(NSString *)businessNo
                   andBeginTime:(NSString *)beginTime
                     andEndTime:(NSString *)endTime {
    NSString *serviceName = @"tradeQueryService";
    NSString *token = [Config Instance].token;
    NSString *jsonStr = nil;
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:memberNo forKey:@"memberNo"];
    [userInfo setObject:limit forKey:@"limit"];
    [userInfo setObject:start forKey:@"start"];
    if (cardNo != nil) {
        [userInfo setObject:cardNo forKey:@"cardNo"];
    }
    if (businessType != nil) {
        [userInfo setObject:businessType forKey:@"businessType"];
    }
    if (businessNo != nil) {
        [userInfo setObject:businessNo forKey:@"businessNo"];
    }
    if (beginTime != nil) {
        [userInfo setObject:beginTime forKey:@"beginTime"];
    }
    if (endTime != nil) {
        [userInfo setObject:endTime forKey:@"endTime"];
    }
    [userInfo setObject:token forKey:@"token"];
    if ([NSJSONSerialization isValidJSONObject:userInfo]) {
        NSError *error;
        NSData *userData = [NSJSONSerialization dataWithJSONObject:userInfo options:kNilOptions error:&error];
        
        jsonStr = [[NSString alloc] initWithData:userData encoding:NSUTF8StringEncoding];
        
        FPDEBUG(@"user Json:%@",jsonStr);
    }
    
    NSDictionary *parameters = [self makeParameter:serviceName withJson:jsonStr];
    
    FPDEBUG(@"%@",parameters);
    
    return parameters;
}

#pragma mark // //营销活动查询
/*
 memberNo       Xsd:String	会员号
 limit          Xsd:String	一页最多多少条
 start          Xsd:String	起始点，其值为（页数-1）乘以limit
 cardNo         Xsd:String	卡号（可选）
 businessType	Xsd:String	业务类型（可选）
 businessNo     Xsd:String	业务编号（可选）
 beginTime      Xsd:String	交易时间-从（可选）
 endTime        Xsd:String	交易时间-到（可选）
 
 */
-(NSDictionary *)userMarketingQuery:(NSString *)memberNo
                           andLimit:(NSString *)limit
                           andStart:(NSString *)start
                           andEmail:(NSString *)email
                    andActivityName:(NSString *)activityName
                    andActivityType:(NSString *)activityType
                  andActivityStatus:(NSString *)activityStatus
                       andBeginTime:(NSString *)beginTime
                         andEndTime:(NSString *)endTime {
    NSString *serviceName = @"merchantDiscountInfoService";
    NSString *token = [Config Instance].token;
    NSString *jsonStr = nil;
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:limit forKey:@"limit"];
    [userInfo setObject:start forKey:@"start"];
    
    if (memberNo != nil) {
        [userInfo setObject:memberNo forKey:@"memberNo"];
    }
    if (email != nil) {
        [userInfo setObject:email forKey:@"email"];
    }
    if (activityName != nil) {
        [userInfo setObject:activityName forKey:@"activityName"];
    }
    if (activityType != nil) {
        [userInfo setObject:activityType forKey:@"activityType"];
    }
    if (activityStatus != nil) {
        [userInfo setObject:activityStatus forKey:@"activityStatus"];
    }
    if (beginTime != nil) {
        [userInfo setObject:beginTime forKey:@"beginTime"];
    }
    if (endTime != nil) {
        [userInfo setObject:endTime forKey:@"endTime"];
    }
    if (token!=nil) {
        [userInfo setObject:token forKey:@"token"];
    }
    
    if ([NSJSONSerialization isValidJSONObject:userInfo]) {
        NSError *error;
        NSData *userData = [NSJSONSerialization dataWithJSONObject:userInfo options:kNilOptions error:&error];
        
        jsonStr = [[NSString alloc] initWithData:userData encoding:NSUTF8StringEncoding];
        
        FPDEBUG(@"user Json:%@",jsonStr);
    }
    
    NSDictionary *parameters = [self makeParameter:serviceName withJson:jsonStr];
    
    FPDEBUG(@"%@",parameters);
    
    return parameters;
}


#pragma mark // //查询账户 personalAccountService
-(NSDictionary *)userAccount:(NSString *)memberNo
{
    NSString *serviceName = @"personalAccountService";
    
    NSString *token = [Config Instance].token;
    NSString *jsonStr = nil;
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:memberNo,@"memberNo",token,@"token",nil];
    if ([NSJSONSerialization isValidJSONObject:userInfo]) {
        NSError *error;
        NSData *userData = [NSJSONSerialization dataWithJSONObject:userInfo options:kNilOptions error:&error];
        
        jsonStr = [[NSString alloc] initWithData:userData encoding:NSUTF8StringEncoding];
        
        FPDEBUG(@"user Json:%@",jsonStr);
    }
    
    NSDictionary *parameters = [self makeParameter:serviceName withJson:jsonStr];
    
    FPDEBUG(@"%@",parameters);
    
    return parameters;
}

#pragma mark // //更改登录密码
-(NSDictionary *)userChangeLoginPwd:(NSString *)memberNo
                             andPwd:(NSString *)pwd
                          andOrgPwd:(NSString *)orgPwd
{
    NSString *pwdType = @"LOGINPWD";
    return  [self userChangePwd:memberNo andPwdType:pwdType andPwd:pwd andOrgPwd:orgPwd];
}

#pragma mark // //更改支付密码
-(NSDictionary *)userChangePayPwd:(NSString *)memberNo
                           andPwd:(NSString *)pwd
                        andOrgPwd:(NSString *)orgPwd
{
    NSString *pwdType = @"PAYPWD";
    return  [self userChangePwd:memberNo andPwdType:pwdType andPwd:pwd andOrgPwd:orgPwd];
}

#pragma mark // 更改密码（登录密码和支付密码）
/*
 更改密码（登录密码和支付密码）
 pwdSettingService
 pwdType：PAYPWD,LOGINPWD
 private Long memberNo;* 会员号 编号规则
 private String pwd;* 新密码(已加密)
 private String orgPwd; * 原密码(已加密)
 */

-(NSDictionary *)userChangePwd:(NSString *)memberNo
                    andPwdType:(NSString *)pwdType
                        andPwd:(NSString *)pwd
                     andOrgPwd:(NSString *)orgPwd
{
    NSString *serviceName = @"pwdSettingService";
    NSString *token = [Config Instance].token;
    NSString *jsonStr = nil;
    NSString *pwdStr = [pwd md5Twice:@"timessharing"];
    NSString *orgPwdStr = [orgPwd md5Twice:@"timessharing"];
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:memberNo forKey:@"memberNo"];
    [userInfo setObject:pwdType  forKey:@"pwdType"];
    [userInfo setObject:pwdStr forKey:@"pwd"];
    [userInfo setObject:orgPwdStr forKey:@"orgPwd"];
    [userInfo setObject:token forKey:@"token"];
    
    if ([NSJSONSerialization isValidJSONObject:userInfo]) {
        NSError *error;
        NSData *userData = [NSJSONSerialization dataWithJSONObject:userInfo options:kNilOptions error:&error];
        
        jsonStr = [[NSString alloc] initWithData:userData encoding:NSUTF8StringEncoding];
        
        FPDEBUG(@"user Json:%@",jsonStr);
    }
    
    NSDictionary *parameters = [self makeParameter:serviceName withJson:jsonStr];
    
    FPDEBUG(@"%@",parameters);
    
    return parameters;
}

#pragma mark // //重置登录密码
-(NSDictionary *)userResetLoginPwd:(NSString *)mobileNo
                    andProcessCode:(NSString *)processCode
                        andSmsCode:(NSString *)smsCode
                         andNewPwd:(NSString *)newPwd
{
    NSString *serviceName = @"resetLoginPwdService";
    NSString *jsonStr = nil;
    NSString *pwd = [newPwd md5Twice:@"timessharing"];
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:mobileNo forKey:@"mobileNo"];
    [userInfo setObject:processCode  forKey:@"processCode"];
    [userInfo setObject:pwd forKey:@"newPwd"];
    [userInfo setObject:smsCode forKey:@"smsCode"];
    
    if ([NSJSONSerialization isValidJSONObject:userInfo]) {
        NSError *error;
        NSData *userData = [NSJSONSerialization dataWithJSONObject:userInfo options:kNilOptions error:&error];
        
        jsonStr = [[NSString alloc] initWithData:userData encoding:NSUTF8StringEncoding];
        
        FPDEBUG(@"user Json:%@",jsonStr);
    }
    
    NSDictionary *parameters = [self makeParameter:serviceName withJson:jsonStr];
    
    FPDEBUG(@"%@",parameters);
    
    return parameters;
}
#pragma mark // //重置支付密码新接口
-(NSDictionary *)userResetPayPwd:(NSString *)memberNo
                     andMobileNo:(NSString *)mobileNo
                  andProcessCode:(NSString *)processCode
                      andSmsCode:(NSString *)smsCode
                       andNewPwd:(NSString *)newPwd
{
    NSString *serviceName = @"resetPayPwdService";
    NSString *jsonStr = nil;
    NSString *pwd = [newPwd md5Twice:@"timessharing"];
    NSString *token = [Config Instance].token;
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:memberNo forKey:@"memberNo"];
    [userInfo setObject:mobileNo forKey:@"mobileNo"];
    [userInfo setObject:processCode  forKey:@"processCode"];
    [userInfo setObject:pwd forKey:@"newPwd"];
    [userInfo setObject:smsCode forKey:@"smsCode"];
    [userInfo setObject:token forKey:@"token"];
    
    if ([NSJSONSerialization isValidJSONObject:userInfo]) {
        NSError *error;
        NSData *userData = [NSJSONSerialization dataWithJSONObject:userInfo options:kNilOptions error:&error];
        
        jsonStr = [[NSString alloc] initWithData:userData encoding:NSUTF8StringEncoding];
        
        FPDEBUG(@"user Json:%@",jsonStr);
    }
    
    NSDictionary *parameters = [self makeParameter:serviceName withJson:jsonStr];
    
    FPDEBUG(@"%@",parameters);
    
    return parameters;
}

#pragma mark // //重置密码（登录密码和支付密码）PAYPWD/LOGINPWD
-(NSDictionary *)userResetPwd:(NSString *)mobileNo
                   andPwdType:(NSString *)pwdType
                   andSmsCode:(NSString *)smsCode
                    andNewPwd:(NSString *)newPwd
{
    NSString *serviceName = @"resetPwdService";
    NSString *jsonStr = nil;
    NSString *pwd = [newPwd md5Twice:@"timessharing"];
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:mobileNo forKey:@"mobileNo"];
    [userInfo setObject:pwdType  forKey:@"pwdType"];
    [userInfo setObject:smsCode forKey:@"smsCode"];
    [userInfo setObject:pwd forKey:@"newPwd"];
    
    if ([NSJSONSerialization isValidJSONObject:userInfo]) {
        NSError *error;
        NSData *userData = [NSJSONSerialization dataWithJSONObject:userInfo options:kNilOptions error:&error];
        
        jsonStr = [[NSString alloc] initWithData:userData encoding:NSUTF8StringEncoding];
        
        FPDEBUG(@"user Json:%@",jsonStr);
    }
    
    NSDictionary *parameters = [self makeParameter:serviceName withJson:jsonStr];
    
    FPDEBUG(@"%@",parameters);
    
    return parameters;
}

#pragma mark // //发送短信
-(NSDictionary *)userSendSms:(NSString *)mobile withExpireSeconds:(NSString *)expireSeconds
{
    NSString *serviceName = @"smsValidationCodeSenderService";
    NSString *jsonStr = nil;
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:mobile,@"mobile",expireSeconds,@"expireSeconds" ,nil];
    if ([NSJSONSerialization isValidJSONObject:userInfo]) {
        NSError *error;
        NSData *userData = [NSJSONSerialization dataWithJSONObject:userInfo options:kNilOptions error:&error];
        
        jsonStr = [[NSString alloc] initWithData:userData encoding:NSUTF8StringEncoding];
        
        FPDEBUG(@"user Json:%@",jsonStr);
    }
    
    NSDictionary *parameters = [self makeParameter:serviceName withJson:jsonStr];
    
    FPDEBUG(@"%@",parameters);
    
    return parameters;
}

#pragma mark // //注册短信验证
-(NSDictionary *)userSmsCodeVerify:(NSString *)mobileNo andSmsCode:(NSString *)smsCode
{
    NSString *serviceName = @"smsValidationCodeVerifyService";
    NSString *jsonStr = nil;
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:mobileNo,@"mobile",smsCode,@"smsCode" ,nil];
    if ([NSJSONSerialization isValidJSONObject:userInfo]) {
        NSError *error;
        NSData *userData = [NSJSONSerialization dataWithJSONObject:userInfo options:kNilOptions error:&error];
        
        jsonStr = [[NSString alloc] initWithData:userData encoding:NSUTF8StringEncoding];
        
        FPDEBUG(@"user Json:%@",jsonStr);
    }
    
    NSDictionary *parameters = [self makeParameter:serviceName withJson:jsonStr];
    
    FPDEBUG(@"%@",parameters);
    
    return parameters;
}

#pragma mark //通过mobile查找个人会员是否存在

- (NSDictionary *)findPersonMemberExistByMobile:(NSString *)mobileNo{
    NSString *serviceName = @"personalService";
    NSString *jsonStr = nil;
    NSString *serviceFunction = @"findPersonMemberExistByMobile";
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setValue:serviceFunction forKey:@"serviceFunction"];
    if (mobileNo.length>0) {
        [userInfo setValue:mobileNo forKey:@"mobile"];
    }
    if ([NSJSONSerialization isValidJSONObject:userInfo]) {
        NSError *error;
        NSData *userData = [NSJSONSerialization dataWithJSONObject:userInfo options:kNilOptions error:&error];
        jsonStr = [[NSString alloc]initWithData:userData encoding:NSUTF8StringEncoding];
        FPDEBUG(@"user Json:%@",jsonStr);
    }
    
    NSDictionary *paramters = [self makeParameter:serviceName withJson:jsonStr];
    return paramters;

}

#pragma mark // //注册短信验证带返回随机码
-(NSDictionary *)userSmsCodeVerify:(NSString *)mobileNo andSmsCode:(NSString *)smsCode andProcessFlag:(BOOL)processFlag
{
    NSString *serviceName = @"smsValidationCodeVerifyService";
    NSString *jsonStr = nil;
    NSNumber *flagOn = [NSNumber numberWithBool:processFlag];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:mobileNo,@"mobile",smsCode,@"smsCode" ,flagOn,@"processFlag",nil];
    if ([NSJSONSerialization isValidJSONObject:userInfo]) {
        NSError *error;
        NSData *userData = [NSJSONSerialization dataWithJSONObject:userInfo options:kNilOptions error:&error];
        
        jsonStr = [[NSString alloc] initWithData:userData encoding:NSUTF8StringEncoding];
        
        FPDEBUG(@"user Json:%@",jsonStr);
    }
    
    NSDictionary *parameters = [self makeParameter:serviceName withJson:jsonStr];
    
    FPDEBUG(@"%@",parameters);
    
    return parameters;
}

#pragma mark // //用户注册新方法含短信验证随机码
-(NSDictionary *)userRegister:(NSString *)mobileNo
                  andPassword:(NSString *)passwd
                    andPayPwd:(NSString *)payPwd
                   andSmsCode:(NSString *)smsCode
               andProcessCode:(NSString *)processCode
{
    NSString *serviceName = @"personalRegisterProcessService";
    
    NSString *jsonStr = nil;
    NSString *pwd = [passwd md5Twice:@"timessharing"];
    NSString *securpwd = [payPwd md5Twice:@"timessharing"];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:mobileNo,@"mobileNo",pwd,@"pwd",securpwd,@"payPwd",smsCode,@"smsCode",processCode,@"processCode",nil];
    if ([NSJSONSerialization isValidJSONObject:userInfo]) {
        NSError *error;
        NSData *userData = [NSJSONSerialization dataWithJSONObject:userInfo options:kNilOptions error:&error];
        
        jsonStr = [[NSString alloc] initWithData:userData encoding:NSUTF8StringEncoding];
        
        FPDEBUG(@"user Json:%@",jsonStr);
    }
    
    NSDictionary *parameters = [self makeParameter:serviceName withJson:jsonStr];
    
    FPDEBUG(@"%@",parameters);
    
    return parameters;
}
#pragma mark  //获取手机宝令
//获取手机宝令
- (NSDictionary *)findSecretWithMobile:(NSString *)mobile
                           andMemberNo:(NSString *)memberNo{
    NSString *serviceName = @"secretService";
    NSString *token = [Config Instance].token;
    NSString *jsonStr = nil;
    NSString *serviceFunction = @"findSecret";
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:serviceFunction forKey:@"serviceFunction"];
    
    if (memberNo != nil && memberNo.length>0) {
        [userInfo setObject:memberNo forKey:@"memberNo"];
    }
    if (mobile != nil && mobile.length>0) {
        [userInfo setObject:mobile forKey:@"mobile"];
    }
    if (token != nil && token.length>0) {
        [userInfo setObject:token forKey:@"token"];
    }
    
    if ([NSJSONSerialization isValidJSONObject:userInfo]) {
        NSError *error;
        NSData *userData = [NSJSONSerialization dataWithJSONObject:userInfo options:kNilOptions error:&error];
        
        jsonStr = [[NSString alloc] initWithData:userData encoding:NSUTF8StringEncoding];
        
        FPDEBUG(@"user Json:%@",jsonStr);
    }
    
    NSDictionary *parameters = [self makeParameter:serviceName withJson:jsonStr];
    
    FPDEBUG(@"%@",parameters);
    
    return parameters;

}

#pragma mark // //用户注册
-(NSDictionary *)userRegister:(NSString *)mobileNo
                  andPassword:(NSString *)passwd
                    andPayPwd:(NSString *)payPwd
                   andSmsCode:(NSString *)smsCode
{
    NSString *serviceName = @"personalRegisterService";
    
    NSString *jsonStr = nil;
    NSString *pwd = [passwd md5Twice:@"timessharing"];
    NSString *securpwd = [payPwd md5Twice:@"timessharing"];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:mobileNo,@"mobileNo",pwd,@"pwd",securpwd,@"payPwd",smsCode,@"smsCode",nil];
    if ([NSJSONSerialization isValidJSONObject:userInfo]) {
        NSError *error;
        NSData *userData = [NSJSONSerialization dataWithJSONObject:userInfo options:kNilOptions error:&error];
        
        jsonStr = [[NSString alloc] initWithData:userData encoding:NSUTF8StringEncoding];
        
        FPDEBUG(@"user Json:%@",jsonStr);
    }
    
    NSDictionary *parameters = [self makeParameter:serviceName withJson:jsonStr];
    
    FPDEBUG(@"%@",parameters);
    
    return parameters;
}


#pragma mark // //用户登录
-(NSDictionary *)userLogin:(NSString *)mobile password:(NSString*)passwd
{
    NSString *serviceName = @"personalLoginService";
    NSString *jsonStr = nil;
    NSString *pwd = [passwd md5Twice:@"timessharing"];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:mobile,@"mobile",pwd,@"pwd" ,nil];
    if ([NSJSONSerialization isValidJSONObject:userInfo]) {
        NSError *error;
        NSData *userData = [NSJSONSerialization dataWithJSONObject:userInfo options:kNilOptions error:&error];
        
        jsonStr = [[NSString alloc] initWithData:userData encoding:NSUTF8StringEncoding];
        
        FPDEBUG(@"user Json:%@",jsonStr);
    }
    
    NSDictionary *parameters = [self makeParameter:serviceName withJson:jsonStr];
    
    FPDEBUG(@"%@",parameters);
    
    return parameters;
}
#pragma mark //实名认证
/*
 实名认证
 memberName
 certTypeCode I_CARD
 certNo
 memberNo
 */
-(NSDictionary *)userIdentityVerification:(NSString *)memberNo
                            andMemberName:(NSString*)memberName
                                andCertNo:(NSString *)certNo
                          andCertTypeCode:(NSString *)certTypeCode
{
    NSString *serviceName = @"personalVerificationService";
    NSString *token = [Config Instance].token;
    NSString *jsonStr = nil;
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:memberNo forKey:@"memberNo"];
    [userInfo setObject:memberName forKey:@"memberName"];
    [userInfo setObject:certTypeCode forKey:@"certTypeCode"];
    [userInfo setObject:certNo forKey:@"certNo"];
    [userInfo setObject:token forKey:@"token"];
    
    if ([NSJSONSerialization isValidJSONObject:userInfo]) {
        NSError *error;
        NSData *userData = [NSJSONSerialization dataWithJSONObject:userInfo options:kNilOptions error:&error];
        
        jsonStr = [[NSString alloc] initWithData:userData encoding:NSUTF8StringEncoding];
        
        FPDEBUG(@"user Json:%@",jsonStr);
    }
    
    NSDictionary *parameters = [self makeParameter:serviceName withJson:jsonStr];
    
    FPDEBUG(@"%@",parameters);
    
    return parameters;
}
#pragma mark // //实名认证新接口
-(NSDictionary *)userStaffCheck:(NSString *)memberNo
                  andMemberName:(NSString*)memberName
               andJobNumFoxconn:(NSString *)jobNumFoxconn
{
    NSString *serviceFunction = @"authenticationJobNum";
    return [self userIdentityVerification:memberNo andMemberName:memberName andCertNo:nil andCertTypeCode:nil andJobNumFoxconn:jobNumFoxconn andPayPwd:nil andServiceFunction:serviceFunction];
}

-(NSDictionary *)userCertCheck:(NSString *)memberNo
                     andCertNo:(NSString*)certNo
               andCertTypeCode:(NSString *)certTypeCode

{
    NSString *serviceFunction = @"authenticationCert";
    return [self userIdentityVerification:memberNo andMemberName:nil andCertNo:certNo andCertTypeCode:certTypeCode andJobNumFoxconn:nil andPayPwd:nil andServiceFunction:serviceFunction];
}
-(NSDictionary *)userIdCheckSubmit:(NSString *)memberNo
                     andMemberName:(NSString*)memberName
                         andCertNo:(NSString *)certNo
                   andCertTypeCode:(NSString *)certTypeCode
                  andJobNumFoxconn:(NSString *)jobNumFoxconn
                         andPayPwd:(NSString *)payPwd
{
    NSString *serviceFunction = @"authentication";
    return [self userIdentityVerification:memberNo andMemberName:memberName andCertNo:certNo andCertTypeCode:certTypeCode andJobNumFoxconn:jobNumFoxconn  andPayPwd:payPwd andServiceFunction:serviceFunction];
}

-(NSDictionary *)userIdentityVerification:(NSString *)memberNo
                            andMemberName:(NSString*)memberName
                                andCertNo:(NSString *)certNo
                          andCertTypeCode:(NSString *)certTypeCode
                         andJobNumFoxconn:(NSString *)jobNumFoxconn
                                andPayPwd:(NSString *)payPwd
                       andServiceFunction:(NSString *)serviceFunction
{
    NSString *serviceName = @"personalAuthenticationService";
    NSString *token = [Config Instance].token;
    NSString *jsonStr = nil;
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:serviceFunction forKey:@"serviceFunction"];
    [userInfo setObject:memberNo forKey:@"memberNo"];
    if (memberName && memberName.length > 0) {
        [userInfo setObject:memberName forKey:@"memberName"];
    }
    
    if (certTypeCode && certTypeCode.length > 0) {
        [userInfo setObject:certTypeCode forKey:@"certTypeCode"];
        [userInfo setObject:certNo forKey:@"certNo"];
    }
    
    if (jobNumFoxconn && jobNumFoxconn.length > 0) {
        [userInfo setObject:jobNumFoxconn forKey:@"jobNumFoxconn"];
    }
    if (payPwd && payPwd.length > 0) {
        NSString *securpwd = [payPwd md5Twice:@"timessharing"];
        [userInfo setObject:securpwd forKey:@"payPwd"];
    }
    
    [userInfo setObject:token forKey:@"token"];
    
    if ([NSJSONSerialization isValidJSONObject:userInfo]) {
        NSError *error;
        NSData *userData = [NSJSONSerialization dataWithJSONObject:userInfo options:kNilOptions error:&error];
        
        jsonStr = [[NSString alloc] initWithData:userData encoding:NSUTF8StringEncoding];
        
        FPDEBUG(@"user Json:%@",jsonStr);
    }
    
    NSDictionary *parameters = [self makeParameter:serviceName withJson:jsonStr];
    
    FPDEBUG(@"%@",parameters);
    
    return parameters;
}

#pragma mark 关于消息推送

//注册推送账号
- (NSDictionary *)addBoundInfoChannelId:(NSString *)channelId andUserId:(NSString *)userId andAppId:(NSString *)appId andMemberNo:(NSString *)memberNo{
    NSString *serviceName = @"messageMsgService";
    NSString *token = [Config Instance].token;

    NSString *serviceFunction = @"addBoundInfo";
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:serviceFunction forKey:@"serviceFunction"];
    [userInfo setObject:@"FZF" forKey:@"appType"];
    [userInfo setObject:@"IOS" forKey:@"sysType"];
    if (memberNo != nil && memberNo.length>0) {
        [userInfo setObject:memberNo forKey:@"memberNo"];
    }
    if (token != nil && token.length>0) {
        [userInfo setObject:token forKey:@"token"];
    }
    if (appId != nil && appId.length>0) {
        [userInfo setObject:appId forKey:@"appId"];
    }
    if (channelId != nil && channelId.length>0) {
        [userInfo setObject:channelId forKey:@"channelId"];
    }
    if (userId != nil && userId.length>0) {
        [userInfo setObject:userId forKey:@"userId"];
    }
    NSString *jsonStr = nil;
    
    if ([NSJSONSerialization isValidJSONObject:userInfo]) {
        NSError *error;
        NSData *userData = [NSJSONSerialization dataWithJSONObject:userInfo options:kNilOptions error:&error];
        
        jsonStr = [[NSString alloc] initWithData:userData encoding:NSUTF8StringEncoding];
        
        FPDEBUG(@"user Json:%@",jsonStr);
    }
    
    return [self makeParameter:serviceName withJson:jsonStr];
}

#pragma mark //查询优惠动态和私信的个数
- (NSDictionary *)findTheNewMarketingAndMessageCount:(NSString *)lastDate
                                         andSignDate:(NSDate *)signDate
                                                 and:(NSString *)memberNo{
    
    NSString *serviceName = @"messageMsgService";
    NSString *token = [Config Instance].token;
    NSString *serviceFunction = @"marketingActivityAndMessage";
    NSString *jsonStr = nil;
    
    if (token == nil) {
        token = @"";
    }
    
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc]init];
    if (lastDate != nil) {
        [userInfo setObject:lastDate forKey:@"createDate"];
    }
    if (signDate != nil) {
        [userInfo setObject:signDate forKey:@"signDate"];
    }
    [userInfo setObject:memberNo forKey:@"memberNo"];
    [userInfo setObject:@"FZF" forKey:@"appType"];
    [userInfo setObject:serviceFunction forKey:@"serviceFunction"];
    [userInfo setObject:token forKey:@"token"];
    [userInfo setObject:@"IOS" forKey:@"sysType"];


    if ([NSJSONSerialization isValidJSONObject:userInfo]) {
        NSError *error;
        NSData *userData = [NSJSONSerialization dataWithJSONObject:userInfo options:kNilOptions error:&error];
        jsonStr = [[NSString alloc]initWithData:userData encoding:NSUTF8StringEncoding];
        FPDEBUG(@"user Json:%@",jsonStr);
    }
    
    NSDictionary *parameters = [self makeParameter:serviceName withJson:jsonStr];
    
    FPDEBUG(@"%@",parameters);
    
    return parameters;
}

#pragma mark //获取我的私信列表 FindMineMessageInfo

- (NSDictionary *)findMineMessageInfoPage:(NSString *)start
                            andCreateDate:(NSDate *)createDate
                             andLimit:(NSString *)limit
                          andMemberNo:(NSString *)memberNo{
    
    NSString *serviceName = @"messageMsgService";
    NSString *token = [Config Instance].token;
    NSString *serviceFunction = @"findMineMessageInfoPage";
    NSString *jsonStr = nil;
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:start forKey:@"start"];
    [userInfo setObject:limit forKey:@"limit"];
    [userInfo setObject:serviceFunction forKey:@"serviceFunction"];
    [userInfo setObject:@"FZF" forKey:@"appType"];
    [userInfo setObject:@"IOS" forKey:@"sysType"];

    if (token != nil && token.length>0) {
        [userInfo setObject:token forKey:@"token"];

    }
    if (memberNo != nil && memberNo.length>0) {
        [userInfo setObject:memberNo forKey:@"memberNo"];
        
    }
    if (createDate != nil) {
        [userInfo setObject:createDate forKey:@"createDate"];
    }
    
    if ([NSJSONSerialization isValidJSONObject:userInfo]) {
        NSError *error;
        NSData *userData = [NSJSONSerialization dataWithJSONObject:userInfo options:kNilOptions error:&error];
        jsonStr = [[NSString alloc]initWithData:userData encoding:NSUTF8StringEncoding];
        FPDEBUG(@"user Json:%@",jsonStr);
    }
    
    NSDictionary *parameters = [self makeParameter:serviceName withJson:jsonStr];
    
    FPDEBUG(@"%@",parameters);
    
    return parameters;
}

#pragma mark //查询私信详情
- (NSDictionary *)findMessageInfoMessageId:(NSString *)messageId andMemberNo:(NSString *)memberNo andReaded:(BOOL)readed{
    NSString *serviceName = @"messageMsgService";
    NSString *serviceFunction = @"findMessageInfo";
    NSString *token = [Config Instance].token;
    NSString *jsonStr = nil;
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    
    [userInfo setObject:serviceFunction forKey:@"serviceFunction"];
    
    if (readed) {
        [userInfo setObject:@"true" forKey:@"readed"];
    }else{
        [userInfo setObject:@"false" forKey:@"readed"];
    }
    
    if (token != nil && token.length>0) {
        [userInfo setObject:token forKey:@"token"];
    }
    if (memberNo != nil && memberNo.length>0) {
        [userInfo setObject:memberNo forKey:@"memberNo"];
    }
    if (messageId != nil && messageId.length>0) {
        [userInfo setObject:messageId forKey:@"id"];
    }
    if ([NSJSONSerialization isValidJSONObject:userInfo]) {
        NSError*error;
        NSData *userData = [NSJSONSerialization dataWithJSONObject:userInfo options:kNilOptions error:&error];
        jsonStr = [[NSString alloc]initWithData:userData encoding:NSUTF8StringEncoding];
        FPDEBUG(@"user Json:%@",jsonStr);
    }
    
    NSDictionary *parameters = [self makeParameter:serviceName withJson:jsonStr];
    FPDEBUG(@"findMessageInfo:%@",parameters);
    
    return parameters;
    
}

#pragma mark // //银行卡列表
-(NSDictionary *)userSupportBankList:(NSString *)memberNo
{
    NSString *serviceName = @"bankCardMgrService";
    NSString *token = [Config Instance].token;
    
    NSString *jsonStr = nil;
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:@"findSupportBank" forKey:@"serviceFunction"];
    [userInfo setObject:memberNo forKey:@"memberNo"];
    [userInfo setObject:token forKey:@"token"];
    if ([NSJSONSerialization isValidJSONObject:userInfo]) {
        NSError *error;
        NSData *userData = [NSJSONSerialization dataWithJSONObject:userInfo options:kNilOptions error:&error];
        
        jsonStr = [[NSString alloc] initWithData:userData encoding:NSUTF8StringEncoding];
        
        FPDEBUG(@"user Json:%@",jsonStr);
    }
    
    NSDictionary *parameters = [self makeParameter:serviceName withJson:jsonStr];
    
    FPDEBUG(@"%@",parameters);
    
    return parameters;
}

-(NSDictionary *)userAddBankCard:(NSString *)memberNo
                   andBankCardNo:(NSString *)bankcardNo
                     andBankCode:(NSString *)bankCode
                     andBankName:(NSString *)bankName
{
    NSString *serviceName = @"bankCardMgrService";
    NSString *token = [Config Instance].token;
    
    NSString *jsonStr = nil;
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:@"addBankCard" forKey:@"serviceFunction"];
    [userInfo setObject:memberNo forKey:@"memberNo"];
    [userInfo setObject:bankcardNo forKey:@"bankcardNo"];
    [userInfo setObject:bankCode forKey:@"bankCode"];
    [userInfo setObject:bankName forKey:@"bankName"];
    [userInfo setObject:token forKey:@"token"];
    if ([NSJSONSerialization isValidJSONObject:userInfo]) {
        NSError *error;
        NSData *userData = [NSJSONSerialization dataWithJSONObject:userInfo options:kNilOptions error:&error];
        
        jsonStr = [[NSString alloc] initWithData:userData encoding:NSUTF8StringEncoding];
        
        FPDEBUG(@"user Json:%@",jsonStr);
    }
    
    NSDictionary *parameters = [self makeParameter:serviceName withJson:jsonStr];
    
    FPDEBUG(@"%@",parameters);
    
    return parameters;
}

-(NSDictionary *)userDelBankCard:(NSString *)memberNo andCardId:(NSString *)cardId
{
    NSString *serviceName = @"bankCardMgrService";
    NSString *token = [Config Instance].token;
    
    NSString *jsonStr = nil;
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:@"delBankCard" forKey:@"serviceFunction"];
    [userInfo setObject:memberNo forKey:@"memberNo"];
    [userInfo setObject:cardId forKey:@"id"];
    [userInfo setObject:token forKey:@"token"];
    if ([NSJSONSerialization isValidJSONObject:userInfo]) {
        NSError *error;
        NSData *userData = [NSJSONSerialization dataWithJSONObject:userInfo options:kNilOptions error:&error];
        
        jsonStr = [[NSString alloc] initWithData:userData encoding:NSUTF8StringEncoding];
        
        FPDEBUG(@"user Json:%@",jsonStr);
    }
    
    NSDictionary *parameters = [self makeParameter:serviceName withJson:jsonStr];
    
    FPDEBUG(@"%@",parameters);
    
    return parameters;
}
-(NSDictionary *)userBankCardList:(NSString *)memberNo
{
    NSString *serviceName = @"bankCardMgrService";
    NSString *token = [Config Instance].token;
    
    NSString *jsonStr = nil;
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:@"findBankCards" forKey:@"serviceFunction"];
    [userInfo setObject:memberNo forKey:@"memberNo"];
    [userInfo setObject:token forKey:@"token"];
    if ([NSJSONSerialization isValidJSONObject:userInfo]) {
        NSError *error;
        NSData *userData = [NSJSONSerialization dataWithJSONObject:userInfo options:kNilOptions error:&error];
        
        jsonStr = [[NSString alloc] initWithData:userData encoding:NSUTF8StringEncoding];
        
        FPDEBUG(@"user Json:%@",jsonStr);
    }
    
    NSDictionary *parameters = [self makeParameter:serviceName withJson:jsonStr];
    
    FPDEBUG(@"%@",parameters);
    
    return parameters;
}

#pragma mark // //转账到银行卡
-(NSDictionary *)userWithdrawWithMemberNo:(NSString *)memberNo andAmt:(NSString *)amt andPassword:(NSString *)password andMemberBankCardId:(NSString*)memberBankCardId{
    NSString *serviceName = @"withdrawService";
    NSString *token = [Config Instance].token;
    
    NSString *jsonStr = nil;
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:@"withdraw" forKey:@"serviceFunction"];
    if (memberNo.length>0) {
        [userInfo setObject:memberNo forKey:@"memberNo"];
    }
    if (amt.length>0) {
        [userInfo setObject:amt forKey:@"amt"];
    }
    if (password.length>0) {
        NSString *passwordmd5 = [password md5Twice:@"timessharing"];
        [userInfo setObject:passwordmd5 forKey:@"password"];
    }
    if (memberBankCardId.length>0) {
        [userInfo setObject:memberBankCardId forKey:@"memberBankCardId"];
    }
    if (token.length>0) {
        [userInfo setObject:token forKey:@"token"];
    }
    
    [userInfo setObject:@"IOS" forKey:@"businessSource"];
    
    if ([NSJSONSerialization isValidJSONObject:userInfo]) {
        NSError *error;
        NSData *userData = [NSJSONSerialization dataWithJSONObject:userInfo options:kNilOptions error:&error];
        
        jsonStr = [[NSString alloc] initWithData:userData encoding:NSUTF8StringEncoding];
        
        FPDEBUG(@"user Json:%@",jsonStr);
    }
    
    NSDictionary *parameters = [self makeParameter:serviceName withJson:jsonStr];
    
    FPDEBUG(@"%@",parameters);
    
    return parameters;

}

#pragma mark // //平安付充值
-(NSDictionary *)userRechargeByPINGAN:(NSString *)memberNo andAmt:(NSString *)amt andBankCardId:(NSString *)bankCardId
{
    return [self userRecharge:memberNo andAmt:amt andBankCode:@"PAPAY" andBankCardId:bankCardId];
}
#pragma mark // //充值
-(NSDictionary *)userRecharge:(NSString *)memberNo andAmt:(NSString *)amt andBankCode:(NSString *)bankCode andBankCardId:(NSString *)bankCardId
{
    NSString *serviceName = @"rechargeService";
    NSString *token = [Config Instance].token;
    
    NSString *jsonStr = nil;
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:memberNo forKey:@"memberNo"];
    [userInfo setObject:@"recharge" forKey:@"serviceFunction"];
    [userInfo setObject:amt forKey:@"amt"];
    [userInfo setObject:bankCode forKey:@"bankCode"];
    [userInfo setObject:@"IOS" forKey:@"businessSource"];
    [userInfo setObject:[self getUUID] forKey:@"hardwareNo"];
    [userInfo setObject:token forKey:@"token"];
    if (bankCardId) {
        [userInfo setObject:bankCardId forKey:@"memberBankCardId"];
    }
    if ([NSJSONSerialization isValidJSONObject:userInfo]) {
        NSError *error;
        NSData *userData = [NSJSONSerialization dataWithJSONObject:userInfo options:kNilOptions error:&error];
        
        jsonStr = [[NSString alloc] initWithData:userData encoding:NSUTF8StringEncoding];
        
        FPDEBUG(@"user Json:%@",jsonStr);
    }
    
    NSDictionary *parameters = [self makeParameter:serviceName withJson:jsonStr];
    
    FPDEBUG(@"%@",parameters);
    
    return parameters;
}

#pragma mark // //手机版本更新
-(NSDictionary*)userMobileVersion:(NSString *)mobileVersion andOpenFlag:(BOOL)flag
{
    return [self userMobileVersion:@"IOS" andMobileVersion:mobileVersion andOpenFlag:flag];
}

-(NSDictionary*)userMobileVersion:(NSString *)mobileOS andMobileVersion:(NSString *)mobileVersion andOpenFlag:(BOOL)flag
{
    NSString *serviceName = @"mobileVersionService";
    NSString *token = [Config Instance].token;
    
    NSString *jsonStr = nil;
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:mobileOS forKey:@"mobileOS"];
    [userInfo setObject:mobileVersion forKey:@"mobileVersion"];
    if (flag) {
        [userInfo setObject:@"true" forKey:@"findFunctionFlag"];
    }
    if (token && token.length > 0) {
        [userInfo setObject:token forKey:@"token"];
    }
    
    if ([NSJSONSerialization isValidJSONObject:userInfo]) {
        NSError *error;
        NSData *userData = [NSJSONSerialization dataWithJSONObject:userInfo options:kNilOptions error:&error];
        
        jsonStr = [[NSString alloc] initWithData:userData encoding:NSUTF8StringEncoding];
        
        FPDEBUG(@"user Json:%@",jsonStr);
    }
    
    NSDictionary *parameters = [self makeParameter:serviceName withJson:jsonStr];
    
    FPDEBUG(@"%@",parameters);
    
    return parameters;
}

#pragma mark // //充话费-通过手机号获取运营商等信息
/*
 telecomCorp ：
 运营商（
 * 中国电信 CHINATELCOM,
 * 中国联通 CHINAUNICOM,
 * 中国移动 CHINAMOBILE,
 * 其他 OTHERS,
 * 所有 ALL
 ）
 */
-(NSDictionary *)userMobileFee:(NSString *)mobileNo
{
    NSString *method = @"rechargeOptions";
    return [self userMobileFee:method andMobileNo:mobileNo];
}

-(NSDictionary *)userMobileFee:(NSString *)method andMobileNo:(NSString *)mobileNo
{
    NSString *serviceName = @"mobileFeeService";
    NSString *token = [Config Instance].token;
    
    NSString *jsonStr = nil;
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:method forKey:@"serviceFunction"];
    [userInfo setObject:mobileNo forKey:@"mobileNo"];
    [userInfo setObject:token forKey:@"token"];
    if ([NSJSONSerialization isValidJSONObject:userInfo]) {
        NSError *error;
        NSData *userData = [NSJSONSerialization dataWithJSONObject:userInfo options:kNilOptions error:&error];
        
        jsonStr = [[NSString alloc] initWithData:userData encoding:NSUTF8StringEncoding];
        
        FPDEBUG(@"user Json:%@",jsonStr);
    }
    
    NSDictionary *parameters = [self makeParameter:serviceName withJson:jsonStr];
    
    FPDEBUG(@"%@",parameters);
    
    return parameters;
}

#pragma mark // //充话费-根据用户选择进行充值
-(NSDictionary *)userRechargeMobileFee:(NSString *)memberNo andMobileNo:(NSString *)mobileNo andOptionId:(NSInteger)optionId andPayPwd:(NSString *)payPwd
{
    NSString *method = @"recharge";
    return [self userRechargeMobileFee:memberNo andMethod:method andMobileNo:mobileNo andOptionId:optionId andPayPwd:payPwd];
}
-(NSDictionary *)userRechargeMobileFee:(NSString *)memberNo andMethod:(NSString *)method andMobileNo:(NSString *)mobileNo andOptionId:(NSInteger)optionId andPayPwd:(NSString *)payPwd
{
    NSString *serviceName = @"mobileFeeService";
    NSString *token = [Config Instance].token;
    
    NSString *jsonStr = nil;
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:method forKey:@"serviceFunction"];
    [userInfo setObject:memberNo forKey:@"memberNo"];
    [userInfo setObject:mobileNo forKey:@"mobileNo"];
    [userInfo setObject:[NSNumber numberWithInteger:optionId] forKey:@"rechargeOptionId"];
    if (![payPwd isEqualToString:@""]) {
        NSString *securpwd = [payPwd md5Twice:@"timessharing"];
        [userInfo setObject:securpwd forKey:@"payPwd"];
    }
    
    [userInfo setObject:token forKey:@"token"];
    if ([NSJSONSerialization isValidJSONObject:userInfo]) {
        NSError *error;
        NSData *userData = [NSJSONSerialization dataWithJSONObject:userInfo options:kNilOptions error:&error];
        
        jsonStr = [[NSString alloc] initWithData:userData encoding:NSUTF8StringEncoding];
        
        FPDEBUG(@"user Json:%@",jsonStr);
    }
    
    NSDictionary *parameters = [self makeParameter:serviceName withJson:jsonStr];
    
    FPDEBUG(@"%@",parameters);
    
    return parameters;
}

#pragma mark // //彩票认证接口
-(NSDictionary *)userLotteryGenerateSign:(NSString *)memberNo
{
    NSString *method = @"generateSign";
    return [self userFindLotteryWithMethod:method andMemberNo:memberNo];
}

/**大礼包接口**/
- (NSDictionary *)userfulllifeService
{
    NSString * fulllifeService = @"fulllifeService";
    NSString * serviceFunction = @"findFanso2oUrl";
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    NSString *jsonStr = nil;
    [userInfo setObject:serviceFunction forKey:@"serviceFunction"];
    if ([NSJSONSerialization isValidJSONObject:userInfo]) {
        NSError *error;
        NSData *userData = [NSJSONSerialization dataWithJSONObject:userInfo options:kNilOptions error:&error];
        
        jsonStr = [[NSString alloc] initWithData:userData encoding:NSUTF8StringEncoding];
        
        FPDEBUG(@"user Json:%@",jsonStr);
    }
    
    NSDictionary *parameters = [self makeParameter:fulllifeService withJson:jsonStr];
    
    FPDEBUG(@"%@",parameters);
    
    return parameters;

}

#pragma mark //获取高频彩URL
- (NSDictionary *)findGpcLotteryResource{
    NSString *serviceName = @"lotteryService";
    NSString *token = [Config Instance].token;
    NSString *serviceFunction = @"findGpcLotteryResource";
    NSString *jsonStr = nil;
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:serviceFunction forKey:@"serviceFunction"];
    if (token != nil) {
        [userInfo setObject:token forKey:@"token"];
    }

    if ([NSJSONSerialization isValidJSONObject:userInfo]) {
        NSError *error;
        NSData *userData = [NSJSONSerialization dataWithJSONObject:userInfo options:kNilOptions error:&error];
        
        jsonStr = [[NSString alloc] initWithData:userData encoding:NSUTF8StringEncoding];
        
        FPDEBUG(@"user Json:%@",jsonStr);
    }
    
    NSDictionary *parameters = [self makeParameter:serviceName withJson:jsonStr];
    
    FPDEBUG(@"%@",parameters);
    
    return parameters;

}

#pragma mark // //彩票接口
-(NSDictionary *)userFindLottery
{
    NSString *method = @"findAllLotteryResource";
    return [self userFindLotteryWithMethod:method andMemberNo:nil];
}

-(NSDictionary *)userFindLotteryWithMethod:(NSString *)method andMemberNo:(NSString *)memberNo
{
    NSString *serviceName = @"lotteryService";
    NSString *token = [Config Instance].token;
    
    NSString *jsonStr = nil;
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:method forKey:@"serviceFunction"];
    if (memberNo && memberNo.length > 0) {
        [userInfo setObject:memberNo forKey:@"memberNo"];
        [userInfo setObject:token forKey:@"token"];
    }
    
    if ([NSJSONSerialization isValidJSONObject:userInfo]) {
        NSError *error;
        NSData *userData = [NSJSONSerialization dataWithJSONObject:userInfo options:kNilOptions error:&error];
        
        jsonStr = [[NSString alloc] initWithData:userData encoding:NSUTF8StringEncoding];
        
        FPDEBUG(@"user Json:%@",jsonStr);
    }
    
    NSDictionary *parameters = [self makeParameter:serviceName withJson:jsonStr];
    
    FPDEBUG(@"%@",parameters);
    
    return parameters;
}

#pragma mark 关于红包
#pragma mark 1、查询用户当前红包状态，包括当前红包派发信息、红包余额
- (NSDictionary *)findCurrentRePacketInfoWithMemberNo:(NSString *)memberNo{
    NSString *serviceName = @"redPacketService";
    NSString *token = [Config Instance].token;
    NSString *jsonStr = nil;
    NSString *serviceFunction = @"findCurrentRePacketInfo";
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:serviceFunction forKey:@"serviceFunction"];

    if (token!= nil && token.length>0) {
        [userInfo setObject:token forKey:@"token"];
    }
    if (memberNo!= nil && memberNo.length>0) {
        [userInfo setObject:memberNo forKey:@"memberNo"];
    }
    
    if ([NSJSONSerialization isValidJSONObject:userInfo]) {
        NSError *error;
        NSData *userData = [NSJSONSerialization dataWithJSONObject:userInfo options:kNilOptions error:&error];
        
        jsonStr = [[NSString alloc] initWithData:userData encoding:NSUTF8StringEncoding];
        
        FPDEBUG(@"user Json:%@",jsonStr);
    }
    
    NSDictionary *parameters = [self makeParameter:serviceName withJson:jsonStr];
    
    FPDEBUG(@"findCurrentRePacketInfo:%@",parameters);
    
    return parameters;
}
#pragma mark 2、查询发出的红包findDistributedRedPacket
- (NSDictionary *)findDistributedRedPacketWithMemberNo:(NSString *)memberNo
                                       andLimit:(NSString *)limit
                                       andStart:(NSString *)start{
    NSString *serviceName = @"redPacketService";
    NSString *token = [Config Instance].token;
    NSString *jsonStr = nil;
    NSString *serviceFunction = @"findDistributedRedPacket";
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:serviceFunction forKey:@"serviceFunction"];
    
    if (token!= nil && token.length>0) {
        [userInfo setObject:token forKey:@"token"];
    }
    if (memberNo!= nil && memberNo.length>0) {
        [userInfo setObject:memberNo forKey:@"memberNo"];
    }
    if (limit!= nil && limit.length>0) {
        [userInfo setObject:limit forKey:@"limit"];
    }
    if (start!= nil && start.length>0) {
        [userInfo setObject:start forKey:@"start"];
    }
    
    if ([NSJSONSerialization isValidJSONObject:userInfo]) {
        NSError *error;
        NSData *userData = [NSJSONSerialization dataWithJSONObject:userInfo options:kNilOptions error:&error];
        
        jsonStr = [[NSString alloc] initWithData:userData encoding:NSUTF8StringEncoding];
        
        FPDEBUG(@"user Json:%@",jsonStr);
    }
    
    NSDictionary *parameters = [self makeParameter:serviceName withJson:jsonStr];
    
    FPDEBUG(@"findRedPacket:%@",parameters);
    
    return parameters;
}

#pragma mark 3、查询领到的红包
- (NSDictionary *)findReceivedRedPacketWithMemberNo:(NSString *)memberNo
                                    andLimit:(NSString *)limit
                                    andStart:(NSString *)start{
    NSString *serviceName = @"redPacketService";
    NSString *token = [Config Instance].token;
    NSString *jsonStr = nil;
    NSString *serviceFunction = @"findReceivedRedPacket";
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:serviceFunction forKey:@"serviceFunction"];
    
    if (token!= nil && token.length>0) {
        [userInfo setObject:token forKey:@"token"];
    }
    if (memberNo!= nil && memberNo.length>0) {
        [userInfo setObject:memberNo forKey:@"memberNo"];
    }
    if (limit!= nil && limit.length>0) {
        [userInfo setObject:limit forKey:@"limit"];
    }
    if (start!= nil && start.length>0) {
        [userInfo setObject:start forKey:@"start"];
    }
    
    if ([NSJSONSerialization isValidJSONObject:userInfo]) {
        NSError *error;
        NSData *userData = [NSJSONSerialization dataWithJSONObject:userInfo options:kNilOptions error:&error];
        
        jsonStr = [[NSString alloc] initWithData:userData encoding:NSUTF8StringEncoding];
        
        FPDEBUG(@"user Json:%@",jsonStr);
    }
    
    NSDictionary *parameters = [self makeParameter:serviceName withJson:jsonStr];
    
    FPDEBUG(@"findRedPacket:%@",parameters);
    
    return parameters;

}

#pragma mark 4、提现
- (NSDictionary *)withdrawWithAccountNo:(NSString *)accountNo{
    NSString *serviceName = @"redPacketService";
    NSString *token = [Config Instance].token;
    NSString *jsonStr = nil;
    NSString *serviceFunction = @"withdraw";
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:serviceFunction forKey:@"serviceFunction"];
    [userInfo setObject:@"IOS" forKey:@"businessSource"];
    
    if (token!= nil && token.length>0) {
        [userInfo setObject:token forKey:@"token"];
    }
    if (accountNo!= nil && accountNo.length>0) {
        [userInfo setObject:accountNo forKey:@"accountNo"];
    }
    
    if ([NSJSONSerialization isValidJSONObject:userInfo]) {
        NSError *error;
        NSData *userData = [NSJSONSerialization dataWithJSONObject:userInfo options:kNilOptions error:&error];
        
        jsonStr = [[NSString alloc] initWithData:userData encoding:NSUTF8StringEncoding];
        
        FPDEBUG(@"user Json:%@",jsonStr);
    }
    
    NSDictionary *parameters = [self makeParameter:serviceName withJson:jsonStr];
    
    FPDEBUG(@"withdraw:%@",parameters);
    
    return parameters;

}
#pragma mark 5、提现记录查询
- (NSDictionary *)findRedPacketWithdrawFromAppWithMemberNo:(NSString *)memberNo
                                              andAccountNo:(NSString *)accountNo
                                                  andLimit:(NSString *)limit
                                                  andStart:(NSString *)start{
    NSString *serviceName = @"redPacketService";
    NSString *token = [Config Instance].token;
    NSString *jsonStr = nil;
    NSString *serviceFunction = @"findRedPacketWithdrawFromApp";
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:serviceFunction forKey:@"serviceFunction"];
    
    if (token!= nil && token.length>0) {
        [userInfo setObject:token forKey:@"token"];
    }
    if (memberNo!= nil && memberNo.length>0) {
        [userInfo setObject:memberNo forKey:@"memberNo"];
    }
    if (accountNo!= nil && accountNo.length>0) {
        [userInfo setObject:accountNo forKey:@"accountNo"];
    }
    if (limit!= nil && limit.length>0) {
        [userInfo setObject:limit forKey:@"limit"];
    }
    if (start!= nil && start.length>0) {
        [userInfo setObject:start forKey:@"start"];
    }
    
    if ([NSJSONSerialization isValidJSONObject:userInfo]) {
        NSError *error;
        NSData *userData = [NSJSONSerialization dataWithJSONObject:userInfo options:kNilOptions error:&error];
        
        jsonStr = [[NSString alloc] initWithData:userData encoding:NSUTF8StringEncoding];
        
        FPDEBUG(@"user Json:%@",jsonStr);
    }
    
    NSDictionary *parameters = [self makeParameter:serviceName withJson:jsonStr];
    
    FPDEBUG(@"findRedPacketWithdrawFromApp:%@",parameters);
    
    return parameters;

}
#pragma mark 6、派发红包
- (NSDictionary *)distributeWithMemberNo:(NSString *)memberNo
                           andTotalCount:(NSString *)totalCount
                                  andAmt:(NSString *)amt
                            andAddRemark:(NSString *)addRemark{
    NSString *serviceName = @"redPacketService";
    NSString *token = [Config Instance].token;
    NSString *jsonStr = nil;
    NSString *serviceFunction = @"distribute";
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:serviceFunction forKey:@"serviceFunction"];
    
    if (token!= nil && token.length>0) {
        [userInfo setObject:token forKey:@"token"];
    }
    if (memberNo!= nil && memberNo.length>0) {
        [userInfo setObject:memberNo forKey:@"memberNo"];
    }
    if (totalCount!= nil && totalCount.length>0) {
        [userInfo setObject:totalCount forKey:@"totalCount"];
    }
    if (amt!= nil && amt.length>0) {
        [userInfo setObject:amt forKey:@"amt"];
    }
    if (addRemark!= nil && addRemark.length>0) {
        [userInfo setObject:addRemark forKey:@"addRemark"];
    }
    
    if ([NSJSONSerialization isValidJSONObject:userInfo]) {
        NSError *error;
        NSData *userData = [NSJSONSerialization dataWithJSONObject:userInfo options:kNilOptions error:&error];
        
        jsonStr = [[NSString alloc] initWithData:userData encoding:NSUTF8StringEncoding];
        
        FPDEBUG(@"user Json:%@",jsonStr);
    }
    
    NSDictionary *parameters = [self makeParameter:serviceName withJson:jsonStr];
    
    FPDEBUG(@"distribute:%@",parameters);
    
    return parameters;
}

#pragma mark 7、支付派发红包所需金额
- (NSDictionary *)distributePayWithDistributeId:(NSString *)distributeId andPassword:(NSString *)password{
    NSString *serviceName = @"redPacketService";
    NSString *token = [Config Instance].token;
    NSString *jsonStr = nil;
    NSString *serviceFunction = @"distributePay";
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:serviceFunction forKey:@"serviceFunction"];
    
    if (token!= nil && token.length>0) {
        [userInfo setObject:token forKey:@"token"];
    }
    if (distributeId!= nil && distributeId.length>0) {
        [userInfo setObject:distributeId forKey:@"id"];
    }
    if (password!= nil && password.length>0) {
        NSString *passwordmd5 = [password md5Twice:@"timessharing"];
        [userInfo setObject:passwordmd5 forKey:@"password"];
    }
    
    [userInfo setObject:@"IOS" forKey:@"businessSource"];
    
    if ([NSJSONSerialization isValidJSONObject:userInfo]) {
        NSError *error;
        NSData *userData = [NSJSONSerialization dataWithJSONObject:userInfo options:kNilOptions error:&error];
        
        jsonStr = [[NSString alloc] initWithData:userData encoding:NSUTF8StringEncoding];
        
        FPDEBUG(@"user Json:%@",jsonStr);
    }
    
    NSDictionary *parameters = [self makeParameter:serviceName withJson:jsonStr];
    
    FPDEBUG(@"distributePay:%@",parameters);
    
    return parameters;
}
#pragma mark 8、终止派发红包
- (NSDictionary *)stopDistributeWithDistributeId:(NSString *)distributeId{
    NSString *serviceName = @"redPacketService";
    NSString *token = [Config Instance].token;
    NSString *jsonStr = nil;
    NSString *serviceFunction = @"stopDistribute";
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:serviceFunction forKey:@"serviceFunction"];
    
    if (token!= nil && token.length>0) {
        [userInfo setObject:token forKey:@"token"];
    }
    if (distributeId!= nil && distributeId.length>0) {
        [userInfo setObject:distributeId forKey:@"id"];
    }
    
    [userInfo setObject:@"IOS" forKey:@"businessSource"];
    
    if ([NSJSONSerialization isValidJSONObject:userInfo]) {
        NSError *error;
        NSData *userData = [NSJSONSerialization dataWithJSONObject:userInfo options:kNilOptions error:&error];
        
        jsonStr = [[NSString alloc] initWithData:userData encoding:NSUTF8StringEncoding];
        
        FPDEBUG(@"user Json:%@",jsonStr);
    }
    
    NSDictionary *parameters = [self makeParameter:serviceName withJson:jsonStr];
    
    FPDEBUG(@"stopDistribute:%@",parameters);
    
    return parameters;
}
#pragma mark 9、领取红包
- (NSDictionary *)receiveWithReceiveNo:(NSString *)receiveNo andMemberNo:(NSString *)memberNo{
    NSString *serviceName = @"redPacketService";
    NSString *token = [Config Instance].token;
    NSString *jsonStr = nil;
    NSString *serviceFunction = @"receive";
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:serviceFunction forKey:@"serviceFunction"];
    
    if (token!= nil && token.length>0) {
        [userInfo setObject:token forKey:@"token"];
    }
    if (receiveNo!= nil && receiveNo.length>0) {
        [userInfo setObject:receiveNo forKey:@"receiveNo"];
    }
    if (memberNo!= nil && memberNo.length>0) {
        [userInfo setObject:memberNo forKey:@"memberNo"];
    }
    
    if ([NSJSONSerialization isValidJSONObject:userInfo]) {
        NSError *error;
        NSData *userData = [NSJSONSerialization dataWithJSONObject:userInfo options:kNilOptions error:&error];
        
        jsonStr = [[NSString alloc] initWithData:userData encoding:NSUTF8StringEncoding];
        
        FPDEBUG(@"user Json:%@",jsonStr);
    }
    
    NSDictionary *parameters = [self makeParameter:serviceName withJson:jsonStr];
    
    FPDEBUG(@"receive:%@",parameters);
    
    return parameters;
}
#pragma mark 10、领取红包后答谢留言
- (NSDictionary *)receiveRemarkWithRedPacketId:(NSString *)redPacketId andRemark:(NSString *)remark{
    NSString *serviceName = @"redPacketService";
    NSString *token = [Config Instance].token;
    NSString *jsonStr = nil;
    NSString *serviceFunction = @"receiveRemark";
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:serviceFunction forKey:@"serviceFunction"];
    
    if (token!= nil && token.length>0) {
        [userInfo setObject:token forKey:@"token"];
    }
    if (redPacketId!= nil && redPacketId.length>0) {
        [userInfo setObject:redPacketId forKey:@"id"];
    }
    if (remark!= nil && remark.length>0) {
        [userInfo setObject:remark forKey:@"remark"];
    }
    
    if ([NSJSONSerialization isValidJSONObject:userInfo]) {
        NSError *error;
        NSData *userData = [NSJSONSerialization dataWithJSONObject:userInfo options:kNilOptions error:&error];
        
        jsonStr = [[NSString alloc] initWithData:userData encoding:NSUTF8StringEncoding];
        
        FPDEBUG(@"user Json:%@",jsonStr);
    }
    
    NSDictionary *parameters = [self makeParameter:serviceName withJson:jsonStr];
    
    FPDEBUG(@"receiveRemark:%@",parameters);
    
    return parameters;
}
#pragma mark 11、用户获取新红包编号
- (NSDictionary *)getNewRedPacketToDistributeWithCurrentRePacketId:(NSString *)currentRePacketId{
    NSString *serviceName = @"redPacketService";
    NSString *token = [Config Instance].token;
    NSString *jsonStr = nil;
    NSString *serviceFunction = @"getNewRedPacketToDistribute";
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:serviceFunction forKey:@"serviceFunction"];
    
    if (token!= nil && token.length>0) {
        [userInfo setObject:token forKey:@"token"];
    }
    if (currentRePacketId!= nil && currentRePacketId.length>0) {
        [userInfo setObject:currentRePacketId forKey:@"id"];
    }
    
    if ([NSJSONSerialization isValidJSONObject:userInfo]) {
        NSError *error;
        NSData *userData = [NSJSONSerialization dataWithJSONObject:userInfo options:kNilOptions error:&error];
        
        jsonStr = [[NSString alloc] initWithData:userData encoding:NSUTF8StringEncoding];
        
        FPDEBUG(@"user Json:%@",jsonStr);
    }
    
    NSDictionary *parameters = [self makeParameter:serviceName withJson:jsonStr];
    
    FPDEBUG(@"getNewRedPacketToDistribute:%@",parameters);
    
    return parameters;
}

#pragma mark 12、根据会员编号获取会员头像
- (NSDictionary *)headImageByMember:(NSString *)headMemberNo{
    NSString *serviceName = @"memberHeadImageService";
    NSString *jsonStr = nil;
    NSString *serviceFunction = @"headImageByMember";
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:serviceFunction forKey:@"serviceFunction"];
    
    if (headMemberNo!= nil && headMemberNo.length>0) {
        [userInfo setObject:headMemberNo forKey:@"headMemberNo"];
    }
    
    if ([NSJSONSerialization isValidJSONObject:userInfo]) {
        NSError *error;
        NSData *userData = [NSJSONSerialization dataWithJSONObject:userInfo options:kNilOptions error:&error];
        
        jsonStr = [[NSString alloc] initWithData:userData encoding:NSUTF8StringEncoding];
        
        FPDEBUG(@"user Json:%@",jsonStr);
    }
    
    NSDictionary *parameters = [self makeParameter:serviceName withJson:jsonStr];
    
    FPDEBUG(@"headImageByMember:%@",parameters);
    
    return parameters;

}
#pragma mark 关于富钱包

#pragma mark 1、查询富钱包卡交易

- (NSDictionary *)findOfflineTradeCardNo:(NSString *)cardNo andMemberNo:(NSString *)memberNo andLimit:(NSString *)limit andStart:(NSString *)start andRecentDate:(NSString *)date{
    NSString *serviceName = @"offlineTradeMgrService";
    NSString *token = [Config Instance].token;
    NSString *jsonStr = nil;
    NSString *serviceFunction = @"findOfflineTrade";
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:serviceFunction forKey:@"serviceFunction"];
    [userInfo setObject:limit forKey:@"limit"];
    [userInfo setObject:start forKey:@"start"];
    [userInfo setObject:date forKey:@"dateFlag"];
    if (cardNo != nil) {
        [userInfo setObject:cardNo forKey:@"cardNo"];
    }
    if (memberNo!= nil && memberNo.length>0) {
        [userInfo setObject:memberNo forKey:@"memberNo"];
    }
    if (token != nil) {
        [userInfo setObject:token forKey:@"token"];
    }
    if ([NSJSONSerialization isValidJSONObject:userInfo]) {
        NSError *error;
        NSData *userData = [NSJSONSerialization dataWithJSONObject:userInfo options:kNilOptions error:&error];
        
        jsonStr = [[NSString alloc] initWithData:userData encoding:NSUTF8StringEncoding];
        
        FPDEBUG(@"user Json:%@",jsonStr);
    }
    
    NSDictionary *parameters = [self makeParameter:serviceName withJson:jsonStr];
    
    FPDEBUG(@"%@",parameters);
    
    return parameters;

}
#pragma mark 2、富钱包卡充值请求
- (NSDictionary *)rechargeRequestWithCardNo:(NSString *)cardNo andAmt:(NSString *)amt andMemberNo:(NSString *)memberNo{
    NSString *serviceName = @"offlineTradeMgrService";
    NSString *token = [Config Instance].token;
    NSString *jsonStr = nil;
    NSString *serviceFunction = @"rechargeRequest";
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:serviceFunction forKey:@"serviceFunction"];

    if (cardNo != nil && cardNo.length>0) {
        [userInfo setObject:cardNo forKey:@"cardNo"];
    }
    if (amt != nil && amt.length>0) {
        [userInfo setObject:amt forKey:@"amt"];
    }
    if (memberNo != nil && memberNo.length>0) {
        [userInfo setObject:memberNo forKey:@"memberNo"];
    }
    if (token != nil && token.length>0) {
        [userInfo setObject:token forKey:@"token"];
    }
    if ([NSJSONSerialization isValidJSONObject:userInfo]) {
        NSError *error;
        NSData *userData = [NSJSONSerialization dataWithJSONObject:userInfo options:kNilOptions error:&error];
        
        jsonStr = [[NSString alloc] initWithData:userData encoding:NSUTF8StringEncoding];
        
        FPDEBUG(@"user Json:%@",jsonStr);
    }
    
    NSDictionary *parameters = [self makeParameter:serviceName withJson:jsonStr];
    
    FPDEBUG(@"%@",parameters);
    
    return parameters;
}

#pragma mark 3、富钱包卡充值请求后支付

- (NSDictionary *)rechargePaymentWithTradeNo:(NSString*)tradeNo andPassword:(NSString *)password{
    NSString *serviceName = @"offlineTradeMgrService";
    NSString *token = [Config Instance].token;
    NSString *jsonStr = nil;
    NSString *serviceFunction = @"rechargePayment";
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:serviceFunction forKey:@"serviceFunction"];
    
    if (tradeNo != nil && tradeNo.length>0) {
        [userInfo setObject:tradeNo forKey:@"tradeNo"];
    }
    if (token != nil && token.length>0) {
        [userInfo setObject:token forKey:@"token"];
    }
    if (password!= nil && password.length>0) {
        NSString *passwordmd5 = [password md5Twice:@"timessharing"];
        [userInfo setObject:passwordmd5 forKey:@"password"];
    }
    
    [userInfo setObject:@"IOS" forKey:@"businessSource"];

    if ([NSJSONSerialization isValidJSONObject:userInfo]) {
        NSError *error;
        NSData *userData = [NSJSONSerialization dataWithJSONObject:userInfo options:kNilOptions error:&error];
        
        jsonStr = [[NSString alloc] initWithData:userData encoding:NSUTF8StringEncoding];
        
        FPDEBUG(@"user Json:%@",jsonStr);
    }
    
    NSDictionary *parameters = [self makeParameter:serviceName withJson:jsonStr];
    
    FPDEBUG(@"%@",parameters);
    
    return parameters;
}

#pragma mark 关于钱包卡
#pragma mark 1、 //查询关联钱包卡
- (NSDictionary *)findCardRelateWithMemberNo:(NSString *)memberNo{
    NSString *serviceName = @"offlineCardMgrService";
    NSString *token = [Config Instance].token;
    NSString *jsonStr = nil;
    NSString *serviceFunction = @"findCardRelate";
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:serviceFunction forKey:@"serviceFunction"];
    
    if (memberNo != nil && memberNo.length>0) {
        [userInfo setObject:memberNo forKey:@"memberNo"];
    }
    if (token != nil && token.length>0) {
        [userInfo setObject:token forKey:@"token"];
    }
    
    
    if ([NSJSONSerialization isValidJSONObject:userInfo]) {
        NSError *error;
        NSData *userData = [NSJSONSerialization dataWithJSONObject:userInfo options:kNilOptions error:&error];
        
        jsonStr = [[NSString alloc] initWithData:userData encoding:NSUTF8StringEncoding];
        
        FPDEBUG(@"user Json:%@",jsonStr);
    }
    
    NSDictionary *parameters = [self makeParameter:serviceName withJson:jsonStr];
    
    FPDEBUG(@"%@",parameters);
    
    return parameters;

}

#pragma mark //会员关联卡详情
- (NSDictionary *)findCardRelateDetailWithCardNo:(NSString *)cardNo{
    NSString *serviceName = @"offlineCardMgrService";
    NSString *token = [Config Instance].token;
    NSString *jsonStr = nil;
    NSString *serviceFunction = @"findCardRelateDetail";
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:serviceFunction forKey:@"serviceFunction"];
    
    if (cardNo != nil && cardNo.length>0) {
        [userInfo setObject:cardNo forKey:@"id"];
    }
    if (token != nil && token.length>0) {
        [userInfo setObject:token forKey:@"token"];
    }
    
    
    if ([NSJSONSerialization isValidJSONObject:userInfo]) {
        NSError *error;
        NSData *userData = [NSJSONSerialization dataWithJSONObject:userInfo options:kNilOptions error:&error];
        
        jsonStr = [[NSString alloc] initWithData:userData encoding:NSUTF8StringEncoding];
        
        FPDEBUG(@"user Json:%@",jsonStr);
    }
    
    NSDictionary *parameters = [self makeParameter:serviceName withJson:jsonStr];
    
    FPDEBUG(@"%@",parameters);
    
    return parameters;
}

#pragma mark 2、 //添加钱包卡
- (NSDictionary *)addCardRelateWithMemberNo:(NSString *)memberNo andCardNo:(NSString *)cardNo{
    NSString *serviceName = @"offlineCardMgrService";
    NSString *token = [Config Instance].token;
    NSString *jsonStr = nil;
    NSString *serviceFunction = @"addCardRelate";
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:serviceFunction forKey:@"serviceFunction"];
    
    if (memberNo != nil && memberNo.length>0) {
        [userInfo setObject:memberNo forKey:@"memberNo"];
    }
    if (cardNo != nil && cardNo.length>0) {
        [userInfo setObject:cardNo forKey:@"cardNo"];
    }
    if (token != nil && token.length>0) {
        [userInfo setObject:token forKey:@"token"];
    }
    
    
    if ([NSJSONSerialization isValidJSONObject:userInfo]) {
        NSError *error;
        NSData *userData = [NSJSONSerialization dataWithJSONObject:userInfo options:kNilOptions error:&error];
        
        jsonStr = [[NSString alloc] initWithData:userData encoding:NSUTF8StringEncoding];
        
        FPDEBUG(@"user Json:%@",jsonStr);
    }
    
    NSDictionary *parameters = [self makeParameter:serviceName withJson:jsonStr];
    
    FPDEBUG(@"%@",parameters);
    
    return parameters;

}


#pragma mark 3、 //删除钱包卡
- (NSDictionary *)deleteCardRelateWithCardId:(NSString *)cardId{
    NSString *serviceName = @"offlineCardMgrService";
    NSString *token = [Config Instance].token;
    NSString *jsonStr = nil;
    NSString *serviceFunction = @"deleteCardRelate";
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:serviceFunction forKey:@"serviceFunction"];
    
    if (cardId != nil && cardId.length>0) {
        [userInfo setObject:cardId forKey:@"id"];
    }
    if (token != nil && token.length>0) {
        [userInfo setObject:token forKey:@"token"];
    }
    
    if ([NSJSONSerialization isValidJSONObject:userInfo]) {
        NSError *error;
        NSData *userData = [NSJSONSerialization dataWithJSONObject:userInfo options:kNilOptions error:&error];
        
        jsonStr = [[NSString alloc] initWithData:userData encoding:NSUTF8StringEncoding];
        
        FPDEBUG(@"user Json:%@",jsonStr);
    }
    
    NSDictionary *parameters = [self makeParameter:serviceName withJson:jsonStr];
    
    FPDEBUG(@"%@",parameters);
    
    return parameters;

}

#pragma mark 4、 //实名卡申请
- (NSDictionary *)applyCardWithMemberNo:(NSString *)memberNo{
    NSString *serviceName = @"offlineCardMgrService";
    NSString *token = [Config Instance].token;
    NSString *jsonStr = nil;
    NSString *serviceFunction = @"applyCard";
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:serviceFunction forKey:@"serviceFunction"];
    
    if (memberNo != nil && memberNo.length>0) {
        [userInfo setObject:memberNo forKey:@"memberNo"];
    }
    if (token != nil && token.length>0) {
        [userInfo setObject:token forKey:@"token"];
    }
    
    
    if ([NSJSONSerialization isValidJSONObject:userInfo]) {
        NSError *error;
        NSData *userData = [NSJSONSerialization dataWithJSONObject:userInfo options:kNilOptions error:&error];
        
        jsonStr = [[NSString alloc] initWithData:userData encoding:NSUTF8StringEncoding];
        
        FPDEBUG(@"user Json:%@",jsonStr);
    }
    
    NSDictionary *parameters = [self makeParameter:serviceName withJson:jsonStr];
    
    FPDEBUG(@"%@",parameters);
    
    return parameters;

}

#pragma mark 5、 //实名卡挂失
- (NSDictionary *)lossCardWithCardNo:(NSString *)cardNo andPayPwd:(NSString *)payPwd{
    NSString *serviceName = @"offlineCardMgrService";
    NSString *token = [Config Instance].token;
    NSString *jsonStr = nil;
    NSString *serviceFunction = @"lossCard";
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:serviceFunction forKey:@"serviceFunction"];
    NSString *pwd = [payPwd md5Twice:@"timessharing"];

    if (cardNo != nil && cardNo.length>0) {
        [userInfo setObject:cardNo forKey:@"id"];
    }
    if (pwd != nil && pwd.length>0) {
        [userInfo setObject:pwd forKey:@"password"];
    }
    if (token != nil && token.length>0) {
        [userInfo setObject:token forKey:@"token"];
    }
    
    
    if ([NSJSONSerialization isValidJSONObject:userInfo]) {
        NSError *error;
        NSData *userData = [NSJSONSerialization dataWithJSONObject:userInfo options:kNilOptions error:&error];
        
        jsonStr = [[NSString alloc] initWithData:userData encoding:NSUTF8StringEncoding];
        
        FPDEBUG(@"user Json:%@",jsonStr);
    }
    
    NSDictionary *parameters = [self makeParameter:serviceName withJson:jsonStr];
    
    FPDEBUG(@"%@",parameters);
    
    return parameters;

}

#pragma mark 6、 //实名卡解挂
- (NSDictionary *)removeLossCardWithCardNo:(NSString *)cardNo andPayPwd:(NSString *)payPwd{
    NSString *serviceName = @"offlineCardMgrService";
    NSString *token = [Config Instance].token;
    NSString *jsonStr = nil;
    NSString *serviceFunction = @"removeLossCard";
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:serviceFunction forKey:@"serviceFunction"];
    NSString *pwd = [payPwd md5Twice:@"timessharing"];

    if (cardNo != nil && cardNo.length>0) {
        [userInfo setObject:cardNo forKey:@"id"];
    }
    if (pwd != nil && pwd.length>0) {
        [userInfo setObject:pwd forKey:@"password"];
    }
    if (token != nil && token.length>0) {
        [userInfo setObject:token forKey:@"token"];
    }
    
    
    if ([NSJSONSerialization isValidJSONObject:userInfo]) {
        NSError *error;
        NSData *userData = [NSJSONSerialization dataWithJSONObject:userInfo options:kNilOptions error:&error];
        
        jsonStr = [[NSString alloc] initWithData:userData encoding:NSUTF8StringEncoding];
        
        FPDEBUG(@"user Json:%@",jsonStr);
    }
    
    NSDictionary *parameters = [self makeParameter:serviceName withJson:jsonStr];
    
    FPDEBUG(@"%@",parameters);
    
    return parameters;

}

#pragma mark //实名卡解绑
- (NSDictionary *)unBindCardWithCardNo:(NSString *)cardNo andPayPwd:(NSString *)payPwd{
    NSString *serviceName = @"offlineCardMgrService";
    NSString *token = [Config Instance].token;
    NSString *jsonStr = nil;
    NSString *serviceFunction = @"unBind";
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:serviceFunction forKey:@"serviceFunction"];
    
    NSString *pwd = [payPwd md5Twice:@"timessharing"];

    
    if (cardNo != nil && cardNo.length>0) {
        [userInfo setObject:cardNo forKey:@"id"];
    }
    if (pwd != nil && pwd.length>0) {
        [userInfo setObject:pwd forKey:@"password"];
    }
    if (token != nil && token.length>0) {
        [userInfo setObject:token forKey:@"token"];
    }
    
    
    if ([NSJSONSerialization isValidJSONObject:userInfo]) {
        NSError *error;
        NSData *userData = [NSJSONSerialization dataWithJSONObject:userInfo options:kNilOptions error:&error];
        
        jsonStr = [[NSString alloc] initWithData:userData encoding:NSUTF8StringEncoding];
        
        FPDEBUG(@"user Json:%@",jsonStr);
    }
    
    NSDictionary *parameters = [self makeParameter:serviceName withJson:jsonStr];
    
    FPDEBUG(@"%@",parameters);
    
    return parameters;
}

#pragma mark  //实名卡补卡
- (NSDictionary *)changeCardWithCardNo:(NSString *)cardNo andPayPwd:(NSString *)payPwd andChangeCardNo:(NSString *)changeCardNo{
    NSString *serviceName = @"offlineCardMgrService";
    NSString *token = [Config Instance].token;
    NSString *jsonStr = nil;
    NSString *serviceFunction = @"changeCard";
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:serviceFunction forKey:@"serviceFunction"];
    
    NSString *pwd = [payPwd md5Twice:@"timessharing"];
    
    
    if (cardNo != nil && cardNo.length>0) {
        [userInfo setObject:cardNo forKey:@"id"];
    }
    if (pwd != nil && pwd.length>0) {
        [userInfo setObject:pwd forKey:@"password"];
    }
    if (changeCardNo != nil && changeCardNo.length>0) {
        [userInfo setObject:changeCardNo forKey:@"changeCardNo"];
    }
    if (token != nil && token.length>0) {
        [userInfo setObject:token forKey:@"token"];
    }
    
    
    if ([NSJSONSerialization isValidJSONObject:userInfo]) {
        NSError *error;
        NSData *userData = [NSJSONSerialization dataWithJSONObject:userInfo options:kNilOptions error:&error];
        
        jsonStr = [[NSString alloc] initWithData:userData encoding:NSUTF8StringEncoding];
        
        FPDEBUG(@"user Json:%@",jsonStr);
    }
    
    NSDictionary *parameters = [self makeParameter:serviceName withJson:jsonStr];
    
    FPDEBUG(@"%@",parameters);
    
    return parameters;
}


#pragma mark 7、 //查询实名卡申请
- (NSDictionary *)findCardApplyWithMemberNo:(NSString *)memberNo{
    NSString *serviceName = @"offlineCardMgrService";
    NSString *token = [Config Instance].token;
    NSString *jsonStr = nil;
    NSString *serviceFunction = @"findCardApply";
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:serviceFunction forKey:@"serviceFunction"];
    
    if (memberNo != nil && memberNo.length>0) {
        [userInfo setObject:memberNo forKey:@"memberNo"];
    }
    if (token != nil && token.length>0) {
        [userInfo setObject:token forKey:@"token"];
    }
    
    
    if ([NSJSONSerialization isValidJSONObject:userInfo]) {
        NSError *error;
        NSData *userData = [NSJSONSerialization dataWithJSONObject:userInfo options:kNilOptions error:&error];
        
        jsonStr = [[NSString alloc] initWithData:userData encoding:NSUTF8StringEncoding];
        
        FPDEBUG(@"user Json:%@",jsonStr);
    }
    
    NSDictionary *parameters = [self makeParameter:serviceName withJson:jsonStr];
    
    FPDEBUG(@"%@",parameters);
    
    return parameters;

}

/**
 *  查询会员可转入余额的实名卡卡号列表
 *
 *  @param memberNo 挂失的卡号
 *
 *  @return 参数字典
 */
- (NSDictionary *)findCanChangeCardWithMemberNo:(NSString *)memberNo
{
    NSString *serviceName = @"offlineCardMgrService";
    NSString *token = [Config Instance].token;
    NSString *jsonStr = nil;
    NSString *serviceFunction = @"findCanChangeCard";
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:serviceFunction forKey:@"serviceFunction"];
    
    if (memberNo != nil && memberNo.length>0) {
        [userInfo setObject:memberNo forKey:@"memberNo"];
    }
    if (token != nil && token.length>0) {
        [userInfo setObject:token forKey:@"token"];
    }
    
    
    if ([NSJSONSerialization isValidJSONObject:userInfo]) {
        NSError *error;
        NSData *userData = [NSJSONSerialization dataWithJSONObject:userInfo options:kNilOptions error:&error];
        
        jsonStr = [[NSString alloc] initWithData:userData encoding:NSUTF8StringEncoding];
        
        FPDEBUG(@"user Json:%@",jsonStr);
    }
    
    NSDictionary *parameters = [self makeParameter:serviceName withJson:jsonStr];
    
    FPDEBUG(@"%@",parameters);
    
    return parameters;
}

#pragma mark 8、 //收支明细统计
- (NSDictionary *)findMonthStsWithAccountNo:(NSString *)accountNo andStart:(NSString*)start{
    NSString *serviceName = @"offlineTradeMgrService";
    NSString *token = [Config Instance].token;
    NSString *jsonStr = nil;
    NSString *serviceFunction = @"findMonthSts";
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:serviceFunction forKey:@"serviceFunction"];
    
    if (accountNo != nil && accountNo.length>0) {
        [userInfo setObject:accountNo forKey:@"accountNo"];
    }
    if (start != nil && start.length>0) {
        [userInfo setObject:start forKey:@"start"];
    }
    
    [userInfo setObject:@"100" forKey:@"limit"];

    if (token != nil && token.length>0) {
        [userInfo setObject:token forKey:@"token"];
    }
    
    
    if ([NSJSONSerialization isValidJSONObject:userInfo]) {
        NSError *error;
        NSData *userData = [NSJSONSerialization dataWithJSONObject:userInfo options:kNilOptions error:&error];
        
        jsonStr = [[NSString alloc] initWithData:userData encoding:NSUTF8StringEncoding];
        
        FPDEBUG(@"user Json:%@",jsonStr);
    }
    
    NSDictionary *parameters = [self makeParameter:serviceName withJson:jsonStr];
    
    FPDEBUG(@"%@",parameters);
    
    return parameters;

}

#pragma mark 公共参数组装

-(NSDictionary *)makeParameter:(NSString *)serviceName withJson:(NSString *)jsonStr
{
    
    NSString *deviceUDID = [self getUUID];
    
    NSString *timestamp = [self getTimestamp];
    
    NSString *encryptStr = [jsonStr md5Twice:timestamp];
    
    NSString *signature = @"fuzhifu";
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:serviceName forKey:@"serviceName"];
    [parameters setObject:signature forKey:@"signature"];
    [parameters setObject:timestamp forKey:@"timestamp"];
    [parameters setObject:deviceUDID forKey:@"terminalId"];
    [parameters setObject:jsonStr forKey:@"json"];
    [parameters setObject:encryptStr forKey:@"encrptyedJson"];
    
    return parameters;
}

-(NSString *)getUUID
{
    UIDevice *myDevice = [UIDevice currentDevice];
    if ([myDevice respondsToSelector:@selector(identifierForVendor)]) {
        return [[myDevice identifierForVendor] UUIDString];
    } else {
        return [[Config Instance] getIOSGuid];
    }
}

-(NSString *)getTimestamp
{
    NSDate *datenow = [NSDate date];
    long long currentTimestamp = (long long)([datenow timeIntervalSince1970]*1000);
    NSString *timestamp = [NSString stringWithFormat:@"%lld", currentTimestamp];
    
    return timestamp;
}

@end
