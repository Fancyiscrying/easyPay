//
//  FPTrendViewController.h
//  FullPayApp
//
//  Created by mark zheng on 14-2-12.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPViewController.h"

typedef NS_ENUM(NSInteger, FPTrendType) {
    FPTrendTypeDynmic = 0,
    FPTrendTypeDalibao
};

@interface FPTrendViewController : FPViewController <UIWebViewDelegate>

@property(nonatomic,strong) UIWebView *webView;
@property(nonatomic,assign) FPTrendType trendType;

@end
