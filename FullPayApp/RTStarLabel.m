//
//  RTStarLabel.m
//  ReadilyTao
//
//  Created by lc on 14-8-25.
//  Copyright (c) 2014年 FZF. All rights reserved.
//

#import "RTStarLabel.h"

@implementation RTStarLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

- (id)initWithFrame:(CGRect)frame andText:(NSString *)text andTextColor:(UIColor *)color{
    self = [self initWithFrame:frame];
    self.text = text;
    self.textColor = color;
    [self initView];
    
    return self;
}


- (void)initView{
    UIImageView *redStar = [[UIImageView alloc]initWithImage:MIMAGE(@"red_star.png")];
    redStar.center = CGPointMake(10, self.height/2);
    redStar.width = 7;
    redStar.height = 7;
    
    [self addSubview:redStar];
    
    UILabel *label = [[UILabel alloc]initWithFrame:self.bounds];
    label.width = self.width-redStar.width;
    label.left = redStar.right;
    label.textColor = self.textColor;
    label.text = self.text;
    label.font = [UIFont systemFontOfSize:13.0];
    if (self.textColor == nil) {
        label.textColor = [UIColor grayColor];
    }
    
    [self addSubview:label];
}

@end
