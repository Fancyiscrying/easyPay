//
//  FPPayConfirmViewController.m
//  FullPayApp
//
//  Created by mark zheng on 14-3-3.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPPayConfirmViewController.h"
#import "FPDataBaseManager.h"
#import "ZHCheckBoxButton.h"

#define TipsFormat @"%@ %@(%@)"
#define TipsFormatWithoutRemark @"%@ %@"

@interface FPPayConfirmViewController ()<FPPassCodeViewDelegate,ZHCheckBoxButtonDelegate,UIAlertViewDelegate>
@property (strong, nonatomic) ZHCheckBoxButton *btnShowPwd;
@end

@implementation FPPayConfirmViewController

- (void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    UIImageView *background = [[UIImageView alloc] initWithFrame:view.bounds];
    background.image = [UIImage imageNamed:@"BG"];
    [view addSubview:background];
    
    self.lbl_InPhoneNumber = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 290, 50)];
    //    self.lbl_InPhoneNumber.text = @"18718867801 *文超 (赏你的)";
    self.lbl_InPhoneNumber.backgroundColor = [UIColor clearColor];
    self.lbl_InPhoneNumber.textAlignment = NSTextAlignmentCenter;
    self.lbl_InPhoneNumber.font = [UIFont systemFontOfSize:14.0f];
    self.lbl_InPhoneNumber.textColor = [UIColor darkGrayColor];
    self.lbl_InPhoneNumber.backgroundColor = [UIColor whiteColor];
    self.lbl_InPhoneNumber.numberOfLines = 2;
    [view addSubview:self.lbl_InPhoneNumber];
    
    self.lbl_PayTip = [[UILabel alloc] initWithFrame:CGRectMake(15, 70, 30, 21)];
    self.lbl_PayTip.text = @"付款";
    self.lbl_PayTip.textColor = [UIColor blackColor];
    self.lbl_PayTip.textAlignment = NSTextAlignmentLeft;
    self.lbl_PayTip.font = [UIFont systemFontOfSize:12.0f];
    [view addSubview:self.lbl_PayTip];
    
    self.lbl_payNumber = [[UILabel alloc] initWithFrame:CGRectMake(45, 68, 140, 21)];
    self.lbl_payNumber.text = @"";
    self.lbl_payNumber.textColor = [UIColor redColor];
    self.lbl_payNumber.textAlignment = NSTextAlignmentLeft;
    self.lbl_payNumber.font = [UIFont systemFontOfSize:14.0f];
    [view addSubview:self.lbl_payNumber];
    
    self.lbl_Balance = [[UILabel alloc] initWithFrame:CGRectMake(155, 70, 140, 21)];
    self.lbl_Balance.textColor = [UIColor darkGrayColor];
    self.lbl_Balance.textAlignment = NSTextAlignmentRight;
    self.lbl_Balance.font = [UIFont systemFontOfSize:12.0f];
    self.lbl_Balance.text = @"可用余额 0.00";
    [view addSubview:self.lbl_Balance];
    
    UIImageView *imgLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 100, 320, 1)];
    imgLine.image = MIMAGE(@"confirmation_dottedline");
    [view addSubview:imgLine];
    
    self.fld_PayPwd = [[FPPassCodeView alloc] initWithFrame:CGRectMake(25, 110, 280, 65) withSimple:YES];
    self.fld_PayPwd.titleLabel.text = @"请输入手机支付密码确认";
    self.fld_PayPwd.delegate = self;
    self.fld_PayPwd.securet = YES;
    [view addSubview:self.fld_PayPwd];
    
    /* 密码可见button */
    NSString *pwdString = @"显示密码";
    self.btnShowPwd = [[ZHCheckBoxButton alloc] initWithFrame:CGRectMake(20, 185, 80, 15)];
    [self.btnShowPwd.label setText:pwdString];
    [self.btnShowPwd setChecked:NO];
    self.btnShowPwd.delegate = self;
    [view addSubview:self.btnShowPwd];
    
    self.btn_NextStep = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btn_NextStep.frame = CGRectMake(15, 210, 290, 45);
    [self.btn_NextStep setTitle:@"确定" forState:UIControlStateNormal];
    [self.btn_NextStep setBackgroundImage:[UIImage imageNamed:COMM_BTN_YELL] forState:UIControlStateNormal];
    [self.btn_NextStep setBackgroundImage:[UIImage imageNamed:COMM_BTN_GRAY] forState:UIControlStateDisabled];
    [self.btn_NextStep addTarget:self action:@selector(click_NextStep:) forControlEvents:UIControlEventTouchUpInside];
    self.btn_NextStep.enabled = NO;
    [view addSubview:self.btn_NextStep];
    
    self.view = view;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tabBarController.tabBar setHidden:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.title = @"付款确认";
    self.navigationController.navigationBar.translucent = NO;
    
    if(self.transferData){

        NSString *phone = [self.transferData.toMemberPhone changeMoblieToFormatMoblie];
        NSString *memberName = self.transferData.toMemberName;
        if (memberName.length>1) {
            memberName = [memberName substringFromIndex:1];
            memberName = [NSString stringWithFormat:@"*%@",memberName];
        }
        NSString *remark = self.transferData.toRemark;
        if (remark.length == 0) {
            self.lbl_InPhoneNumber.text = [NSString stringWithFormat:TipsFormatWithoutRemark,phone,memberName];
        }else{
            self.lbl_InPhoneNumber.text = [NSString stringWithFormat:TipsFormat,phone,memberName,self.transferData.toRemark];
        }
        double amount = [self.transferData.toAmount doubleValue]/100;
        self.lbl_payNumber.text = [NSString stringWithFormat:@" %.2f",amount];
        
    }
    
    FPAccountInfoItem *accountItem = [[Config Instance] accountItem];
    if (accountItem) {
        double amount = [accountItem.accountAmount doubleValue];
        
        self.lbl_Balance.text = [NSString stringWithFormat:@"可用余额 %0.2f",amount/100];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)passCodeView:(FPPassCodeView *)sender checkPassCodeLength:(NSString *)passCode{
    if (passCode.length == 6) {
        self.btn_NextStep.enabled = YES;
    }else{
        self.btn_NextStep.enabled = NO;
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //    [self.fld_NewPwd resignFirstResponder];
    if ([self.fld_PayPwd isFirstResponse]) {
        [self.fld_PayPwd resignFirstResponse];
    } else {
        [self.fld_PayPwd becomeFirstResponse];
    }
}

- (void)click_NextStep:(id)sender
{
    NSString *password = [self.fld_PayPwd.passcode trimSpace];
    FPDEBUG(@"pa:%@",password);
    if (!password || ![password checkPayPwd]) {
        [self.fld_PayPwd clearPasscode];
        return;
    }
    
    if (self.transferData == nil) {
        UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"警告" message:@"已经成功转账，请勿重复提交!" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        
        [alter setContentMode:UIViewContentModeCenter];
        [alter show];
        
        return;
    }
    
    self.transferData.password = password;
    
    FPClient *urlClient = [FPClient sharedClient];
    NSDictionary *parameters = [urlClient userTransfer:self.transferData.fromMemberNo andInMemberNo:self.transferData.toMemberNo andAmt:self.transferData.toAmount andPassword:self.transferData.password andRemark:self.transferData.toRemark];
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    [UtilTool showHUD:@"正在处理" andView:self.view andHUD:hud];
    [urlClient POST:kFPPost parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [hud hide:YES];
        [self.fld_PayPwd clearPasscode];
        if ([[responseObject objectForKey:@"result"] boolValue] == YES) {
            
            FPDataBaseManager *center = [FPDataBaseManager shareCenter];
            [center createTable_Cantact];

            
            [center updateIfExistTable_Cantact:self.transferData];
            
            self.transferData = nil;
            UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"转账成功" message:nil delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
            alter.tag = 101;
            [alter setContentMode:UIViewContentModeCenter];
            [alter show];
            
           
//            BOOL hasViewController = NO;
//            for (UIViewController *viewController in [self.navigationController viewControllers]) {
//                if ([viewController isKindOfClass:[FPViewController class]]) {
//                    [self.navigationController popToViewController:viewController animated:YES];
//                    hasViewController = YES;
//                    break;
//                }
//            }
//            
//            if (hasViewController == NO) {
//                
//                FPViewController *mainView = [[FPViewController alloc] init];
//                [self.navigationController pushViewController:mainView animated:YES];
//            }
            
            
        }else{
            NSString *errInfo = [responseObject objectForKey:@"errorInfo"];
            UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"转账失败" message:errInfo delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
            
            [alter setContentMode:UIViewContentModeCenter];
            [alter show];
            
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [hud hide:YES];
        [self.fld_PayPwd clearPasscode];
        FPDEBUG(@"%@",error);
        [[Config Instance] setAutoLogin:NO];
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"网络连接失败,请查看网络是否连接正常！" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }];
}

-(void)transferWithoutPaypwd
{
//    if (self.transferData == nil) {
//        FPAlertView *alter = [[FPAlertView alloc]initWithTitle:@"警告" message:@"已经成功转账，请勿重复提交!" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
//        
//        [alter setContentMode:UIViewContentModeCenter];
//        [alter show];
//        
//        return;
//    }
//    
//    self.transferData.password = @"";
    
//    FPClient *urlClient = [FPClient sharedClient];
//    NSDictionary *parameters = [urlClient userTransfer:self.transferData.memberNo andInMemberNo:self.transferData.inMemberNo andAmt:self.transferData.amount andPassword:self.transferData.password andRemark:self.transferData.remark];
//    
//    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
//    [UtilTool showHUD:@"正在处理" andView:self.view andHUD:hud];
//    [urlClient POST:kFPPost parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        [hud hide:YES];
//        if ([[responseObject objectForKey:@"result"] boolValue] == YES) {
//            //            NSDictionary *object = [responseObject objectForKey:@"returnObj"];
//            //            FPDEBUG(@"%@",object);
//            
//            NSString *memberNo = [Config Instance].memberNo;
//            FPContactsInfoController *contact = [[FPContactsInfoController alloc] init];
//            [contact addContacts:self.transferData.inMobileNo andInMemberNo:self.transferData.inMemberNo andInMemberName:self.transferData.inMemberName andRemark:self.transferData.remark andAmount:[self.transferData.amount doubleValue] andIsNotice:NO andMemberNo:memberNo];
            
//            self.transferData = nil;
//            UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"转账成功" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            
//            [alter setContentMode:UIViewContentModeCenter];
//            [alter show];
//            
//            BOOL hasViewController = NO;
//            for (UIViewController *viewController in [self.navigationController viewControllers]) {
//                if ([viewController isKindOfClass:[FPViewController class]]) {
//                    [self.navigationController popToViewController:viewController animated:YES];
//                    hasViewController = YES;
//                    break;
//                }
//            }
//            
//            if (hasViewController == NO) {
//                
//                FPViewController *mainView = [[FPViewController alloc] init];
//                //                mainView.personMember = [Config Instance].personMember;
//                
//                [self.navigationController pushViewController:mainView animated:YES];
//            }
//            
//        }else{
//            NSString *errInfo = [responseObject objectForKey:@"errorInfo"];
//            FPAlertView *alter = [[FPAlertView alloc]initWithTitle:@"转账失败" message:errInfo delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
//            
//            [alter setContentMode:UIViewContentModeCenter];
//            [alter show];
//            
//        }
//    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [hud hide:YES];
//        FPDEBUG(@"%@",error);
//        FPAlertView *alert=[[FPAlertView alloc] initWithTitle:@"温馨提示" message:@"网络连接失败,请查看网络是否连接正常！" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alert show];
//    }];
    
}
#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 101) {
        //返回首页
        [UtilTool setHomeViewRootController];
    }
}


#pragma mark ZHCheckBoxButton delegate
- (void)onCheckButtonClicked:(id)control{
    [self.view endEditing:YES];
    self.fld_PayPwd.securet = !self.fld_PayPwd.securet;
    
    //刷新视图
    [self.fld_PayPwd refeshView];
}



@end
