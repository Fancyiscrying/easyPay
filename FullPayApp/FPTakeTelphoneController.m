//
//  FPTakeTelphoneController.m
//  FullPayApp
//
//  Created by lc on 14-6-5.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPTakeTelphoneController.h"
#import "FPTakeSecurityController.h"
#import "FPRegisterProtocolViewController.H"
#import "FPTextField.h"
#import "FPAppDelegate.h"
#import "FPNavLoginViewController.h"
#import "FPRgtItem.h"
#import "FPAppVersion.h"
#import "ZHCheckBoxButton.H"
#import "FPLoginViewController.h"

@interface FPTakeTelphoneController ()<FPTextFieldDelegate,UIAlertViewDelegate,ZHCheckBoxButtonDelegate,UITextFieldDelegate>
@property (copy, nonatomic) NSString *numberStr;
@property (strong, nonatomic) FPTextField *textField;
@property (nonatomic,strong) FPRgtItem *rgtItem;
@property (nonatomic,strong) NSString *updateUrl;
@property (strong, nonatomic) ZHCheckBoxButton *btn_Agree;

@property (strong, nonatomic) UIButton *btn_ShowProtecol;
@property (strong, nonatomic) UIButton *nextButton;
@end

@implementation FPTakeTelphoneController

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
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, ScreenWidth, 20)];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:13];
    label.text = @"需要使用您的手机号码为注册账号";
    label.textColor = [UIColor darkGrayColor];
    [view addSubview:label];
    
    _textField = [[FPTextField alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
    _textField.top = label.bottom+10;
    _textField.backgroundColor = [UIColor whiteColor];
    _textField.textAlignment = NSTextAlignmentLeft;
    _textField.keyboardType = UIKeyboardTypeNumberPad;
    //textField.text = @"+86";
    _textField.delegateDone = self;
    _textField.delegate = self;
    _textField.tag = 101;
    [view addSubview:_textField];
    
    UILabel *fieldLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 30, 20)];
    fieldLabel.backgroundColor = [UIColor clearColor];
    fieldLabel.textAlignment = NSTextAlignmentLeft;
    fieldLabel.font = [UIFont systemFontOfSize:16];
    fieldLabel.text = @"+86";
    fieldLabel.textColor = [UIColor blackColor];
    [_textField addSubview:fieldLabel];

    /* 密码可见button */
    NSString *pwdString = @"同意";
    self.btn_Agree = [[ZHCheckBoxButton alloc] initWithFrame:CGRectMake(20, _textField.bottom+10, 50, 15)];
    [self.btn_Agree.label setText:pwdString];
    [self.btn_Agree setChecked:YES];
    self.btn_Agree.delegate = self;
    [view addSubview:self.btn_Agree];
    
    /*注册协议*/
    self.btn_ShowProtecol = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btn_ShowProtecol.frame = CGRectMake(75, _textField.bottom+10, 140, 15);
    self.btn_ShowProtecol.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    [self.btn_ShowProtecol setTitle:@"《使用条款和隐私政策》" forState:UIControlStateNormal];
    [self.btn_ShowProtecol setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.btn_ShowProtecol setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    
    [self.btn_ShowProtecol addTarget:self action:@selector(click_ShowProtecol:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:self.btn_ShowProtecol];
    
    _nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _nextButton.frame = CGRectMake(20, 200, 280, 45);
    _nextButton.top = _textField.bottom +50;
    [_nextButton setBackgroundImage:MIMAGE(COMM_BTN_YELL) forState:UIControlStateNormal];
    [_nextButton setBackgroundImage:MIMAGE(COMM_BTN_GRAY) forState:UIControlStateDisabled];
    [_nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [_nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_nextButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    [_nextButton addTarget:self action:@selector(click_Next:) forControlEvents:UIControlEventTouchUpInside];
    [_nextButton setEnabled:NO];
    [view addSubview:_nextButton];
    
    UIButton *login = [UIButton buttonWithType:UIButtonTypeCustom];
    login.frame = CGRectMake(100, 0, 80, 30);
    login.top = _nextButton.bottom+30;
    login.left = (ScreenWidth-80)/2;
    login.backgroundColor = [UIColor clearColor];
    [login setTitle:@"前往登录" forState:UIControlStateNormal];
    login.titleLabel.font = [UIFont systemFontOfSize:20];
    [login setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [login addTarget:self action:@selector(click_Login:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:login];
    

    self.view = view;
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]init];
    [backItem setTitle:@""];
    self.navigationItem.backBarButtonItem = backItem;
    
    UIBarButtonItem *outItem = [[UIBarButtonItem alloc]initWithTitle:@"跳过注册" style:UIBarButtonItemStylePlain target:self action:@selector(gotoHome)];
    
    [outItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15.0] , NSFontAttributeName,
                                     nil] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = outItem;
    
}

-(void)click_Login:(id)sender{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    FPLoginViewController   *controller = [storyBoard instantiateViewControllerWithIdentifier:@"FPLoginView"];
    FPNavLoginViewController * nav = [[FPNavLoginViewController alloc] initWithRootViewController:controller];
    controller.isToRoot = YES;
    FPAppDelegate *delegate = (FPAppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.window.rootViewController = nav;
}

- (void)gotoHome{
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"中止注册提示" message:@"注册未完成,确定跳过该步骤?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    alert.tag = 201;
    [alert show];
}

#pragma mark - ZHCheckBoxButtonDelegate
- (void)onCheckButtonClicked:(id)control
{
    ZHCheckBoxButton *checkButton = (ZHCheckBoxButton *)control;
    [_nextButton setEnabled:checkButton.isChecked];
}

#pragma mark---buttonActions

//点击显示注册协议
- (void)click_ShowProtecol:(UIButton *)sender
{
    FPRegisterProtocolViewController *controller = [[FPRegisterProtocolViewController alloc] init];
    
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)click_Next:(id)sender{
    
    
    if (!self.btn_Agree.isChecked) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请勾选《使用条款和隐私政策》" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
        [alert show];
        
        return;
    }
    
    //取消响应状态
    _numberStr = [_textField.text trimOnlySpace];
    [self.view endEditing:YES];
    
    if ([_numberStr checkTel]) {
        
        [self checkPhoneNumber:_numberStr];
    }
    
}

#pragma mark  UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.tag == 101) {
        NSString *mobile = [textField.text trimOnlySpace];
        if (mobile.length==11) {
            self.nextButton.enabled = YES;
        }else{
            self.nextButton.enabled = NO;
        }
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField.tag == 101) {
        
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"timeleft_"];
        [[NSUserDefaults standardUserDefaults] setObject:@"90" forKey:@"timeleft_"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
            NSMutableString *temp = [NSMutableString stringWithString:textField.text];
            [temp insertString:string atIndex:range.location];
            
            NSString *phone = [temp trimOnlySpace];
        
            if (![string checkNumber]) {
                return YES;
            }
            
            if (phone.length >= 11) {
                phone = [phone changeMoblieToFormatMoblie];
                [textField setText:phone];
                [self.textField resignFirstResponder];
                [self textFieldDidEndEditing:_textField];
                return NO;
            }
            phone = [phone changeMoblieToFormatMoblie];
            [textField setText:phone];
        
            [textField setPhoneTextFieldCursorWithRange:range];
        
            return NO;
        }else{
            return YES;
        }
    
    return YES;
}


