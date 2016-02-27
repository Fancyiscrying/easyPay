//
//  FPRgtPayPwdViewController.m
//  FullPayApp
//
//  Created by mark zheng on 14-2-20.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPRgtPayPwdViewController.h"
#import "FPLoginViewController.h"
#import "FPNavigationViewController.h"
#import "FPNameAndStaffIdViewController.h"
#import "FPTabBarViewController.h"
#import "FPUserLogin.h"
#import "AESCrypt.h"

#define USER_PASSWORD @"userpassword"

@interface FPRgtPayPwdViewController () <ZHCheckBoxButtonDelegate,UIAlertViewDelegate,FPPassCodeViewDelegate>

@end

@implementation FPRgtPayPwdViewController

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
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    
    UIImageView *background = [[UIImageView alloc] initWithFrame:view.bounds];
    background.image = [UIImage imageNamed:@"BG"];
    [view addSubview:background];
    
    self.fieldPassword = [[FPPassCodeView alloc] initWithFrame:CGRectMake(22, 10, 280, 39) withSimple:YES];
    self.fieldPassword.titleLabel.text = @"请设置支付密码：";
    self.fieldPassword.securet = NO;
    self.fieldPassword.delegate = self;
    [view addSubview:self.fieldPassword];
    
    /* 密码可见button */
    NSString *pwdString = @"显示密码";
    self.btn_ShowPwd = [[ZHCheckBoxButton alloc] initWithFrame:CGRectMake(25, 95, 80, 15)];
    [self.btn_ShowPwd.label setText:pwdString];
    [self.btn_ShowPwd setChecked:YES];
    self.btn_ShowPwd.delegate = self;
    [view addSubview:self.btn_ShowPwd];
    
    self.btn_NextStep = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btn_NextStep.frame = CGRectMake(15, 130, 290, 45);
    [self.btn_NextStep setBackgroundImage:MIMAGE(COMM_BTN_YELL) forState:UIControlStateNormal];
    [self.btn_NextStep setBackgroundImage:MIMAGE(COMM_BTN_GRAY) forState:UIControlStateDisabled];
    [self.btn_NextStep setTitle:@"下一步" forState:UIControlStateNormal];
    [self.btn_NextStep setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btn_NextStep addTarget:self action:@selector(click_NextStep:) forControlEvents:UIControlEventTouchUpInside];
    self.btn_NextStep.enabled = NO;
    [view addSubview:self.btn_NextStep];
    
    self.view = view;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if ([self.fieldPassword isFirstResponse]) {
        [self.fieldPassword resignFirstResponse];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    if (_isFirstLaunch) {
        
        UIBarButtonItem *outItem = [[UIBarButtonItem alloc]initWithTitle:@"跳过注册" style:UIBarButtonItemStylePlain target:self action:@selector(gotoHome)];
        
        [outItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:13.0] , NSFontAttributeName,
                                         nil] forState:UIControlStateNormal];
        self.navigationItem.rightBarButtonItem = outItem;

        
        self.navigationItem.title = @"设置手机支付密码";
        [self.fieldPassword becomeFirstResponse];
    }else{
        self.navigationItem.title = @"设置手机支付密码 3/3";
        [self.fieldPassword becomeFirstResponse];
    }
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
    
    if (alertView.tag == 202 && buttonIndex == 0) {
         [self gotoHomePage];
    }else if(alertView.tag == 202 && buttonIndex == 1){
        //前往实名
        FPNameAndStaffIdViewController *controller = [[FPNameAndStaffIdViewController alloc] init];
        
        FPNavigationViewController *navController = [[FPNavigationViewController alloc]initWithRootViewController:controller];
        [UtilTool setRootViewController:navController];
    }
    
}

