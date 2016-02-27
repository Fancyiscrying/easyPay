//
//  FPChangeLoginPwdViewController.h
//  FullPayApp
//
//  Created by mark zheng on 14-2-27.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPViewController.h"
#import "ZHTextField.h"
#import "ZHCheckBoxButton.h"

@interface FPChangeLoginPwdViewController : FPViewController

@property (strong, nonatomic) ZHTextField *fieldOrgPwd;
@property (strong, nonatomic) ZHTextField *fieldPwd;
@property (strong, nonatomic) ZHCheckBoxButton *btnShowPwd;
@property (strong, nonatomic) UIButton *btnConfirm;

@end
