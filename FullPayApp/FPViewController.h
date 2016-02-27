//
//  FPViewController.h
//  FullPayApp
//
//  Created by mark zheng on 14-2-11.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FPViewController : UIViewController
{
    UIView  *defaultBackView;
}

@property (nonatomic,assign) FPControllerState  launch_state;

- (void)showMojiNotice:(BOOL)flag;

- (void)showToastMessage:(NSString *)message;

- (void)gotoHomePage;
@end
