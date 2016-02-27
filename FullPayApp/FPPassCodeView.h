//
//  FPPassCodeView.h
//  PAPasscode Example
//
//  Created by mark zheng on 13-12-16.
//  Copyright (c) 2013年 Peer Assembly. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FPPassCodeView;
@protocol FPPassCodeViewDelegate <NSObject>

@optional
-(void)passCodeViewBecomeFirstResponse;
-(void)passCodeViewResignFirstResponse;
-(void)handleCompleteField:(FPPassCodeView*)sender;
-(void)passCodeView:(FPPassCodeView *)sender checkPassCodeLength:(NSString *)passCode;
@end

#define IMG_PASSCODE_COUNT 6

@interface FPPassCodeView : UIView {
    UIView *contentView;
    NSInteger phase;
    UITextField *passcodeTextField;
    UIImageView *digitImageViews[IMG_PASSCODE_COUNT];
    UIImageView *snapshotImageView;
}

@property (strong) NSString *passcode;
@property (strong) UILabel *titleLabel;
@property (assign) BOOL simple;
@property (assign) BOOL securet;

@property (nonatomic,weak) id<FPPassCodeViewDelegate> delegate;

-(id)initWithFrame:(CGRect)frame withSimple:(BOOL)simple;
- (void)showScreenForPhase:(NSInteger)newPhase animated:(BOOL)animated;

-(void)setInputIdKeyboard:(BOOL)keyboardType;

-(BOOL)isFirstResponse;
-(void)becomeFirstResponse;
-(void)resignFirstResponse;
-(void)clearPasscode;
/**
 *  获取passcode
 *
 *  @return 字符串
 */
-(NSString *)getPasscode;

- (void)refeshView;

@end
