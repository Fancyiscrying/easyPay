//
//  FPCardRechargeViewController.m
//  FullPayApp
//
//  Created by mark zheng on 14-2-28.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPCardRechargeViewController.h"
#import "FPPARechargeWebController.h"
//#import "FPViewController.h"
#import "FPAppParams.h"

#import "FPGroupBuyViewController.h"

#define IMG_WHITEBACK @"Box 06.png"
#define IMG_BTNBACK @"Box 002.png"
#define IMG_FIELDBACK @"Box 07.png"

@interface FPCardRechargeViewController ()<UITextFieldDelegate>
{
    long long minRgeAmount;  //最小充值金额
    long long maxBalance;  //最大账户余额
    long long maxRgeAmount; //最大充值金额
    long long accountAmount; //账户余额
    
    UILabel *tip2;
}

@property (nonatomic, assign) NSInteger rechargeStatus;
@end

@implementation FPCardRechargeViewController

-(void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    
    UIImageView *background = [[UIImageView alloc] initWithFrame:view.bounds];
    background.image = [UIImage imageNamed:@"BG"];
    [view addSubview:background];
    
    self.labelAccount = [[UILabel alloc] init];
    self.labelAccount.frame = CGRectMake(20, 22, 278, 28);
    self.labelAccount.backgroundColor = [UIColor clearColor];
    self.labelAccount.textColor = [UIColor darkGrayColor];
    self.labelAccount.font = [UIFont systemFontOfSize:15.0f];
    self.labelAccount.numberOfLines = 1;
    [view addSubview:self.labelAccount];
    
    self.fieldAmt = [[ZHTextField alloc] init];
    self.fieldAmt.frame = CGRectMake(0, 60, 320, 50);
    self.fieldAmt.backgroundColor = [UIColor whiteColor];
    self.fieldAmt.textAlignment = NSTextAlignmentLeft;
    self.fieldAmt.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.fieldAmt.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.fieldAmt.placeholder = @"充值金额 ￥0.00";
    self.fieldAmt.delegate = self;
    [view addSubview:self.fieldAmt];
    
    tip2 = [[UILabel alloc] init];
    tip2.frame = CGRectMake(20, 115, 194, 27);
    tip2.text = @"提示:请输入整数,范围为10元至9999元.";
    tip2.textColor = [UIColor blackColor];
    tip2.font = [UIFont systemFontOfSize:10.0f];
    tip2.textAlignment = NSTextAlignmentLeft;
    tip2.numberOfLines = 1;
    [view addSubview:tip2];
    
    UIButton *btnSubmit = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSubmit.frame = CGRectMake(0, 150, 320, 44);
    [btnSubmit setBackgroundImage:MIMAGE_COLOR_SIZE([UIColor orangeColor],btnSubmit.frame.size) forState:UIControlStateNormal];
    [btnSubmit setBackgroundImage:MIMAGE_COLOR_SIZE([UIColor darkGrayColor],btnSubmit.frame.size) forState:UIControlStateDisabled];
    [btnSubmit setTitle:@"确认" forState:UIControlStateNormal];
    [btnSubmit setTitleColor:MCOLOR(@"text_color") forState:UIControlStateNormal];
    [btnSubmit addTarget:self action:@selector(clickToRecharge:) forControlEvents:UIControlEventTouchUpInside];
    btnSubmit.tag = 101;
    btnSubmit.enabled = NO;
    [view addSubview:btnSubmit];
    
    self.view = view;
}
#pragma mark  UITextField delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    NSString *text = textField.text;
    
    UIButton *btnSubmit = (UIButton *)[self.view viewWithTag:101];
    if (text.length == 0) {
        btnSubmit.enabled = YES;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSString *text = textField.text;

    UIButton *btnSubmit = (UIButton *)[self.view viewWithTag:101];
    if (text.length >0) {
        btnSubmit.enabled = YES;
    }else {
        btnSubmit.enabled = NO;
    }

}

#pragma mark - view lifecycle
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.navigationBar.translucent = NO;
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.title = @"富之富 | 充值";
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    self.navigationItem.backBarButtonItem = backItem;
    backItem.title = @"";
    //[[tftPlugin shareInstance] setDelegate:self];
    
    NSString *mobileNo = [Config Instance].personMember.mobile;
    self.labelAccount.text = [NSString stringWithFormat:@"往 富之富账户充值 %@",mobileNo];
    [self.fieldAmt setDelegate:self];
    [self.fieldAmt setKeyboardType:UIKeyboardTypeNumberPad];
    [self.fieldAmt setClearButtonMode:UITextFieldViewModeWhileEditing];
    [self.fieldAmt setClearsOnBeginEditing:YES];
    
    /*
     充值金额最小值判断，充值金额之后的额度要小于总得金额
     */
    FPAppParams *appParams = [Config Instance].appParams;

    NSNumber *number = [NSNumber numberWithDouble:10000.00];
    accountAmount = [number longLongValue];
    BOOL isRealName = [Config Instance].personMember.nameAuthFlag;
    minRgeAmount = [appParams.allUserRgeMinAmount longLongValue];  //最小充值金额
    maxBalance = 0;  //最大账户余额
    maxRgeAmount = 0; //最大充值金额
    if (isRealName) {
        maxBalance = [appParams.realNameAcctMaxBalance longLongValue];
        maxRgeAmount = [appParams.realNameRgeMaxAmount longLongValue];
    } else {
        maxBalance = [appParams.unRealNameAcctMaxBalance longLongValue];
        maxRgeAmount = [appParams.unRealNameRgeMaxAmount longLongValue];
    }
    
    tip2.text = [NSString stringWithFormat:@"提示:请输入整数,范围为%lld元至%lld元.",minRgeAmount/100,maxRgeAmount/100];
}

