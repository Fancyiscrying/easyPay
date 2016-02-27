//
//  FPBankCardInfoViewController.h
//  FullPayApp
//
//  Created by mark zheng on 14-2-28.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPViewController.h"

@interface FPBankCardInfoViewController : FPViewController

@property (nonatomic,strong) UIButton   *btn_Delete;

@property (nonatomic,strong) NSString   *bankCardId;
@property (strong, nonatomic) NSDictionary *bankCard;
@end
