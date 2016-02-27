//
//  TimeLineCellView.h
//  FullPayApp
//
//  Created by 刘通超 on 15/4/9.
//  Copyright (c) 2015年 fullpay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FPWalletApplyCardList.h"


@interface TimeLineCellView : UIView

- (id)initWithFrame:(CGRect)frame andApplyCardInfo:(ApplyItem *)item atTheLeft:(BOOL)left;

@end
