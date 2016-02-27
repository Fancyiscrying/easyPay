//
//  FPTakeSecurityController.m
//  FullPayApp
//
//  Created by lc on 14-6-5.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPTakeSecurityController.h"
#import "FPRgtLoginPwdViewController.h"
#import "FPTextField.h"
#import "FPTakeTelphoneController.h"

@interface FPTakeSecurityController ()<FPTextFieldDelegate,UIAlertViewDelegate>
{
}

@property (strong, nonatomic) FPTextField *textField;
@property (copy, nonatomic)   NSString *smsCode;
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UILabel *timeNum;
@property (strong, nonatomic) UIButton *btn_GetCaptcha;

@end

@implementation FPTakeSecurityController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView{
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    
    UIImageView *background = [[UIImageView alloc] initWithFrame:view.bounds];
    background.image = [UIImage imageNamed:@"BG"];
    [view addSubview:background];

    
    UILabel *remindLab = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, ScreenWidth-20, 20)];
    remindLab.backgroundColor = [UIColor clearColor];
    remindLab.font = [UIFont systemFontOfSize:13.f];
    remindLab.text = @"我们已发送 验证码短信 到这个号码";
    remindLab.textColor = [UIColor darkGrayColor];
    
    [view addSubview:remindLab];
    
    UILabel *telNumber = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, remindLab.width, 30)];
    telNumber.top = remindLab.bottom;
    telNumber.backgroundColor = [UIColor clearColor];
    telNumber.font = [UIFont systemFontOfSize:15];
    telNumber.text = _teleNmuber;
    [view addSubview:telNumber];
    
    _textField = [[FPTextField alloc]initWithFrame:CGRectMake(-30, 0, ScreenWidth+30, 40)];
    _textField.top = telNumber.bottom;
    _textField.backgroundColor = [UIColor whiteColor];
    _textField.placeholder = @"|请填入验证码";
    [view addSubview:_textField];
    _textField.keyboardType = UIKeyboardTypeNumberPad;

    
    _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, remindLab.width, 20)];
    _timeLabel.top = _textField.bottom+5;
    _timeLabel.right = ScreenWidth-30;
    _timeLabel.backgroundColor = [UIColor clearColor];
    _timeLabel.font = [UIFont systemFontOfSize:12];
    _timeLabel.text = @"剩余      秒";
    _timeLabel.textAlignment = NSTextAlignmentRight;
    _timeLabel.hidden = NO;
    [view addSubview:_timeLabel];
    
    _timeNum = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 20)];
    _timeNum.top = _textField.bottom+5;
    _timeNum.right = _timeLabel.right-15;
    _timeNum.backgroundColor = [UIColor clearColor];
    _timeNum.font = [UIFont systemFontOfSize:12];
    _timeNum.text = [NSString stringWithFormat:@"%lu",(unsigned long)(timeLeft_>0?timeLeft_:90)];
    _timeNum.textColor = [UIColor redColor];
    _timeNum.textAlignment = NSTextAlignmentRight;
    _timeNum.hidden = NO;
    [view addSubview:_timeNum];
    
    _btn_GetCaptcha = [UIButton buttonWithType:UIButtonTypeCustom];
    _btn_GetCaptcha.frame = CGRectMake(0, _timeLabel.top, 100, 20);
    _btn_GetCaptcha.right = ScreenWidth - 20;
    [self.btn_GetCaptcha setTitle:@"重新获取验证码" forState:UIControlStateNormal];
    [self.btn_GetCaptcha setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    self.btn_GetCaptcha.titleLabel.font = [UIFont boldSystemFontOfSize:13.0f];
    [self.btn_GetCaptcha addTarget:self action:@selector(click_GetCaptcha:) forControlEvents:UIControlEventTouchUpInside];
    _btn_GetCaptcha.hidden = YES;
    [view addSubview:self.btn_GetCaptcha];

    
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.frame = CGRectMake(20, 160, 280, 45);
    nextButton.top = _timeNum.bottom +20;
    [nextButton setBackgroundColor:[UIColor orangeColor]];
    [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    [nextButton addTarget:self action:@selector(click_Next:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:nextButton];

    
    self.view = view;
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]init];
    [backItem setTitle:@""];    
    self.navigationItem.backBarButtonItem = backItem;
    
    UIBarButtonItem *outItem = [[UIBarButtonItem alloc]initWithTitle:@"跳过注册" style:UIBarButtonItemStylePlain target:self action:@selector(gotoHome)];
    
    [outItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:13.0] , NSFontAttributeName,
                                     nil] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = outItem;
}

