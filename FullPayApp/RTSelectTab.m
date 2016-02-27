//
//  RTSelectTab.m
//  ReadilyTao
//
//  Created by lc on 14-8-12.
//  Copyright (c) 2014年 FZF. All rights reserved.
//

#import "RTSelectTab.h"

@implementation RTSelectTab

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

- (RTSelectTab*)initWithFrame:(CGRect)frame andButtonTitles:(NSArray*)buttonTitles{
    self = [self initWithFrame:frame];
    UIImageView *bg = [[UIImageView alloc]initWithFrame:frame];
    bg.image = MIMAGE(@"BG.png");
    [self addSubview:bg];
    
    self.backgroundColor = [UIColor clearColor];
    self.buttonTitles = buttonTitles;
    [self loadView];
    
    return self;
}


- (void)loadView{
    if (_buttonTitles.count > 0) {
       long int buttons = _buttonTitles.count;
        for (int i=0;i<buttons;i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(i*ScreenWidth/buttons, 0, ScreenWidth/buttons, self.height);
            button.backgroundColor = [UIColor clearColor];
            button.titleLabel.font = [UIFont systemFontOfSize:14.0f];
            [button setTitle:_buttonTitles[i] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
            [button addTarget:self action:@selector(clickButtonWithButtonIndex:) forControlEvents:UIControlEventTouchUpInside];
            [button setTag:i];
            if (i==0) {
                [button setSelected:YES];
            }
            [self addSubview:button];
        }
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake((ScreenWidth/buttons)/4, self.height-2, (ScreenWidth/buttons)/2, 2)];
        line.backgroundColor = [UIColor orangeColor];
        line.tag = 100;
        [self addSubview:line];
        
    }
}

- (void)clickButtonWithButtonIndex:(UIButton *)sender{
    int tag = (int)sender.tag;
    int count = (int)self.buttonTitles.count;
    UIView *line = [self viewWithTag:100];
    [UIView animateWithDuration:0.5 animations:^{
        CGAffineTransform transform = CGAffineTransformMakeTranslation(tag*ScreenWidth/count, 0);
        line.transform = transform;
    }];
    for (UIButton *button in self.subviews) {
        if ([button isMemberOfClass:[UIButton class]]) {
            if (button == sender) {
                [button setSelected:YES];
            }else{
                [button setSelected:NO];
            }

        }
    }
    if ([self.delegate respondsToSelector:@selector(clickButtonWithButtonIndex:)]) {
        [self.delegate clickButtonWithButtonIndex:(int)sender.tag];
    }
}

- (void)setLineLeft:(CGFloat)left andWidth:(CGFloat)width{
    UIView *line = [self viewWithTag:100];
    line.width = width;
    line.left = left;
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
