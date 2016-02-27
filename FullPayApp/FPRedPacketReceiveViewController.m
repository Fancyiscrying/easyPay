//
//  FPRedPacketReceiveViewController.m
//  FullPayApp
//
//  Created by 刘通超 on 14/12/3.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPRedPacketReceiveViewController.h"

#define ReceiveRedPacket @"获得<%@>的红包"

@interface FPRedPacketReceiveViewController ()<UITextViewDelegate,UIAlertViewDelegate>
@property (nonatomic, assign) float amt;
@property (nonatomic, copy) NSString *redPacketId;
@property (nonatomic, copy) NSString *distributeName;
@property (nonatomic, copy) NSString *distributeRemark;

@property (nonatomic, strong) UIImageView *firstImage;
@property (nonatomic, strong) UIImageView *detailImage;
@property (nonatomic, strong) UIImageView *noneImage;

@property (nonatomic, strong) UIView *thankBackView;
@property (nonatomic, strong) UITextView *thankTextView;
@end

@implementation FPRedPacketReceiveViewController

- (void)loadView{
    UIView *view = [[UIView alloc]initWithFrame:ScreenBounds];
    view.userInteractionEnabled = YES;
    self.view = view;
    self.title = @"红包详情";
    [self addFirstImageView];
    [self addDetilImageView];
    [self addNoneImageView];
    
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
    //[self createReceiveThanksView];
    // Do any additional setup after loading the view.
    //[self showImageView:_firstImage];
    [self receiveWithReceiveNo];
}

