//
//  FPWalletPayPwdView.m
//  FullPayApp
//
//  Created by LC on 15/6/22.
//  Copyright (c) 2015年 fullpay. All rights reserved.
//

#import "FPWalletPayPwdView.h"

#define Button_Tag 50

@interface FPWalletPayPwdView()
@property (nonatomic,strong)FPPassCodeView *passCode;
@property (nonatomic,strong)UIView * mainView;
@property (nonatomic,strong)UIButton * selectBtn;
@property (nonatomic,strong)UIButton * sureBtn;
@property (nonatomic,copy) void (^completion)(BOOL cancelled,NSString * password);
@end

@implementation FPWalletPayPwdView
- (id)init{
    self = [super init];
    if (self) {
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // 注册键盘的监听通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
        
    }
    
    return self;
}

/**
 *  创建挂失提示View
 */
-(id)initWithLossCardTypeMessageandCompletion:(FPWalletPayPwdCompletionBlock)completion
{
    self = [self initWithFrame:ScreenBounds];
    NSString * mess = @"1.亲，富钱包卡是离线卡，食堂的蜀黍和阿姨可不会实时上传数据的哦，所以请亲给我们一点点时间，2个工作日之后挂失就可以生效啦，同样的，解除挂失也是一样的喔！\n\n2.如果不幸，亲的富钱包卡在这2个工作日中被坏人盗刷了，那我们会和亲一起画个圈圈诅咒他，那些被盗刷的钱就让它随风而去吧！\n\n3.因为卡片不翼而飞啦，所以挂失之后，原来卡得10元押金就找不回来喔!";
    [self creatViewWithLossCardMessage:mess completion:completion];
    return self;
}

/**
 *  创建挂失卡View
 */
-(id)initWithLossCardTypeandCompletion:(FPWalletPayPwdCompletionBlock)completion;{
    self = [self initWithFrame:ScreenBounds];
    NSString *mess = @"卡片挂失需2个工作日后才能生效";
    [self createViewWithMessage:mess completion:completion];
    
    return self;
}

/**
 *  创建解绑卡View
 */
-(id)initWithUnbingCardTypeandCompletion:(FPWalletPayPwdCompletionBlock)completion
{
    self = [self initWithFrame:ScreenBounds];
    NSString *mess = @"解绑后，该卡将不可再申请实名卡，但可以作为不记名卡继续使用，是否确定解绑？";
    [self createViewWithMessage:mess completion:completion];
    
    return self;
}

/**
 *  创建解挂卡View
 */
-(id)initWithRemoveLossCardTypeandCompletion:(FPWalletPayPwdCompletionBlock)completion
{
    self = [self initWithFrame:ScreenBounds];
    NSString *mess = @"卡片解挂需2个工作日后才能生效";
    [self createViewWithMessage:mess completion:completion];
    
    return self;
}

/**
 *  创建补卡View
 */
-(id)initWithchangeCardTypeandandmoney:(CGFloat)money Completion:(FPWalletPayPwdCompletionBlock)completion
{
    self = [self initWithFrame:ScreenBounds];
    NSString * blance = [NSString stringWithFormat:@"￥%@",[NSString simpMoney:money]];
    NSString * mess = [NSString stringWithFormat:@"%@%@%@",@"当前卡内余额为",blance,@"元，如无疑问请点击【确认】按钮进行余额转移，如有疑问可拨打客服电话0755-33687917"];
    [self creatViewWithNoInputMessage:mess completion:completion];
    return self;
}

/**
 *  创建转入卡View
 *
 *  @param money      转入金额
 *  @param completion 完成后的点击事件
 *  @parrm cardNo     转入实名卡号
 *
 *  @return 转入卡View
 */
-(id)initWithchangeCardTypeandandmoney:(CGFloat)money CardNo:(NSString *)cardNo Completion:(FPWalletPayPwdCompletionBlock)completion;
{
    self = [self initWithFrame:ScreenBounds];
    NSString * moneyStr = [NSString stringWithFormat:@"%@%@%@",@"转入金额:￥",[NSString simpMoney:money],@"元\n"];
    NSString * cardNoStr = [NSString stringWithFormat:@"%@%@",@"转入卡号: ",cardNo];
    NSString * mess = [NSString stringWithFormat:@"%@%@",moneyStr,cardNoStr];
    
    [self createViewWithMessage:mess completion:completion];
    
    return self;
}

