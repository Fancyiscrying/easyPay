//
//  FPCheckNewPhoneViewController.h
//  FullPayApp
//
//  Created by mark zheng on 14-3-4.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPViewController.h"
#import "FPTextField.h"

@interface FPCheckNewPhoneViewController : FPViewController

@property (strong, nonatomic) FPTextField *fld_PhoneNumber;
@property (strong, nonatomic) FPTextField *fld_Captcha;

@property (strong, nonatomic) UIButton *btn_GetCaptcha;
@property (strong, nonatomic) UIButton *btn_NextStep;

@end
