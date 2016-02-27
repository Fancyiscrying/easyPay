//
//  FPChangeLoginPwdViewController.m
//  FullPayApp
//
//  Created by mark zheng on 14-2-27.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPChangeLoginPwdViewController.h"
#import "UIButton+UIButtonImageWithLabel.h"
#import "FPLoginViewController.h"

#define IMG_NOSHOW  @"login_check_no"
#define IMG_SHOW    @"login_check_yes"

@interface FPChangeLoginPwdViewController () <ZHCheckBoxButtonDelegate,UIAlertViewDelegate,UITextFieldDelegate>

@property (nonatomic,strong) NSString *orgPwd;
@property (nonatomic,strong) NSString *pwd;

@end

@implementation FPChangeLoginPwdViewController

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
    
    self.fieldOrgPwd = [[ZHTextField alloc] init];
    self.fieldOrgPwd.frame = CGRectMake(0, 22, 320, 50);
    self.fieldOrgPwd.placeholder = @"当前密码(6-12位字符)";
    self.fieldOrgPwd.textAlignment = NSTextAlignmentLeft;
    self.fieldOrgPwd.backgroundColor = [UIColor whiteColor];
    self.fieldOrgPwd.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.fieldOrgPwd.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.fieldOrgPwd.keyboardType = UIKeyboardTypeASCIICapable;
    self.fieldOrgPwd.delegate = self;
    [view addSubview:self.fieldOrgPwd];
    
    self.fieldPwd = [[ZHTextField alloc] init];
    self.fieldPwd.frame = CGRectMake(0, 77, 320, 50);
    self.fieldPwd.placeholder = @"新密码(6-12位字符)";
    self.fieldPwd.textAlignment = NSTextAlignmentLeft;
    self.fieldPwd.backgroundColor = [UIColor whiteColor];
    self.fieldPwd.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.fieldPwd.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.fieldPwd.keyboardType = UIKeyboardTypeASCIICapable;
    self.fieldPwd.delegate = self;
    [view addSubview:self.fieldPwd];
    
    /* 密码可见button */
    NSString *pwdString = @"显示密码";
    self.btnShowPwd = [[ZHCheckBoxButton alloc] initWithFrame:CGRectMake(20, 142, 80, 15)];
    [self.btnShowPwd.label setText:pwdString];
    [self.btnShowPwd setChecked:YES];
    self.btnShowPwd.delegate = self;
    [view addSubview:self.btnShowPwd];
    
    UIButton *btnNextStep = [UIButton buttonWithType:UIButtonTypeCustom];
    btnNextStep.frame = CGRectMake(15, 170, 290, 45);
    [btnNextStep setBackgroundImage:MIMAGE_COLOR_SIZE([UIColor orangeColor],btnNextStep.frame.size) forState:UIControlStateNormal];
    [btnNextStep setBackgroundImage:MIMAGE_COLOR_SIZE([UIColor darkGrayColor],btnNextStep.frame.size) forState:UIControlStateDisabled];
    [btnNextStep setTitle:@"确定" forState:UIControlStateNormal];
    [btnNextStep setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnNextStep addTarget:self action:@selector(clickConfirm:) forControlEvents:UIControlEventTouchUpInside];
    btnNextStep.tag = 99;
    btnNextStep.enabled = NO;
    [view addSubview:btnNextStep];
    
    self.view = view;
}

#pragma mark - view lifecycle
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    /* 导航栏设置*/
    self.navigationItem.title = @"修改登录密码";
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self fieldResignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setFieldOrgPwd:nil];
    [self setFieldPwd:nil];
    [self setBtnShowPwd:nil];
    [self setBtnConfirm:nil];
    [super viewDidUnload];
}

-(void)fieldResignFirstResponder
{
    if ([self.fieldOrgPwd isFirstResponder]) {
        [self.fieldOrgPwd resignFirstResponder];
    }
    
    if ([self.fieldPwd isFirstResponder]) {
        [self.fieldPwd resignFirstResponder];
    }
}

- (void)clickConfirm:(UIButton *)sender {
    
    [self fieldResignFirstResponder];
    
    self.orgPwd = self.fieldOrgPwd.text ;
    self.pwd = self.fieldPwd.text ;
    
    if ([self.orgPwd checkLoginPwd] == NO) {
        self.fieldOrgPwd.text = @"";
        [self.fieldOrgPwd becomeFirstResponder];
        return;
    }
    if ([self.pwd checkLoginPwd] == NO) {
        self.fieldPwd.text = @"";
        [self.fieldPwd becomeFirstResponder];
        return;
    }
    
    NSString *memberNo = [Config Instance].memberNo;
    FPClient *urlClient = [FPClient sharedClient];
    NSDictionary *parameters = [urlClient userChangeLoginPwd:memberNo andPwd:self.pwd andOrgPwd:self.orgPwd];
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    [UtilTool showHUD:@"正在处理" andView:self.view andHUD:hud];
    [urlClient POST:kFPPost parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [hud hide:YES];
        NSLog(@"%@",responseObject);
        if ([[responseObject objectForKey:@"result"] boolValue] == YES) {

            UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"修改登录密码完成" message:@"请使用新的密码登录" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            
            [alter setContentMode:UIViewContentModeCenter];
            alter.tag = 101;
            [alter show];
            
        }else{
            NSString *errInfo = [responseObject objectForKey:@"errorInfo"];
            [self showToastMessage:errInfo];
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [hud hide:YES];
        [self showToastMessage:kNetworkErrorMessage];
    }];
}

#pragma mark - ZHCheckBoxButtonDelegate
- (void)onCheckButtonClicked:(id)control
{
    [self fieldResignFirstResponder];
    self.fieldOrgPwd.secureTextEntry = !self.fieldOrgPwd.secureTextEntry;
    self.fieldPwd.secureTextEntry = !self.fieldPwd.secureTextEntry;
}

#pragma mark UIAlertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 101) {
        [[Config Instance] setAutoLogin:NO];
        //返回登录
        [UtilTool setLoginViewRootController];
        //[self.navigationController popToRootViewControllerAnimated:YES];
    }
}
#pragma mark UITextField delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    UIButton *btn_NextStep = (UIButton *)[self.view viewWithTag:99];
    if (self.fieldPwd.text.length >=5 && self.fieldOrgPwd.text.length >= 5) {
        btn_NextStep.enabled = YES;
    }else{
        btn_NextStep.enabled = NO;
    }
    
    return YES;
}
@end
