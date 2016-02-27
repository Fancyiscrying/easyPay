//
//  FPRgtPhoneViewController.m
//  FullPayApp
//
//  Created by mark zheng on 14-2-20.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPRgtPhoneViewController.h"
#import "FPRgtLoginPwdViewController.h"
#import "FPRegisterProtocolViewController.h"

#import "FPRgtItem.h"

@interface FPRgtPhoneViewController () <ZHCheckBoxButtonDelegate,UITextFieldDelegate>
{
    NSUInteger timeLeft_;
}

@property (nonatomic,retain) NSTimer *timer;

@property (nonatomic,strong) FPRgtItem *rgtItem;

@end

@implementation FPRgtPhoneViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)rgtItem
{
    if (!_rgtItem) {
        _rgtItem = [[FPRgtItem alloc] init];
    }
    
    return _rgtItem;
}

-(void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    
    UIImageView *background = [[UIImageView alloc] initWithFrame:view.bounds];
    background.image = [UIImage imageNamed:@"BG"];
    [view addSubview:background];
    
    self.fld_PhoneNumber = [[FPTextField alloc] init];
    self.fld_PhoneNumber.frame = CGRectMake(0, 10, 320, 50);
    self.fld_PhoneNumber.placeholder = @"手机号(账号)";
    self.fld_PhoneNumber.textAlignment = NSTextAlignmentLeft;
    self.fld_PhoneNumber.backgroundColor = [UIColor whiteColor];
    self.fld_PhoneNumber.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.fld_PhoneNumber.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.fld_PhoneNumber.keyboardType = UIKeyboardTypeNumberPad;
    self.fld_PhoneNumber.textColor = MCOLOR(@"color_login_field");
    UIImageView *imgPhone = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_ic_ID"]];
    self.fld_PhoneNumber.leftView = imgPhone;
    self.fld_PhoneNumber.leftViewMode = UITextFieldViewModeAlways;
    self.fld_PhoneNumber.delegate = self;
    self.fld_PhoneNumber.tag = 101;
    [view addSubview:self.fld_PhoneNumber];
    
    self.fld_Captcha = [[FPTextField alloc] init];
    self.fld_Captcha.frame = CGRectMake(0, 70, 190, 50);
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
    [self.btn_GetCaptcha addTarget:self action:@selector(click_GetCaptcha:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:self.fld_Captcha];
    
    //    self.fld_Captcha.delegate = self;
    
    //获取验证码按钮
    self.btn_GetCaptcha = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btn_GetCaptcha.frame = CGRectMake(190, 70, 130, 50);
    [self.btn_GetCaptcha setTitle:@"点击获取验证码" forState:UIControlStateNormal];
    [self.btn_GetCaptcha setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btn_GetCaptcha setBackgroundImage:MIMAGE(COMM_BTN_BLUE) forState:UIControlStateNormal];
    [self.btn_GetCaptcha setBackgroundImage:MIMAGE(COMM_BTN_GRAY) forState:UIControlStateDisabled];
    
    self.btn_GetCaptcha.titleLabel.font = [UIFont boldSystemFontOfSize:13.0f];
    [self.btn_GetCaptcha addTarget:self action:@selector(click_GetCaptcha:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:self.btn_GetCaptcha];
    
    /* 密码可见button */
    NSString *pwdString = @"同意";
    self.btn_Agree = [[ZHCheckBoxButton alloc] initWithFrame:CGRectMake(20, 130, 50, 15)];
    [self.btn_Agree.label setText:pwdString];
    [self.btn_Agree setChecked:YES];
    self.btn_Agree.delegate = self;
    [view addSubview:self.btn_Agree];
    
    /*注册协议*/
    self.btn_ShowProtecol = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btn_ShowProtecol.frame = CGRectMake(75, 133, 115, 11);
    self.btn_ShowProtecol.titleLabel.font = [UIFont systemFontOfSize:10.0f];
    [self.btn_ShowProtecol setTitle:@"《使用条款和隐私政策》" forState:UIControlStateNormal];
    [self.btn_ShowProtecol setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.btn_ShowProtecol setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    
    [self.btn_ShowProtecol addTarget:self action:@selector(click_ShowProtecol:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:self.btn_ShowProtecol];
    
    self.btn_NextStep = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btn_NextStep.frame = CGRectMake(15, 170, 290, 45);
    [self.btn_NextStep setBackgroundImage:MIMAGE(COMM_BTN_YELL) forState:UIControlStateNormal];
    [self.btn_NextStep setBackgroundImage:MIMAGE(COMM_BTN_GRAY) forState:UIControlStateDisabled];
    [self.btn_NextStep setTitle:@"下一步" forState:UIControlStateNormal];
    [self.btn_NextStep setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btn_NextStep addTarget:self action:@selector(click_NextStep:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.btn_NextStep setEnabled:NO];
    [view addSubview:self.btn_NextStep];
    
    self.view = view;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.title = @"用户注册 1/3";
    [self installCustomView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//获取验证码
- (void)click_GetCaptcha:(UIButton *)sender
{
    if ([self.fld_PhoneNumber isFirstResponder]) {
        [self.fld_PhoneNumber resignFirstResponder];
    }
    
    self.rgtItem.rgt_PhoneNumber = [[self.fld_PhoneNumber.text trimSpace] iphoneFormat];
    if (![self.rgtItem.rgt_PhoneNumber checkTel]) {
        return;
    }
    
    [self checkPhoneNumber:self.rgtItem.rgt_PhoneNumber];
}

//点击显示注册协议
- (void)click_ShowProtecol:(UIButton *)sender
{
    FPRegisterProtocolViewController *controller = [[FPRegisterProtocolViewController alloc] init];
    
    [self.navigationController pushViewController:controller animated:YES];
}

//点击下一步
- (void)click_NextStep:(UIButton *)sender
{
    if (!self.btn_Agree.isChecked) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请勾选《使用条款和隐私政策》" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
        [alert show];
        
        return;
    }

    
    if (![self.rgtItem.rgt_PhoneNumber checkTel]) {
        return;
    }
    self.rgtItem.rgt_CaptchaCode = [self.fld_Captcha.text trimSpace];
    if ([self.rgtItem.rgt_CaptchaCode checkCaptcha] == NO) {
        return;
    }
    
    [self checkPhoneAndSmsCode:self.rgtItem.rgt_PhoneNumber andSmsCode:self.rgtItem.rgt_CaptchaCode];
}

-(void)checkPhoneNumber:(NSString *)phoneNumber
{
    FPClient *urlClient = [FPClient sharedClient];
    NSDictionary *parameters = [urlClient findPersonMemberExistByMobile:phoneNumber];
    
    [urlClient POST:kFPPost parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        if ([[responseObject objectForKey:@"result"] boolValue] == YES) {
            if ([[responseObject objectForKey:@"returnObj"] boolValue] == YES) {
                NSString *errInfo = [NSString stringWithFormat:@"手机号%@已经被他人注册!",phoneNumber];
                [self showToastMessage:errInfo];
            }else{
                [self getCaptchaCode];
            }
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showToastMessage:kNetworkErrorMessage];
    }];
}

-(void)getCaptchaCode
{
    self.btn_GetCaptcha.enabled = NO;
    
    FPClient *urlClient = [FPClient sharedClient];
    
    NSDictionary *parameters = [urlClient userSendSms:self.rgtItem.rgt_PhoneNumber withExpireSeconds:@"90"];
    
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
            [self showToastMessage:errInfo];
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [hud hide:YES];
        [self showToastMessage:kNetworkErrorMessage];
        self.btn_GetCaptcha.enabled = YES;
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
        [self.btn_GetCaptcha setTitle:@"获取验证码" forState:UIControlStateNormal];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self.fld_PhoneNumber isFirstResponder]) {
        [self.fld_PhoneNumber resignFirstResponder];
    }
    
    if ([self.fld_Captcha isFirstResponder]) {
        [self.fld_Captcha resignFirstResponder];
    }
}

- (void)installCustomView
{
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    self.navigationItem.backBarButtonItem = backItem;
    backItem.title = @"";
}

- (void)checkPhoneAndSmsCode:(NSString *)phoneNumber andSmsCode:(NSString *)smsCode
{
    FPClient *urlClient = [FPClient sharedClient];
    NSDictionary *parameters = [urlClient userSmsCodeVerify:phoneNumber andSmsCode:smsCode andProcessFlag:YES];
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    [UtilTool showHUD:@"正在处理" andView:self.view andHUD:hud];
    
    [urlClient POST:kFPPost parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [hud hide:YES];
        NSLog(@"%@",responseObject);
        if ([[responseObject objectForKey:@"result"] boolValue] == YES) {
            self.rgtItem.rgt_ProcessCode = [responseObject objectForKey:@"returnObj"];
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

#pragma mark - custom method
- (void)checkSuccessToNextViewController
{
    [self clearDataBeforeViewDisappear];
    
    FPRgtLoginPwdViewController *controller = [[FPRgtLoginPwdViewController alloc] init];
    controller.rgtItem = self.rgtItem;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - ZHCheckBoxButtonDelegate
- (void)onCheckButtonClicked:(id)control
{
    ZHCheckBoxButton *checkButton = (ZHCheckBoxButton *)control;
    [self.btn_NextStep setEnabled:checkButton.isChecked];
}

#pragma mark UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField.tag == 101) {
        if (textField == self.fld_PhoneNumber) {
            NSMutableString *temp = [NSMutableString stringWithString:textField.text];
            [temp insertString:string atIndex:range.location];
            
            NSString *phone = [temp trimOnlySpace];
            
            if (![string checkNumber]) {
                return YES;
            }
            
            if (phone.length >= 11) {
                [textField resignFirstResponder];
                phone = [phone changeMoblieToFormatMoblie];
                [textField setText:phone];
                return NO;
            }
            phone = [phone changeMoblieToFormatMoblie];
            [textField setText:phone];
            
            [textField setPhoneTextFieldCursorWithRange:range];
            
            return NO;
        }else{
            return YES;
        }
    }
    
    return YES;
}

@end
