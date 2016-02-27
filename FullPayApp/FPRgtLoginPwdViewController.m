//
//  FPRgtLoginPwdViewController.m
//  FullPayApp
//
//  Created by mark zheng on 14-2-20.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPRgtLoginPwdViewController.h"
#import "FPRgtPayPwdViewController.h"

@interface FPRgtLoginPwdViewController () <ZHCheckBoxButtonDelegate,UIAlertViewDelegate,UITextFieldDelegate>

@end

@implementation FPRgtLoginPwdViewController

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
    
    self.fld_LoginPwd = [[FPTextField alloc] init];
    self.fld_LoginPwd.frame = CGRectMake(0, 10, 320, 50);
    self.fld_LoginPwd.placeholder = @"设置登录密码(6-12位字符)";
    self.fld_LoginPwd.textAlignment = NSTextAlignmentLeft;
    self.fld_LoginPwd.backgroundColor = [UIColor whiteColor];
    self.fld_LoginPwd.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.fld_LoginPwd.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.fld_LoginPwd.keyboardType = UIKeyboardTypeASCIICapable;
    [self.fld_LoginPwd setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [self.fld_LoginPwd setAutocorrectionType:UITextAutocorrectionTypeNo];
    self.fld_LoginPwd.textColor = MCOLOR(@"color_login_field");
    UIImageView *imgPwd = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_ic_psw"]];
    self.fld_LoginPwd.leftView = imgPwd;
    self.fld_LoginPwd.leftViewMode = UITextFieldViewModeAlways;
    self.fld_LoginPwd.delegate = self;
    [view addSubview:self.fld_LoginPwd];
    
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
    self.btn_NextStep.enabled =NO;
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
    if (_isFirstLaunch) {
        self.navigationItem.title = @"设置登录密码";
        
        UIBarButtonItem *outItem = [[UIBarButtonItem alloc]initWithTitle:@"跳过注册" style:UIBarButtonItemStylePlain target:self action:@selector(gotoHome)];
        
        [outItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:13.0] , NSFontAttributeName,
                                         nil] forState:UIControlStateNormal];
        self.navigationItem.rightBarButtonItem = outItem;

    }else{
        self.navigationItem.title = @"设置登录密码 2/3";
    }
    [self installCustomView];
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

#pragma mark UITextField delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (self.fld_LoginPwd.text.length > 4) {
        self.btn_NextStep.enabled = YES;
    }else{
        self.btn_NextStep.enabled = NO;
    }
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (self.fld_LoginPwd.text.length > 4) {
        self.btn_NextStep.enabled = YES;
    }else{
        self.btn_NextStep.enabled = NO;
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)click_NextStep:(UIButton *)sender
{
    self.rgtItem.rgt_LoginPwd = [self.fld_LoginPwd.text trimSpace];
    if ([self.rgtItem.rgt_LoginPwd checkLoginPwd] == NO) {
        self.fld_LoginPwd.text = @"";
        return;
    }

    FPRgtPayPwdViewController *controller = [[FPRgtPayPwdViewController alloc] init];
    controller.rgtItem = self.rgtItem;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)click_ShowPwd:(UIButton *)sender
{
    sender.selected = !sender.isSelected;
    
    self.fld_LoginPwd.secureTextEntry = !sender.selected;
}

- (void)installCustomView
{
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    self.navigationItem.backBarButtonItem = backItem;
    backItem.title = @"";
}

#pragma mark - ZHCheckBoxButtonDelegate
- (void)onCheckButtonClicked:(id)control
{
    self.fld_LoginPwd.secureTextEntry = !self.fld_LoginPwd.secureTextEntry;
}

@end
