//
//  myDate.h
//  FullPayApp
//
//  Created by 刘通超 on 14-10-9.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface myDate : NSObject
@property (nonatomic,strong) NSString *year;
@property (nonatomic,strong) NSString *month;
@property (nonatomic,strong) NSString *day;
@property (nonatomic,strong) NSString *hour;
@property (nonatomic,strong) NSString *minute;
@property (nonatomic,strong) NSString *seconds;

- (id)initWithDate:(NSDate *)date;

@end
