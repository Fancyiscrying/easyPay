//
//  FPRgtPhoneViewController.h
//  FullPayApp
//
//  Created by mark zheng on 14-2-20.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPViewController.h"
#import "FPTextField.h"
#import "ZHCheckBoxButton.h"

@interface FPRgtPhoneViewController : FPViewController

@property (strong, nonatomic) FPTextField *fld_PhoneNumber;
@property (strong, nonatomic) FPTextField *fld_Captcha;

@property (strong, nonatomic) UIButton *btn_GetCaptcha;
@property (strong, nonatomic) ZHCheckBoxButton *btn_Agree;
@property (strong, nonatomic) UIButton *btn_ShowProtecol;

@property (strong, nonatomic) UIButton *btn_NextStep;

@end
