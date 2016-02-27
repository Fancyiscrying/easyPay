  //
//  FPPositivePayView.m
//  FullPayApp
//
//  Created by 刘通超 on 14/11/24.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPPositivePayView.h"
#import "FPPositivePayCell.h"
#import "FPDataBaseManager.H"
#import "FPMobileRechargeModel.h"
#import "FPMobileRechargeModel.h"

typedef enum{
    PositivePayViewComeFromTranform,//转账
    PositivePayViewComeFromRedPacket,//红包
    PositivePayViewComeFromFullWellet, //富钱包卡充值
    PositivePayViewComeFromMobile,   //手机充值
    PositivePayViewComeFromWithdraw  //转账到银行卡
} PositivePayViewComeFrom;

@interface FPPositivePayView()<UIAlertViewDelegate> {
    int _numberOfRows;
    BOOL _hasRemark;
    BOOL _hasPass;
    
    BOOL _isRedPacktePay;
}

@property (nonatomic, strong) FPPassCodeView *passCode;
@property (nonatomic, strong) UIButton       *sureButton;
@property (nonatomic, strong) UITableView    *table;

@property (nonatomic, copy  ) NSString       *redPacktePayMoney;
@property (nonatomic, copy  ) NSString       *redPacktePayId;

@property (nonatomic, copy  ) NSString       *fullWalletRechargeAmt;
@property (nonatomic, copy  ) NSString       *fullWalletRechargeCardNumber;
@property (nonatomic, copy  ) NSString       *fullWalletRechargeTradeNo;

@property (nonatomic,strong ) NSString       *mobileRechargeNo;
@property (nonatomic,strong ) MobileOption   *mobileRechargeOption;

@property (nonatomic, copy  ) NSString       *withdrawAmt;
@property (nonatomic, copy  ) NSString       *withdrawBankCardId;
@property (nonatomic, copy  ) NSString       *withdrawTitle;

@property (nonatomic, assign) PositivePayViewComeFrom viewAllocFrom;


@end
static NSString *postivePayCellIndent = @"posstivePayCell";

@implementation FPPositivePayView

- (void)setTransferData:(ContactsInfo *)transferData{
    _transferData = transferData;
    float height = _transferData.toRemark.length>0? 310: 270;
    _table.height = height;
    [_table reloadData];
}

- (id)init{
    self = [super init];
    if (self) {
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    
    return self;
}

#pragma mark  //转账到银行卡
//转账到银行卡
- (id)initWithWithdrawTypeWithParamters:(NSDictionary *)paramters andHasPass:(BOOL)hasPass{
    self = [self initWithFrame:ScreenBounds];
    _numberOfRows =0;
    _hasPass = hasPass;
    _hasRemark = NO;
    
    _withdrawAmt = [paramters objectForKey:@"withdrawAmt"];
    _withdrawBankCardId = [paramters objectForKey:@"withdrawBankCardId"];
    _withdrawTitle = [paramters objectForKey:@"withdrawTitle"];
    
    _viewAllocFrom = PositivePayViewComeFromWithdraw;
    
    [self installCostomView];
    
    return self;
}

#pragma mark  //手机充值
//手机充值
- (id)initWithMobileRechargeTypeWithParamters:(NSDictionary *)paramters andHasPass:(BOOL)hasPass{
    self = [self initWithFrame:ScreenBounds];
    _numberOfRows =0;
    _hasPass = hasPass;
    _hasRemark = NO;
    
    _mobileRechargeNo = [paramters objectForKey:@"mobileRechargeNo"];
    _mobileRechargeOption = [paramters objectForKey:@"mobileRechargeOption"];
    _viewAllocFrom = PositivePayViewComeFromMobile;
    
    [self installCostomView];
    
    return self;
}
#pragma mark  //富钱包充值
//富钱包充值
- (id)initWithFullWalletTypeWithParamters:(NSDictionary *)paramters andHasPass:(BOOL)hasPass{
    self = [self initWithFrame:ScreenBounds];
    
    _numberOfRows =0;
    _hasPass = hasPass;
    _hasRemark = NO;
    
    _fullWalletRechargeAmt = [paramters objectForKey:@"fullWalletRechargeAmt"];
    _fullWalletRechargeCardNumber = [paramters objectForKey:@"fullWalletRechargeCardNumber"];
    _fullWalletRechargeTradeNo = [paramters objectForKey:@"fullWalletRechargeTradeNo"];

    _viewAllocFrom = PositivePayViewComeFromFullWellet;
    
    [self installCostomView];
    
    return self;
}

#pragma mark  //红包支付
//红包支付
- (id)initWithRedPackteTypeWithParamters:(NSDictionary *)paramters andHasPass:(BOOL)hasPass{
    self = [self initWithFrame:ScreenBounds];
    _isRedPacktePay = YES;

    _numberOfRows =0;
    _hasPass = hasPass;
    _hasRemark = NO;
    
    _redPacktePayId = [paramters objectForKey:@"redPacktePayId"];
    _redPacktePayMoney = [paramters objectForKey:@"redPacktePayMoney"];

    _viewAllocFrom = PositivePayViewComeFromRedPacket;

    
    [self installCostomView];
    
    return self;
}

- (id)initWithInputPassWordView:(BOOL)hasPass andWithRemark:(BOOL)hasMark{
    self = [self initWithFrame:ScreenBounds];
    _numberOfRows =0;
    _hasPass = hasPass;
    _hasRemark = hasMark;
    
    _viewAllocFrom = PositivePayViewComeFromTranform;
    
    [self installCostomView];
    
    return self;
}

- (void)installCostomView{
    UIView *view = [[UIView alloc]initWithFrame:ScreenBounds];
    view.backgroundColor = [UIColor blackColor];
    view.alpha = 0.5;
    [self addSubview:view];
    
    float height  = 0;
    if (_hasRemark) {
        height = 310;
    }else{
        height = 270;
    }

    _table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth-20, height) style:UITableViewStylePlain];
    _table.backgroundColor = [UIColor whiteColor];
    _table.delegate = self;
    _table.dataSource = self;
    _table.tag = 101;
    _table.allowsSelection = NO;
    _table.scrollEnabled = NO;
    _table.separatorColor = [UIColor clearColor];
    _table.center = CGPointMake(ScreenWidth/2, ScreenHigh/2-10);

    
    [self addSubview:_table];
    
    _table.layer.masksToBounds = YES;
    _table.layer.borderColor = [UIColor grayColor].CGColor;
    _table.layer.borderWidth = 0.5;
    _table.layer.cornerRadius = 5;
    
    [self addTableFootView:_table];
    [self addTableHeadView:_table];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapTheTable)];
    [_table addGestureRecognizer:tap];
    
    self.hidden = YES;
}


