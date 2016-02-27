//
//  FPAddFutongCardViewController.h
//  FullPayApp
//
//  Created by mark zheng on 14-2-20.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPViewController.h"
#import "ZHTextField.h"

@interface FPAddFutongCardViewController : FPViewController

@property (strong, nonatomic)  ZHTextField *fld_CardNo;
@property (strong, nonatomic)  ZHTextField *fld_SignCode;
@property (strong, nonatomic)  ZHTextField *fld_Remark;

@property (strong, nonatomic)  UIButton *btn_NextStep;

@end
