//
//  FPShortcutPayView.m
//  FullPayApp
//
//  Created by 刘通超 on 14/11/26.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPShortcutPayView.h"

@implementation FPShortcutPayView

- (id)init{
    self = [super initWithFrame:ScreenBounds];
    if (self) {
        [self installCostum];
    }
    
    return self;
}

- (void)installCostum{
    UIView *view = [[UIView alloc]initWithFrame:self.frame];
    view.backgroundColor = [UIColor blackColor];
    view.alpha = 0.8;
    [self addSubview:view];
    self.backgroundColor = [UIColor clearColor];
    
    UIButton *dimScan = [UIButton buttonWithType:UIButtonTypeCustom];
    dimScan.frame = CGRectMake(ScreenWidth-80, 44, 50, 50);
    [dimScan setBackgroundColor:[UIColor clearColor]];
    [dimScan setImage:MIMAGE(@"home_shortcut_pay.png") forState:UIControlStateNormal];
    
    [dimScan addTarget:self action:@selector(click_DimScan) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:dimScan];
    
    UIButton *preferentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    preferentButton.frame = CGRectMake(0, 120,80,80);
    preferentButton.right = ScreenWidth-(ScreenWidth-160)/4;
    [preferentButton setImage:MIMAGE(@"home_shortcutPay_2dcode.png") forState:UIControlStateNormal];
    [preferentButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    preferentButton.backgroundColor = [UIColor clearColor];
    preferentButton.tag = 101;
    
    [view addSubview:preferentButton];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(preferentButton.left, preferentButton.bottom-5, 80, 30)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:20];
    label.text = @"收款码";
    label.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label];
    
    UIButton *goodsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    goodsButton.frame = CGRectMake((ScreenWidth-160)/4, preferentButton.top, 80, 80);
    [goodsButton setImage:MIMAGE(@"home_shortcutPay_scan.png") forState:UIControlStateNormal];
    
    [goodsButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    goodsButton.backgroundColor = [UIColor clearColor];
    goodsButton.tag = 100;
    
    [view addSubview:goodsButton];
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(goodsButton.left, goodsButton.bottom-5, 80, 30)];
    label2.backgroundColor = [UIColor clearColor];
    label2.textColor = [UIColor whiteColor];
    label2.font = [UIFont systemFontOfSize:20];
    label2.text = @"扫一扫";
    label2.textAlignment = NSTextAlignmentCenter;
    
    
    [view addSubview:label2];
}

- (void)click_DimScan{

    [self removeFromSuperview];
}

- (void)clickButton:(UIButton *)sender{
    int buttonIndex = (int)sender.tag - 100;
    if ([self.delegate respondsToSelector:@selector(shortcutPayViewClickButtonAtIdexth:)]) {
        [self.delegate shortcutPayViewClickButtonAtIdexth:buttonIndex];
    }

    [self removeFromSuperview];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{

    [self removeFromSuperview];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