#pragma mark add head and foot view
- (void)addTableHeadView:(UITableView *)table{
    UIView *head = [[UIView alloc]initWithFrame:CGRectMake(0, 0, table.width, 50)];
    head.backgroundColor = [UIColor whiteColor];
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake((table.width-150)/2, 0, 150, head.height)];
    title.text = @"输入支付密码";
    title.font = [UIFont boldSystemFontOfSize:18];
    title.textAlignment = NSTextAlignmentCenter;
    title.backgroundColor = [UIColor clearColor];
    [head addSubview:title];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(12.5, 12.5, 25, 25);
    [cancelButton addTarget:self action:@selector(tapCancelButton) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton setImage:MIMAGE(@"positivePayView_cancel_nomal.png") forState:UIControlStateNormal];
    [cancelButton setImage:MIMAGE(@"positivePayView_cancel_click.png") forState:UIControlStateSelected];
    [head addSubview:cancelButton];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, head.height-0.5, head.width, 0.5)];
    line.backgroundColor = [UIColor lightGrayColor];
    line.alpha = 0.5;
    [head addSubview:line];
    
    [table setTableHeaderView:head];
}

- (void)addTableFootView:(UITableView *)table{
    UIView *foot = [[UIView alloc]initWithFrame:CGRectMake(0, 0, table.width, 130)];
    foot.backgroundColor = [UIColor whiteColor];
    

    
    if (_hasPass) {
        _passCode = [[FPPassCodeView alloc] initWithFrame:CGRectMake((table.width-280)/2+5, -10, 280, 60) withSimple:YES];
        _passCode.delegate = self;
        _passCode.securet = YES;
        [_passCode becomeFirstResponse];

        [foot addSubview:_passCode];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapThePassCode)];
        [_passCode addGestureRecognizer:tap];
        
    }else{
        UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, table.width-40, 60)];
        title.text = @"你已开启小额免密支付,本次无需输入支付密码,可在“支付额度管理”中更改。";
        title.textAlignment = NSTextAlignmentLeft;
        title.numberOfLines = 2;
        title.font = [UIFont systemFontOfSize:12];
        title.textColor = [UIColor grayColor];
        title.backgroundColor = [UIColor clearColor];
        [foot addSubview:title];
    }
    
    _sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _sureButton.frame = CGRectMake(15, 75, table.width-30, 40);
    [_sureButton addTarget:self action:@selector(tapSureButton) forControlEvents:UIControlEventTouchUpInside];
    [_sureButton setTitle:@"确认" forState:UIControlStateNormal];
    [_sureButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_sureButton setBackgroundImage:MIMAGE(COMM_BTN_BLUE) forState:UIControlStateNormal];
    [_sureButton setBackgroundImage:MIMAGE(COMM_BTN_GRAY) forState:UIControlStateDisabled];
    [foot addSubview:_sureButton];
    
    if (_hasPass) {
        _sureButton.enabled = NO;
    }
    _sureButton.layer.masksToBounds = YES;
