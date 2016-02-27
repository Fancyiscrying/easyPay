//
//  FPLotteryWebViewController.h
//  FullPayApp
//
//  Created by mark zheng on 13-11-19.
//  Copyright (c) 2013年 fullpay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FPLotteryViewController.h"

#define LOTTERYGETFORMART  @"%@?%@"
#define LOTTERYGETFORMART_WITH_SYMBOL  @"%@&%@"

@interface FPLotteryWebViewController : UIViewController<UIWebViewDelegate>

@property(nonatomic,strong) UIWebView *webView;
@property(nonatomic,strong) NSString *redirectUri;

//用于高频彩超时
@property (copy, nonatomic) NSString *gpcURL;

@property(nonatomic,assign) FPLotteryViewControllerType webViewType;

//-(NSString *)makeLotteryData:(NSString *)memberNo;
//-(NSString *)makeLotteryData:(NSString *)memberNo andMemberName:(NSString *)memberName andCertType:(NSInteger)type andCertNo:(NSString *)certNo andMobile:(NSString *)mobileNo;
//-(NSString *)getSignByJson:(NSString *)jsonStr;

-(NSString *)getGenerateSign;
-(NSString *)getGenerateGpcSign;
@end
