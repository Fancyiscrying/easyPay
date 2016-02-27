//
//  FPNameAndStaffIdViewController.m
//  FullPayApp
//
//  Created by mark zheng on 14-3-3.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPNameAndStaffIdViewController.h"
#import "FPCertificateViewController.h"
#import "FPIdVerify.h"

@interface FPNameAndStaffIdViewController ()<UITextFieldDelegate>

@property (nonatomic,strong) FPIdVerify   *idVerifyInfo;

@end

@implementation FPNameAndStaffIdViewController
{
    UIView * _backGround;
}

- (id)idVerifyInfo
{
    if (!_idVerifyInfo) {
        _idVerifyInfo = [[FPIdVerify alloc] init];
    }
    
    return _idVerifyInfo;
}

- (void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    UIImageView *background = [[UIImageView alloc] initWithFrame:view.bounds];
    background.image = [UIImage imageNamed:@"BG"];
    [view addSubview:background];
    
    self.view = view;
    
    self.fld_RealName = [[ZHTextField alloc] init];
    self.fld_RealName.frame = CGRectMake(0, 20, 320, 50);
    self.fld_RealName.placeholder = @"真实姓名:";
    self.fld_RealName.textAlignment = NSTextAlignmentLeft;
    self.fld_RealName.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.fld_RealName.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.fld_RealName.backgroundColor = [UIColor whiteColor];
    self.fld_RealName.delegate = self;
    [self.view addSubview:self.fld_RealName];
    
    self.fld_StaffId = [[ZHTextField alloc] init];
    self.fld_StaffId.frame = CGRectMake(0, 75, 320, 50);
    self.fld_StaffId.placeholder = @"工号: (不区分大小写)";
    self.fld_StaffId.textAlignment = NSTextAlignmentLeft;
    self.fld_StaffId.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.fld_StaffId.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.fld_StaffId.backgroundColor = [UIColor whiteColor];
    self.fld_StaffId.delegate = self;
    [self.view addSubview:self.fld_StaffId];
    
    self.btn_NextStep = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btn_NextStep.frame = CGRectMake(15, 145, 290, 45);
    [self.btn_NextStep setBackgroundImage:MIMAGE(COMM_BTN_YELL) forState:UIControlStateNormal];
    [self.btn_NextStep setBackgroundImage:MIMAGE(COMM_BTN_GRAY) forState:UIControlStateDisabled];
    [self.btn_NextStep setTitle:@"下一步" forState:UIControlStateNormal];
    [self.btn_NextStep setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btn_NextStep setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    [self.btn_NextStep addTarget:self action:@selector(click_NextStep:) forControlEvents:UIControlEventTouchUpInside];
    self.btn_NextStep.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    self.btn_NextStep.enabled = NO;
    [self.view addSubview:self.btn_NextStep];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.title = @"实名认证 1/3";
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    self.navigationItem.backBarButtonItem = backItem;
    backItem.title = @"";
    self.navigationController.navigationBar.translucent = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)resignAllControl
{
    if ([self.fld_RealName isFirstResponder]) {
        [self.fld_RealName resignFirstResponder];
    }
    
    if ([self.fld_StaffId isFirstResponder]) {
        [self.fld_StaffId resignFirstResponder];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self resignAllControl];
}

-( void)click_NextStep:(UIButton *)sender
{
    [self resignAllControl];
    
    self.idVerifyInfo.realName = [self.fld_RealName.text trimSpace];
    if (![self.idVerifyInfo.realName checkRealName]) {
        return;
    }
    self.idVerifyInfo.staffId = [self.fld_StaffId.text trimSpace];
    if (self.idVerifyInfo.staffId.length == 0 ) {
        return;
    }
    
    FPCertificateViewController *controller = [[FPCertificateViewController alloc] init];
    controller.idVerifyInfo = self.idVerifyInfo;
    [self.navigationController pushViewController:controller animated:YES];
    
//    [self staffNameCheck];
}

-(void)staffNameCheck
{
    NSString *memberNo = [Config Instance].memberNo;
    
    FPClient *urlClient = [FPClient sharedClient];
    NSDictionary *parameters = [urlClient userStaffCheck:memberNo andMemberName:self.idVerifyInfo.realName andJobNumFoxconn:self.idVerifyInfo.staffId];
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    [UtilTool showHUD:@"正在处理中" andView:self.view andHUD:hud];
    
    [urlClient POST:kFPPost parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [hud hide:YES];
        FPDEBUG(@"%@",responseObject);
        if ([[responseObject objectForKey:@"result"] boolValue] == YES) {
            FPCertificateViewController *controller = [[FPCertificateViewController alloc] init];
            controller.idVerifyInfo = self.idVerifyInfo;
            [self.navigationController pushViewController:controller animated:YES];
            
        }else{
            NSString *errInfo = [responseObject objectForKey:@"errorInfo"];
            UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"实名认证失败" message:errInfo delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            
            [alter setContentMode:UIViewContentModeCenter];
            [alter show];
            
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [hud hide:YES];
        FPDEBUG(@"%@",error);
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"网络连接失败,请查看网络是否连接正常！" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }];
}

#pragma mark UITextField delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

    if (self.fld_RealName.text.length >0 && self.fld_StaffId.text.length>0) {
        self.btn_NextStep.enabled = YES;
    }else{
        self.btn_NextStep.enabled = NO;
    }
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    if (self.fld_RealName.text.length >0 && self.fld_StaffId.text.length>0) {
        self.btn_NextStep.enabled = YES;
    }else{
        self.btn_NextStep.enabled = NO;
    }

}


@end
