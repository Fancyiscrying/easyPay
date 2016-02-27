//
//  FPFullWalletRechargeViewController.m
//  FullPayApp
//
//  Created by 刘通超 on 14/12/5.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPFullWalletRechargeViewController.h"
#import "FPWalletRechargeSucceeController.h"
#import "FPTextField.h"

@interface FPFullWalletRechargeViewController ()<FPTextFieldDelegate,UITextFieldDelegate,FPPositivePayViewDelegate,UIAlertViewDelegate>

@property (strong, nonatomic) UILabel *cardLabel;
@property (strong, nonatomic) FPTextField *textFieldCard;
@property (strong, nonatomic) FPTextField *textFieldRecharge;
@property (nonatomic,strong) FPPositivePayView *positivePayView;
@property (nonatomic,strong) UILabel *labelBalance;

@property (nonatomic, assign) double amount;
@end

@implementation FPFullWalletRechargeViewController

- (void)loadView{
    UIView *view = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    UIImageView *background = [[UIImageView alloc] initWithFrame:view.bounds];
    background.image = [UIImage imageNamed:@"BG"];
    [view addSubview:background];
    
//    UILabel *fieldLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, ScreenWidth, 40)];
//    fieldLabel.backgroundColor = [UIColor whiteColor];
//    fieldLabel.textAlignment = NSTextAlignmentLeft;
//    fieldLabel.font = [UIFont systemFontOfSize:13];
//    fieldLabel.text = @"    卡号";
//    fieldLabel.textColor = [UIColor blackColor];
//    [view addSubview:fieldLabel];
//    
//    _cardLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 20, ScreenWidth-30, 40)];
//    _cardLabel.backgroundColor = [UIColor clearColor];
//    _cardLabel.textAlignment = NSTextAlignmentCenter;
//    _cardLabel.text = _cardNo;
//    [view addSubview:_cardLabel];
    
    _textFieldRecharge = [[FPTextField alloc]initWithFrame:CGRectMake(30, 20, ScreenWidth-30, 40)];
    _textFieldRecharge.backgroundColor = [UIColor whiteColor];
    _textFieldRecharge.textAlignment = NSTextAlignmentLeft;
    _textFieldRecharge.keyboardType = UIKeyboardTypeNumberPad;
    _textFieldRecharge.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    _textFieldRecharge.delegateDone = self;
    _textFieldRecharge.delegate = self;
    _textFieldRecharge.placeholder = @"不少于10元";
    _textFieldRecharge.font = SystemFontSize(14);
    [view addSubview:_textFieldRecharge];
    
    UILabel *rechargeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, _textFieldRecharge.top, 80, 40)];
    rechargeLabel.backgroundColor = [UIColor whiteColor];
    rechargeLabel.textAlignment = NSTextAlignmentLeft;
    rechargeLabel.font = [UIFont systemFontOfSize:14];
    rechargeLabel.text = @"    充值金额";
    rechargeLabel.textColor = COLOR_STRING(@"#222222");
    [view addSubview:rechargeLabel];
    
    UIView *balanceView = [[UIView alloc]initWithFrame:CGRectMake(0, _textFieldRecharge.bottom+20, ScreenWidth, 40)];
    balanceView.backgroundColor = [UIColor whiteColor];
    
    UILabel *label_1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 40)];
    label_1.backgroundColor = [UIColor whiteColor];
    label_1.textAlignment = NSTextAlignmentLeft;
    label_1.font = [UIFont systemFontOfSize:14];
    label_1.text = @"    付款方式";
    label_1.textColor = COLOR_STRING(@"#222222");
    [balanceView addSubview:label_1];
    
    
    UILabel *label_2 = [[UILabel alloc]initWithFrame:CGRectMake(90, 0, 70, 40)];
    label_2.backgroundColor = [UIColor whiteColor];
    label_2.textAlignment = NSTextAlignmentLeft;
    label_2.font = [UIFont systemFontOfSize:14];
    label_2.text = @"富之富余额";
    label_2.textColor = COLOR_STRING(@"#222222");
    [balanceView addSubview:label_2];
    
    _labelBalance = [[UILabel alloc]initWithFrame:CGRectMake(label_2.right+5, 0, 120, 40)];
    _labelBalance.backgroundColor = [UIColor whiteColor];
    _labelBalance.textAlignment = NSTextAlignmentLeft;
    _labelBalance.font = [UIFont systemFontOfSize:13];
    _labelBalance.textColor = COLOR_STRING(@"#FB1F28");
    [balanceView addSubview:_labelBalance];
    
    UIImageView *accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_ic_enter"]];
    accessoryView.frame = CGRectMake(ScreenWidth-30, 10, 10, 20);
    [balanceView addSubview:accessoryView];
    
    [view addSubview:balanceView];
    
    FPAccountInfoItem *accountItem = [[Config Instance] accountItem];
    if (accountItem) {
        _amount = [accountItem.accountAmount doubleValue];
        _labelBalance.text = [NSString stringWithFormat:@"(￥ %0.2f 可用)",_amount/100];
    }
    
    
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.frame = CGRectMake(20, 160, 280, 40);
    nextButton.top = balanceView.bottom +30;
    [nextButton setBackgroundColor:[UIColor orangeColor]];
    [nextButton setBackgroundImage:MIMAGE(COMM_BTN_BLUE) forState:UIControlStateNormal];
    [nextButton setBackgroundImage:MIMAGE(COMM_BTN_GRAY) forState:UIControlStateDisabled];
    [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    [nextButton addTarget:self action:@selector(click_Next:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:nextButton];
    nextButton.layer.masksToBounds = YES;
    nextButton.layer.cornerRadius = 5;
    self.view = view;

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    self.tabBarController.tabBar.hidden = NO;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"富钱包|充值";
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    self.navigationItem.backBarButtonItem = backItem;
    backItem.title = @"";
    [self getAccountInfo];
    // Do any additional setup after loading the view.
}



- (void)click_Next:(id)sender{
    [self.view endEditing:YES];
    
    NSString *cardNumber = [_cardNo trimOnlySpace];
    if (cardNumber.length < 16) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"警告" message:@"请输入16位卡号!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        
        [alertView show];
       // [self.textFieldCard becomeFirstResponder];
        return;

    }
    
    //转账金额不能为0，不能大于用于实际余额，
    NSString *amt = [self.textFieldRecharge.text trimSpace];
    [self.textFieldRecharge resignFirstResponder];
    if ([amt checkAmt] == NO) {
        [self.textFieldRecharge becomeFirstResponder];
        return;
    }
    amt = [UtilTool decimalNumberMutiplyWithString:amt andValue:kAMT_PROPORTION];
    
    FPAppParams *appParams = [Config Instance].appParams;
    
    if ([amt doubleValue] > self.amount ) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"警告" message:@"余额不足!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        
        [alertView show];
        [self.textFieldRecharge becomeFirstResponder];
        return;
    }
    
    double offlineRgeMinAmount = [appParams.offlineRgeMinAmount doubleValue];
    if([amt doubleValue] < offlineRgeMinAmount) {
        NSString *warnStr = [NSString stringWithFormat:@"最小充值金额为%.2f元",offlineRgeMinAmount/100];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"警告" message:warnStr delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        
        [alertView show];
        [self.textFieldRecharge becomeFirstResponder];
        return;
    }
    
    double offlineRgeMaxAmount = [appParams.offlineRgeMaxAmount doubleValue];
    
    if([amt doubleValue] > offlineRgeMaxAmount) {
        NSString *warnStr = [NSString stringWithFormat:@"最大充值金额为%.2f元",offlineRgeMaxAmount/100];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"警告" message:warnStr delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        
        [alertView show];
        [self.textFieldRecharge becomeFirstResponder];
        return;
    }

    if ([Config Instance].personMember.nameAuthFlag) {
        NSInteger payMax = [appParams.realNamePayMaxAmount integerValue];
        
        if ([amt doubleValue] > payMax) {
            [self.textFieldRecharge becomeFirstResponder];
            NSString *warnStr = [NSString stringWithFormat:@"抱歉！此次支付超出单笔支出限额，单笔最高支付限额为%.2f元",payMax/100.0];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:warnStr delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            
            [alertView show];
            return;
        }
        
    } else {
        NSInteger payMax = [appParams.unRealNamePayMaxAmount integerValue];
        
        if ([amt doubleValue] > payMax) {
            [self.textFieldRecharge becomeFirstResponder];
            NSString *warnStr = [NSString stringWithFormat:@"抱歉！此次支付超出单笔支出限额，单笔最高支付限额为%.2f元",payMax/100.0];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:warnStr delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            
            [alertView show];
            return;
        }
    }
    
    //创建提交订单
    NSInteger limit = [[Config Instance].appParams.noPswAmountLimit integerValue];
    BOOL more = ([amt doubleValue] > limit) ? YES : NO;
    
    FPClient *client = [FPClient sharedClient];
    NSDictionary *paramter = [client rechargeRequestWithCardNo:cardNumber andAmt:amt andMemberNo:[Config Instance].personMember.memberNo];
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    [UtilTool showHUD:@"正在处理" andView:self.view andHUD:hud];

    [client POST:kFPPost parameters:paramter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [hud hide:YES];
        if ([[responseObject objectForKey:@"result"] boolValue] == YES) {
            NSDictionary *returnObj = [responseObject objectForKey:@"returnObj"];
            NSString *tradeNo = [returnObj objectForKey:@"tradeNo"];
            
            NSMutableDictionary *paramter = [NSMutableDictionary dictionary];
            [paramter setObject:tradeNo forKey:@"fullWalletRechargeTradeNo"];
            [paramter setObject:amt forKey:@"fullWalletRechargeAmt"];
            
            [self createPositiveViewWithPayMoreThanLimt:more andParamter:paramter];
            
        }else{
            NSString *errInfo = [responseObject objectForKey:@"errorInfo"];
            UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"创建订单失败!" message:errInfo delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
            alter.tag = 101;
            [alter setContentMode:UIViewContentModeCenter];
            [alter show];
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [hud hide:YES];

        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"网络连接失败,请查看网络是否连接正常！" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }];
}