#pragma mark addView
- (void)addFirstImageView{
    _firstImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth*796/640)];
    _firstImage.image = MIMAGE(@"redPacket_dimsacn_first_BG");
    _firstImage.userInteractionEnabled = YES;
    
    UIImageView *centerImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth*339/426)];
    centerImage.center = CGPointMake(ScreenWidth/2, ScreenHigh/2-64);
    centerImage.image = MIMAGE(@"redPacket_dimsacn_first_center");
    centerImage.userInteractionEnabled = YES;
    [_firstImage addSubview:centerImage];
    
    UIImageView *topImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth-100, (ScreenWidth-100)*53/339)];
    topImage.center = CGPointMake(0, centerImage.top/2);
    topImage.left = 20;
    topImage.image = MIMAGE(@"redPacket_dimsacn_first_top");
    topImage.userInteractionEnabled = YES;

    [_firstImage addSubview:topImage];
    
    UIImage *image = MIMAGE(@"redPacket_dimsacn_first_bottom");
    //image = [image stretchableImageWithLeftCapWidth:0 topCapHeight:100];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(120,0,2,0) resizingMode:UIImageResizingModeStretch];
    UIImageView *bottomImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, centerImage.bottom-50, ScreenWidth, ScreenHigh-64-centerImage.bottom+50)];
    bottomImage.bottom = ScreenHigh-64;
    bottomImage.image =image;
    bottomImage.userInteractionEnabled = YES;

    [_firstImage addSubview:bottomImage];

    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0,0, ScreenWidth, 20)];
    label.center = CGPointMake(ScreenWidth/2, ScreenHigh/2-64-30);
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = COLOR_STRING(@"#FFFFFF");
    label.font = [UIFont systemFontOfSize:13];
    label.text = [NSString stringWithFormat:ReceiveRedPacket,@"雷一闫福"];
    label.tag = 101;
    [_firstImage addSubview:label];
    
    UILabel *congratu = [[UILabel alloc]initWithFrame:CGRectMake(0,0, ScreenWidth, 40)];
    congratu.bottom = label.top;
    congratu.backgroundColor = [UIColor clearColor];
    congratu.textAlignment = NSTextAlignmentCenter;
    congratu.textColor = COLOR_STRING(@"#FFFFFF");
    congratu.font = [UIFont boldSystemFontOfSize:25];
    congratu.text = @"恭喜你!";
    [_firstImage addSubview:congratu];
    
    UIButton *buttonOpen = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonOpen.frame = CGRectMake((ScreenWidth-(_firstImage.width-100))/2,80, _firstImage.width-100, 40);
    [buttonOpen setTitleColor:COLOR_STRING(@"#FFFFFF") forState:UIControlStateNormal];
    [buttonOpen setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [buttonOpen setTitle:@"拆开红包" forState:UIControlStateNormal];
    buttonOpen.backgroundColor = COLOR_STRING(@"#FBB134");
    buttonOpen.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    buttonOpen.layer.masksToBounds = YES;
    buttonOpen.layer.cornerRadius = 5;
    buttonOpen.enabled = YES;
    [buttonOpen addTarget:self action:@selector(tapButtonUnpack:) forControlEvents:UIControlEventTouchUpInside];
    [bottomImage addSubview:buttonOpen];
    
    [_firstImage addSubview:bottomImage];

    _firstImage.hidden = YES;
    [self.view addSubview:_firstImage];
}
- (void)addDetilImageView{
    
    _detailImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHigh-64)];
    _detailImage.userInteractionEnabled = YES;
    _detailImage.backgroundColor  = [UIColor blackColor];
    
    
    UIImageView *topImage = [[UIImageView alloc]initWithFrame:CGRectMake((ScreenWidth - ScreenWidth*253/320)/2, 0,ScreenWidth*253/320, ScreenWidth*253/320*206/380)];
    topImage.image = MIMAGE(@"redPacket_dimsacn_detail_top");
    [_detailImage addSubview:topImage];

    UIImage *image = MIMAGE(@"redPacket_dimsacn_detail_BG");
    image = [image stretchableImageWithLeftCapWidth:96 topCapHeight:5];
    UIImageView *bgImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, topImage.bottom/2+5, ScreenWidth, ScreenHigh-64-topImage.bottom/2)];
    bgImage.userInteractionEnabled = YES;
    bgImage.image = image;
    [_detailImage insertSubview:bgImage belowSubview:topImage];
    
    UILabel *labelMoney = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 25)];
    labelMoney.center = CGPointMake(ScreenWidth/2, ScreenHigh/2-24);
    labelMoney.backgroundColor = [UIColor clearColor];
    labelMoney.textAlignment = NSTextAlignmentCenter;
    labelMoney.font = [UIFont boldSystemFontOfSize:25];
    labelMoney.text = [NSString stringWithFormat:@"100.00  元"];
    labelMoney.textColor = COLOR_STRING(@"#FFFFFF");
    labelMoney.tag = 202;
    [_detailImage addSubview:labelMoney];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, labelMoney.top-30, ScreenWidth, 20)];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:13];
    label.text = [NSString stringWithFormat:ReceiveRedPacket,@"雷一闫福"];
    label.textColor = COLOR_STRING(@"#FFFFFF");
    label.tag = 201;
    [_detailImage addSubview:label];
    
    UILabel *congratu = [[UILabel alloc]initWithFrame:CGRectMake(0,0, ScreenWidth, 40)];
    congratu.bottom = label.top;
    congratu.backgroundColor = [UIColor clearColor];
    congratu.textAlignment = NSTextAlignmentCenter;
    congratu.textColor = COLOR_STRING(@"#FFFFFF");
    congratu.font = [UIFont boldSystemFontOfSize:25];
    congratu.text = @"恭喜你!";
    [_detailImage addSubview:congratu];

    
    UILabel *labelRemark = [[UILabel alloc]initWithFrame:CGRectMake((ScreenWidth -topImage.width+40)/2, labelMoney.bottom+10, topImage.width-40, 20)];
    labelRemark.backgroundColor = [UIColor clearColor];
    labelRemark.textAlignment = NSTextAlignmentCenter;
    labelRemark.font = [UIFont systemFontOfSize:14];
    labelRemark.text = [NSString stringWithFormat:@"恭喜发财！合家欢乐团团圆圆和和美美幸幸福福"];
    labelRemark.textColor = COLOR_STRING(@"#FFFFFF");
    labelRemark.tag = 203;
    [_detailImage addSubview:labelRemark];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(ScreenWidth*3/10, _detailImage.bottom-150, 2*ScreenWidth/5, 35);
    [button setTitleColor:COLOR_STRING(@"#FF5B5C") forState:UIControlStateNormal];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [button setBackgroundColor:COLOR_STRING(@"#FFDD5F")];
    [button setTitle:@"留言答谢" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:18];
    [button addTarget:self action:@selector(tapButtonThanks) forControlEvents:UIControlEventTouchUpInside];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 5;
    [_detailImage addSubview:button];
    
    _detailImage.hidden = YES;
    
    [self.view addSubview:_detailImage];
}
- (void)addNoneImageView{
    
    _noneImage = [[UIImageView alloc] initWithFrame:self.view.bounds];
    _noneImage.backgroundColor = COLOR_STRING(@"#EC4A4D");
    //_noneImage.image = [UIImage imageNamed:@"BG"];
    _noneImage.userInteractionEnabled = YES;
    [self.view addSubview:_noneImage];
    
    UIImageView *none = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 266, 356)];
    //none.image = MIMAGE(@"redPacket_dimsacn_none_none");
    none.center = CGPointMake(ScreenWidth/2, ScreenHigh/2-44);
    none.backgroundColor  = [UIColor clearColor];
    none.tag = 102;
    _noneImage.hidden = YES;
    [_noneImage addSubview:none];
    
}

