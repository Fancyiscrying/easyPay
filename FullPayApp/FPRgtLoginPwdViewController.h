//
//  FPRgtLoginPwdViewController.h
//  FullPayApp
//
//  Created by mark zheng on 14-2-20.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPViewController.h"
#import "FPTextField.h"
#import "ZHCheckBoxButton.h"
#import "FPRgtItem.h"

@interface FPRgtLoginPwdViewController : FPViewController

@property (strong, nonatomic) FPTextField *fld_LoginPwd;
@property (strong, nonatomic) ZHCheckBoxButton *btn_ShowPwd;

@property (strong, nonatomic) IBOutlet UIButton *btn_NextStep;

@property (nonatomic,strong) FPRgtItem *rgtItem;
@property (nonatomic) BOOL isFirstLaunch;

@end
