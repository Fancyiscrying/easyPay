//
//  ZHCheckBoxButton.h
//  ZHCheckBoxDemo
//
//  Created by mark zheng on 14-5-19.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ZH_ICON_CHECK_NORMAL    @"check_no"
#define ZH_ICON_CHECK_SELECT    @"check_yes"

@protocol ZHCheckBoxButtonDelegate <NSObject>

- (void)onCheckButtonClicked:(id)control;

@end

@interface ZHCheckBoxButton : UIControl

@property (nonatomic,strong) id<ZHCheckBoxButtonDelegate> delegate;
@property (nonatomic,strong) UIImageView                  *icon;
@property (nonatomic,strong) UILabel                      *label;
@property (nonatomic,assign,getter = isChecked) BOOL      checked;

@property (nonatomic,strong) UIImage        *normalImage;
@property (nonatomic,strong) UIImage        *selectedImage;

@end
