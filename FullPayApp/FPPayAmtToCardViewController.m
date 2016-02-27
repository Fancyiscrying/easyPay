//
//  FPPayAmtToCardViewController.m
//  FullPayApp
//
//  Created by 刘通超 on 15/3/20.
//  Copyright (c) 2015年 fullpay. All rights reserved.
//

#import "FPPayAmtToCardViewController.h"
#import "AccountCell.h"
#import "LeftTitleTextField.h"

@interface FPPayAmtToCardViewController ()<FPPositivePayViewDelegate,UITextFieldDelegate>
@property (nonatomic,strong) UILabel *labelBalance;
@property (nonatomic,strong) LeftTitleTextField *payMoney;
@property (nonatomic,strong) AccountCell *withdrawFree;
@property (nonatomic,strong) UIButton *nextButton;

@property (nonatomic,assign) double feeAmtFen;//单位为分
@end

@implementation FPPayAmtToCardViewController
- (void)loadView{
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    self.view = view;
    
    [self createCoustomView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getAccountInfo];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"转账确认";
    self.view.backgroundColor = COLOR_STRING(@"#F3F3F3");
    // Do any additional setup after loading the view.
}

- (void)createCoustomView{
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, 200, 20)];
    label1.backgroundColor = ClearColor;
    label1.textColor = COLOR_STRING(@"#686868");
    label1.font = SystemFontSize(14);
    label1.text = @"收款银行卡";
    [self.view addSubview:label1];
    
    AccountCell *cardNum = [[AccountCell alloc]initWithFrame:CGRectMake(15, label1.bottom+10, ScreenWidth-30, 35)];
    cardNum.backgroundColor = COLOR_STRING(@"#FFFFFF");
    cardNum.textColor = COLOR_STRING(@"#686868");
    cardNum.leftStringColor = COLOR_STRING(@"#000000");
    cardNum.leftString = @"卡号";
    cardNum.rightString = [[_bankCard objectForKey:@"bankcardNo"] formateCardNo];
    cardNum.fontSize = SystemFontSize(14);
    cardNum.widthToSide = 15;
    cardNum.rightStringLeft = 70;
    [self.view addSubview:cardNum];
    
    AccountCell *bankName = [[AccountCell alloc]initWithFrame:CGRectMake(15, cardNum.bottom+1, ScreenWidth-30, 35)];
    bankName.backgroundColor = COLOR_STRING(@"#FFFFFF");
    bankName.textColor = COLOR_STRING(@"#686868");
    bankName.leftStringColor = COLOR_STRING(@"#000000");
    bankName.leftString = @"银行";
    bankName.rightString = [_bankCard objectForKey:@"bankName"];
    bankName.fontSize = SystemFontSize(14);
    bankName.widthToSide = 15;
    bankName.rightStringLeft = 70;
    [self.view addSubview:bankName];
    
    AccountCell *userName = [[AccountCell alloc]initWithFrame:CGRectMake(15, bankName.bottom+1, ScreenWidth-30, 35)];
    userName.backgroundColor = COLOR_STRING(@"#FFFFFF");
    userName.textColor = COLOR_STRING(@"#686868");
    userName.leftStringColor = COLOR_STRING(@"#000000");
    userName.leftString = @"姓名";
    userName.rightString = [_bankCard objectForKey:@"memberName"];
    userName.fontSize = SystemFontSize(14);
    userName.widthToSide = 15;
    userName.rightStringLeft = 70;
    [self.view addSubview:userName];
    
    _payMoney = [[LeftTitleTextField alloc]initWithFrame:CGRectMake(15, userName.bottom+1, ScreenWidth-30, 35)];
    _payMoney.backgroundColor = COLOR_STRING(@"#ffffff");
    [_payMoney setTextLeft:70];
    [_payMoney setLeftTitle:@"金额"];
    _payMoney.leftLabel.font = SystemFontSize(14);
    _payMoney.leftLabel.textColor = COLOR_STRING(@"#000000");
    _payMoney.keyboardType = UIKeyboardTypeDecimalPad;
    _payMoney.textColor = COLOR_STRING(@"#686868");
    _payMoney.font =SystemFontSize(14);
    _payMoney.delegate = self;
    [self.view addSubview:_payMoney];
    
    int  realNamePayMaxAmount = [[Config Instance].appParams.realNamePayMaxAmount intValue]/100;
    int  realNamePayAmountLimit = [[Config Instance].appParams.realNamePayAmountLimit intValue]/100;
    _payMoney.placeholder = [NSString stringWithFormat:@"单笔限额%d 每日累计限额%d",realNamePayMaxAmount,realNamePayAmountLimit];
    
    _withdrawFree = [[AccountCell alloc]initWithFrame:CGRectMake(15, _payMoney.bottom+1, ScreenWidth-30, 35)];
    _withdrawFree.backgroundColor = COLOR_STRING(@"#FFFFFF");
    _withdrawFree.textColor = COLOR_STRING(@"#686868");
    _withdrawFree.leftStringColor = COLOR_STRING(@"#000000");
    _withdrawFree.leftString = @"手续费";
    _withdrawFree.rightString = @"0.00";
    _withdrawFree.fontSize = SystemFontSize(14);
    _withdrawFree.widthToSide = 15;
    _withdrawFree.rightStringLeft = 70;
    [self.view addSubview:_withdrawFree];
    
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(15, _withdrawFree.bottom+20, 200, 20)];
    label2.backgroundColor = ClearColor;
    label2.textColor = COLOR_STRING(@"#686868");
    label2.font = SystemFontSize(14);
    label2.text = @"付款方式";
    [self.view addSubview:label2];
    
    AccountCell *payType = [[AccountCell alloc]initWithFrame:CGRectMake(15, label2.bottom+10, ScreenWidth-30, 35)];
    payType.backgroundColor = COLOR_STRING(@"#FFFFFF");
    payType.textColor = COLOR_STRING(@"#686868");
    payType.leftStringColor = COLOR_STRING(@"#000000");
    payType.leftString = @"富之富余额";
    payType.fontSize = SystemFontSize(14);
    payType.widthToSide = 15;
    payType.rightStringLeft = 70;
    [self.view addSubview:payType];
    
    UIImageView *accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_ic_enter"]];
    accessoryView.frame = CGRectMake(payType.width-20, 12.5, 10, 10);
    [payType addSubview:accessoryView];
    
    _labelBalance = [[UILabel alloc]initWithFrame:CGRectMake(30, payType.bottom+5, ScreenWidth-45, 20)];
    _labelBalance.backgroundColor = ClearColor;
    _labelBalance.textAlignment = NSTextAlignmentLeft;
    _labelBalance.font = [UIFont systemFontOfSize:14];
    _labelBalance.textColor = COLOR_STRING(@"#686868");
    _labelBalance.text = @"可用余额 0.00元";
    [self.view addSubview:_labelBalance];
    
    UILabel *tips = [[UILabel alloc]initWithFrame:CGRectMake(30, _labelBalance.bottom, ScreenWidth-45, 20)];
    tips.backgroundColor = ClearColor;
    tips.textAlignment = NSTextAlignmentLeft;
    tips.font = [UIFont systemFontOfSize:14];
    tips.textColor = COLOR_STRING(@"#686868");
    tips.text = @"到账时间:下个工作日23:59前到账";
    [self.view addSubview:tips];
    
    _nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _nextButton.frame = CGRectMake(15, tips.bottom +20, ScreenWidth-30, 40);
    [_nextButton setBackgroundImage:MIMAGE(COMM_BTN_YELL) forState:UIControlStateNormal];
    [_nextButton setBackgroundImage:MIMAGE(COMM_BTN_GRAY) forState:UIControlStateDisabled];
    [_nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [_nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_nextButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    [_nextButton addTarget:self action:@selector(click_Next:) forControlEvents:UIControlEventTouchUpInside];
    _nextButton.enabled = NO;
    [self.view addSubview:_nextButton];
    
}

- (void)click_Next:(UIButton *)sender{
    
    //个人最小提现金额
    double withdrawFee = [[Config Instance].appParams.withdrawMinAmt doubleValue];
    double amount = [[_payMoney.text transformYuanToCents] doubleValue];
    if (amount < withdrawFee) {
        NSString *message = [NSString stringWithFormat:@"最小提现金额 %0.0f 元",withdrawFee/100];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:message message:nil delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        
        return;
        
    }
    
    //转账所需金额（转账金额+手续费）
    double amt = _feeAmtFen + amount;
    
    double accountAmount = [[Config Instance].accountItem.accountAmount doubleValue];
    if (amt > accountAmount) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"转账金额大于可用余额!" message:nil delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        
        return;
        
    }
    
    if ([Config Instance].personMember.nameAuthFlag) {
        NSInteger payMax = [[Config Instance].appParams.realNamePayMaxAmount integerValue];
        
        if (amt > payMax) {
            NSString *warnStr = [NSString stringWithFormat:@"抱歉！此次支付超出单笔支出限额，单笔最高支付限额为%.2f元",payMax/100.0];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:warnStr delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            
            [alertView show];
            return;
        }
        
    } else {
        NSInteger payMax = [[Config Instance].appParams.unRealNamePayMaxAmount integerValue];
        
        if (amt > payMax) {
            NSString *warnStr = [NSString stringWithFormat:@"抱歉！此次支付超出单笔支出限额，单笔最高支付限额为%.2f元",payMax/100.0];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:warnStr delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            
            [alertView show];
            return;
        }
    }
    
    
    //创建提交订单
    NSString *title = [NSString stringWithFormat:@"转账至 %@ %@（%@）",[_bankCard objectForKey:@"memberName"],[_bankCard objectForKey:@"bankName"],[_bankCard objectForKey:@"bankcardNoLastFour"]];
    
    NSDictionary *paramters = [NSDictionary dictionaryWithObjectsAndKeys:[_payMoney.text transformYuanToCents],@"withdrawAmt",[_bankCard objectForKey:@"id"],@"withdrawBankCardId",title,@"withdrawTitle", nil];
    [self createPositiveViewWith:paramters andMoreThanLimt:YES];
    
}