- (void)autoLogin{
    
    NSString *phoneNumber = self.rgtItem.rgt_PhoneNumber ;
    if ([phoneNumber checkTel] == NO) {
        return;
    }
    NSString *password = self.rgtItem.rgt_LoginPwd;
    if ([phoneNumber checkPwd] == NO) {
        return;
    }
    
    [FPUserLogin globalUserLoginWithLoginId:phoneNumber andPwd:password andBlock:^(FPUserLogin *userInfo,NSError *error){
        if (error) {
            
            //将自动登录置否
            [[Config Instance] setAutoLogin:NO];
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"网络连接失败,请查看网络是否连接正常!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            
        } else {
            if (userInfo.result) {
                //设置为自动登录
                [[Config Instance] setAutoLogin:YES];
                [super setLaunch_state:FPControllerStateAuthorization];
                FPDEBUG(@"memberNo:%@",userInfo.personMember.memberNo);
                
                //加密储存密码
                NSString *securityPassword = [AESCrypt encrypt:password password:AESEncryKey];
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                if (securityPassword != nil) {
                    [defaults setObject:securityPassword forKey:USER_PASSWORD];
                    [defaults synchronize];
                }
            
                //设置账户手势密码为未设置状态，下次启动程序提示
                if ([FPTelGesturePWD isFirstLaunch:phoneNumber]) {
                    [FPTelGesturePWD addTelGesturePassword:EVER_SET_GESUTREPWD andTelNumber:phoneNumber];
                }
                
                //是否实名
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"恭喜,注册已完成" delegate:self cancelButtonTitle:@"前往首页" otherButtonTitles:@"实名认证", nil];
                alert.tag = 202;
                [alert show];
                
            } else {
                //将自动登录置否
                [[Config Instance] setAutoLogin:NO];
                
                [UtilTool setLoginViewRootController];
            }
        }
    }];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self.fieldPassword isFirstResponse]) {
        [self.fieldPassword resignFirstResponse];
    } else {
        [self.fieldPassword becomeFirstResponse];
    }
}

- (void)click_NextStep:(UIButton *)sender
{
    self.rgtItem.rgt_PayPwd = [self.fieldPassword.passcode trimSpace];
    if ([self.rgtItem.rgt_PayPwd checkPayPwd] == NO) {
        [self.fieldPassword clearPasscode];
        return;
    }
    
    FPClient *urlClient = [FPClient sharedClient];
    
    NSDictionary *parameters = [urlClient userRegister:self.rgtItem.rgt_PhoneNumber andPassword:self.rgtItem.rgt_LoginPwd andPayPwd:self.rgtItem.rgt_PayPwd andSmsCode:self.rgtItem.rgt_CaptchaCode andProcessCode:self.rgtItem.rgt_ProcessCode];
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    [UtilTool showHUD:@"正在处理" andView:self.view andHUD:hud];
    
    [urlClient POST:kFPPost parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [hud hide:YES];
        NSLog(@"%@",responseObject);
        if ([[responseObject objectForKey:@"result"] boolValue] == YES) {
            NSDictionary *object = [responseObject objectForKey:@"returnObj"];
            NSLog(@"%@",object);
            
            [self autoLogin];
            
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

- (void)backToLoginView
{
    /*BOOL hasController = NO;
    for (id controller in [self.navigationController viewControllers]) {
        if ([controller isKindOfClass:[FPLoginViewController class]]) {
            hasController = YES;
            [self.navigationController popToViewController:controller animated:YES];
            break;
        }
    }
    
    if (hasController == NO) {
        FPLoginViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"FPLoginView"];
        CATransition *transition = [CATransition animation];
        transition.duration = 0.4f;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionPush;
        transition.delegate = self;
        transition.subtype = kCATransitionFromLeft;
        
        [self.navigationController.view.layer addAnimation:transition forKey:nil];
        [self.navigationController pushViewController:controller animated:YES];
    } */
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    FPTabBarViewController *controller = [storyBoard instantiateViewControllerWithIdentifier:@"FPTabBarView"];
    controller.userState = FPControllerStateAuthorization;
    [controller setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [UtilTool setRootViewController:controller];
}

#pragma mark - ZHCheckBoxButtonDelegate
- (void)onCheckButtonClicked:(id)control
{
    self.fieldPassword.securet = !self.fieldPassword.securet;
    [self.fieldPassword refeshView];
}

#pragma mark-FPPassCodeView delegate
-(void)passCodeView:(FPPassCodeView *)sender checkPassCodeLength:(NSString *)passCode;{
    
    if(passCode.length == 6){
        self.btn_NextStep.enabled = YES;
    }else{
        self.btn_NextStep.enabled = NO;
    }
    
}

@end
