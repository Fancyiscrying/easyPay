//
//  FPCheckOldPhoneViewController.m
//  FullPayApp
//
//  Created by mark zheng on 14-3-4.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPCheckOldPhoneViewController.h"
#import "FPCheckNewPhoneViewController.h"

@interface FPCheckOldPhoneViewController ()
{
    NSUInteger timeLeft_;
    NSString *oldPhoneNumber;
    NSString *captcha;
}

@property (nonatomic,retain) NSTimer *timer;
@end

@implementation FPCheckOldPhoneViewController

-(void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    
    UIImageView *background = [[UIImageView alloc] initWithFrame:view.bounds];
    background.image = [UIImage imageNamed:@"BG"];
    [view addSubview:background];
    
    UILabel *tip = [[UILabel alloc] init];
    tip.frame = CGRectMake(22, 11, 280, 21);
    tip.text = @"验证你注册时使用的手机号码";
    tip.textColor = [UIColor darkGrayColor];
    tip.font = [UIFont systemFontOfSize:10.0f];
    tip.backgroundColor = [UIColor clearColor];
    tip.textAlignment = NSTextAlignmentLeft;
    tip.numberOfLines = 0;
    [view addSubview:tip];
    
    self.fld_Captcha = [[FPTextField alloc] init];
    self.fld_Captcha.frame = CGRectMake(0, 40, 190, 50);
    self.fld_Captcha.placeholder = @"输入验证码";
    self.fld_Captcha.textAlignment = NSTextAlignmentLeft;
    self.fld_Captcha.backgroundColor = [UIColor whiteColor];
    self.fld_Captcha.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.fld_Captcha.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.fld_Captcha.keyboardType = UIKeyboardTypeNumberPad;
    
    self.fld_Captcha.textColor = MCOLOR(@"color_login_field");
    UIImageView *imgPwd = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"retrieve_ic_verification"]];
    self.fld_Captcha.leftView = imgPwd;
    self.fld_Captcha.leftViewMode = UITextFieldViewModeAlways;
    [view addSubview:self.fld_Captcha];
    
    //获取验证码按钮
    self.btn_GetCaptcha = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btn_GetCaptcha.frame = CGRectMake(190, 40, 130, 50);
    [self.btn_GetCaptcha setBackgroundImage:MIMAGE(COMM_BTN_BLUE) forState:UIControlStateNormal];
    [self.btn_GetCaptcha setBackgroundImage:MIMAGE(COMM_BTN_GRAY) forState:UIControlStateDisabled];
    
    [self.btn_GetCaptcha setTitle:@"点击获取验证码" forState:UIControlStateNormal];
    [self.btn_GetCaptcha setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.btn_GetCaptcha.titleLabel.font = [UIFont boldSystemFontOfSize:13.0f];
    [self.btn_GetCaptcha addTarget:self action:@selector(click_GetCaptcha:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:self.btn_GetCaptcha];
    
    self.btn_NextStep = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btn_NextStep.frame = CGRectMake(15, 110, 290, 45);
    [self.btn_NextStep setBackgroundImage:MIMAGE(COMM_BTN_YELL) forState:UIControlStateNormal];
    [self.btn_NextStep setBackgroundImage:MIMAGE(COMM_BTN_GRAY) forState:UIControlStateDisabled];
    [self.btn_NextStep setTitle:@"下一步" forState:UIControlStateNormal];
    [self.btn_NextStep setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btn_NextStep addTarget:self action:@selector(click_NextStep:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.btn_NextStep setEnabled:NO];
    [view addSubview:self.btn_NextStep];
    
    self.view = view;
}

#pragma mark - view lifecycle
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self clearDataBeforeViewDisappear];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.title = @"验证注册手机号";
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
    if ([self.fld_Captcha isFirstResponder]) {
        [self.fld_Captcha resignFirstResponder];
    }
}

- (void)click_NextStep:(UIButton *)sender
{
    if ([self.fld_Captcha isFirstResponder]) {
        [self.fld_Captcha resignFirstResponder];
    }
    captcha = [self.fld_Captcha.text trimSpace];
    if (![captcha checkCaptcha]) {
        return;
    }
    
    [self checkPhoneAndSmsCode:oldPhoneNumber andSmsCode:captcha];
}

