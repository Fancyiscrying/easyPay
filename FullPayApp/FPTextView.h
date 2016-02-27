//
//  FPTextView.h
//  FullPayApp
//
//  Created by 刘通超 on 14/12/1.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FPTextView;
@protocol FPTextViewDelegate <NSObject>

@optional
-(void)clickDone:(FPTextView *)sender;

@end

@interface FPTextView : UITextView
@property (nonatomic,weak) id<FPTextViewDelegate> delegateDone;

@end
