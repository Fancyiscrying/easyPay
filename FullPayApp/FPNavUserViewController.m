//
//  FPNavUserViewController.m
//  FullPayApp
//
//  Created by mark zheng on 14-2-13.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPNavUserViewController.h"

@interface FPNavUserViewController ()

@end

@implementation FPNavUserViewController

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
    self.tabBarItem.selectedImage = [[UIImage imageNamed:@"tab_ic_user_on"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationBar.translucent = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
