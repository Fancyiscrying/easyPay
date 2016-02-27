//
//  FPFullWalletEnclosureViewController.m
//  FullPayApp
//
//  Created by 刘通超 on 14/12/8.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPFullWalletEnclosureViewController.h"
#import "FPFullWalletViewController.h"

@interface FPFullWalletEnclosureViewController ()

@end

@implementation FPFullWalletEnclosureViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    self.tabBarController.tabBar.hidden = NO;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"如何圈存";
    UIBarButtonItem * backItem = [[UIBarButtonItem alloc] init];
    self.navigationItem.backBarButtonItem = backItem;
        // Do any additional setup after loading the view.
}

- (void)click_LeftButton{

    NSArray *controllers = self.navigationController.viewControllers;
    for (UIViewController *temp in controllers) {
        if ([temp isMemberOfClass:NSClassFromString(@"FPFullWalletViewController")]) {
            [self.navigationController popToViewController:temp animated:NO];
            return;
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
