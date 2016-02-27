//
//  FPResetPayPwdViewController.h
//  FullPayApp
//
//  Created by mark zheng on 14-2-27.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPViewController.h"
#import "FPPassCodeView.h"
#import "ZHCheckBoxButton.h"
#import "FPRgtItem.h"

@interface FPResetPayPwdViewController : FPViewController

@property (strong, nonatomic) FPPassCodeView *fieldPassword;

@property (strong, nonatomic) ZHCheckBoxButton *btn_ShowPwd;
@property (strong, nonatomic) UIButton *btn_NextStep;

@property (nonatomic,strong) FPRgtItem *rgtItem;

@end
