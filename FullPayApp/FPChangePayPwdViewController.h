//
//  FPChangePayPwdViewController.h
//  FullPayApp
//
//  Created by mark zheng on 14-2-27.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPViewController.h"
#import "FPPassCodeView.h"

@interface FPChangePayPwdViewController : FPViewController

@property (strong, nonatomic) FPPassCodeView *fieldOrgPwd;
@property (strong, nonatomic) FPPassCodeView *fieldPwd;
@property (strong, nonatomic) UIButton *btnShowPwd;

@end
