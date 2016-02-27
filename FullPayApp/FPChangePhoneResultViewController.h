//
//  FPChangePhoneResultViewController.h
//  FullPayApp
//
//  Created by mark zheng on 14-3-4.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPViewController.h"
#import "FPPassCodeView.h"

@interface FPChangePhoneResultViewController : FPViewController

@property (strong, nonatomic) FPPassCodeView *fld_PayPwd;
@property (strong, nonatomic) UIButton *btnShowPwd;
@property (retain, nonatomic) NSString *theNewMobile;

@end
