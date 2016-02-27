//
//  ContactsInfo.h
//  FullPayApp
//
//  Created by mark zheng on 14-6-3.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContactsInfo : NSObject

@property (nonatomic, retain) NSString * fromMemberNo;
@property (nonatomic, retain) NSString * toMemberAvator;
@property (nonatomic, retain) NSString * toMemberNo;
@property (nonatomic, retain) NSString * toMemberName;
@property (nonatomic, retain) NSString * toMemberPhone;
@property (nonatomic, retain) NSString * toRemark;
@property (nonatomic, retain) NSString * toAmount;
@property (nonatomic, retain) NSString *createDate;

@property (nonatomic,strong) NSString *password;

@end