/**
 *  创建输入密码的View
 */
-(void)createViewWithMessage:(NSString *)mess completion:(FPWalletPayPwdCompletionBlock)completion{
    UIView *view = [[UIView alloc]initWithFrame:ScreenBounds];
    view.backgroundColor = [UIColor blackColor];
    view.alpha = 0.5;
    [self addSubview:view];
    
    if (completion) {
        self.completion = completion;
    }
    
    _mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth-40, 100)];
    _mainView.backgroundColor = [UIColor whiteColor];
    _mainView.center = CGPointMake(self.width/2, self.height/2);
    
    UIView *head = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _mainView.width, 50)];
    head.backgroundColor = [UIColor whiteColor];
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake((_mainView.width-150)/2, 0, 150, head.height)];
    title.text = @"输入支付密码";
    title.font = [UIFont systemFontOfSize:18];
    title.textAlignment = NSTextAlignmentCenter;
    title.backgroundColor = [UIColor clearColor];
    [head addSubview:title];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, head.height-0.5, head.width, 0.5)];
    line.backgroundColor = [UIColor lightGrayColor];
    line.alpha = 0.5;
    [head addSubview:line];
    
    [_mainView addSubview:head];
    
    UILabel *message = [[UILabel alloc]initWithFrame:CGRectMake(10, line.bottom+10, _mainView.width-20, 30)];
    message.font = [UIFont systemFontOfSize:16];
    message.textAlignment = NSTextAlignmentLeft;
    message.backgroundColor = [UIColor clearColor];
    message.textColor = COLOR_STRING(@"808080");
    message.lineBreakMode = NSLineBreakByCharWrapping;
    message.numberOfLines = 10;
    CGFloat height = [mess getHeightWithFontSize:16 andWidth:message.width];
    message.height = height;
    message.text = mess;
    [_mainView addSubview:message];
    
    _passCode = [[FPPassCodeView alloc] initWithFrame:CGRectMake((_mainView.width-280)/2+5, message.bottom-10, 280, 60) withSimple:YES];
    _passCode.delegate = self;
    _passCode.securet = YES;
    [_passCode becomeFirstResponse];
    [_mainView addSubview:_passCode];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapThePassCode)];
    [_passCode addGestureRecognizer:tap];
    
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, _passCode.bottom+10, _mainView.width, 0.5)];
    line2.backgroundColor = [UIColor lightGrayColor];
    line2.alpha = 0.5;
    [head addSubview:line2];
    
    for (NSInteger i = 0 ; i < 2; i ++) {
        UIButton * btn = [[UIButton alloc] init];
        btn.frame = CGRectMake((_mainView.width/2+1)*i, line2.bottom, _mainView.width/2-1, 40);
        btn.tag = Button_Tag + i;
        if (i == 0) {
            [btn setTitle:@"取消" forState:UIControlStateNormal];
            
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(btn.width, btn.top, 0.5, btn.height)];
            line.backgroundColor = [UIColor lightGrayColor];
            line.alpha = 0.5;
            [_mainView addSubview:line];
            
        }else{
            [btn setTitle:@"确认" forState:UIControlStateNormal];
        }
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setBackgroundImage:MIMAGE(COMM_BTN_WHITE) forState:UIControlStateNormal];
        [btn setBackgroundImage:MIMAGE(COMM_BTN_GRAY) forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_mainView addSubview:btn];
        
    }
    
    UIButton * sureButton = (id)[_mainView viewWithTag:Button_Tag];
    _mainView.height = sureButton.bottom;
    
    [self addSubview:_mainView];
}

