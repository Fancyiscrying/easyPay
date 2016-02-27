//
//  FPIdVerifyConfirmViewController.h
//  FullPayApp
//
//  Created by mark zheng on 14-3-3.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPViewController.h"
#import "FPPassCodeView.h"
#import "FPIdVerify.h"

@interface FPIdVerifyConfirmViewController : FPViewController

@property (nonatomic,strong) FPPassCodeView *fld_PayPwd;
@property (nonatomic,strong) UIImageView *imgLine;
@property (nonatomic,strong) UIButton   *btn_Refill;
@property (nonatomic,strong) UIButton   *btn_Submit;
@property (strong, nonatomic) UIButton *btn_BackHomeView;

@property (nonatomic,strong) NSString   *payPwd;

@property (nonatomic,assign) BOOL         result;
@property (nonatomic,strong) FPIdVerify   *idVerifyInfo;

@end
