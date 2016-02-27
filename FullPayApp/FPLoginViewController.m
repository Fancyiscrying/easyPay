//
//  FPLoginViewController.m
//  FullPayApp
//
//  Created by mark zheng on 14-2-19.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPLoginViewController.h"
#import "FPTabBarViewController.h"
#import "UIButton+UIButtonImageWithLabel.h"
#import "FPCheckPhoneViewController.h"
#import "FPRgtPhoneViewController.h"
#import "FPLockViewController.h"

#import "FPTelGesturePWD.h"

#import "FPUserLogin.h"
#import "Config.h"
#import "AESCrypt.h"

#import "BPush.h"


#define USER_PASSWORD @"userpassword"

@interface FPLoginViewController () <UITextFieldDelegate>

@end

@implementation FPLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//-(void)loadView
//{
//    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
//    
//    UIImageView *background = [[UIImageView alloc] initWithFrame:view.bounds];
//    background.image = [UIImage imageNamed:@"BG"];
//    [view addSubview:background];
//    
//    self.fld_PhoneNumber = [[FPTextField alloc] init];
//    self.fld_PhoneNumber.frame = CGRectMake(0, 22, 320, 50);
//    self.fld_PhoneNumber.placeholder = @"当前密码(6-12位字符)";
//    self.fld_PhoneNumber.textAlignment = NSTextAlignmentLeft;
//    self.fld_PhoneNumber.backgroundColor = [UIColor whiteColor];
//    self.fld_PhoneNumber.clearButtonMode = UITextFieldViewModeWhileEditing;
//    self.fld_PhoneNumber.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//    self.fld_PhoneNumber.keyboardType = UIKeyboardTypeASCIICapable;
//    [view addSubview:self.fld_PhoneNumber];
//    
//    self.fld_LoginPwd = [[FPTextField alloc] init];
//    self.fld_LoginPwd.frame = CGRectMake(0, 77, 320, 50);
//    self.fld_LoginPwd.placeholder = @"新密码(6-12位字符)";
//    self.fld_LoginPwd.textAlignment = NSTextAlignmentLeft;
//    self.fld_LoginPwd.backgroundColor = [UIColor whiteColor];
//    self.fld_LoginPwd.clearButtonMode = UITextFieldViewModeWhileEditing;
//    self.fld_LoginPwd.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//    self.fld_LoginPwd.keyboardType = UIKeyboardTypeASCIICapable;
//    [view addSubview:self.fld_LoginPwd];
//    
//    /* 密码可见button */
//    NSString *pwdString = @"自动登录";
//    self.btn_AutoLogin = [[ZHCheckBoxButton alloc] initWithFrame:CGRectMake(20, 142, 80, 11)];
//    [self.btn_AutoLogin.label setText:pwdString];
//    [self.btn_AutoLogin setChecked:YES];
//    self.btn_AutoLogin.delegate = self;
//    [view addSubview:self.btn_AutoLogin];
//    
//    UIButton *btnNextStep = [UIButton buttonWithType:UIButtonTypeCustom];
//    btnNextStep.frame = CGRectMake(15, 170, 290, 45);
//    [btnNextStep setBackgroundColor:[UIColor orangeColor]];
//    [btnNextStep setTitle:@"确定" forState:UIControlStateNormal];
//    [btnNextStep setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [btnNextStep addTarget:self action:@selector(clickConfirm:) forControlEvents:UIControlEventTouchUpInside];
//    [view addSubview:btnNextStep];
//    
//    self.view = view;
//}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self showTelNumber];
}
//处理textField只显示账户
- (void)showTelNumber{
    if (self.fld_PhoneNumber.text.length > 0) {
        self.fld_LoginPwd.text = @"";
    }else if([Config Instance].personMember.mobile.length > 0){
        if ([Config Instance].personMember) {
            NSString *mobile = [Config Instance].personMember.mobile;
            self.fld_PhoneNumber.text = [mobile changeMoblieToFormatMoblie];

        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.title = @"填写账号";
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    self.navigationItem.backBarButtonItem = backItem;
    backItem.title = @"";
    
    if (!self.isNotReturn) {
        UIBarButtonItem *outItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(gotoHome)];
        
        [outItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15.0] , NSFontAttributeName,
                                         nil] forState:UIControlStateNormal];
        self.navigationItem.leftBarButtonItem = outItem;
    }
    
    [self installCustomView];
    
    self.view.backgroundColor = [ColorUtils hexStringToColor:@"#ECEDEE"];
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)gotoHome{
    
    if(self.isToRoot){
        [self gotoHomePage];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


#pragma mark click_method
- (void)click_Login:(UIButton *)sender
{
    NSString *phoneNumber = [self.fld_PhoneNumber.text trimOnlySpace];
    if ([phoneNumber checkTel] == NO) {
        return;
    }
    NSString *password = [self.fld_LoginPwd.text trimOnlySpace];
    if ([password checkPwd] == NO) {
        return;
    }
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    [UtilTool showHUD:@"正在登录" andView:self.view andHUD:hud];
    [FPUserLogin globalUserLoginWithLoginId:phoneNumber andPwd:password andBlock:^(FPUserLogin *userInfo,NSError *error){
        [hud hide:YES];
        if (error) {
            //将自动登录置否
            [[Config Instance] setAutoLogin:NO];
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"网络连接失败,请查看网络是否连接正常!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        } else {
            if (userInfo.result) {
                //获取彩票信息
                [self getLotterySign];
                
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
                
                //绑定百度推送
                //绑定
                [BPush bindChannel];
                
                //如果是首次登陆跳转设置手势密码
                if ([FPTelGesturePWD isFirstLaunch:[Config Instance].personMember.mobile]) {
                    
                    //先把手势设置未关闭状态
                    if ([Config Instance].personMember) {
                        NSString *tel = [Config Instance].personMember.mobile;
                        [FPTelGesturePWD resetGesturePassword:SET_GESUTREPWD_OFF andTelNumber:tel];
                    }
                    
                    FPLockViewController *controller = [[FPLockViewController alloc]init];
                    controller.isFirstTimeSetting = YES;
                    
                    [UtilTool setRootViewController:controller];
                   
                }else{
                    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    FPTabBarViewController *controller = [storyBoard instantiateViewControllerWithIdentifier:@"FPTabBarView"];
                    controller.userState = FPControllerStateAuthorization;
                    [controller setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
                    [UtilTool setRootViewController:controller];
                }
                
            } else {
                //将自动登录置否
                [[Config Instance] setAutoLogin:NO];
                
                UIAlertView *warning = [[UIAlertView alloc]initWithTitle:@"登录失败" message:userInfo.errorInfo delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
                
                [warning setContentMode:UIViewContentModeCenter];
                [warning show];
            }
        }
    }];
}

- (void)getLotterySign{
    [FPLotterySign getLotterySignWithBlock:^(FPLotterySign *lotterySign,NSError *error) {
        if (error) {
//            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"网络连接失败,请查看网络是否连接正常！" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//            [alert show];
        } else {
            if (lotterySign.result) {
                [[Config Instance] setLotterySign:lotterySign];
            } else {
                //                    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:lotterySign.errorInfo delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                //                    [alert show];
            }
        }
    }];

}

- (void)click_Register:(UIButton *)sender
{
    FPRgtPhoneViewController *controller = [[FPRgtPhoneViewController alloc] init];
    
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)click_ResetLoginPwd:(UIButton *)sender
{
    FPCheckPhoneViewController *controller = [[FPCheckPhoneViewController alloc] init];
    
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self.fld_PhoneNumber isFirstResponder]) {
        [self.fld_PhoneNumber resignFirstResponder];
    }
    
    if ([self.fld_LoginPwd isFirstResponder]) {
        [self.fld_LoginPwd resignFirstResponder];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (self.fld_LoginPwd.text) {
        self.btn_Login.enabled = YES;
    }else{
        self.btn_Login.enabled = NO;
    }
    
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
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    //    [textField resignFirstResponder];
    [self.view setFrame:CGRectMake(0,64,320,self.view.frame.size.height)];
    
    if (self.fld_LoginPwd.text.length>0) {
        self.btn_Login.enabled = YES;
    }else{
        self.btn_Login.enabled = NO;
    }

}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    /*iphone 键盘高度216*/
    CGFloat cy = textField.frame.origin.y + textField.frame.size.height;
    if (cy > self.view.frame.size.height - 250.0) {
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.2];
        [self.view setFrame:CGRectMake(0,-cy + self.view.frame.size.height - 250,320,self.view.frame.size.height)];
        [UIView commitAnimations];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isFirstResponder]) {
        [textField resignFirstResponder];
    }
    
    return YES;
}

