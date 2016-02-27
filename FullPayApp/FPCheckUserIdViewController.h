//
//  FPCheckUserIdViewController.h
//  FullPayApp
//
//  Created by mark zheng on 14-3-4.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPViewController.h"
#import "FPPassCodeView.h"

typedef enum {
    comeFromPersonallInfo,
    ComeFromSecuritySetView
}ComeFrom;

@interface FPCheckUserIdViewController : FPViewController

@property (strong, nonatomic) FPPassCodeView *fld_UserId;
@property (strong, nonatomic) UIButton *btnShowPwd;
@property (assign, nonatomic) ComeFrom comeFrom;
@end