- (void)gotoHome{
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"中止注册提示" message:@"注册未完成,确定跳过该步骤?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    alert.tag = 201;
    [alert show];
}

#pragma mark----UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag == 201 && buttonIndex == 1) {
        [self gotoHomePage];
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"填写验证码";
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    NSString *timeStr =[[NSUserDefaults standardUserDefaults]objectForKey:@"timeleft_"];
    int time = [timeStr intValue];
    
    if (timer == nil || timeLeft_ == 90 || time==90) {
        [timer invalidate];
        timeLeft_ = 90;
        [self getCaptchaCode];
    }else{
        if (timeLeft_ > 0) {
            [timer invalidate];
            timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTimes:) userInfo:nil repeats:YES];
        }else{
            [timer invalidate];
            [self getCaptchaCode];
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    NSString *time = [NSString stringWithFormat:@"%d",timeLeft_];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"timeleft_"];
    [[NSUserDefaults standardUserDefaults] setObject:time forKey:@"timeleft_"];
    [[NSUserDefaults standardUserDefaults] synchronize];

}

-(void)getCaptchaCode
{
    
    FPClient *urlClient = [FPClient sharedClient];
    
    NSDictionary *parameters = [urlClient userSendSms:_teleNmuber withExpireSeconds:@"90"];
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    [UtilTool showHUD:@"正在处理" andView:self.view andHUD:hud];
    [urlClient POST:kFPPost parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [hud hide:YES];
        NSLog(@"%@",responseObject);
        if ([[responseObject objectForKey:@"result"] boolValue] == YES) {
            
            timeLeft_ = 90;
            [self switchButtonAndLabel:YES];
            timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTimes:) userInfo:nil repeats:YES];
            
        }else{
            
            NSString *errInfo = [responseObject objectForKey:@"errorInfo"];
            [self showToastMessage:errInfo];
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [hud hide:YES];
        [self showToastMessage:kNetworkErrorMessage];
        
    }];
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
            if (self.rgtItem == nil) {
                self.rgtItem = [[FPRgtItem alloc]init];
            }
            self.rgtItem.rgt_ProcessCode = [responseObject objectForKey:@"returnObj"];
            self.rgtItem.rgt_PhoneNumber = phoneNumber;
            self.rgtItem.rgt_CaptchaCode = smsCode;
            
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
#pragma mark---FPTextFieldDelegate
-(void)clickDone:(FPTextField *)sender{
    _smsCode = sender.text;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    _smsCode = _textField.text;
    [self.view endEditing:YES];
}


#pragma mark - custom method
- (void)checkSuccessToNextViewController
{
    
    FPRgtLoginPwdViewController *controller = [[FPRgtLoginPwdViewController alloc] init];
    controller.isFirstLaunch = YES;
    controller.rgtItem = self.rgtItem;
    [self.navigationController pushViewController:controller animated:YES];
}


#pragma mark--ButtonActions
- (void)click_Next:(id)sender{

    //[self checkSuccessToNextViewController];
    _smsCode = [_textField.text trimOnlySpace];
    [self.view endEditing:YES];
    
    if ([_smsCode checkCaptcha]) {
        [self checkPhoneAndSmsCode:_teleNmuber andSmsCode:_smsCode];
    }
}

- (void)switchButtonAndLabel:(BOOL)isRunTime{
    _timeLabel.hidden = !isRunTime;
    _timeNum.hidden = !isRunTime;
    _btn_GetCaptcha.hidden = isRunTime;
}

-(void)updateTimes:(NSTimer *)theTimer
{
    
    timeLeft_ -= [theTimer timeInterval];
    if (timeLeft_ == 0) {
        [theTimer invalidate];
        theTimer = nil;
        timeLeft_ = 90;
        _timeNum.text = @"90";
        [self switchButtonAndLabel:NO];
    
    }else{
        
        NSString *times;
        if (timeLeft_ < 10) {
            times = [NSString stringWithFormat:@"0%lu",(unsigned long)timeLeft_];
        }else {
            times = [NSString stringWithFormat:@"%lu",(unsigned long)timeLeft_];

        }
        self.timeNum.text = times;
        
    }
}

//获取验证码
- (void)click_GetCaptcha:(UIButton *)sender{
    [self getCaptchaCode];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
