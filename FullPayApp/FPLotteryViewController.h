//
//  FPLotteryViewController.h
//  FullPayApp
//
//  Created by mark zheng on 13-11-18.
//  Copyright (c) 2013年 fullpay. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, FPLotteryViewControllerType) {
    FPLotteryViewControllerTypeAuth,
    FPLotteryViewControllerTypeNoAuth,
    FPGPCLotteryViewControllerType
};

@interface FPLotteryViewController : UIViewController

@property(nonatomic,assign) FPLotteryViewControllerType lotteryViewType;

@end
