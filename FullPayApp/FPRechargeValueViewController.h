//
//  FPRechargeValueViewController.h
//  FullPayApp
//
//  Created by mark zheng on 14-3-3.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPViewController.h"
#import "ZHTextField.h"

@interface FPRechargeValueViewController : FPViewController

@property (nonatomic,strong) ZHTextField    *fld_PhoneNumber;
@property (nonatomic,strong) UIButton       *btn_PhoneList;

@property (nonatomic,strong) UILabel        *lbl_TelComp;
@property (nonatomic,strong) UIButton       *btn_FirstValue;
@property (nonatomic,strong) UIButton       *btn_SecondValue;
@property (nonatomic,strong) UIButton       *btn_ThirdValue;
@property (nonatomic,strong) UIButton       *btn_FourValue;
@property (nonatomic,strong) UILabel        *lbl_RealPrice;

@property (nonatomic,strong) UIButton       *btn_NextStep;


@end
