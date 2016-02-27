//
//  AppMacro.h
//  FullPayApp
//
//  Created by mark zheng on 14-5-17.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#ifndef FullPayApp_AppMacro_h
#define FullPayApp_AppMacro_h

#define kFPPost @"preprocess/mobile/mobileService"
#define kFPFilePost @"preprocess/mobile/mobileUploadService"
#define kHEADIMGPATH @"/preprocess/mobile/mobileHeadImage/"
#define kGETIMAGE @"/preprocess/mobile/mobileHeadImageByMember"


#ifdef DEBUG
#define kSST_DOWNLOAD @"http://61.145.158.130:6082/fulllife-web/secondhand/main.do"//@"http://10.186.255.212/fulllife-web/secondhand/main.do"
#else
#define kSST_DOWNLOAD @"http://secondhand.futongcard.com/fulllife-web/secondhand/main.do"
#endif

#ifdef DEBUG
#define kRESTAURANT_URL @"http://10.186.255.47:8080/fulllife-web/lbs/index.do"
#else
#define kRESTAURANT_URL @"http://www.futongcard.com/fulllife-web/lbs/index.do"
#endif

#ifdef DEBUG
//#define CAIPIAOTEST
#ifdef CAIPIAOTEST
#define kGROUPBUY_BASEURI @"http://caipiao.futongcard.com:6082"
#else
#define kGROUPBUY_BASEURI @"http://10.186.255.47"
#endif
#else
#define kGROUPBUY_BASEURI @"http://mobile.futongcard.com"
#endif
#define kMainWebUri @"/fulllife-web/groupbuy/index.do"
#define kPayPageUri @"/fulllife-web/groupbuy/input_psw.do"
#define kPayResultUri @"/fulllife-web/groupbuy/pay.do"
#define kOrderUri  @"/fulllife-web/groupbuy/order.do"
#define kRestaurantUrl @"/fulllife-web/lbs/index.do"


#define kNetworkErrorMessage @"网络连接失败,请查看网络是否连接正常!"

#define kCardRemarkMaxLength  10
#define kPhoneNumberLength 11

//定义app是否登录状态
typedef NS_ENUM(NSInteger, FPControllerState) {
    FPControllerStateNoAuthorization = 0,
    FPControllerStateAuthorization,
};

#endif
