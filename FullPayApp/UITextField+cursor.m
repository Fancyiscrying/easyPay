//
//  UITextField+cursor.m
//  FullPayApp
//
//  Created by 刘通超 on 14/11/17.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "UITextField+cursor.h"

@implementation UITextField (cursor)
-(void)setPhoneTextFieldCursorWithRange:(NSRange)range{
    UITextPosition *beginning = self.beginningOfDocument;
    UITextPosition *start = [self positionFromPosition:beginning offset:range.location+1];
    if (range.location == 3||range.location == 8) {
        start = [self positionFromPosition:beginning offset:range.location+2];
    }
    UITextPosition *end = [self positionFromPosition:start offset:0];
    UITextRange *textRange = [self textRangeFromPosition:start toPosition:end];
    
    self.selectedTextRange = textRange;
}

-(void)setBankCardTextFieldCursorWithRange:(NSRange)range{
    UITextPosition *beginning = self.beginningOfDocument;
    UITextPosition *start = [self positionFromPosition:beginning offset:range.location+1];
    if (range.location % 5 == 4) {
        start = [self positionFromPosition:beginning offset:range.location+2];
    }
    UITextPosition *end = [self positionFromPosition:start offset:0];
    UITextRange *textRange = [self textRangeFromPosition:start toPosition:end];
    
    self.selectedTextRange = textRange;
}

@end
