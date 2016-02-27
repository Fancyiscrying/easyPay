//
//  ZHCheckBoxButton.m
//  ZHCheckBoxDemo
//
//  Created by mark zheng on 14-5-19.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "ZHCheckBoxButton.h"

@implementation ZHCheckBoxButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _icon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetHeight(frame), CGRectGetHeight(frame))];
        [self setChecked:NO];
        [self addSubview:_icon];
        
        _label = [[UILabel alloc] initWithFrame:CGRectMake(_icon.frame.size.width + 7.0, 0, frame.size.width - _icon.frame.size.width - 10, frame.size.height)];
        _label.backgroundColor = [UIColor clearColor];
        _label.textAlignment = NSTextAlignmentLeft;
        _label.font = [UIFont systemFontOfSize:10];
        [self addSubview:_label];
        
        [self addTarget:self action:@selector(onButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)setChecked:(BOOL)checked
{
    if (checked != _checked) {
        _checked = checked;
    }
    
    if (!_normalImage) {
        _normalImage = [UIImage imageNamed:ZH_ICON_CHECK_NORMAL];
    }
    
    if (!_selectedImage) {
        _selectedImage = [UIImage imageNamed:ZH_ICON_CHECK_SELECT];
    }
    
    if (_checked) {
        [_icon setImage:self.selectedImage];
    } else {
        [_icon setImage:self.normalImage];
    }
}

- (void)onButtonClicked:(id)sender
{
    [self setChecked:!_checked];
    
    if(_delegate){
        if([_delegate respondsToSelector:@selector(onCheckButtonClicked:)]){
            [_delegate performSelector:@selector(onCheckButtonClicked:) withObject:self];
        }
    }
}

- (void)dealloc
{
    _delegate = nil;
    _icon = nil;
    _label = nil;
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
