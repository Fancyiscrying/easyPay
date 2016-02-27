//
//  FPTextField.h
//  FullPayApp
//
//  Created by mark zheng on 13-8-29.
//  Copyright (c) 2013年 fullpay. All rights reserved.
//

#import <UIKit/UIKit.h>


@class FPTextField;
@protocol FPTextFieldDelegate <NSObject>

@optional
-(void)clickDone:(FPTextField *)sender;

@end

@interface FPTextField : UITextField

@property (nonatomic,weak) id<FPTextFieldDelegate> delegateDone;

- (id)initWithNoRectOffsetFrame:(CGRect)frame;
@end
