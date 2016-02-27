//
//  FPLoginViewController.h
//  FullPayApp
//
//  Created by mark zheng on 14-2-19.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPViewController.h"
#import "FPTextField.h"
#import "ZHCheckBoxButton.h"

@interface FPLoginViewController : FPViewController

@property (strong, nonatomic) FPTextField *fld_PhoneNumber;
@property (strong, nonatomic) FPTextField *fld_LoginPwd;

@property (strong, nonatomic) ZHCheckBoxButton *btn_AutoLogin;
@property (strong, nonatomic) UIButton *btn_ResetLoginPwd;

@property (strong, nonatomic) UIButton *btn_Login;
@property (strong, nonatomic) UIButton *btn_Register;

@property (assign, nonatomic) BOOL isToRoot;
@property (assign, nonatomic) BOOL isNotReturn;

@end
