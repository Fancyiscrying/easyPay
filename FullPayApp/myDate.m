//
//  myDate.m
//  FullPayApp
//
//  Created by 刘通超 on 14-10-9.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "myDate.h"

@implementation myDate
- (id)initWithDate:(NSDate *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy"];
    self.year = [dateFormatter stringFromDate:date];
    
    [dateFormatter setDateFormat:@"MM"];
    self.month = [dateFormatter stringFromDate:date];
    
    [dateFormatter setDateFormat:@"dd"];
    self.day = [dateFormatter stringFromDate:date];
    
    [dateFormatter setDateFormat:@"HH"];
    self.hour = [dateFormatter stringFromDate:date];
    
    [dateFormatter setDateFormat:@"mm"];
    self.minute = [dateFormatter stringFromDate:date];
    
    [dateFormatter setDateFormat:@"ss"];
    self.seconds = [dateFormatter stringFromDate:date];
    
    return self;
}

@end