- (void)createReceiveThanksView{
    if (_thankBackView == nil) {
        _thankBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHigh)];
        _thankBackView.backgroundColor = [UIColor clearColor];
        _thankBackView.hidden = NO;
        [self.navigationController.view addSubview:_thankBackView];
        
        UIView *backView = [[UIView alloc]initWithFrame:_thankBackView.bounds];
        backView.backgroundColor = [UIColor blackColor];
        backView.alpha = 0.8;
        [_thankBackView addSubview:backView];
        
        UIView *thankView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth-40, 220)];
        thankView.center = CGPointMake(_thankBackView.width/2, _thankBackView.height/2-20);
        thankView.backgroundColor = [UIColor whiteColor];
        thankView.layer.masksToBounds = YES;
        thankView.layer.cornerRadius = 5;
        thankView.tag = 101;
        [_thankBackView addSubview:thankView];
        
        UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, thankView.width, 40)];
        title.textAlignment = NSTextAlignmentCenter;
        title.font = [UIFont boldSystemFontOfSize:18];
        title.text = @"留言答谢";
        [thankView addSubview:title];
        
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelButton.frame = CGRectMake(15, 10, 20, 20);
        [cancelButton addTarget:self action:@selector(tapCancelButton) forControlEvents:UIControlEventTouchUpInside];
        [cancelButton setImage:MIMAGE(@"positivePayView_cancel_nomal.png") forState:UIControlStateNormal];
        [cancelButton setImage:MIMAGE(@"positivePayView_cancel_click.png") forState:UIControlStateSelected];
        [thankView addSubview:cancelButton];

        _thankTextView = [[FPTextView alloc] initWithFrame:CGRectMake(10, title.bottom+10, thankView.width-20, 100)];
        _thankTextView.textAlignment = NSTextAlignmentLeft;
        _thankTextView.backgroundColor = COLOR_STRING(@"#EDF1F0");
        _thankTextView.keyboardType = UIKeyboardTypeDefault;
        _thankTextView.font = [UIFont systemFontOfSize:16];
        _thankTextView.text = @"恭喜发财!";
        //_redPacketRemark.textColor  = [UIColor lightGrayColor];
        _thankTextView.delegate = self;
        _thankTextView.layer.masksToBounds = YES;
        _thankTextView.layer.cornerRadius = 5;
        [thankView addSubview:_thankTextView];

        UIButton *thanksButton = [UIButton buttonWithType:UIButtonTypeCustom];
        thanksButton.frame = CGRectMake(30, _thankTextView.bottom+20, thankView.width-60, 35);
        [thanksButton addTarget:self action:@selector(tapThanksButton) forControlEvents:UIControlEventTouchUpInside];
        [thanksButton setTitle:@"答谢" forState:UIControlStateNormal];
        [thanksButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [thanksButton setBackgroundImage:MIMAGE(COMM_BTN_BLUE) forState:UIControlStateNormal];
        [thanksButton setBackgroundImage:MIMAGE(COMM_BTN_GRAY) forState:UIControlStateDisabled];
        thanksButton.tag = 102;
        [thankView addSubview:thanksButton];
        
        thanksButton.layer.masksToBounds = YES;
        thanksButton.layer.cornerRadius = 5;
        
        [thankView addSubview:thanksButton];
        
    }else{
        _thankBackView.hidden = NO;
    }
}

- (void)showImageView:(UIImageView *)imageView{
    NSArray *imageViews = @[_firstImage,_detailImage,_noneImage];
    for (UIImageView *temp in imageViews) {
        temp.hidden = (temp == imageView) ? NO : YES;
    }
}

- (void)refreshView{
    UILabel *label = (UILabel *)[_firstImage viewWithTag:101];
    label.text = [NSString stringWithFormat:ReceiveRedPacket,_distributeName];
    
    UILabel *label2 = (UILabel *)[_detailImage viewWithTag:201];
    label2.text = [NSString stringWithFormat:ReceiveRedPacket,_distributeName];
    
    UILabel *label3 = (UILabel *)[_detailImage viewWithTag:202];
    label3.text = [NSString stringWithFormat:@"%0.2f  元",_amt/100];
    
    UILabel *label4 = (UILabel *)[_detailImage viewWithTag:203];
    label4.text = _distributeRemark;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark buttonActions

- (void)tapButtonUnpack:(id)sender{
 
    [UIView animateWithDuration:0.5 animations:^{
        [self showImageView:_detailImage];
    }];
}

- (void)tapButtonThanks{
    [self createReceiveThanksView];
}

- (void)tapCancelButton{
    _thankBackView.hidden = YES;
}

- (void)tapThanksButton{
    [self.view endEditing:YES];
    NSString *thanksText = [_thankTextView.text trimOnlySpace];
    if (thanksText.length > 0) {
        [self receiveRemarkWith:thanksText];
    }else{
        
    }

}

#pragma mark UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView{
    UIView *thank = (UIView *)[_thankBackView viewWithTag:101];
    float bottom = thank.bottom-40;
    float temp = _thankBackView.height - bottom;
    if (temp-216-50 < 0) {
        [self setThankViewTranfromWithY:temp-216-50];
    }

}
- (void)textViewDidEndEditing:(UITextView *)textView{
    NSString *thanksText = [_thankTextView.text trimOnlySpace];
    UIButton *button =(UIButton *) [_thankBackView viewWithTag:102];
    button.enabled = thanksText.length>0 ? YES : NO;
    
    [self setThankViewTranfromWithY:0];

}
#pragma mark viewAnimate

