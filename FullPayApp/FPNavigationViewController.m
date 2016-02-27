//
//  FPNavigationViewController.m
//  FullPayApp
//
//  Created by mark zheng on 14-2-13.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPNavigationViewController.h"

@interface FPNavigationViewController ()

@end

@implementation FPNavigationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
}

+(void)initialize
{
    UINavigationBar *navBar = [UINavigationBar appearance];
    [navBar setBackgroundImage:[UIImage imageNamed:@"title_bg.png"] forBarPosition:UIBarPositionTopAttached barMetrics:UIBarMetricsDefault];
    
    [navBar setBarTintColor:MCOLOR(@"color_navbar_tint")];
    
    navBar.tintColor = [UIColor whiteColor]; //这是设置返回上一级的颜色,默认蓝色

    UIFont *font = [UIFont systemFontOfSize:18.0f];
    NSDictionary *dict = @{NSFontAttributeName:font,NSForegroundColorAttributeName:[UIColor whiteColor]};
    navBar.titleTextAttributes = dict;
    
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.childViewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    [super pushViewController:viewController animated:animated];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
