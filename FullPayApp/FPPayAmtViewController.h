//
//  FPPayAmtViewController.h
//  FullPayApp
//
//  Created by mark zheng on 14-3-3.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPViewController.h"
#import "FPTextField.h"
#import "ZHTextField.h"
#import "ContactsInfo.h"

@interface FPPayAmtViewController : FPViewController

@property (nonatomic,strong) ZHTextField    *fld_PhoneNumber;
@property (nonatomic,strong) UIButton       *btn_PhoneList;

@property (nonatomic,strong) UILabel        *lbl_Tip1;
@property (nonatomic,strong) UILabel        *lbl_InPhoneNumber;
@property (nonatomic,strong) FPTextField    *fld_PayAmt;
@property (nonatomic,strong) UILabel        *lbl_Balance;
@property (nonatomic,strong) FPTextField    *fld_Remark;

@property (nonatomic,strong) UIButton       *btn_NextStep;

@property (nonatomic,strong) ContactsInfo  *transferData;
@property (nonatomic,assign) BOOL           showPhoneNumberField;

//由扫描界面进入
@property (nonatomic) BOOL isFromDimScanViewController;
@property (copy, nonatomic) NSString *toTelNumber;
@property (copy, nonatomic) NSString *toName;

//从通讯录
@property (nonatomic) BOOL isComeFromPeoplePicker;
@property (nonatomic, copy) NSString *theSelectPhoneNum;

@end
