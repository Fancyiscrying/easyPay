//
//  FPMethodMap.h
//  FullPayApp
//
//  Created by mark zheng on 14-1-10.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FPMethodMap : NSObject

@property (nonatomic,strong) NSDictionary *methodMap;

- (id)initWithAttributes:(NSDictionary *)attributes;

@end