- (void)createPositiveViewWithPayMoreThanLimt:(BOOL)more andParamter:(NSDictionary *)paramter{
    
    FPPositivePayView *temp = nil;
    BOOL pass = [Config Instance].personMember.noPswLimitOn;
    if (pass && !more) {
        temp = [[FPPositivePayView alloc]initWithFullWalletTypeWithParamters:paramter andHasPass:NO];
    }else{
        temp = [[FPPositivePayView alloc]initWithFullWalletTypeWithParamters:paramter andHasPass:YES];
    }
    temp.delegate = self;
    temp.hidden = NO;
    
    _positivePayView = temp;
    [self.tabBarController.view addSubview:_positivePayView];
    
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 101) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark FPPositivePayViewDelegate 
- (void)positivePayViewHasPayAwayWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        
        FPWalletRechargeSucceeController *controller = [[FPWalletRechargeSucceeController alloc]init];
        [self.navigationController pushViewController:controller animated:YES];
        
    }else if(buttonIndex == 1){
        NSArray *controllers = self.navigationController.viewControllers;
        if (controllers.count>=2) {
            [self.navigationController popToViewController:controllers[1] animated:YES];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

#pragma mark---FPTextFieldDelegate
-(void)clickDone:(FPTextField *)sender{
    if (sender == _textFieldCard) {
        _cardNo = sender.text;
        [UtilTool saveFullWalletCardNo:_cardNo];
    }
}

#pragma mark - delegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (![string checkNumber]) {
        return YES;
    }
    if (textField != _textFieldCard) {
        return YES;
    }
    
    NSMutableString *temp = [NSMutableString stringWithString:textField.text];
    [temp insertString:string atIndex:range.location];
    
    NSString *tempStr = [temp trimOnlySpace];
    NSMutableString *text = [NSMutableString stringWithString:tempStr];
    
    int rem = tempStr.length%4;
    int con = (int)tempStr.length/4;
    if (rem == 0) {
        con = con -1;
    }
    for (int i=1; i<=con; i++) {
        [text insertString:@" " atIndex:(4*i+(i-1))];
    }
    if(text.length>=19){
        
        [textField setText:[text substringToIndex:19]];
        [textField resignFirstResponder];
        
        return NO;
        
    }
    textField.text = text;
    
    [textField setBankCardTextFieldCursorWithRange:range];
    
    return NO;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == _textFieldCard) {
        NSString *card = textField.text;
        if (card.length > 19){
            card = [card substringToIndex:19];
        }
        textField.text = card;
        if (card.length == 0) {
            card = @"";
        }
        [UtilTool saveFullWalletCardNo:card];
    }
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
                self.amount = amount;
                _labelBalance.text = [NSString stringWithFormat:@"(￥ %0.2f 可用)",amount/100];
            }
        }
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
