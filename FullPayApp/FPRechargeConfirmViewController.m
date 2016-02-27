//
//  FPRechargeConfirmViewController.m
//  FullPayApp
//
//  Created by mark zheng on 14-3-3.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPRechargeConfirmViewController.h"
#import "FPBankCardListViewController.h"
#import "FPNameAndStaffIdViewController.h"
#import "ZHCheckBoxButton.h"

#define TIPFORMAT @"%@ %@ %2.0f元话费 快速充值"

@interface FPRechargeConfirmViewController ()<FPPassCodeViewDelegate,ZHCheckBoxButtonDelegate>
@property (strong, nonatomic) ZHCheckBoxButton *btnShowPwd;
@end

@implementation FPRechargeConfirmViewController

- (void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    UIImageView *background = [[UIImageView alloc] initWithFrame:view.bounds];
    background.image = [UIImage imageNamed:@"BG"];
    [view addSubview:background];
    
    self.lbl_InPhoneNumber = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 290, 50)];
//    self.lbl_InPhoneNumber.text = @"18718867801 中国移动 30元话费 快速充值";
    self.lbl_InPhoneNumber.backgroundColor = [UIColor clearColor];
    self.lbl_InPhoneNumber.textAlignment = NSTextAlignmentLeft;
    self.lbl_InPhoneNumber.font = [UIFont systemFontOfSize:13.0f];
    self.lbl_InPhoneNumber.textColor = [UIColor darkGrayColor];
    self.lbl_InPhoneNumber.backgroundColor = [UIColor whiteColor];
    [view addSubview:self.lbl_InPhoneNumber];
    
    self.lbl_PayTip = [[UILabel alloc] initWithFrame:CGRectMake(15, 70, 30, 21)];
    self.lbl_PayTip.text = @"实款";
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
    
    [self getAccountInfo];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.title = @"充值确认 2/2";
    self.navigationController.navigationBar.translucent = NO;
    
    UIBarButtonItem *back = [[UIBarButtonItem alloc]init];
    [back setTitle:@""];
    self.navigationItem.backBarButtonItem = back;
    
    if(self.mobileOption){
        
        NSString *telecorp = [self getTelecom:self.userPhoneTelecom];
        self.lbl_InPhoneNumber.text = [NSString stringWithFormat:TIPFORMAT,self.mobileNo,telecorp,self.mobileOption.rechargeAmount];
        
        self.lbl_payNumber.text = [NSString stringWithFormat:@" %.2f元",self.mobileOption.payAmount];
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

#pragma mark 获取余额信息
- (void)getAccountInfo
{
    [FPAccountInfo getFPAccountInfoWithBlock:^(FPAccountInfo *cardInfo,NSError *error){
        if (error) {
            
            [self showToastMessage:kNetworkErrorMessage];
        } else {
            if (cardInfo.result) {
                [[Config Instance]setAccountItem:cardInfo.accountItem];
                
                double amount = [cardInfo.accountItem.accountAmount doubleValue];
                self.lbl_Balance.text = [NSString stringWithFormat:@"可用余额 %0.2f",amount/100];

            } else {
                
            }
        }
    }];
    
}

#pragma mark FPPassCodeView delegate

-(void)passCodeViewBecomeFirstResponse{
    FPAccountInfoItem *accountItem = [[Config Instance] accountItem];
    if (accountItem) {
        double amount = [accountItem.accountAmount doubleValue]/100;
        double payAmount = (double)self.mobileOption.payAmount;
        if (payAmount > amount) {
            
            if ([self.fld_PayPwd isFirstResponse]) {
                [self.fld_PayPwd resignFirstResponse];
            }
            
            UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"您的余额不足!" message:nil delegate:self cancelButtonTitle:@"取消"  otherButtonTitles:@"给账户充值", nil];
            alter.tag = 101;
            [alter show];
            
            return;
        }
    }
}
-(void)passCodeView:(FPPassCodeView *)sender checkPassCodeLength:(NSString *)passCode{

    if(passCode.length == 6){
        self.btn_NextStep.enabled = YES;
    }else{
        self.btn_NextStep.enabled = NO;
    }

}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 101 && buttonIndex == 1) {
        FPPersonMember *personMember = [Config Instance].personMember;
        if (personMember.nameAuthFlag) {
            
            //跳转到银行卡列表
            FPBankCardListViewController *controller = [[FPBankCardListViewController alloc] init];
            controller.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:controller animated:YES];
            
        }else{
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"此功能需实名认证才可使用!" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"前往实名", nil];
            alert.tag = 102;
            [alert show];
            
        }
 
    }
    
    if (alertView.tag == 102 && buttonIndex == 1) {
        //前往实名
        FPNameAndStaffIdViewController *controller = [[FPNameAndStaffIdViewController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
    }
    
    if (alertView.tag == 103) {
        //充值成功返回
        BOOL found = NO;
        for (id controller in [self.navigationController viewControllers]) {
            if ([controller isKindOfClass:[FPViewController class]]) {
                found = YES;
                [self.navigationController popToViewController:controller animated:YES];
                break;
            }
        }
        
        if (found == NO) {
            
            FPViewController *controller = [[FPViewController alloc] init];
            //                controller.personMember = [Config Instance].personMember;
            [self.navigationController pushViewController:controller animated:YES];
        }

    }
}

#pragma mark - Util
- (NSString *)getTelecom:(NSString *)telecom
{
    if ([telecom isEqualToString:@"CHINAMOBILE"]) {
        return @"中国移动";
    } else if ([telecom isEqualToString:@"CHINAUNICOM"]) {
        return @"中国联通";
    } else if ([telecom isEqualToString:@"CHINATELCOM"]){
        return @"中国电信";
    } else {
        return @"未知";
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
    NSString *payPwd = nil;

    payPwd = [self.fld_PayPwd.passcode trimSpace];
    if ([payPwd checkPayPwd] == NO) {
        [self.fld_PayPwd clearPasscode];
        [self.fld_PayPwd becomeFirstResponse];
        return;
    }
    
    if (!self.mobileOption ) {
        return;
    }
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    [UtilTool showHUD:@"正在处理" andView:self.view andHUD:hud];
    
    [FPMobileRechargeModel userRechargeMobileFeeWithMobileNo:self.mobileNo andOptionId:self.mobileOption.optionId andPayPwd:payPwd andBlock:^(FPMobileRechargeModel *dataInfo,NSError *error){
        [hud setHidden:YES];
        [self.fld_PayPwd clearPasscode];
        if (error) {
            [self showToastMessage:kNetworkErrorMessage];
        } else {
            if (dataInfo.result) {
                NSString *messageInfo = @"话费充值成功!";
                UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"提示!" message:messageInfo delegate:self cancelButtonTitle:@"确认"  otherButtonTitles:nil, nil];
                alter.tag = 103;
                [alter setContentMode:UIViewContentModeCenter];
                [alter show];

            } else {
                UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"提示!" message:dataInfo.errorInfo delegate:nil cancelButtonTitle:@"确认"  otherButtonTitles:nil, nil];
                
                [alter setContentMode:UIViewContentModeCenter];
                [alter show];
            }
        }
    }];
    
}

#pragma mark ZHCheckBoxButton delegate
- (void)onCheckButtonClicked:(id)control{
    [self.view endEditing:YES];
    self.fld_PayPwd.securet = !self.fld_PayPwd.securet;
    
    //刷新视图
    [self.fld_PayPwd refeshView];
}


@end
