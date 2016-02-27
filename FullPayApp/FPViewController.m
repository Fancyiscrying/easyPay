//
//  FPViewController.m
//  FullPayApp
//
//  Created by mark zheng on 14-2-11.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPViewController.h"

#import "FPTabBarViewController.h"
#import "FPAppDelegate.h"
#import "FPLockViewController.h"

@interface FPViewController ()

@end

@implementation FPViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    
    //处理用户未登录的逻辑
    if (self.tabBarController) {
        if ([self.tabBarController isKindOfClass:[FPTabBarViewController class]]) {
            
           BOOL isPatternSet = [Config Instance].isAutoLogin;

            if (isPatternSet) {
                self.launch_state = FPControllerStateAuthorization;
            }else{
                self.launch_state = FPControllerStateNoAuthorization;
            }
            
        }
    } else {
        self.launch_state = FPControllerStateNoAuthorization;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
//    self.isLogin = NO;
    defaultBackView = [UtilTool getDefaultView:ScreenBounds];
    [self.view addSubview:defaultBackView];
    defaultBackView.hidden = YES;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showMojiNotice:(BOOL)flag
{
    defaultBackView.hidden = !flag;
}

- (void)showToastMessage:(NSString *)message
{
    [UtilTool showToastToView:self.view andMessage:message];
}

- (void)popToViewControllerCustom:(NSString *)controllerName
{
    
    BOOL hasController = NO;
    for (id controller in [self.navigationController viewControllers]) {
        if ([controller isKindOfClass:[FPViewController class]]) {
            hasController = YES;
            [self.navigationController popToViewController:controller animated:YES];
            break;
        }
    }
    if (hasController == NO) {
        FPViewController *controller = [[FPViewController alloc] init];
        //            controller.personMember = [Config Instance].personMember;
        CATransition *transition = [CATransition animation];
        transition.duration = 0.4f;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionPush;
        transition.delegate = self;
        transition.subtype = kCATransitionFromLeft;
        
        [self.navigationController.view.layer addAnimation:transition forKey:nil];
        [self.navigationController pushViewController:controller animated:YES];
    }
}
//返回到首页
- (void)gotoHomePage{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    FPTabBarViewController   *controller = [storyBoard instantiateViewControllerWithIdentifier:@"FPTabBarView"];
    
    FPAppDelegate *delegate = (FPAppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.window.rootViewController = controller;
}

@end
