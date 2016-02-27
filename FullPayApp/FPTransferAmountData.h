//
//  FPTransferAmountData.h
//  FullPayApp
//
//  Created by mark zheng on 14-5-28.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FPTransferAmountData : NSObject

@property (nonatomic,strong) NSString *memberNo;
@property (nonatomic,strong) NSString *inMemberNo;
@property (nonatomic,strong) NSString *amount;
@property (nonatomic,strong) NSString *password;
@property (nonatomic,strong) NSString *remark;
@property (nonatomic,strong) NSString *inMobileNo;
@property (nonatomic,strong) NSString *inMemberName;
@property (nonatomic,strong) NSString *inMemberAvator;

@end
