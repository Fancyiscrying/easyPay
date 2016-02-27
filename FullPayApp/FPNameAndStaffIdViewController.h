//
//  FPNameAndStaffIdViewController.h
//  FullPayApp
//
//  Created by mark zheng on 14-3-3.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPViewController.h"
#import "ZHTextField.h"

@interface FPNameAndStaffIdViewController : FPViewController

@property (nonatomic,strong) UILabel    *lbl_Tips;
@property (nonatomic,strong) ZHTextField *fld_RealName;
@property (nonatomic,strong) ZHTextField *fld_StaffId;
@property (nonatomic,strong) UILabel     *lbl_Notice;
@property (nonatomic,strong) UIButton    *btn_NextStep;

@end
