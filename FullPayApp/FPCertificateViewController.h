//
//  FPCertificateViewController.h
//  FullPayApp
//
//  Created by mark zheng on 14-3-3.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPViewController.h"
#import "ZHTextField.h"
#import "FPIdVerify.h"

@interface FPCertificateViewController : FPViewController

@property (nonatomic,strong) FPIdVerify   *idVerifyInfo;

@property (nonatomic,strong) ZHTextField *fld_CertNo;
@property (nonatomic,strong) UIButton *btn_NextStep;

@end
