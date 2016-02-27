//
//  FPDimScanPayViewController.m
//  FullPayApp
//
//  Created by 刘通超 on 14/11/26.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPDimScanPayViewController.h"
#import "FPTextField.h"
#import "FPPersonMember.h"
#import "UIImageView+AFNetworking.h"

@interface FPDimScanPayViewController ()<FPTextFieldDelegate,UITextFieldDelegate,FPPositivePayViewDelegate>{
    double _amount;
}

@property (nonatomic, strong) UIImageView *personImage;
@property (nonatomic, strong) UILabel *lbl_Balance;
@property (nonatomic, strong) UIButton *btn_NextStep;
@property (nonatomic, strong) FPTextField *fld_PayAmt;
@property (nonatomic, strong) FPTextField *fld_Remark;
@property (nonatomic, strong) FPPositivePayView *positivePayView;
@end

@implementation FPDimScanPayViewController

- (void)loadView{
    
    // 注册键盘的监听通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    UIView *view = [[UIView alloc]initWithFrame:ScreenBounds];
    UIImageView *background = [[UIImageView alloc] initWithFrame:view.bounds];
    background.image = [UIImage imageNamed:@"BG"];
    [view addSubview:background];
    
    float width = 70;
    _personImage = [[UIImageView alloc]initWithFrame:CGRectMake((ScreenWidth-width)/2, 20, width, width)];
    _personImage.image = MIMAGE(@"home_head_none.png");
    _personImage.layer.borderColor = [[UIColor whiteColor] CGColor];
    _personImage.layer.borderWidth = 1.0f;
    _personImage.layer.cornerRadius = width/2;
    _personImage.layer.masksToBounds = YES;
    [view addSubview:_personImage];
    
    UILabel *lbl_person = [[UILabel alloc]initWithFrame:CGRectMake(0, _personImage.bottom+10, ScreenWidth, 30)];
    lbl_person.textAlignment = NSTextAlignmentCenter;
    lbl_person.backgroundColor = [UIColor clearColor];
    
    NSString *memberName = _transferData.toMemberName;
    if (![memberName isEqualToString:@"未实名用户"] &&  memberName.length>=1) {
        memberName = [NSString stringWithFormat:@"*%@",[memberName substringFromIndex:1]];
    }
    lbl_person.text = [NSString stringWithFormat:@"%@  %@",memberName,_transferData.toMemberPhone];
    [view addSubview:lbl_person];
    
    UIView *payAmount = [[UIView alloc]initWithFrame:CGRectMake(0, lbl_person.bottom+20, ScreenWidth, 40)];
    payAmount.backgroundColor = [UIColor whiteColor];
    
    RTStarLabel *starLable = [[RTStarLabel alloc]initWithFrame:CGRectMake(25, 0, 40, payAmount.height) andText:@"金额" andTextColor:[UIColor blackColor]];
    [payAmount addSubview:starLable];
    
    _fld_PayAmt = [[FPTextField alloc] initWithFrame:CGRectMake(starLable.width, 0, ScreenWidth-starLable.width, payAmount.height)];
    _fld_PayAmt.placeholder = @"￥ 0.00";
    _fld_PayAmt.backgroundColor = [UIColor whiteColor];
    _fld_PayAmt.clearButtonMode = UITextFieldViewModeWhileEditing;
    _fld_PayAmt.keyboardType = UIKeyboardTypeDecimalPad;
    _fld_PayAmt.delegate = self;
    [payAmount addSubview:_fld_PayAmt];
    [payAmount bringSubviewToFront:starLable];
    
    [view addSubview:payAmount];
    
    UILabel *banlance = [[UILabel alloc] initWithFrame:CGRectMake(30, payAmount.bottom+10, 60, 21)];
    banlance.textColor = [UIColor darkGrayColor];
    banlance.textAlignment = NSTextAlignmentLeft;
    banlance.font = [UIFont systemFontOfSize:12.0f];
    banlance.text = @"可用余额";
    [view addSubview:banlance];
    
    self.lbl_Balance = [[UILabel alloc] initWithFrame:CGRectMake(100, banlance.top, 100, 21)];
    self.lbl_Balance.textColor = [UIColor orangeColor];
    self.lbl_Balance.textAlignment = NSTextAlignmentLeft;
    self.lbl_Balance.font = [UIFont systemFontOfSize:12.0f];
    self.lbl_Balance.text = @"可用余额 0.00";
    [view addSubview:self.lbl_Balance];
    
    FPAccountInfoItem *accountItem = [[Config Instance] accountItem];
    if (accountItem) {
        _amount = [accountItem.accountAmount doubleValue];
        
        self.lbl_Balance.text = [NSString stringWithFormat:@"%0.2f",_amount/100];
    }
    
    
    UIView *remark = [[UIView alloc]initWithFrame:CGRectMake(0, self.lbl_Balance.bottom+10, ScreenWidth, 40)];
    remark.backgroundColor = [UIColor whiteColor];
    
    self.fld_Remark = [[FPTextField alloc] initWithFrame:remark.bounds];
    self.fld_Remark.placeholder = @"10个字以内";
    self.fld_Remark.backgroundColor = [UIColor whiteColor];
    self.fld_Remark.delegate = self;
    self.fld_Remark.left = 50;
    [remark addSubview:self.fld_Remark];
    
    UILabel *message = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, 80, 30)];
    message.text = @"留言(可不填)";
    message.font = [UIFont systemFontOfSize:14];
    [remark addSubview:message];
    
    [view addSubview:remark];
    
    
    self.btn_NextStep = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btn_NextStep.frame = CGRectMake(30, remark.bottom+40, ScreenWidth-60, 40);
    [self.btn_NextStep setTitle:@"下一步" forState:UIControlStateNormal];
    [self.btn_NextStep setBackgroundImage:MIMAGE(COMM_BTN_YELL) forState:UIControlStateNormal];
    [self.btn_NextStep setBackgroundImage:MIMAGE(COMM_BTN_GRAY) forState:UIControlStateDisabled];
    [self.btn_NextStep addTarget:self action:@selector(click_NextStep:) forControlEvents:UIControlEventTouchUpInside];
    self.btn_NextStep.enabled = NO;
    [view addSubview:self.btn_NextStep];
    
    self.view = view;
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


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"给TA付款";
    
    [self checkPersonByPhoneNumber:_transferData.toMemberPhone];
    // Do any additional setup after loading the view.
}

