//
//  Config.h
//  FullPayApp
//
//  Created by mark zheng on 14-2-21.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FPAppParams.h"
#import "FPPersonMember.h"
#import "FPMethodMap.h"
#import "FPLotterySign.h"
#import "FPAdvertiseInfo.h"
#import "FPAccountInfo.h"

#define kAutoLoginPattern   @"KeyForAutoLogin"

@interface Config : NSObject

@property (nonatomic,assign,getter = isAutoLogin) BOOL autoLogin;
@property (nonatomic, retain) NSString *memberNo;
@property (nonatomic,retain) NSString *token;
//公共参数
@property (nonatomic,strong) FPAppParams    *appParams;
//获取会员信息
@property (nonatomic, retain) FPPersonMember *personMember;
//接口开放情况
@property (nonatomic,strong) FPMethodMap    *methodMap;
//彩票信息
@property (nonatomic,strong) FPLotterySign  *lotterySign;
//资产信息
@property (nonatomic,strong) FPAccountInfoItem   *accountItem;
//红包账户信息

-(NSString *)getIOSGuid;

/*图像名称获取*/
-(NSString *)getHeadAddressByMemberNo:(NSString *)memberNo;
-(void)setHeadAddress:(NSString *)memberNo andName:(NSString *)imgName;

/*-------营销广告begin*/
-(FPAdvertiseInfo *)getAdInfoWithMemberNo:(NSString *)memberNo;
-(BOOL)saveAdInfo:(NSString *)memberNo andObject:(FPAdvertiseInfo *)adInfoItem;
-(BOOL)deleteAdFileData;
/*-------营销广告end*/

-(BOOL)isShowDisclaimer:(NSString *)memberNo;
-(void)setShowDisclaimer:(NSString *)memberNo andFlag:(BOOL)showDisclaimer;


+(Config *) Instance;
+(id)allocWithZone:(NSZone *)zone;

@end
