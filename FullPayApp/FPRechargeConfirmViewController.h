//
//  FPRechargeConfirmViewController.h
//  FullPayApp
//
//  Created by mark zheng on 14-3-3.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPViewController.h"
#import "FPPassCodeView.h"

#import "FPMobileRechargeModel.h"

@interface FPRechargeConfirmViewController : FPViewController

@property (nonatomic,strong) UILabel    *lbl_InPhoneNumber;
@property (nonatomic,strong) UILabel    *lbl_PayTip;
@property (nonatomic,strong) UILabel    *lbl_payNumber;
@property (nonatomic,strong) UILabel    *lbl_PayAmt;

@property (nonatomic,strong) UILabel    *lbl_Balance;

@property (nonatomic,strong) FPPassCodeView  *fld_PayPwd;
@property (nonatomic,strong) UIButton   *btn_NextStep;

@property (nonatomic,strong) NSString       *mobileNo;
@property (nonatomic,strong) MobileOption   *mobileOption;
@property (nonatomic,strong) NSString       *userPhoneTelecom;

@end
