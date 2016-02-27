//
//  FPAddBankCardViewController.h
//  FullPayApp
//
//  Created by mark zheng on 14-2-28.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPViewController.h"
#import "ZHTextField.h"

@interface FPAddBankCardViewController : FPViewController<UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate>

@property (nonatomic,strong) UIPickerView   *pickerView;
@property (nonatomic,strong) UILabel        *lbl_Tips;
@property (nonatomic,strong) ZHTextField *fld_BankList;
@property (nonatomic,strong) UIButton    *btn_Choose;
@property (nonatomic,strong) ZHTextField *fld_BankCardNo;
@property (nonatomic,strong) UILabel *lbl_Notice;
@property (nonatomic,strong) UIButton *btn_NextStep;

@end
