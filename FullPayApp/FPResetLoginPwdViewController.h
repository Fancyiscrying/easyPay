//
//  FPResetLoginPwdViewController.h
//  FullPayApp
//
//  Created by mark zheng on 14-2-20.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPViewController.h"
#import "ZHTextField.h"
#import "ZHCheckBoxButton.h"
#import "FPRgtItem.h"

@interface FPResetLoginPwdViewController : FPViewController

@property (strong, nonatomic) ZHTextField *fld_NewLoginPwd;
@property (strong, nonatomic) ZHCheckBoxButton *btn_ShowPwd;
@property (strong, nonatomic) UIButton *btn_NextStep;

@property (nonatomic,strong) FPRgtItem *rgtItem;

@end