- (void)click_NextStep:(id)sender{
    [self.view endEditing:YES];
    
    if ([self.transferData.toMemberPhone checkTel] == NO) {
        [self.fld_PayAmt becomeFirstResponder];
        return;
    }
    
    //转账金额不能为0，不能大于用于实际余额，
    NSString *amt = [self.fld_PayAmt.text trimSpace];
    [self.fld_PayAmt resignFirstResponder];
    if ([amt checkAmt] == NO) {
        [self.fld_PayAmt becomeFirstResponder];
        return;
    }
    self.transferData.toAmount = [UtilTool decimalNumberMutiplyWithString:amt andValue:kAMT_PROPORTION];

    if ([self.transferData.toAmount doubleValue] > _amount ) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"警告" message:@"转账金额大于可用余额!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        
        [alertView show];
        [self.fld_PayAmt becomeFirstResponder];
        return;
    } else if([self.transferData.toAmount doubleValue] <= 0.0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"警告" message:@"转账金额必须大于零!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        
        [alertView show];
        [self.fld_PayAmt becomeFirstResponder];
        return;
    }
    
    NSInteger userPay = [self.transferData.toAmount integerValue];
    if ([Config Instance].personMember.nameAuthFlag) {
        NSInteger payMax = [[Config Instance].appParams.realNamePayMaxAmount integerValue];
        
        if (userPay > payMax) {
            [self.fld_PayAmt becomeFirstResponder];
            NSString *warnStr = [NSString stringWithFormat:@"抱歉！此次支付超出单笔支出限额，单笔最高支付限额为%.2f元",payMax/100.0];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:warnStr delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            
            [alertView show];
            return;
        }
        
    } else {
        NSInteger payMax = [[Config Instance].appParams.unRealNamePayMaxAmount integerValue];
        
        if (userPay > payMax) {
            [self.fld_PayAmt becomeFirstResponder];
            NSString *warnStr = [NSString stringWithFormat:@"抱歉！此次支付超出单笔支出限额，单笔最高支付限额为%.2f元",payMax/100.0];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:warnStr delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            
            [alertView show];
            return;
        }
    }
    
    NSString *remarkStr = [self.fld_Remark.text trimSpace];
    self.transferData.toRemark = remarkStr.length > 0 ? remarkStr : @"";
    self.transferData.fromMemberNo = [Config Instance].personMember.memberNo;
    
    //创建提交订单
    NSInteger limit = [[Config Instance].appParams.noPswAmountLimit integerValue];
    BOOL more = (userPay > limit) ? YES : NO;
    
    [self createPositiveViewWithPayMoreThanLimt:more];
    _positivePayView.transferData = self.transferData;
    _positivePayView.hidden = NO;
    
}

