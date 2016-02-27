//
//  FPWalletPayPwdView.h
//  FullPayApp
//
//  Created by LC on 15/6/22.
//  Copyright (c) 2015年 fullpay. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FPWalletPayPwdView;
@protocol FPWalletPayPwdViewDelegate <NSObject>
@optional

- (void)walletPayPwdView:(FPWalletPayPwdView *)walletPayPwdView andPassword:(NSString *)password;

@end

typedef void(^FPWalletPayPwdCompletionBlock)(BOOL cancelled, NSString * password);

@interface FPWalletPayPwdView : UIView<FPPassCodeViewDelegate>
@property (nonatomic,strong) id<FPWalletPayPwdViewDelegate> delegate;

/**
 *  创建解绑卡View
 */
-(id)initWithUnbingCardTypeandCompletion:(FPWalletPayPwdCompletionBlock)completion;

/**
 *  创建挂失卡View
 */
-(id)initWithLossCardTypeandCompletion:(FPWalletPayPwdCompletionBlock)completion;

/**
 *  创建解挂卡View
 */
-(id)initWithRemoveLossCardTypeandCompletion:(FPWalletPayPwdCompletionBlock)completion;

/**
 *  创建补卡提示View
 */
-(id)initWithchangeCardTypeandandmoney:(CGFloat)money Completion:(FPWalletPayPwdCompletionBlock)completion;

/**
 *  创建转入卡View
 *
 *  @param money      转入金额
 *  @param completion 完成后的点击事件
 *  @parrm cardNo     转入实名卡号
 *
 *  @return 转入卡View
 */
-(id)initWithchangeCardTypeandandmoney:(CGFloat)money CardNo:(NSString *)cardNo Completion:(FPWalletPayPwdCompletionBlock)completion;

/**
 *  创建挂失提示View
 */
-(id)initWithLossCardTypeMessageandCompletion:(FPWalletPayPwdCompletionBlock)completion;


@end