//    _sureButton.layer.borderColor = [UIColor blackColor].CGColor;
//    _sureButton.layer.borderWidth = 0.5;
    _sureButton.layer.cornerRadius = 5;
    
//    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, foot.width, 0.5)];
//    line.backgroundColor = [UIColor lightGrayColor];
//    line.alpha = 0.5;
//    [foot addSubview:line];
    
    [table setTableFooterView:foot];
}

#pragma mark buttonActions

- (void)tapCancelButton{
   // _table.hidden = YES;
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"取消本次付款操作?" message:nil delegate:self cancelButtonTitle:@"按错了" otherButtonTitles:@"确认", nil];
    alert.tag = 101;
    [alert show];
//    if ([self.delegate respondsToSelector:@selector(positivePayViewClickCancle)]) {
//        [self.delegate positivePayViewClickCancle];
//    }
}

- (void)tapSureButton{
    //禁止重点确定按钮
    self.sureButton.enabled = NO;
    switch (_viewAllocFrom) {
        case PositivePayViewComeFromTranform:
             [self userTransferTo:_transferData];
            break;
        case PositivePayViewComeFromFullWellet:
             [self rechargePayment];
            break;
        case PositivePayViewComeFromRedPacket:
             [self distributePay];
            break;
        case PositivePayViewComeFromMobile:
             [self userRechargeMobileFeeWithMobileNo];
            break;
        case PositivePayViewComeFromWithdraw:
            [self userWithdrawToBankCard];
            break;
        default:
            break;
    }
}

- (void)tapTheTable{
    if (_passCode.isFirstResponse) {
        [_passCode resignFirstResponse];
    }
}

-  (void)tapThePassCode{
    if (_passCode.isFirstResponse) {
        [_passCode resignFirstResponse];
    }else{
        [_passCode becomeFirstResponse];
    }
}

#pragma mark Networking

/**
 *  转账到银行卡
 */
- (void)userWithdrawToBankCard{
    FPClient *client = [FPClient sharedClient];
    NSDictionary *paramters = [client userWithdrawWithMemberNo:[Config Instance].memberNo andAmt:_withdrawAmt andPassword:_passCode.passcode andMemberBankCardId:_withdrawBankCardId];
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self];
    [UtilTool showHUD:@"正在处理" andView:self andHUD:hud];
    
    [client POST:kFPPost parameters:paramters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //启用确定按钮
        self.sureButton.enabled = YES;
        [hud hide:YES];
        
        if ([[responseObject objectForKey:@"result"] boolValue] == YES) {
            
            UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"转账成功!" message:nil delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
            alter.tag = 102;
            [alter setContentMode:UIViewContentModeCenter];
            [alter show];
            
        }else{
            NSString *errInfo = [responseObject objectForKey:@"errorInfo"];
            UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"转账失败!" message:errInfo delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
            
            [alter setContentMode:UIViewContentModeCenter];
            [alter show];
            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //启用确定按钮
        self.sureButton.enabled = YES;
        [hud hide:YES];
        FPDEBUG(@"%@",error);
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"网络连接失败,请查看网络是否连接正常！" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }];

}

/**
 *  手机充值
 */
- (void)userRechargeMobileFeeWithMobileNo{
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self];
    [UtilTool showHUD:@"正在处理" andView:self andHUD:hud];
    
    [FPMobileRechargeModel userRechargeMobileFeeWithMobileNo:_mobileRechargeNo andOptionId:_mobileRechargeOption.optionId andPayPwd:_passCode.passcode andBlock:^(FPMobileRechargeModel *dataInfo,NSError *error){
        //启用确定按钮
        self.sureButton.enabled = YES;
        
        [hud hide:YES];
        if (error) {
            [hud hide:YES];
            FPDEBUG(@"%@",error);
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"网络连接失败,请查看网络是否连接正常！" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        } else {
            if (dataInfo.result) {
                UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"充值成功!" message:nil delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
                alter.tag = 102;
                [alter setContentMode:UIViewContentModeCenter];
                [alter show];
                
            } else {
                NSString *errInfo = dataInfo.errorInfo;
                UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"付款失败!" message:errInfo delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
                
                [alter setContentMode:UIViewContentModeCenter];
                [alter show];
            }
        }
    }];

}

