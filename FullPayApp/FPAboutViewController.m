//
//  FPAboutViewController.m
//  FullPayApp
//
//  Created by mark zheng on 14-2-25.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPAboutViewController.h"

#define IMG_ABOUT_BACKGROUND @"Default.png"
#define IMG_ABOUT_BACKGROUND_568 @"Default-568h.png"

@interface FPAboutViewController ()

@property (nonatomic,strong) UILabel    *lbl_Version;
@property (nonatomic,strong) UILabel    *lbl_AppName;

@end

@implementation FPAboutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    UIImageView *background = [[UIImageView alloc] initWithFrame:view.bounds];
    if (IS_IPHONE568) {
        background.image = [UIImage imageNamed:IMG_ABOUT_BACKGROUND_568];
    } else {
        background.image = [UIImage imageNamed:IMG_ABOUT_BACKGROUND];
    }
    
    [view addSubview:background];
    
    self.lbl_AppName = [[UILabel alloc] init];
    CGRect rect_Name = CGRectMake(0, 330, 160, 30);
    if (IS_IPHONE568) {
        rect_Name.origin.y += 30;
    }
    self.lbl_AppName.frame = rect_Name;
    self.lbl_AppName.backgroundColor = [UIColor clearColor];
    self.lbl_AppName.textColor = [UIColor grayColor];
    self.lbl_AppName.textAlignment = NSTextAlignmentRight;
    [view addSubview:self.lbl_AppName];
    
    self.lbl_Version = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 160, 30)];
    self.lbl_Version.frame = CGRectOffset(rect_Name, CGRectGetWidth(self.lbl_AppName.frame), 0);
    self.lbl_Version.backgroundColor = [UIColor clearColor];
    self.lbl_Version.textColor = [UIColor grayColor];
    self.lbl_Version.textAlignment = NSTextAlignmentLeft;
    [view addSubview:self.lbl_Version];
    
    self.view = view;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [[UIApplication sharedApplication]setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication]setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backToPrevView:)];
    [self.view addGestureRecognizer:gesture];
    
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    NSString *bundlName = [infoDic objectForKey:@"CFBundleDisplayName"];
    
    self.lbl_AppName.text = bundlName;
    self.lbl_Version.text = [NSString stringWithFormat:@"V%@",appVersion];
}

- (void)backToPrevView:(id)sender {
    [self.view removeGestureRecognizer:sender];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