- (void)createPositiveViewWithPayMoreThanLimt:(BOOL)more{
    FPPositivePayView *temp = nil;
    BOOL pass = [Config Instance].personMember.noPswLimitOn;
    if (pass && !more) {
        temp = [[FPPositivePayView alloc]initWithInputPassWordView:NO andWithRemark:NO];
    }else{
        temp = [[FPPositivePayView alloc]initWithInputPassWordView:YES andWithRemark:NO];
    }
    temp.delegate = self;
    temp.hidden = NO;
    _positivePayView = temp;
    [self.tabBarController.view addSubview:_positivePayView];
    
}

- (void)checkPersonByPhoneNumber:(NSString *)phoneNumber {
    
    NSString *mobileNumber = [[Config Instance] personMember].mobile;
    if ([phoneNumber isEqualToString:mobileNumber]) {
        
        UIAlertView *alter = [[UIAlertView alloc]initWithTitle:nil message:@"收款方账号不能等于付款方账号!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alter.tag = 200;
        [alter setContentMode:UIViewContentModeCenter];
        [alter show];
        
        return;
    }
    
    FPClient *urlClient = [FPClient sharedClient];
    NSDictionary *parameters = [urlClient userInformation:phoneNumber];
    
    [urlClient POST:kFPPost parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        if ([[responseObject objectForKey:@"result"] boolValue] == YES) {
            NSDictionary *object = [responseObject objectForKey:@"returnObj"];
            NSLog(@"%@",object);
            
            FPPersonMember *personInfo =[[FPPersonMember alloc] initWithAttributes:object];
            self.transferData.toMemberNo = personInfo.memberNo;
            self.transferData.toMemberPhone = phoneNumber;
            self.transferData.toMemberAvator = personInfo.headAddress;
        
            NSString *imageUrl = @"";
            if (personInfo.headAddress != nil && personInfo.headAddress.length > 0) {
                imageUrl = [NSString stringWithFormat:@"%@%@%@",[FPClient ServerAddress],kHEADIMGPATH,personInfo.headAddress];
                [_personImage setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:MIMAGE(@"home_head_none.png")];
            }
            
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [[Config Instance] setAutoLogin:NO];
//        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"网络连接失败,请查看网络是否连接正常！" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alert show];
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
                double amount = [cardInfo.accountItem.accountAmount doubleValue];
                _amount = amount;
                self.lbl_Balance.text = [NSString stringWithFormat:@"%0.2f",amount/100];
            }
        }
    }];
    
}

#pragma mark FPPositivePayViewDelegate
- (void)positivePayViewHasPayAway{
    //返回首页
    [UtilTool setHomeViewRootController];}

#pragma mark UITextFieldDelegate //216+40
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    float bottom = _lbl_Balance.bottom;
    float temp = ScreenHigh - bottom -55;
    if (temp-256 < 0) {
//        [self setViewTranfromWithY:temp-256];
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
//    [self setViewTranfromWithY:0];
    if (textField == _fld_PayAmt) {
        if (textField.text.length>0) {
            _btn_NextStep.enabled = YES;
        }else{
            _btn_NextStep.enabled = NO;
        }
    }
    
}

#pragma  mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag == 200) {
        // 表示收款账号等于支付账号
        if(buttonIndex == 0){
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
}

- (void)setViewTranfromWithY:(CGFloat)Y{
    CGAffineTransform transFormY = CGAffineTransformMakeTranslation(0, Y);
    [UIView animateWithDuration:0.3 animations:^{
        
        self.view.transform = transFormY;
        
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 监听键盘
- (void)keyboardWillChange:(NSNotification *)notification
{
    NSDictionary *dict = notification.userInfo;
    
    // 1. 获取键盘的y值
    CGRect keyFrame = [dict[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardY = keyFrame.origin.y;
    // 2. 计算需要移动的距离
    CGFloat translationY = 0;
    if (keyboardY >= ScreenHigh) {
        translationY = 0;
    } else {
        CGFloat height = [[UIScreen mainScreen] bounds].size.height ;
        if (height == 480) {
            translationY = -keyFrame.size.height+140;
        }else{
            translationY = -keyFrame.size.height+200;
        }
    }
    // 3. 计算动画执行的时间
    CGFloat duration = [dict[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 4. 通过动画移动view
    [UIView animateWithDuration:duration delay:0.0 options:7 << 16 animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0, translationY);
    } completion:^(BOOL finished) {
    }];
}

@end
