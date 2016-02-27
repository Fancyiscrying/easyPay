//
//  FPWalletRechargeSucceeController.m
//  FullPayApp
//
//  Created by 刘通超 on 15/4/9.
//  Copyright (c) 2015年 fullpay. All rights reserved.
//

#import "FPWalletRechargeSucceeController.h"
#import "FPFullWalletEnclosureViewController.H"

@implementation FPWalletRechargeSucceeController
- (void)loadView{
    UIView *view = [[UIView alloc]initWithFrame:ScreenBounds];
    view.backgroundColor = COLOR_STRING(@"EDF1F2");
    self.view = view;
    
    [self createCoustomView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad{
    self.title = @"富钱包卡充值";
    
    NSDictionary *attribute = [NSDictionary dictionaryWithObjectsAndKeys:SystemFontSize(12),NSFontAttributeName, nil];
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithTitle:@"圈存知识" style:UIBarButtonItemStylePlain target:self action:@selector(tapRightButton)];
    [right setTitleTextAttributes:attribute forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = right;
    
    UIBarButtonItem *back = [[UIBarButtonItem alloc]init];
    [back setTitle:@""];
    self.navigationItem.backBarButtonItem = back;
    
}


- (void)createCoustomView{
    
    UIScrollView *scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHigh)];
    scroll.backgroundColor = ClearColor;
    scroll.showsVerticalScrollIndicator = NO;
    
    
    float topWidth = 150;

    UIImageView *topView = [[UIImageView alloc]initWithFrame:CGRectMake((ScreenWidth-topWidth)/2, 10, topWidth, topWidth*89/238)];
    topView.image = MIMAGE(@"WalletRecharge_succss_top");
    [scroll addSubview:topView];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, topView.bottom+10, ScreenWidth, 1)];
    line.backgroundColor = COLOR_STRING(@"#D3D5D3");
    [scroll addSubview:line];
    
    float width = ScreenWidth-40;
    
    UIImageView *buttom = [[UIImageView alloc]initWithFrame:CGRectMake(10, line.bottom, width, width*648/393)];
    buttom.image = MIMAGE(@"WalletRecharge_succss_enclosure");
    [scroll addSubview:buttom];
    
    [scroll setContentSize:CGSizeMake(ScreenWidth, buttom.bottom+64)];
    
    [self.view addSubview:scroll];
}

- (void)tapRightButton{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    FPFullWalletEnclosureViewController   *controller = [storyBoard instantiateViewControllerWithIdentifier:@"FPFullWalletEnclosure"];
    [self.navigationController pushViewController:controller animated:YES];

}

@end
