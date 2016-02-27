//
//  FPResetPayPwdViewController.m
//  FullPayApp
//
//  Created by mark zheng on 14-2-27.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPResetPayPwdViewController.h"
#import "UIButton+UIButtonImageWithLabel.h"

#import "FPSecuritySetViewController.h"

@interface FPResetPayPwdViewController () <ZHCheckBoxButtonDelegate>

@end

@implementation FPResetPayPwdViewController

-(void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    
    UIImageView *background = [[UIImageView alloc] initWithFrame:view.bounds];
    background.image = [UIImage imageNamed:@"BG"];
    [view addSubview:background];
    
    self.fieldPassword = [[FPPassCodeView alloc] initWithFrame:CGRectMake(20, 22, 278, 110) withSimple:YES];
    self.fieldPassword.titleLabel.text = @"请输入支付密码：";
    self.fieldPassword.securet = NO;
    [view addSubview:self.fieldPassword];
    
    /* 密码可见button */
    NSString *pwdString = @"显示密码";
    self.btn_ShowPwd = [[ZHCheckBoxButton alloc] initWithFrame:CGRectMake(20, 100, 80, 15)];
    [self.btn_ShowPwd.label setText:pwdString];
    [self.btn_ShowPwd setChecked:YES];
    self.btn_ShowPwd.delegate = self;
    [view addSubview:self.btn_ShowPwd];
    
    self.btn_NextStep = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btn_NextStep.frame = CGRectMake(15, 136, 290, 45);
    [self.btn_NextStep setBackgroundColor:[UIColor orangeColor]];
    [self.btn_NextStep setTitle:@"确定" forState:UIControlStateNormal];
    [self.btn_NextStep setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btn_NextStep addTarget:self action:@selector(click_NextStep:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:self.btn_NextStep];
    
    self.view = view;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    if (![self.fieldPassword isFirstResponse]) {
        [self.fieldPassword becomeFirstResponse];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.fieldPassword clearPasscode];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.title = @"重置手机支付密码";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //    [self.fld_NewPwd resignFirstResponder];
    if ([self.fieldPassword isFirstResponse]) {
        [self.fieldPassword resignFirstResponse];
    } else {
        [self.fieldPassword becomeFirstResponse];
    }
}

#pragma mark -
- (void)click_NextStep:(UIButton *)sender
{
    if ([self.fieldPassword isFirstResponse]) {
        [self.fieldPassword resignFirstResponse];
    }
    
    self.rgtItem.rgt_PayPwd = [self.fieldPassword.passcode trimSpace];
    if ([self.rgtItem.rgt_PayPwd checkPayPwd] == NO) {
        [self.fieldPassword clearPasscode];
        return;
    }

    NSString *memberNo = [Config Instance].memberNo;
    FPClient *urlClient = [FPClient sharedClient];
    NSDictionary *parameters = [urlClient userResetPayPwd:memberNo andMobileNo:self.rgtItem.rgt_PhoneNumber andProcessCode:self.rgtItem.rgt_ProcessCode andSmsCode:self.rgtItem.rgt_CaptchaCode andNewPwd:self.rgtItem.rgt_PayPwd];
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    [UtilTool showHUD:@"正在处理" andView:self.view andHUD:hud];
    [urlClient POST:kFPPost parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [hud hide:YES];
        NSLog(@"%@",responseObject);
        if ([[responseObject objectForKey:@"result"] boolValue] == YES) {
            //NSDictionary *object = [responseObject objectForKey:@"returnObj"];
            //NSLog(@"%@",object);
            NSString    *message = [NSString stringWithFormat:@"重置支付密码完成,请牢记您的新密码!\n 新的支付密码：%@",self.rgtItem.rgt_PayPwd];
            UIAlertView *alter = [[UIAlertView alloc]initWithTitle:message message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            
            [alter setContentMode:UIViewContentModeCenter];
            [alter show];
            
            BOOL hasController = NO;
            for (id controller in [self.navigationController viewControllers]) {
                if ([controller isKindOfClass:[FPSecuritySetViewController class]]) {
                    hasController = YES;
                    [self.navigationController popToViewController:controller animated:YES];
                    break;
                }
            }
        }else{
            NSString *errInfo = [responseObject objectForKey:@"errorInfo"];
            [self showToastMessage:errInfo];
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [hud hide:YES];
        FPDEBUG(@"%@",error);
        [self showToastMessage:kNetworkErrorMessage];
    }];
}

#pragma mark - ZHCheckBoxButtonDelegate
- (void)onCheckButtonClicked:(id)control
{
    self.fieldPassword.securet = !self.fieldPassword.securet;
    [self.fieldPassword refeshView];
}

@end
