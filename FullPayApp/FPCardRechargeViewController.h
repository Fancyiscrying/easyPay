//
//  FPCardRechargeViewController.h
//  FullPayApp
//
//  Created by mark zheng on 14-2-28.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPViewController.h"
#import "ZHTextField.h"

#define TFTCALLBACKNAME @"fpcallback"

@interface FPCardRechargeViewController : UIViewController<UIAlertViewDelegate,UITextFieldDelegate>

@property (strong, nonatomic) UILabel *labelAccount;
@property (strong, nonatomic) ZHTextField *fieldAmt;
@property (strong, nonatomic) NSString  *bankCardId;
@property (strong, nonatomic) NSString  *bankCardNo;
@property (strong, nonatomic) NSString *redirectUri;

@end