#pragma mark - alterView delegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 99) {
        if (buttonIndex == 1) {
            //[[tftPlugin shareInstance] installTempusPay];
        }
    } else if(alertView.tag == 98) {
        
        //此处逻辑尚需讨论 ios
        if (self.redirectUri && self.redirectUri.length > 0) {

            if (self.rechargeStatus == 0) {
                [self redirectToGroupBuyController];
                return;
            }

        }
        
    }
}

#pragma mark -
- (void)payDidApplyWithStatus:(NSString *)orderStatus withOrderID:(NSString *)orderID andMsg:(NSString *)msg
{
    NSString *str = nil;
    int status = [orderStatus intValue];
    self.rechargeStatus = status;
    switch (status) {
        case 0:
            str = [NSMutableString stringWithFormat:@"订单支付成功,返回信息:%@%@",orderID,msg];
            break;
        case 1:
            str = [NSMutableString stringWithFormat:@"支付失败,订单已经支付过，无需要重复支付,返回信息:%@%@",orderID,msg];
            break;
        case 2:
            str = [NSMutableString stringWithFormat:@"支付失败,订单已经被取消,返回信息:%@%@",orderID,msg];
            break;
        case 3:
            str = [NSMutableString stringWithFormat:@"支付失败,订单不存在,返回信息:%@%@",orderID,msg];
            break;
        default:
            str = [NSMutableString stringWithFormat:@"支付失败,返回信息:%@%@",orderID,msg];
            break;
    }
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:str delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    alertView.tag = 98;
    [alertView show];
}

#pragma mark -
#pragma mark UITextFieldDelegate

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	[self.fieldAmt resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setLabelAccount:nil];
    [self setFieldAmt:nil];
    [super viewDidUnload];
}

- (void)clickToRecharge:(id)sender {
    NSString *amt = [self.fieldAmt.text trimSpace];
    [self.fieldAmt resignFirstResponder];
    if ([amt checkRechargeAmt] == NO) {
        [self.fieldAmt becomeFirstResponder];
        return;
    }
    NSString *iAmt = [UtilTool decimalNumberMutiplyWithString:amt andValue:kAMT_PROPORTION];
    
    BOOL EFlag = NO;
    NSString *msg;
    long long lAmt = [iAmt longLongValue];
    if (lAmt + accountAmount > maxBalance) {
        EFlag = YES;
        msg = @"您的账户余额已经达到最大限额";
    }
    
    if (lAmt > maxRgeAmount) {
        EFlag = YES;
        msg = [NSString stringWithFormat:@"您当前最大可充值金额为%lld元",maxRgeAmount/100];
    }
    
    if (lAmt < minRgeAmount) {
        EFlag = YES;
        msg = [NSString stringWithFormat:@"最小充值金额为%lld元",minRgeAmount/100];
    }
    
    if (EFlag) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
        [self.fieldAmt becomeFirstResponder];
        
        return;
    }
    
    NSString *memberNo = [Config Instance].memberNo;
    FPClient *urlClient = [FPClient sharedClient];
    NSDictionary *parameters = [urlClient userRechargeByPINGAN:memberNo andAmt:iAmt andBankCardId:self.bankCardId];
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    [UtilTool showHUD:@"正在处理" andView:self.view andHUD:hud];
    
    [urlClient POST:kFPPost parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [hud hide:YES];
        FPDEBUG(@"%@",responseObject);
        
        if ([[responseObject objectForKey:@"result"] boolValue] == YES) {

            NSDictionary *returnObj = responseObject[@"returnObj"];
            
            NSString *urlString = [returnObj objectForKey:@"action"];
            
            NSDictionary *dict = [returnObj objectForKey:@"apiMap"];
            
            FPPARechargeWebController *controller = [[FPPARechargeWebController alloc]init];
            controller.urlString = urlString;
            controller.paramters = dict;
            controller.bankCardNO = self.bankCardNo;
            [self.navigationController pushViewController:controller animated:YES];
            
            
        }else{
            NSString *errInfo = [responseObject objectForKey:@"errorInfo"];
            UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"充值失败!" message:errInfo delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            
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

-(void)redirectToGroupBuyController
{
    if (self.redirectUri && self.redirectUri.length > 0) {
        NSString *memberNo = [Config Instance].memberNo;
        NSString *result = [memberNo md5Twice:[memberNo substringWithRange:NSMakeRange(1, 10)]];
        
        NSString *uri = nil;
        if ([self.redirectUri rangeOfString:@"?"].location == NSNotFound) {
            uri = [NSString stringWithFormat:FORMAT_GROUP,kGROUPBUY_BASEURI,self.redirectUri,memberNo,result];
        } else {
            uri = [NSString stringWithFormat:FORMAT_GROUP_With_Symbol,kGROUPBUY_BASEURI,self.redirectUri,memberNo,result];
        }
        
        FPGroupBuyViewController *groupController = [[FPGroupBuyViewController alloc] init];
        groupController.groupViewType = FPGroupBuyViewControllerTypeAuth;
        [groupController setRedirectUri:uri];
        [self.navigationController pushViewController:groupController animated:YES];
    }
}

@end
