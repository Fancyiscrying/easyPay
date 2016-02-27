//
//  RTStarLabel.h
//  ReadilyTao
//
//  Created by lc on 14-8-25.
//  Copyright (c) 2014年 FZF. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RTStarLabel : UIView
@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) UIColor *textColor;

- (id)initWithFrame:(CGRect)frame andText:(NSString *)text andTextColor:(UIColor *)color;
@end
