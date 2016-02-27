//
//  FPCheckUserIdViewController.m
//  FullPayApp
//
//  Created by mark zheng on 14-3-4.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPCheckUserIdViewController.h"
#import "FPCheckOldPhoneViewController.h"
#import "FPCaptchaViewController.H"

@interface FPCheckUserIdViewController ()<FPPassCodeViewDelegate>

@end

@implementation FPCheckUserIdViewController

-(void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    
    UIImageView *background = [[UIImageView alloc] initWithFrame:view.bounds];
    background.image = [UIImage imageNamed:@"BG"];
    [view addSubview:background];
    
    self.fld_UserId = [[FPPassCodeView alloc] initWithFrame:CGRectMake(20, 22, 278, 70) withSimple:YES];
    self.fld_UserId.securet = NO;
    [self.fld_UserId setInputIdKeyboard:YES];
    self.fld_UserId.delegate = self;
    self.fld_UserId.titleLabel.text = @"填写注册时使用的身份证号码末尾6位（X不区分大小写）";
    [view addSubview:self.fld_UserId];
    
    UIButton *btn_NextStep = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_NextStep.frame = CGRectMake(15, 120, 290, 45);
    [btn_NextStep setBackgroundImage:MIMAGE(COMM_BTN_YELL) forState:UIControlStateNormal];
    [btn_NextStep setBackgroundImage:MIMAGE(COMM_BTN_GRAY) forState:UIControlStateDisabled];
    [btn_NextStep setTitle:@"下一步" forState:UIControlStateNormal];
    [btn_NextStep setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn_NextStep addTarget:self action:@selector(click_NextStep:) forControlEvents:UIControlEventTouchUpInside];
    btn_NextStep.enabled = NO;
    btn_NextStep.tag = 101;
    [view addSubview:btn_NextStep];
    
    self.view = view;
}

#pragma mark - view lifecycle
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.fld_UserId becomeFirstResponse];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.fld_UserId clearPasscode];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.title = @"验证身份信息";
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    self.navigationItem.backBarButtonItem = backItem;
    backItem.title = @"";
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self.fld_UserId isFirstResponse]) {
        [self.fld_UserId resignFirstResponse];
       
    }else{
        [self.fld_UserId becomeFirstResponse];
    }
    
}

- (void)click_NextStep:(UIButton *)sender
{
    if ([self.fld_UserId isFirstResponse]) {
        [self.fld_UserId resignFirstResponse];
    }
    
    NSString *IDCard = [Config Instance].personMember.certNo;
    if (IDCard.length > 6) {
        IDCard = [IDCard substringFromIndex:(IDCard.length - 6)];
    }
    
    FPDEBUG(@"id:%@",IDCard);
    
    NSString *userId = [self.fld_UserId passcode];
    
    if (![userId.lowercaseString isEqualToString:IDCard.lowercaseString]) {
        [self showToastMessage:@"身份证号校验失败"];
        return;
    }
    if (self.comeFrom == comeFromPersonallInfo) {
        FPCheckOldPhoneViewController *controller = [[FPCheckOldPhoneViewController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
        
    }else if (self.comeFrom == ComeFromSecuritySetView){
        
        FPCaptchaViewController *controller = [[FPCaptchaViewController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
    }
    
  
}
#pragma mark-FPPassCodeView delegate
-(void)passCodeView:(FPPassCodeView *)sender checkPassCodeLength:(NSString *)passCode;{

    UIButton *btn_NextStep = (UIButton *)[self.view viewWithTag:101];
    
    if(passCode.length == 6){
        btn_NextStep.enabled = YES;
    }else{
        btn_NextStep.enabled = NO;
    }

}


@end
