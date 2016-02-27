//
//  FPRgtItem.h
//  FullPayApp
//
//  Created by mark zheng on 14-2-25.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FPRgtItem : NSObject

@property (nonatomic,strong) NSString *rgt_PhoneNumber;
@property (nonatomic,strong) NSString *rgt_ProcessCode;
@property (nonatomic,strong) NSString *rgt_CaptchaCode;
@property (nonatomic,strong) NSString *rgt_PayPwd;
@property (nonatomic,strong) NSString *rgt_LoginPwd;

@end