- (void)setThankViewTranfromWithY:(CGFloat)Y{
    CGAffineTransform transFormY = CGAffineTransformMakeTranslation(0, Y);
    [UIView animateWithDuration:0.3 animations:^{
        UIView *thank = (UIView *)[_thankBackView viewWithTag:101];
        thank.transform = transFormY;
        
    }];
}
#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 103) {
        _thankBackView.hidden = YES;
        NSArray *controllers = self.navigationController.viewControllers;
        for (UIViewController *temp in controllers) {
            if ([temp isMemberOfClass:NSClassFromString(@"FPRedPacketHomeViewController")]) {
                [self.navigationController popToViewController:temp animated:NO];
                return;
            }
        }
        [self.navigationController popToRootViewControllerAnimated:NO];
    }
}

#pragma mark NetWorking

- (void)receiveRemarkWith:(NSString *)remark{
    
    //禁用答谢按钮
    UIButton *button =  (UIButton *)[_thankBackView viewWithTag:102];
    button.enabled = NO;
    
    FPClient *client = [FPClient sharedClient];
    NSDictionary *paramters = [client receiveRemarkWithRedPacketId:_redPacketId andRemark:remark];
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    [UtilTool showHUD:@"正在处理" andView:self.view andHUD:hud];

    [client POST:kFPPost parameters:paramters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [hud hide:YES];
        button.enabled = YES;
        if ([[responseObject objectForKey:@"result"] boolValue] == YES) {
            
            UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"答谢成功!" message:nil delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
            alter.tag = 103;
            [alter setContentMode:UIViewContentModeCenter];
            [alter show];
            
        }else{
            NSString *errInfo = [responseObject objectForKey:@"errorInfo"];
            UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"答谢失败!" message:errInfo delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
            
            [alter setContentMode:UIViewContentModeCenter];
            [alter show];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [hud hide:YES];
        button.enabled = YES;

        FPDEBUG(@"%@",error);
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"网络连接失败,请查看网络是否连接正常！" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];

    }];

}
/*
 responseObject9:{
 errorCode = "";
 errorInfo = "";
 result = 1;
 returnObj =     {
 amt = 1;
 distributeName = "\U5218\U901a\U8d85";
 distributeNo = 1647399171476383715;
 distributeRemark = "\U606d\U559c\U53d1\U8d22\Uff01";
 id = 647417571004572277;
 };
 validateCode = "";
 }
 */
- (void)receiveWithReceiveNo{
    FPClient *client = [FPClient sharedClient];
    NSDictionary *paramters9 = [client receiveWithReceiveNo:_receiveNo andMemberNo:[Config Instance].personMember.memberNo];
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    [UtilTool showHUD:@"正在处理" andView:self.view andHUD:hud];
    [client POST:kFPPost parameters:paramters9 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [hud hide:YES];
        if ([[responseObject objectForKey:@"result"] boolValue] == YES) {
            NSDictionary *arrtibutes = [responseObject objectForKey:@"returnObj"];
            _amt = [[arrtibutes objectForKey:@"amt"] floatValue];
            _distributeName = [arrtibutes objectForKey:@"distributeName"];
            _distributeRemark = [arrtibutes objectForKey:@"distributeRemark"];
            _redPacketId = [arrtibutes objectForKey:@"id"];
            
            [self refreshView];
            [self showImageView:_firstImage];
        }else {
            NSString *errorCode = [responseObject objectForKey:@"errorCode"];
            UIImageView *none = (UIImageView *)[_noneImage viewWithTag:102];
            if ([errorCode isEqualToString:@"mkt_rp_receive_more_than_limit"]) {
                //已经领过
                none.image = MIMAGE(@"redPacket_dimsacn_none_limt");
            }else if ([errorCode isEqualToString:@"mkt_rp_red_packet_received"]){
                //已经被别人领过
                none.image = MIMAGE(@"redPacket_dimsacn_none_none");
            }else{
                none.image = MIMAGE(@"redPacket_dimsacn_none_none");
            }
            [self showImageView:_noneImage];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [hud hide:YES];
        FPDEBUG(@"%@",error);
        [self showToastMessage:kNetworkErrorMessage];
    }];
    
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
