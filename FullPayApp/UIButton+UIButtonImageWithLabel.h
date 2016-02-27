//
//  UIButton+UIButtonImageWithLabel.h
//  ComponetTest
//
//  Created by mark zheng on 13-8-29.
//  Copyright (c) 2013年 fullpay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (UIButtonImageWithLabel)

-(void)setImage:(UIImage *)image withTitle:(NSString *)title forState:(UIControlState)state;

-(void)addLine:(UIButton *)sender;
-(void)removeLine:(UIButton *)sender;

@end