#pragma mark---FPTextFieldDelegate
-(void)clickDone:(FPTextField *)sender{
    _numberStr = sender.text;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    _numberStr = _textField.text;
    [self.view endEditing:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"填写手机号";
    
    FPAppDelegate *delegate = (FPAppDelegate *)[UIApplication sharedApplication].delegate;
    if (delegate.hasCheckAppVersion == NO) {
        [self checkMobileVersion];
    }
}

-(void)checkPhoneNumber:(NSString *)phoneNumber
{
    FPClient *urlClient = [FPClient sharedClient];
    NSDictionary *parameters = [urlClient findPersonMemberExistByMobile:phoneNumber];
    
    [urlClient POST:kFPPost parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        if ([[responseObject objectForKey:@"result"] boolValue] == YES) {
            
            if ([[responseObject objectForKey:@"result"] boolValue] == YES) {
                if ([[responseObject objectForKey:@"returnObj"] boolValue] == YES) {
                    NSString *errInfo = [NSString stringWithFormat:@"手机号%@已经被他人注册!",phoneNumber];
                    [self showToastMessage:errInfo];
                }else{
                    
                    NSString *phone = [phoneNumber trimOnlySpace];
                    if (self.rgtItem == nil) {
                        self.rgtItem = [[FPRgtItem alloc]init];
                    }
                    self.rgtItem.rgt_PhoneNumber = phone;
                    
                    
                    NSString *timeStr =[[NSUserDefaults standardUserDefaults]objectForKey:@"timeleft_"];
                    int time = [timeStr intValue];
                    
                    if (time <=0 || time == 90) {
                        NSString *message = [NSString stringWithFormat:@"我们将发送验证码短信到这个号码:%@",_numberStr];
                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"确认手机号码" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
                        alert.tag = 101;
                        [alert show];
                        
                    }else{
                        //直接跳转到页面
                        FPTakeSecurityController *securityView = [[FPTakeSecurityController alloc]init];
                        securityView.teleNmuber = _numberStr;
                        securityView.rgtItem = self.rgtItem;
                        [self.navigationController pushViewController:securityView animated:YES];
                    }
                    
                }

            }
            
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showToastMessage:kNetworkErrorMessage];
    }];
}

#pragma mark----UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 101 && buttonIndex == 1) {
        FPTakeSecurityController *securityView = [[FPTakeSecurityController alloc]init];
        securityView.teleNmuber = _numberStr;
        securityView.rgtItem = self.rgtItem;
        [self.navigationController pushViewController:securityView animated:YES];
    }
    
    if (alertView.tag == 201 && buttonIndex == 1) {
        [self gotoHomePage];
    }
    
    if (alertView.tag == 301 && buttonIndex == 0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.updateUrl]];
    }

}

//检测版本更新
-(void)checkMobileVersion
{
    [FPAppVersion checkAppVersion:NO andBlock:^(FPAppVersion *appVersion,NSError *error) {
        if (error) {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"网络连接失败,请查看网络是否连接正常！" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        } else {
            
            if (appVersion.result) {
                
                self.updateUrl = appVersion.updateUrl;
                FPAppDelegate *delegate = (FPAppDelegate *)[UIApplication sharedApplication].delegate;
                delegate.hasCheckAppVersion = YES;
                
                if (appVersion.forceUpdate == YES) {
                    NSString *msg = [NSString stringWithFormat:@"检查到最新版本:%@",appVersion.serverVersion];
                    
                    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:msg delegate:self cancelButtonTitle:@"立即更新" otherButtonTitles:nil];
                    alert.tag = 301;
                    [alert show];
                }else{
                    if (appVersion.needUpdate == YES) {
                        NSString *msg = [NSString stringWithFormat:@"检查到最新版本:%@",appVersion.serverVersion];
                        
                        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:msg delegate:self cancelButtonTitle:@"立即更新" otherButtonTitles:@"知道了",nil];
                        alert.tag = 301;
                        [alert show];
                    }
                    
                }
                
            }
        }
    }];
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