- (void)creatViewWithLossCardMessage:(NSString *)mess completion:(FPWalletPayPwdCompletionBlock)completion
{
    UIView *view = [[UIView alloc]initWithFrame:ScreenBounds];
    view.backgroundColor = [UIColor blackColor];
    view.alpha = 0.5;
    [self addSubview:view];
    
    if (completion) {
        self.completion = completion;
    }
    
    _mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth-40, 100)];
    _mainView.backgroundColor = [UIColor whiteColor];
    
    
    UIView *head = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _mainView.width, 50)];
    head.backgroundColor = [UIColor whiteColor];
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake((_mainView.width-150)/2, 0, 150, head.height)];
    title.text = @"挂失说明";
    title.font = [UIFont systemFontOfSize:18];
    title.textAlignment = NSTextAlignmentCenter;
    title.backgroundColor = [UIColor clearColor];
    [head addSubview:title];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, head.height-0.5, head.width, 0.5)];
    line.backgroundColor = [UIColor lightGrayColor];
    line.alpha = 0.5;
    [head addSubview:line];
    
    [_mainView addSubview:head];
    
    UILabel *message = [[UILabel alloc]initWithFrame:CGRectMake(10, line.bottom+5, _mainView.width-20, 30)];
    message.font = [UIFont systemFontOfSize:14];
    message.textAlignment = NSTextAlignmentLeft;
    message.backgroundColor = [UIColor clearColor];
    message.lineBreakMode = NSLineBreakByCharWrapping;
    message.textColor = COLOR_STRING(@"808080");
    message.numberOfLines = 0;
    CGFloat height = [mess getHeightWithFontSize:14 andWidth:message.width];
    message.height = height;
    message.text = mess;
    [_mainView addSubview:message];
    
    _selectBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, message.bottom+10, _mainView.width-100, 20)];
    [_selectBtn setTitle:@"已仔细阅读以上条款" forState:UIControlStateNormal];
    [_selectBtn setImage:[UIImage imageNamed:@"check_no"] forState:UIControlStateNormal];
    [_selectBtn setImage:[UIImage imageNamed:@"check_yes"] forState:UIControlStateSelected];
    [_selectBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _selectBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    _selectBtn.titleLabel.font = [UIFont systemFontOfSize:14];
//    [_selectBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -40, 0, -40)];
//    [_selectBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 40, 0, 40)];
    [_selectBtn addTarget:self action:@selector(lossCardBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_mainView addSubview:_selectBtn];
    
    _sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, _selectBtn.bottom+10, _mainView.width-30, 35)];
    [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [_sureBtn setBackgroundImage:MIMAGE(COMM_BTN_GRAY) forState:UIControlStateDisabled];
    [_sureBtn setBackgroundImage:MIMAGE(COMM_BTN_BLUE) forState:UIControlStateNormal];
    
    [_sureBtn addTarget:self action:@selector(lossCardBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _sureBtn.enabled = NO;
    [_mainView addSubview:_sureBtn];
    
    _mainView.height = _sureBtn.bottom+10;
    _mainView.center = self.center;
    [self addSubview:_mainView];
    
}




- (void)creatViewWithNoInputMessage:(NSString *)mess completion:(FPWalletPayPwdCompletionBlock)completion
{
    UIView *view = [[UIView alloc]initWithFrame:ScreenBounds];
    view.backgroundColor = [UIColor blackColor];
    view.alpha = 0.5;
    [self addSubview:view];
    
    if (completion) {
        self.completion = completion;
    }
    
    _mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth-40, 100)];
    _mainView.backgroundColor = [UIColor whiteColor];
    _mainView.center = CGPointMake(self.width/2, self.height/2);
    
    UIView *head = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _mainView.width, 50)];
    head.backgroundColor = [UIColor whiteColor];
    
    UILabel *message = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, _mainView.width-20, 30)];
    message.userInteractionEnabled = YES;
    message.font = [UIFont systemFontOfSize:16];
    message.textColor = COLOR_STRING(@"808080");
    message.textAlignment = NSTextAlignmentLeft;
    message.backgroundColor = [UIColor clearColor];
