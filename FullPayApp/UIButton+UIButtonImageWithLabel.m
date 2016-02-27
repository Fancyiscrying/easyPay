//
//  UIButton+UIButtonImageWithLabel.m
//  ComponetTest
//
//  Created by mark zheng on 13-8-29.
//  Copyright (c) 2013年 fullpay. All rights reserved.
//

#import "UIButton+UIButtonImageWithLabel.h"
#import<CoreText/CoreText.h>

@implementation UIButton (UIButtonImageWithLabel)

-(void)setImage:(UIImage *)image withTitle:(NSString *)title forState:(UIControlState)state
{
    UIColor *color = [UIColor darkGrayColor] ;
    [self.imageView setContentMode:UIViewContentModeLeft];
    [self setImage:image forState:state];
//    [self setImageEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0, 0)];
    [self.titleLabel setContentMode:UIViewContentModeRight];
    [self.titleLabel setBackgroundColor:[UIColor clearColor]];
    [self.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:11.0f]];
    [self.titleLabel setTextColor:color];
    [self.titleLabel sizeToFit];
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 10.0, 0, 0)];
    [self setTitle:title forState:state];
    [self setTitleColor:color forState:state];
}

-(void)addLine:(UIButton *)sender
{
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0")) {
        NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:sender.titleLabel.text];
//        [attriString addAttribute:(NSString *)kCTUnderlineStyleAttributeName value:(id)[NSNumber numberWithInt:kCTUnderlineStyleDouble] range:NSMakeRange(0, sender.titleLabel.text.length)];
        [attriString addAttribute:(NSString *)kCTUnderlineStyleAttributeName value:(id)[NSNumber numberWithInt:kCTUnderlineStyleSingle] range:NSMakeRange(0, sender.titleLabel.text.length)];
        
        sender.titleLabel.attributedText = attriString;
    }
}

-(void)removeLine:(UIButton *)sender
{
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0")) {
        NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:sender.titleLabel.text];
        [attriString removeAttribute:(NSString *)kCTUnderlineStyleAttributeName range:NSMakeRange(0, sender.titleLabel.text.length)];
        
        sender.titleLabel.attributedText = attriString; //attributedText是ios6.0之后支持的
    }
}

@end
