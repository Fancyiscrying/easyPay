//
//  UITextField+cursor.h
//  FullPayApp
//
//  Created by 刘通超 on 14/11/17.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (cursor)
-(void)setPhoneTextFieldCursorWithRange:(NSRange)range;
-(void)setBankCardTextFieldCursorWithRange:(NSRange)range;
@end