/**
 *  富钱包卡充值
 */
- (void)rechargePayment{
    FPClient *client = [FPClient sharedClient];
    NSDictionary *paramters7 = [client rechargePaymentWithTradeNo:_fullWalletRechargeTradeNo andPassword:_passCode.passcode];
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self];
    [UtilTool showHUD:@"正在处理" andView:self andHUD:hud];
    
    [client POST:kFPPost parameters:paramters7 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //启用确定按钮
        self.sureButton.enabled = YES;
        [hud hide:YES];
        
        if ([[responseObject objectForKey:@"result"] boolValue] == YES) {
            
            UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"交易成功,请尽快完成金额圈存!" message:nil delegate:self cancelButtonTitle:@"如何圈存" otherButtonTitles:@"知道了", nil];
            alter.tag = 103;
            [alter setContentMode:UIViewContentModeCenter];
            [alter show];
            
        }else{
            NSString *errInfo = [responseObject objectForKey:@"errorInfo"];
            UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"付款失败!" message:errInfo delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
            
            [alter setContentMode:UIViewContentModeCenter];
            [alter show];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //启用确定按钮
        self.sureButton.enabled = YES;
        [hud hide:YES];
        FPDEBUG(@"%@",error);
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"网络连接失败,请查看网络是否连接正常！" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }];
}

/**
 *  红包支付
 */
- (void)distributePay{                     
    FPClient *client = [FPClient sharedClient];
    NSDictionary *paramters7 = [client distributePayWithDistributeId:_redPacktePayId andPassword:_passCode.passcode];
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self];
    [UtilTool showHUD:@"正在处理" andView:self andHUD:hud];
    
    [client POST:kFPPost parameters:paramters7 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //启用确定按钮
        self.sureButton.enabled = YES;
        [hud hide:YES];

        if ([[responseObject objectForKey:@"result"] boolValue] == YES) {
            
            UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"付款成功!" message:nil delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
            alter.tag = 102;
            [alter setContentMode:UIViewContentModeCenter];
            [alter show];
            
        }else{
            NSString *errInfo = [responseObject objectForKey:@"errorInfo"];
            UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"付款失败!" message:errInfo delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
            
            [alter setContentMode:UIViewContentModeCenter];
            [alter show];
            
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //启用确定按钮
        self.sureButton.enabled = YES;
        [hud hide:YES];
        FPDEBUG(@"%@",error);
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"网络连接失败,请查看网络是否连接正常！" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }];
}

/**
 *  用户转账到富支付账户
 *
 */