#pragma create pay view
- (void)createPositiveViewWith:(NSDictionary *)paramters andMoreThanLimt:(BOOL)more{
    
    BOOL pass = [Config Instance].personMember.noPswLimitOn;
    FPPositivePayView *payView = nil;
    if (pass && !more) {
        payView = [[FPPositivePayView alloc]initWithWithdrawTypeWithParamters:paramters andHasPass:NO];
    }else{
        payView = [[FPPositivePayView alloc]initWithWithdrawTypeWithParamters:paramters andHasPass:YES];
    }
    
    payView.hidden = NO;
    payView.delegate = self;
    [self.tabBarController.view addSubview:payView];
}

#pragma mark FPPositivePayViewDelegate
- (void)positivePayViewHasPayAway{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)positivePayViewHasPayAwayWithButtonIndex:(NSInteger)buttonIndex{


}

#pragma mark UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    float bottom = _payMoney.bottom;
    float temp = ScreenHigh-bottom;
    if (temp-216-120 < 0) {
        [self setViewTranfromWithY:temp-216-120];
    }

}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    double money = [textField.text doubleValue]*100;
    _nextButton.enabled = (money>=1) ? YES : NO;
    textField.text = [NSString stringWithFormat:@"%.2f",(double)money/100
                      ];
    
    if (money>1) {
        double free = [[Config Instance].appParams.withdrawFee doubleValue];
        NSString *feeMode = [Config Instance].appParams.withdrawFeeMode;
        if ([feeMode isEqualToString:@"COUNT"]) {
            _withdrawFree.rightString = [NSString stringWithFormat:@"%.2f",free/100
                                         ];
            _feeAmtFen = free;
        }else if([feeMode isEqualToString:@"RATE"]){
            double rateFree = money*free/100;
            double maxFeeAmt = [[Config Instance].appParams.withdrawMaxFeeAmt doubleValue]/100;
            if (rateFree > maxFeeAmt) {
                _withdrawFree.rightString = [NSString stringWithFormat:@"%.2f",maxFeeAmt];
                _feeAmtFen = [[Config Instance].appParams.withdrawMaxFeeAmt doubleValue];

            }else{
                _withdrawFree.rightString = [NSString stringWithFormat:@"%.2f",rateFree];
                _feeAmtFen = money*free;
            }
        }
    }else{
        _withdrawFree.rightString = @"0.00";
        _feeAmtFen = 0;
    }
    
    
    [self setViewTranfromWithY:0];


}

- (void)setViewTranfromWithY:(CGFloat)Y{
    CGAffineTransform transFormY = CGAffineTransformMakeTranslation(0, Y);
    [UIView animateWithDuration:0.3 animations:^{
        self.view.transform = transFormY;
        
    }];
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
                _labelBalance.attributedText = [[NSString stringWithFormat:@"可用余额 %.2f 元",[cardInfo.accountItem.accountAmount doubleValue]/100] transformNumberColorOfString:[UIColor orangeColor]];
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
