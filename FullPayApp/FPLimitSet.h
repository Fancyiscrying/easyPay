//
//  FPLimitSet.h
//  FullPayApp
//
//  Created by mark zheng on 14-2-26.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FPLimitSet : NSObject

@property (nonatomic,copy) NSString *title;
@property (nonatomic,assign) BOOL isOn;
//@property (nonatomic,copy) NSString *placeholder;
@property (nonatomic,copy) NSString *notice;

@property (nonatomic,assign) NSInteger filedTag;

@end
