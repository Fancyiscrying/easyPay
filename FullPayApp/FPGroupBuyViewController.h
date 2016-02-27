//
//  FPGroupBuyViewController.h
//  FullPayApp
//
//  Created by mark zheng on 14-2-13.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPViewController.h"

typedef NS_ENUM(NSInteger, FPGroupBuyViewControllerType) {
    FPGroupBuyViewControllerTypeAuth,
    FPGroupBuyViewControllerTypeNoAuth
};

@interface FPGroupBuyViewController : FPViewController

<UIWebViewDelegate>

@property(nonatomic,strong) UIWebView *webView;
@property(nonatomic,strong) NSString *redirectUri;

@property(nonatomic,assign) FPGroupBuyViewControllerType groupViewType;

@end
