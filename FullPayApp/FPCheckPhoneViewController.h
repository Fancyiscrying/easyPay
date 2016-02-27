//
//  FPCheckPhoneViewController.h
//  FullPayApp
//
//  Created by mark zheng on 14-2-20.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPViewController.h"
#import "FPTextField.h"

@interface FPCheckPhoneViewController : FPViewController

@property (strong, nonatomic) IBOutlet FPTextField *fld_PhoneNumber;
@property (strong, nonatomic) IBOutlet FPTextField *fld_Captcha;

@property (strong, nonatomic) IBOutlet UIButton *btn_GetCaptcha;
@property (strong, nonatomic) IBOutlet UIButton *btn_NextStep;

@end