- (void)click_GetCaptcha:(UIButton *)sender
{
    oldPhoneNumber = [[[Config Instance].personMember.mobile trimSpace] iphoneFormat];
    if (![oldPhoneNumber checkTel]) {
        return;
    }
    
    [self getCaptchaCode:oldPhoneNumber];
}

-(void)getCaptchaCode:(NSString *)phoneNumber
{
    self.btn_GetCaptcha.enabled = NO;

    FPClient *urlClient = [FPClient sharedClient];
    
    NSDictionary *parameters = [urlClient userSendSms:phoneNumber withExpireSeconds:@"90"];
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    [UtilTool showHUD:@"正在处理" andView:self.view andHUD:hud];
    [urlClient POST:kFPPost parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [hud hide:YES];
        NSLog(@"%@",responseObject);
        if ([[responseObject objectForKey:@"result"] boolValue] == YES) {
            
            timeLeft_ = 90;
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTimes:) userInfo:nil repeats:YES];
            self.btn_NextStep.enabled = YES;
        }else{
            self.btn_GetCaptcha.enabled = YES;
            NSString *errInfo = [responseObject objectForKey:@"errorInfo"];
            
            NSString *message = [NSString stringWithFormat:@"发送短信失败\n%@",errInfo];
            [self showToastMessage:message];
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [hud hide:YES];
        [self showToastMessage:kNetworkErrorMessage];
        self.btn_GetCaptcha.enabled = YES;
    }];
}

- (void)checkPhoneAndSmsCode:(NSString *)phoneNumber andSmsCode:(NSString *)smsCode
{
    FPClient *urlClient = [FPClient sharedClient];
    NSDictionary *parameters = [urlClient userSmsCodeVerify:phoneNumber andSmsCode:smsCode];
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    [UtilTool showHUD:@"正在处理" andView:self.view andHUD:hud];
    
    [urlClient POST:kFPPost parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [hud hide:YES];
        NSLog(@"%@",responseObject);
        if ([[responseObject objectForKey:@"result"] boolValue] == YES) {
            [self checkSuccessToNextViewController];
        }else{
            NSString *errInfo = [responseObject objectForKey:@"errorInfo"];
            [self showToastMessage:errInfo];
            
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [hud hide:YES];
        [self showToastMessage:kNetworkErrorMessage];
    }];
}

-(void)updateTimes:(NSTimer *)theTimer
{
    timeLeft_ -= [theTimer timeInterval];
    if (timeLeft_ == 0) {
        [theTimer invalidate];
        theTimer = nil;
        timeLeft_ = 90;

        [self.btn_GetCaptcha setEnabled:YES];
        self.btn_NextStep.enabled = NO;
        
        [self.btn_GetCaptcha setTitle:@"获取验证码" forState:UIControlStateNormal];
        NSString *times = [NSString stringWithFormat:@"正在发送(%luS)",(unsigned long)timeLeft_];
        [self.btn_GetCaptcha setTitle:times forState:UIControlStateDisabled];
        
    }else{
        NSString *times = [NSString stringWithFormat:@"正在发送(%luS)",(unsigned long)timeLeft_];
        
        [self.btn_GetCaptcha setTitle:times forState:UIControlStateDisabled];
        
        [self.btn_GetCaptcha setNeedsDisplay];
    }
}

-(void)clearDataBeforeViewDisappear
{
    if ([self.timer isValid]) {
        [self.timer invalidate];
        self.timer = nil;
        
        [self.btn_GetCaptcha setEnabled:YES];
        [self.btn_GetCaptcha setTitle:@"点击获取验证码" forState:UIControlStateNormal];
    }
}

#pragma mark - custom method
- (void)checkSuccessToNextViewController
{
    [self clearDataBeforeViewDisappear];
    
    FPCheckNewPhoneViewController *controller = [[FPCheckNewPhoneViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

@end
