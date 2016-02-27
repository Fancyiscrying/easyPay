//
//  ZHTextField.m
//  FullPayApp
//
//  Created by mark zheng on 14-5-17.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "ZHTextField.h"

#define kPadLeft 20.0f
@implementation ZHTextField

- (id)init
{
    if (self = [super init]) {

    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}

- (CGRect)textRectForBounds:(CGRect)bounds
{
    return [self zhNewRect:bounds];
}

- (CGRect)placeholderRectForBounds:(CGRect)bounds
{
    
    
    return [self zhNewRect:bounds];
}

- (CGRect)editingRectForBounds:(CGRect)bounds
{
    return [self zhNewRect:bounds];
}

- (CGRect)zhNewRect:(CGRect)bounds
{
    CGRect newRect = CGRectMake(kPadLeft, CGRectGetMinY(bounds), CGRectGetWidth(bounds) - kPadLeft, CGRectGetHeight(bounds));
    
    return newRect;
}

-(void)setLeftView:(UIView *)leftView
{
    [super setLeftView:leftView];
    
    self.leftViewMode = UITextFieldViewModeAlways;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
