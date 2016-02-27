//
//  AccountCell.h
//  MicroLoan
//
//  Created by 刘通超 on 15/1/8.
//  Copyright (c) 2015年 刘通超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountCell : UIView

@property (strong, nonatomic) NSString *leftString;
@property (strong, nonatomic) NSString *rightString;
@property (strong, nonatomic) UIColor *textColor;
@property (strong, nonatomic) UIFont *fontSize;
@property (strong, nonatomic) UIColor *leftStringColor;

@property (assign, nonatomic) float widthToSide;
@property (assign, nonatomic) float rightStringLeft;

@end
