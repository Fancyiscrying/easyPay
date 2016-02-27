//
//  FPResetLoginPwdViewController.m
//  FullPayApp
//
//  Created by mark zheng on 14-2-20.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPResetLoginPwdViewController.h"
#import "FPLoginViewController.h"

@interface FPResetLoginPwdViewController () <ZHCheckBoxButtonDelegate>

@end

@implementation FPResetLoginPwdViewController

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
    
    self.fld_NewLoginPwd = [[ZHTextField alloc] init];
    self.fld_NewLoginPwd.frame = CGRectMake(0, 10, 320, 50);
    self.fld_NewLoginPwd.placeholder = @"新密码(6-12位字符)";
    self.fld_NewLoginPwd.textAlignment = NSTextAlignmentLeft;
    self.fld_NewLoginPwd.backgroundColor = [UIColor whiteColor];
    self.fld_NewLoginPwd.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.fld_NewLoginPwd.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.fld_NewLoginPwd.keyboardType = UIKeyboardTypeASCIICapable;
    [view addSubview:self.fld_NewLoginPwd];
    
    /* 密码可见button */
    NSString *pwdString = @"显示密码";
    self.btn_ShowPwd = [[ZHCheckBoxButton alloc] initWithFrame:CGRectMake(20, 70, 80, 15)];
    [self.btn_ShowPwd.label setText:pwdString];
    [self.btn_ShowPwd setChecked:YES];
    self.btn_ShowPwd.delegate = self;
    [view addSubview:self.btn_ShowPwd];
    
    self.btn_NextStep = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btn_NextStep.frame = CGRectMake(15, 100, 290, 45);
    [self.btn_NextStep setBackgroundImage:MIMAGE(COMM_BTN_YELL) forState:UIControlStateNormal];
    [self.btn_NextStep setBackgroundImage:MIMAGE(COMM_BTN_GRAY) forState:UIControlStateDisabled];
    [self.btn_NextStep setTitle:@"下一步" forState:UIControlStateNormal];
    [self.btn_NextStep setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btn_NextStep addTarget:self action:@selector(click_NextStep:) forControlEvents:UIControlEventTouchUpInside];
    
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
    self.navigationItem.title = @"重设登录密码 2/2";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)click_NextStep:(UIButton *)sender
{
    self.rgtItem.rgt_LoginPwd = [self.fld_NewLoginPwd.text trimSpace];
    if ([self.rgtItem.rgt_LoginPwd checkLoginPwd] == NO) {
        self.fld_NewLoginPwd.text = @"";
        return;
    }
    
    FPClient *urlClient = [FPClient sharedClient];
    NSDictionary *parameters = [urlClient userResetLoginPwd:self.rgtItem.rgt_PhoneNumber andProcessCode:self.rgtItem.rgt_ProcessCode andSmsCode:self.rgtItem.rgt_CaptchaCode andNewPwd:self.rgtItem.rgt_LoginPwd];
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    [UtilTool showHUD:@"正在处理" andView:self.view andHUD:hud];
    [urlClient POST:kFPPost parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [hud hide:YES];
        FPDEBUG(@"%@",responseObject);
        if ([[responseObject objectForKey:@"result"] boolValue] == YES) {
            UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"重置登录密码完成" message:@"请使用新的密码登录" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            
            [alter setContentMode:UIViewContentModeCenter];
            [alter show];
            
            [self backToLoginView];
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
    BOOL hasController = NO;
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
    }
}

#pragma mark - ZHCheckBoxButtonDelegate
- (void)onCheckButtonClicked:(id)control
{
    self.fld_NewLoginPwd.secureTextEntry = !self.fld_NewLoginPwd.secureTextEntry;
}

@end
