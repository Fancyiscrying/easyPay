//
//  TimeLineCellView.m
//  FullPayApp
//
//  Created by 刘通超 on 15/4/9.
//  Copyright (c) 2015年 fullpay. All rights reserved.
//

#import "TimeLineCellView.h"

@implementation TimeLineCellView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame andApplyCardInfo:(ApplyItem *)item atTheLeft:(BOOL)left{
    self = [self initWithFrame:frame];
    
    UIView *verticalLine = [[UIView alloc]initWithFrame:CGRectMake((self.width-2)/2, 0, 2, self.height)];
    verticalLine.backgroundColor = [UIColor whiteColor];
    [self addSubview:verticalLine];
    
    UIView *levelLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width/3, 2)];
    levelLine.top = self.height/2-1;
    levelLine.backgroundColor = [UIColor whiteColor];
    [self addSubview:levelLine];
    
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 10, 10)];
    image.center = CGPointMake(self.width/2, self.height/2);
    image.image = MIMAGE(@"WalletCard_apply_point");
    [self addSubview:image];
    
    
    UILabel *time = [[UILabel alloc]initWithFrame:CGRectMake(0, levelLine.top-10, 60, 10)];
    time.backgroundColor = ClearColor;
    time.font = SystemFontSize(9);
    time.textAlignment = NSTextAlignmentCenter;
    time.text = item.applyDate;
    [self addSubview:time];
    
    
    float width = self.height;
    UIView *mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, width)];
    mainView.right = levelLine.left+40;
    mainView.backgroundColor = [UIColor whiteColor];
    mainView.layer.masksToBounds = YES;
    mainView.layer.cornerRadius = width/2;
    
    [self addSubview:mainView];
    
    UILabel *mainTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, mainView.height/2-20, mainView.width, 20)];
    mainTitle.backgroundColor = ClearColor;
    mainTitle.font = SystemFontSize(12);
    mainTitle.textAlignment = NSTextAlignmentCenter;
    mainTitle.textColor = COLOR_STRING(@"333333");
    mainTitle.text = @"申请成功";
    [mainView addSubview:mainTitle];
    
    UILabel *mainStatus = [[UILabel alloc]initWithFrame:CGRectMake(0, mainView.height/2, mainView.width, 20)];
    mainStatus.backgroundColor = ClearColor;
    mainStatus.font = SystemFontSize(12);
    mainStatus.textAlignment = NSTextAlignmentCenter;
    mainStatus.text = [NSString stringWithFormat:@"(%@)",item.statusName];
    [mainView addSubview:mainStatus];
    
    if (item.status == 1) {
        mainStatus.textColor = COLOR_STRING(@"#52B24D");
    }else{
        mainStatus.textColor = COLOR_STRING(@"#F80000");
    }
    
    if (left) {
        time.textColor = COLOR_STRING(@"#F80000");
        levelLine.right = self.width/2;
        time.right = self.width/2-5;
        mainView.right = levelLine.left+40;

    }else{
        time.textColor = COLOR_STRING(@"#808080");
        levelLine.left = self.width/2;
        time.left = self.width/2+5;
        mainView.left = levelLine.right-40;
    }
    
    
    return self;
}

@end
