//
//  LeftTitleTextField.m
//  CarClub
//
//  Created by 刘通超 on 15/3/19.
//  Copyright (c) 2015年 刘通超. All rights reserved.
//

#import "LeftTitleTextField.h"

@interface LeftTitleTextField()
@end

@implementation LeftTitleTextField
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initLeftView];
    }
    
    return self;
}

- (void)initLeftView{
    self.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    self.leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, self.width-10, self.height)];
    self.leftLabel.backgroundColor = ClearColor;
    self.leftLabel.textColor = COLOR_STRING(@"#808080");
    [leftView addSubview:self.leftLabel];
    
    self.leftView = leftView;

}

- (void)setLeftTitle:(NSString *)leftTitle{
    self.leftLabel.text = leftTitle;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
