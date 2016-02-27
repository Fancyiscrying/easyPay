//
//  FPTabBarViewController.m
//  FullPayApp
//
//  Created by mark zheng on 14-2-12.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPTabBarViewController.h"

@interface FPTabBarViewController ()

@end

@implementation FPTabBarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.userState == FPControllerStateNoAuthorization) {
        FPDEBUG(@"FPControllerStateNoAuthorization");
    } else {
        FPDEBUG(@"FPControllerStateAuthorization");
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [[UITabBar appearance] setBackgroundImage:[UIImage imageNamed:@"tab_bt"]];
//    [[UITabBar appearance] setBarTintColor:[UIColor clearColor]];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:MCOLOR(@"color_tabbar_select")} forState:UIControlStateSelected];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    
    if ([Config Instance].isAutoLogin) {
        self.userState = FPControllerStateAuthorization;
    }else{
        self.userState = FPControllerStateNoAuthorization;

    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
