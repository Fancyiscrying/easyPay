//
//  FPChangePhoneResultViewController.m
//  FullPayApp
//
//  Created by mark zheng on 14-3-4.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPChangePhoneResultViewController.h"
#import "ZHCheckBoxButton.h"

@interface FPChangePhoneResultViewController ()<UIAlertViewDelegate,FPPassCodeViewDelegate,ZHCheckBoxButtonDelegate>

@end

@implementation FPChangePhoneResultViewController

-(void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    
    UIImageView *background = [[UIImageView alloc] initWithFrame:view.bounds];
    background.image = [UIImage imageNamed:@"BG"];
    [view addSubview:background];
    
    self.fld_PayPwd = [[FPPassCodeView alloc] initWithFrame:CGRectMake(20, 22, 278, 70) withSimple:YES];
    self.fld_PayPwd.securet = YES;
    self.fld_PayPwd.delegate = self;
    self.fld_PayPwd.userInteractionEnabled = YES;
    [view addSubview:self.fld_PayPwd];
    
    /* 密码可见button */
    NSString *pwdString = @"显示密码";
    ZHCheckBoxButton *boxButton = [[ZHCheckBoxButton alloc] initWithFrame:CGRectMake(20, self.fld_PayPwd.bottom+10, 80, 15)];
    [boxButton.label setText:pwdString];
    [boxButton setChecked:NO];
    boxButton.delegate = self;
    [view addSubview:boxButton];
    
    UIButton *btn_NextStep = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_NextStep.frame = CGRectMake(15, boxButton.bottom+20, 290, 45);
    [btn_NextStep setBackgroundImage:MIMAGE_COLOR_SIZE([UIColor orangeColor],btn_NextStep.frame.size) forState:UIControlStateNormal];
    [btn_NextStep setBackgroundImage:MIMAGE_COLOR_SIZE([UIColor darkGrayColor],btn_NextStep.frame.size) forState:UIControlStateDisabled];
    [btn_NextStep setTitle:@"确定" forState:UIControlStateNormal];
    [btn_NextStep setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn_NextStep addTarget:self action:@selector(click_NextStep:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn_NextStep];
    
    self.view = view;
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

#pragma mark ZHCheckBoxButtonDelegate

- (void)onCheckButtonClicked:(id)control{
    if ([self.fld_PayPwd isFirstResponder]) {
        [self.fld_PayPwd resignFirstResponder];
    }
    
    self.fld_PayPwd.securet = !self.fld_PayPwd.securet;
    
    //刷新视图
    [self.fld_PayPwd refeshView];
    
}

#pragma mark - view lifecycle
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.fld_PayPwd becomeFirstResponse];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.fld_PayPwd clearPasscode];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.title = @"验证手机支付密码";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)click_NextStep:(UIButton *)sender
{
    [self updateUserMobile];
}

-(void)updateUserMobile
{
    NSString *memberNo = [Config Instance].memberNo;
    NSString *payPsw = self.fld_PayPwd.passcode;
    if (memberNo.length<=0 || _theNewMobile.length<=0 || payPsw.length<=0) {
        return;
    }
    FPClient *urlClient = [FPClient sharedClient];
    NSDictionary *parameters = [urlClient userMobileUpdate:memberNo andMobileNo:_theNewMobile andPayPsw:payPsw];
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    [UtilTool showHUD:@"正在处理" andView:self.view andHUD:hud];
    
    [urlClient POST:kFPPost parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [hud hide:YES];
        NSLog(@"%@",responseObject);
        if ([[responseObject objectForKey:@"result"] boolValue] == YES) {
            
            NSString *errInfo = @"请使用新手机号重新登录!";
            UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"手机账号修改成功" message:errInfo delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            alter.tag = 101;
            
            [alter setContentMode:UIViewContentModeCenter];
            [alter show];
            
        }else{
            [self showToastMessage:[responseObject objectForKey:@"errorInfo"]];
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [hud hide:YES];
        [self showToastMessage:kNetworkErrorMessage];
    }];
}

#pragma mark UIAlertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 101) {
        [[Config Instance] setAutoLogin:NO];
        [UtilTool setLoginViewRootController];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self.fld_PayPwd isFirstResponse]) {
        [self.fld_PayPwd resignFirstResponse];
        
    }else{
        [self.fld_PayPwd becomeFirstResponse];
    }
    
}


@end
