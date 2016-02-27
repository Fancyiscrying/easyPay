//
//  FPDispatchRedPacketViewController.m
//  FullPayApp
//
//  Created by 刘通超 on 14/12/1.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPDispatchRedPacketViewController.h"
#import "FPDispatch2DCodeViewController.h"
#import "FPTextField.h"

#define redPacketDefaultRemark @"输入祝福语（最多80字）"

@interface FPDispatchRedPacketViewController ()<UITextFieldDelegate,UITextViewDelegate,FPPositivePayViewDelegate>{
    double _amount;
}
@property (nonatomic ,strong)FPTextField *redPacketNumber;
@property (nonatomic ,strong)FPTextField *redPacketMoney;
@property (nonatomic ,strong)FPTextView *redPacketRemark;
@property (nonatomic ,strong)UILabel *needMoney;

@property (nonatomic, copy)NSString *distributeId;


@end

@implementation FPDispatchRedPacketViewController

- (void)loadView{
    UIView *view = [[UIView alloc]initWithFrame:ScreenBounds];
    UIImageView *background = [[UIImageView alloc] initWithFrame:view.bounds];
    background.image = [UIImage imageNamed:@"BG"];
    [view addSubview:background];
    self.view = view;
    
    [self installCoustomView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"富之富-红包";
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    self.navigationItem.backBarButtonItem = backItem;
    backItem.title = @"";
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
    
    [self getAccountInfo];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    self.tabBarController.tabBar.hidden = NO;
}

- (void)installCoustomView{
    //UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth * 20/320, ScreenWidth * 20/320, ScreenWidth-(2*ScreenWidth * 20/320), ScreenWidth-(2*ScreenWidth * 20/320))];
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(10,10, ScreenWidth-20,ScreenHigh-20-64)];
    image.layer.masksToBounds = YES;
    image.layer.cornerRadius = 5;
    image.userInteractionEnabled = YES;
    image.backgroundColor = COLOR_STRING(@"#FF5B5C");
    
    UILabel *number = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, image.width-40, 40)];
    number.backgroundColor = [UIColor whiteColor];
    number.layer.masksToBounds = YES;
    number.layer.cornerRadius = 5;
    number.textAlignment= NSTextAlignmentLeft;
    number.font = [UIFont systemFontOfSize:14];
    number.text = @"  发多少个红包 :";
    number.userInteractionEnabled = YES;
    number.textColor = [UIColor grayColor];
    [image addSubview:number];
    
    _redPacketNumber = [[FPTextField alloc] initWithNoRectOffsetFrame:CGRectMake(100, 0, number.width-100, 40)];
   // _redPacketNumber.placeholder = @"发多少个红包";
    _redPacketNumber.textColor = COLOR_STRING(@"#FF5B5C");
    _redPacketNumber.textAlignment = NSTextAlignmentLeft;
    _redPacketNumber.font = [UIFont systemFontOfSize:14];
    _redPacketNumber.backgroundColor = [UIColor whiteColor];
    _redPacketNumber.clearButtonMode = UITextFieldViewModeWhileEditing;
    _redPacketNumber.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _redPacketNumber.keyboardType = UIKeyboardTypeNumberPad;
    _redPacketNumber.delegate = self;
 
    [number addSubview:_redPacketNumber];
    
    UILabel *money = [[UILabel alloc]initWithFrame:CGRectMake(number.left, number.bottom+10, number.width, 40)];
    money.backgroundColor = [UIColor whiteColor];
    money.layer.masksToBounds = YES;
    money.layer.cornerRadius = 5;
    money.textAlignment= NSTextAlignmentLeft;
    money.font = [UIFont systemFontOfSize:14];
    money.text = @"  红包封多少钱 :";
    money.textColor = [UIColor grayColor];
    money.userInteractionEnabled = YES;
    [image addSubview:money];
    
    _redPacketMoney = [[FPTextField alloc] initWithNoRectOffsetFrame:CGRectMake(100, 0, number.width-100, 40)];
    //_redPacketMoney.placeholder = @"每个红包封多少钱";
    _redPacketMoney.textColor = COLOR_STRING(@"#FF5B5C");
    _redPacketMoney.textAlignment = NSTextAlignmentLeft;
    _redPacketMoney.font = [UIFont systemFontOfSize:14];
    _redPacketMoney.backgroundColor = [UIColor whiteColor];
    _redPacketMoney.clearButtonMode = UITextFieldViewModeWhileEditing;
    _redPacketMoney.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _redPacketMoney.keyboardType = UIKeyboardTypeDecimalPad;
    _redPacketMoney.delegate = self;
    _redPacketMoney.layer.masksToBounds = YES;
    _redPacketMoney.layer.cornerRadius = 5;
    [money addSubview:_redPacketMoney];
    
    _redPacketRemark = [[FPTextView alloc] initWithFrame:CGRectMake(money.left, money.bottom+10, money.width, 100)];
    _redPacketRemark.text = redPacketDefaultRemark;
    _redPacketRemark.font = [UIFont systemFontOfSize:15];
    _redPacketRemark.textAlignment = NSTextAlignmentLeft;
    _redPacketRemark.backgroundColor = [UIColor whiteColor];
    _redPacketRemark.keyboardType = UIKeyboardTypeDefault;
    _redPacketRemark.textColor  = [UIColor lightGrayColor];
    _redPacketRemark.delegate = self;
    _redPacketRemark.layer.masksToBounds = YES;
    _redPacketRemark.layer.cornerRadius = 5;
    [image addSubview:_redPacketRemark];
    
    UILabel *remark = [[UILabel alloc]initWithFrame:CGRectMake(0, _redPacketRemark.bottom+30, 200, 20)];
    remark.right = _redPacketRemark.right;
    remark.text = @"需支付金额";
    remark.textColor = [UIColor yellowColor];
    remark.backgroundColor = [UIColor clearColor];
    remark.textAlignment = NSTextAlignmentRight;
    [image addSubview:remark];
    
    _needMoney = [[UILabel alloc]initWithFrame:CGRectMake(0, remark.bottom+5, 200, 20)];
    _needMoney.right = _redPacketRemark.right;
    _needMoney.text = @"0.00";
    _needMoney.textColor = [UIColor whiteColor];
    _needMoney.backgroundColor = [UIColor clearColor];
    _needMoney.textAlignment = NSTextAlignmentRight;
    _needMoney.font = [UIFont boldSystemFontOfSize:20];
    [image addSubview:_needMoney];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(number.left, _needMoney.bottom+10, number.width, 40);
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    button.backgroundColor = [UIColor yellowColor];
    [button setTitle:@"塞钱进红包" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:13];
    
    [button addTarget:self action:@selector(tapButtonPay) forControlEvents:UIControlEventTouchUpInside];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 5;
    [image addSubview:button];
        
    [self.view addSubview:image];
    
    
}
- (void)tapButtonPay{
    NSString *number = _redPacketNumber.text;
    if (number.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请填写红包个数!" message:nil delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        
        return;
    }
    NSString *money = _redPacketMoney.text;
    if (money.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请填写红包钱数!" message:nil delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        
        return;
    }
    NSString *remark = [_redPacketRemark.text trimOnlySpace];
    if (remark.length == 0 ||[remark isEqualToString:redPacketDefaultRemark]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请填写祝福语!" message:nil delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        
        return;
    }
    
    double accountAmount = [[Config Instance].accountItem.accountAmount doubleValue];
    double amount = [[_needMoney.text transformYuanToCents] doubleValue];
    if (amount>accountAmount) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"红包总金额大于可用余额!" message:nil delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        
        return;

    }
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    [UtilTool showHUD:@"正在处理" andView:self.view andHUD:hud];
    FPClient *client = [FPClient sharedClient];
    NSDictionary *paramters = [client distributeWithMemberNo:[Config Instance].personMember.memberNo andTotalCount:_redPacketNumber.text andAmt:[_redPacketMoney.text transformYuanToCents] andAddRemark:remark];
    [client POST:kFPPost parameters:paramters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [hud hide:YES];
        if ([[responseObject objectForKey:@"result"] boolValue] == YES) {
            NSDictionary *returnObj = [responseObject objectForKey:@"returnObj"];
            NSString *distributeId = [returnObj objectForKey:@"distributeId"];
            NSString *redPacktePayMoney = _needMoney.text;
            if (distributeId.length>0 && redPacktePayMoney.length>0) {
                //记录  distributeId;
                _distributeId = distributeId;
                
                //创建提交订单
                NSInteger limit = [[Config Instance].appParams.noPswAmountLimit integerValue];
                NSInteger usepay = [[redPacktePayMoney transformYuanToCents] integerValue];
                BOOL more = (usepay > limit) ? YES : NO;
                
                NSDictionary *paramters = [NSDictionary dictionaryWithObjectsAndKeys:distributeId,@"redPacktePayId",redPacktePayMoney,@"redPacktePayMoney", nil];
                [self createPositiveViewWith:paramters andMoreThanLimt:more];
            }
        }else{
            NSString *errInfo = [responseObject objectForKey:@"errorInfo"];
            UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"创建红包失败!" message:errInfo delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
            
            [alter setContentMode:UIViewContentModeCenter];
            [alter show];
            
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [hud hide:YES];
        FPDEBUG(@"%@",error);
        [self showToastMessage:kNetworkErrorMessage];

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
            }
        }
    }];
    
}
#pragma mark FPPositivePayViewDelegate
- (void)positivePayViewHasPayAway{
    FPDispatch2DCodeViewController *controller = [[FPDispatch2DCodeViewController alloc]init];
    controller.currentRePacketId = _distributeId;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma createview
- (void)createPositiveViewWith:(NSDictionary *)paramters andMoreThanLimt:(BOOL)more{
    
    BOOL pass = [Config Instance].personMember.noPswLimitOn;
    FPPositivePayView *payView = nil;
    if (pass && !more) {
        payView = [[FPPositivePayView alloc]initWithRedPackteTypeWithParamters:paramters andHasPass:NO];
    }else{
        payView = [[FPPositivePayView alloc]initWithRedPackteTypeWithParamters:paramters andHasPass:YES];
    }

    payView.hidden = NO;
    payView.delegate = self;
    [self.tabBarController.view addSubview:payView];
}
#pragma mark UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{

}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSString *number = self.redPacketNumber.text;
    NSString *money = self.redPacketMoney.text;
    
    if (number.length>0 && money.length>0) {
        float intNumber = [number intValue];
        int intMoney = [money doubleValue]*100;
        
        if (intMoney>0) {
            self.needMoney.text = [NSString stringWithFormat:@"%.2f",intMoney*intNumber/100
                                   ];
            self.redPacketMoney.text = [NSString stringWithFormat:@"%.2f",intMoney/100.00
                                   ];
        }else{
            self.needMoney.text = [NSString stringWithFormat:@"%.2f",0.00
                                   ];
            self.redPacketMoney.text = @"0";
        }
    }else{
        self.needMoney.text = @"0.00";
    }
}

- (void)setViewTranfromWithY:(CGFloat)Y{
    CGAffineTransform transFormY = CGAffineTransformMakeTranslation(0, Y);
    [UIView animateWithDuration:0.3 animations:^{
        self.view.transform = transFormY;
        
    }];
}

#pragma mark UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView{
    
    float bottom = _redPacketRemark.bottom+10;
    float temp = ScreenHigh-64 - bottom;
    if (temp-216-70 < 0) {
        [self setViewTranfromWithY:temp-216-70];
    }

    if (textView == self.redPacketRemark) {
        if ([textView.text isEqualToString:redPacketDefaultRemark]) {
            textView.text = @"";
            textView.textColor = COLOR_STRING(@"#FF5B5C");
        }
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    if (textView == self.redPacketRemark) {
        
        [self setViewTranfromWithY:0];

        NSString *text = textView.text;
        if (text.length > 80) {
            text = [text substringToIndex:80];
            textView.text = text;
        }else if (text.length == 0){
            textView.text = redPacketDefaultRemark;
            textView.textColor = [UIColor lightGrayColor];
        }
    }
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
