//
//  FPDefaultView.m
//  FullPayApp
//
//  Created by mark zheng on 14-5-23.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPDefaultView.h"

#define IMG_BROWSERDEFAULT @"com_browserfail"

@implementation FPDefaultView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        CGFloat  width = CGRectGetWidth(frame);
        CGFloat  height = CGRectGetHeight(frame);
        UIImage  *imgShow = [UIImage imageNamed:IMG_BROWSERDEFAULT];
        CGRect imgRect = CGRectMake((width - imgShow.size.width) / 2, (height - imgShow.size.height) / 2 - 80.0 , imgShow.size.width, imgShow.size.height);
        _img_DefaultShow = [[UIImageView alloc] initWithFrame:imgRect];
        [_img_DefaultShow setImage:imgShow];
        [self addSubview:_img_DefaultShow];
        
        CGRect lblRect = CGRectOffset(imgRect, -25, imgRect.size.height + 10);
        lblRect.size = CGSizeMake(imgRect.size.width + 50, 40);
        _lbl_NoticeMessage = [[UILabel alloc] initWithFrame:lblRect];
        _lbl_NoticeMessage.numberOfLines = 0;
        _lbl_NoticeMessage.text = @"暂无内容\n去别的地方逛逛吧";
        _lbl_NoticeMessage.textColor = [UIColor lightGrayColor];
        _lbl_NoticeMessage.textAlignment = NSTextAlignmentCenter;
        _lbl_NoticeMessage.backgroundColor = [UIColor clearColor];
        [_lbl_NoticeMessage setFont:[UIFont systemFontOfSize:16.0f]];
        [self addSubview:_lbl_NoticeMessage];
    }
    return self;
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
