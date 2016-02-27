//
//  FPMicroDefine.h
//  FullPayApp
//
//  Created by mark zheng on 14-2-21.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#ifndef FullPayApp_FPMicroDefine_h
#define FullPayApp_FPMicroDefine_h

#define FORMAT_GROUP @"%@%@?memberNo=%@&sec=%@&sys=ios"
#define FORMAT_GROUP_With_Symbol @"%@%@&memberNo=%@&sec=%@&sys=ios"

#define loadNext20Tip @"下面 20 项 . . ."
#define loadingTip @"正在加载 . . ."
#define Limt @"20"

//AES加密密码
#define AESEncryKey @"timessharing"
#define LAST_DATE @"lastDate"

#define COMM_BTN_BLUE   @"comm_bt_next_blue"
#define COMM_BTN_GRAY   @"comm_bt_next_gray"
#define COMM_BTN_YELL   @"comm_bt_next_yellow"
#define COMM_BTN_WHITE  @"comm_bt_next_white"

//记录手势密码是否关闭，还是未设
#define SET_GESUTREPWD_OFF @"setGesturePwdOFF"
#define EVER_SET_GESUTREPWD @"everSetGesturePwd"

#define FULL_WALLET_CARDNO @"fullWalletCardNo"

#define HAS_CLICK_LOTTERY @"HasClickLottery"

//程序进入后台记录时间(用于检测是否弹出手势密码)
#define BACKGROUND_MAX_TIME_MINUTE 10

//记录手机充值手机号
#define RECHARGE_PHONE_NUM @"rechargePhoneNum"

/**
 * 关于自动更新token，时间戳记录
 */
#define TOKEN_VALUE_TIME_DAY 7
#define LOGIN_TIME @"loginTime"
#define TOKEN_BACKGROUND_TIME @"tokenBackgroundTime"

#endif