- (void)userTransferTo:(ContactsInfo *)transferData{
    FPClient *urlClient = [FPClient sharedClient];
    
    NSDictionary *parameters = [urlClient userTransfer:transferData.fromMemberNo andInMemberNo:transferData.toMemberNo andAmt:transferData.toAmount andPassword:transferData.password andRemark:transferData.toRemark];
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self];
    [UtilTool showHUD:@"正在处理" andView:self andHUD:hud];
    [urlClient POST:kFPPost parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //启用确定按钮
        self.sureButton.enabled = YES;
        
        [hud hide:YES];
        if ([[responseObject objectForKey:@"result"] boolValue] == YES) {
            
            FPDataBaseManager *center = [FPDataBaseManager shareCenter];
            [center createTable_Cantact];
            [center updateIfExistTable_Cantact:transferData];
            
            UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"付款成功!" message:nil delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
            alter.tag = 102;
            [alter setContentMode:UIViewContentModeCenter];
            [alter show];
            
        }else{
            NSString *errInfo = [responseObject objectForKey:@"errorInfo"];
            UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"付款失败!" message:errInfo delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
            
            [alter setContentMode:UIViewContentModeCenter];
            [alter show];
            
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //启用确定按钮
        self.sureButton.enabled = YES;
        [hud hide:YES];
        FPDEBUG(@"%@",error);
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"网络连接失败,请查看网络是否连接正常！" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }];
    
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag == 101){
        if (buttonIndex == 0) {
            _table.hidden = NO;
        }else{
            [_passCode resignFirstResponse];
            self.hidden = YES;
        }
    }else if(alertView.tag == 102){
        self.hidden = YES;
        if ([self.delegate respondsToSelector:@selector(positivePayViewHasPayAway)]) {
            [self.delegate positivePayViewHasPayAway];
        }
    }else if(alertView.tag == 103){
        self.hidden = YES;
        if ([self.delegate respondsToSelector:@selector(positivePayViewHasPayAwayWithButtonIndex:)]) {
            [self.delegate positivePayViewHasPayAwayWithButtonIndex:buttonIndex];
        }
    }
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (_viewAllocFrom) {
        case PositivePayViewComeFromTranform:
        {
            if (_transferData.toRemark.length>0) {
                return 3;
            }else{
                return 2;
            }
            
        }
            break;
        case PositivePayViewComeFromRedPacket:
        {
            return 2;
        }
            break;
        case PositivePayViewComeFromFullWellet:
        {
            return 2;
        }
            break;
        case PositivePayViewComeFromMobile:
        {
            return 2;
        }
            break;
        case PositivePayViewComeFromWithdraw:
        {
            return 2;
        }
            break;
            
        default:
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FPPositivePayCell *cell = [tableView dequeueReusableCellWithIdentifier:postivePayCellIndent];
    if (cell == nil) {
        cell = [[FPPositivePayCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:postivePayCellIndent];
    }
    
    if (indexPath.row == 0) {
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, tableView.width, 20)];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor lightGrayColor];
        label.font = [UIFont systemFontOfSize:14];
        label.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:label];
        
        switch (_viewAllocFrom) {

            case PositivePayViewComeFromTranform:
            {
                label.text = _transferData.toMemberName;
            }
                break;
            case PositivePayViewComeFromRedPacket:
            {
                label.text = @"红包充值";
            }
                break;
            case PositivePayViewComeFromFullWellet:
            {
                label.text = @"富钱包充值";
            }
                break;
                
            case PositivePayViewComeFromMobile:
            {
                label.text = @"手机充值";
            }
                break;
                
            case PositivePayViewComeFromWithdraw:
            {
                label.text = _withdrawTitle;
            }
                break;
                
            default:
                break;
        }
        
       
    }else if (indexPath.row == 1){
        cell.textLabel.font = [UIFont systemFontOfSize:28];

        
        switch (_viewAllocFrom) {
                
            case PositivePayViewComeFromTranform:
            {
                double amount = [_transferData.toAmount doubleValue];
                cell.textLabel.text = [NSString stringWithFormat:@"￥%0.2f",amount/100];
               
            }
                break;
            case PositivePayViewComeFromRedPacket:
            {
                double amount = [_redPacktePayMoney doubleValue];
                cell.textLabel.text = [NSString stringWithFormat:@"￥%0.2f",amount];
            }
                break;
            case PositivePayViewComeFromFullWellet:
            {
                double amount = [_fullWalletRechargeAmt doubleValue];
                cell.textLabel.text = [NSString stringWithFormat:@"￥%0.2f",amount/100];
            }
                break;
                
            case PositivePayViewComeFromMobile:
            {
                float amount = _mobileRechargeOption.payAmount;
                cell.textLabel.text = [NSString stringWithFormat:@"￥%0.2f",amount];
            }
                break;
                
            case PositivePayViewComeFromWithdraw:
            {
                double amount = [_withdrawAmt doubleValue];
                cell.textLabel.text = [NSString stringWithFormat:@"￥%0.2f",amount/100];
            }
                break;
                
            default:
                break;
        }

        
    }else if (indexPath.row == 2){
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, tableView.width, 20)];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:14];
        label.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:label];
        
        label.text = _transferData.toRemark;
    }

    return cell;
    
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 1){
        return 40;
    }else{
        return 40;
    }
}

#pragma mark FPPassCodeViewDelegate
-(void)passCodeViewBecomeFirstResponse{
    UITableView *table = (UITableView *)[self viewWithTag:101];
    float bottom = table.bottom - 65;
    float temp = ScreenHigh - bottom;
    if (temp-216 < 0) {
        [self setTableViewTranfromWithY:temp-216];
    }
    
}

-(void)passCodeViewResignFirstResponse{
    [self setTableViewTranfromWithY:0];
    if (_passCode.passcode.length == 6) {
        _sureButton.enabled = YES;
        _transferData.password = _passCode.passcode;

    }else{
        _sureButton.enabled = NO;
    }
}

#pragma mark viewAnimate

- (void)setTableViewTranfromWithY:(CGFloat)Y{
    CGAffineTransform transFormY = CGAffineTransformMakeTranslation(0, Y);
    [UIView animateWithDuration:0.3 animations:^{
        UITableView *table = (UITableView *)[self viewWithTag:101];
        table.transform = transFormY;
        
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if ([_passCode isFirstResponse]) {
        [_passCode resignFirstResponse];
    }
}
@end