//    message.editable = NO;
    message.lineBreakMode = NSLineBreakByCharWrapping;
    message.numberOfLines = 10;
    CGFloat height = [mess getHeightWithFontSize:16 andWidth:message.width];
    message.height = height;
    message.text = mess;
    
    NSRange Range = [message.text rangeOfString:@"0755-33687917" options:NSBackwardsSearch];
    NSMutableAttributedString *attrText = [[NSMutableAttributedString alloc] initWithString:message.text];
    NSURL * linkURL = [NSURL URLWithString:@"0755-33687917"];
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://0755-33687917"]];
    [attrText setAttributes:@{NSForegroundColorAttributeName:[UIColor blueColor],NSLinkAttributeName:linkURL} range:Range];
    
    UITapGestureRecognizer * callTelTGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(callTel)];
    [message addGestureRecognizer:callTelTGR];
    
    //设置超链接文字
    message.attributedText = attrText;
    
    [_mainView addSubview:message];
    
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, message.bottom+10, _mainView.width, 0.5)];
    line2.backgroundColor = [UIColor lightGrayColor];
    line2.alpha = 0.5;
    [_mainView addSubview:line2];
    
    for (NSInteger i = 0 ; i < 2; i ++) {
        UIButton * btn = [[UIButton alloc] init];
        btn.frame = CGRectMake((_mainView.width/2+1)*i, line2.bottom, _mainView.width/2-1, 40);
        btn.tag = Button_Tag + i;
        if (i == 0) {
            [btn setTitle:@"取消" forState:UIControlStateNormal];
            
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(btn.width, btn.top, 0.5, btn.height)];
            line.backgroundColor = [UIColor lightGrayColor];
            line.alpha = 0.5;
            [_mainView addSubview:line];
        }else{
            [btn setTitle:@"确认" forState:UIControlStateNormal];
        }
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setBackgroundImage:MIMAGE(COMM_BTN_WHITE) forState:UIControlStateNormal];
        [btn setBackgroundImage:MIMAGE(COMM_BTN_GRAY) forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_mainView addSubview:btn];
        
    }
    
    UIButton * sureButton = (id)[_mainView viewWithTag:Button_Tag];
    _mainView.height = sureButton.bottom;
    
    [self addSubview:_mainView];

}


-(void)tapThePassCode{

    if (_passCode.isFirstResponse) {
        [_passCode resignFirstResponse];
    }else{
        [_passCode becomeFirstResponse];
    }
    
}

/**
 *  button点击了
 */
-(void)btnClick:(UIButton *)btn{
    [_passCode resignFirstResponse];
    self.hidden = YES;
    
    if (self.completion) {
        BOOL cancelled = NO;
        
        NSInteger buttonIndex = btn.tag-Button_Tag;
        if (buttonIndex == 0) {
            cancelled = YES;
        }
        NSString * password = [self.passCode getPasscode];
        self.completion(cancelled,password);
    }
}

/**
 *  挂失提示View点击了
 */
- (void)lossCardBtnClick:(UIButton *)btn
{
    if (btn == _selectBtn) {
        if (btn.selected == YES) {
            btn.selected = NO;
            _sureBtn.enabled = NO;
        }else if (btn.selected == NO){
            btn.selected = YES;
            _sureBtn.enabled = YES;
        }
    }else if (btn == _sureBtn){
        if (self.completion) {
            
            self.hidden = YES;
            BOOL cancelled = NO;
            
            self.completion(cancelled,nil);
        }
    }
}

///**
// *  view消失
// */
//- (void)disMiss
//{
//    [_passCode resignFirstResponse];
//    if (self.completion) {
//        
//        self.hidden = YES;
//        BOOL cancelled = YES;
//        
//        self.completion(cancelled,nil);
//    }
//}

/**
 *  拨打电话
 */
- (void)callTel
{
    NSString *num = [[NSString alloc] initWithFormat:@"telprompt://%@",@"0755-33687917"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]];
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
        translationY = -keyFrame.size.height+50;
    }
    // 3. 计算动画执行的时间
    CGFloat duration = [dict[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 4. 通过动画移动view
    [UIView animateWithDuration:duration delay:0.0 options:7 << 16 animations:^{
        _mainView.transform = CGAffineTransformMakeTranslation(0, translationY);
    } completion:^(BOOL finished) {
    }];
}



@end