//#pragma mark - ZHCheckBoxButtonDelegate
//- (void)onCheckButtonClicked:(id)control
//{
//    ZHCheckBoxButton *btnCheck = (ZHCheckBoxButton *)control;
//    BOOL    isSelected = btnCheck.isChecked;
//    
//    [[Config Instance] setAutoLogin:isSelected];
//}
//
- (void)installCustomView
{
    self.fld_PhoneNumber = [[FPTextField alloc] init];
    self.fld_PhoneNumber.frame = CGRectMake(0, 10, 320, 50);
    self.fld_PhoneNumber.placeholder = @"手机号码";
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
    [self.view addSubview:self.fld_PhoneNumber];

    self.fld_LoginPwd = [[FPTextField alloc] init];
    self.fld_LoginPwd.frame = CGRectMake(0, 65, 320, 50);
    self.fld_LoginPwd.placeholder = @"登录密码";
    self.fld_LoginPwd.textAlignment = NSTextAlignmentLeft;
    self.fld_LoginPwd.backgroundColor = [UIColor whiteColor];
    self.fld_LoginPwd.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.fld_LoginPwd.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.fld_LoginPwd.keyboardType = UIKeyboardTypeASCIICapable;
    [self.fld_LoginPwd setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [self.fld_LoginPwd setAutocorrectionType:UITextAutocorrectionTypeNo];
    self.fld_LoginPwd.secureTextEntry = YES;
    self.fld_LoginPwd.textColor = MCOLOR(@"color_login_field");
    UIImageView *imgPwd = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_ic_psw"]];
    self.fld_LoginPwd.leftView = imgPwd;
    self.fld_LoginPwd.leftViewMode = UITextFieldViewModeAlways;
    self.fld_LoginPwd.delegate = self;
    [self.view addSubview:self.fld_LoginPwd];

//    /* 密码可见button */
//    NSString *pwdString = @"自动登录";
//    self.btn_AutoLogin = [[ZHCheckBoxButton alloc] initWithFrame:CGRectMake(20, 130, 80, 11)];
//    [self.btn_AutoLogin.label setText:pwdString];
//    [self.btn_AutoLogin setChecked:NO];
//    self.btn_AutoLogin.delegate = self;
//    [self.view addSubview:self.btn_AutoLogin];
    
    /*忘记登录密码*/
    self.btn_ResetLoginPwd = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btn_ResetLoginPwd.frame = CGRectMake(221, 130, 90, 11);
    self.btn_ResetLoginPwd.titleLabel.font = [UIFont systemFontOfSize:10.0f];
    [self.btn_ResetLoginPwd setTitle:@"忘记登录密码?" forState:UIControlStateNormal];
    [self.btn_ResetLoginPwd setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.btn_ResetLoginPwd setTitleColor:[UIColor orangeColor] forState:UIControlStateHighlighted];
    [self.btn_ResetLoginPwd addTarget:self action:@selector(click_ResetLoginPwd:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btn_ResetLoginPwd];

    self.btn_Login = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btn_Login.frame = CGRectMake(20, 160, 280, 45);
    [self.btn_Login setBackgroundImage:MIMAGE(COMM_BTN_BLUE) forState:UIControlStateNormal];
    [self.btn_Login setBackgroundImage:MIMAGE(COMM_BTN_GRAY) forState:UIControlStateDisabled];
    [self.btn_Login setTitle:@"登录" forState:UIControlStateNormal];
    [self.btn_Login setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btn_Login setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    [self.btn_Login addTarget:self action:@selector(click_Login:) forControlEvents:UIControlEventTouchUpInside];
    self.btn_Login.enabled = NO;
    [self.view addSubview:self.btn_Login];
    
    /*注册新用户*/
    self.btn_Register = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btn_Register.frame = CGRectMake((self.view.width-100)/2, 268, 100, 40);
    self.btn_Register.titleLabel.font = [UIFont systemFontOfSize:17.0f];
    [self.btn_Register setTitle:@"注册新用户" forState:UIControlStateNormal];
    [self.btn_Register setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.btn_Register setTitleColor:[UIColor orangeColor] forState:UIControlStateHighlighted];
    [self.btn_Register addTarget:self action:@selector(click_Register:) forControlEvents:UIControlEventTouchUpInside];
    [self.btn_Register addLine:self.btn_Register];
    [self.view addSubview:self.btn_Register];
}

@end
