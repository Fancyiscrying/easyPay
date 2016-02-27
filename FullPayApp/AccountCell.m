//
//  AccountCell.m
//  MicroLoan
//
//  Created by 刘通超 on 15/1/8.
//  Copyright (c) 2015年 刘通超. All rights reserved.
//

#import "AccountCell.h"
@interface AccountCell()
@property (strong, nonatomic) UILabel *leftLab;
@property (strong, nonatomic) UILabel *rightLab;

@end

@implementation AccountCell

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self installCoustomView];
    }
    
    return self;
}

- (void)installCoustomView{
    _leftLab = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, self.width/2-15, self.height)];
    _leftLab.backgroundColor = [UIColor clearColor];
    _leftLab.font = [UIFont systemFontOfSize:14];
    _leftLab.textAlignment = NSTextAlignmentLeft;
    _leftLab.textColor = [UIColor blackColor];
    [self addSubview:_leftLab];
    
    _rightLab = [[UILabel alloc]initWithFrame:CGRectMake(self.width/2, 0, self.width/2-15, self.height)];
    _rightLab.backgroundColor = [UIColor clearColor];
    _rightLab.font = [UIFont systemFontOfSize:14];
    _rightLab.textAlignment = NSTextAlignmentRight;
    _rightLab.textColor = [UIColor blackColor];
    [self addSubview:_rightLab];
    
}

- (void)setLeftString:(NSString *)leftString{
    _leftLab.text = leftString;
}

- (void)setRightString:(NSString *)rightString{
    float height = [rightString getTextHeightWithSystemFontSize:12 andTextWidth:_rightLab.width-10];
    if (self.height >= height) {
        //_rightLab.height = height;
    }else{
        self.height = height;
        _rightLab.top = -3;
        _rightLab.height = height;
        _rightLab.numberOfLines = 2;

    }
    _rightLab.text = rightString;
}

- (void)setLeftStringColor:(UIColor *)leftStringColor{
    _leftLab.textColor = leftStringColor;
}
- (void)setFontSize:(UIFont *)fontSize{
    _leftLab.font = fontSize;
    _rightLab.font = fontSize;
}

- (void)setTextColor:(UIColor *)textColor{
    _leftLab.textColor = textColor;
    _rightLab.textColor = textColor;
}

- (void)setWidthToSide:(float)widthToSide{
    _leftLab.left = widthToSide;
    _rightLab.width = self.width/2 - widthToSide;
}

- (void)setRightStringLeft:(float)rightStringLeft{
    _rightLab.left = rightStringLeft;
    _rightLab.textAlignment = NSTextAlignmentLeft;
    _rightLab.width = self.width - rightStringLeft-10;
}

@end
