//
//  FPRedPacketHomeViewController.m
//  FullPayApp
//
//  Created by 刘通超 on 14/12/1.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPRedPacketHomeViewController.h"
#import "FPDispatchRedPacketViewController.h"
#import "FPDispatch2DCodeViewController.h"
#import "FPRedPacketSetViewController.h"
#import "FPRedPacketGroupListViewController.h"
#import "FPDimScanViewController.h"
#import "FPNavigationViewController.h"
#import "FPRedPacketWithDrawCashViewController.h"


#import "FPRedPackteInfo.h"

@interface FPRedPacketHomeViewController (){
    BOOL _hasRedPackteDistrbute;
}
@property (nonatomic, strong)UILabel *lbl_withDrawCash;
@property (nonatomic, strong)FPRedPackteInfo *redPackteInfo;
@end

@implementation FPRedPacketHomeViewController

- (void)loadView{
    UIView *view = [[UIView alloc]initWithFrame:ScreenBounds];
    UIImageView *background = [[UIImageView alloc] initWithFrame:view.bounds];
    background.image = [UIImage imageNamed:@"BG"];
    [view addSubview:background];
    
//    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"redPacket_Dscan_right"] style:UIBarButtonItemStyleDone target:self action:@selector(tapButtonReceive)];
//    self.navigationItem.rightBarButtonItem = rightItem;
    
    
    UIButton * rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 26, 26)];
    [rightBtn setImage:[UIImage imageNamed:@"redPacket_Dscan_right"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(tapButtonReceive) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
    self.view = view;
    
    [self addRedPacketImage];
    [self addBottomView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    
    [self findCurrentRePacketInfo];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"富之富-红包";
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    self.navigationItem.backBarButtonItem = backItem;
    backItem.title = @"";
    
    //[self findCurrentRePacketInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark NetWorking
- (void)findCurrentRePacketInfo{
    FPClient *client = [FPClient sharedClient];
    NSDictionary *paramters = [client findCurrentRePacketInfoWithMemberNo:[Config Instance].personMember.memberNo];
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    [UtilTool showHUD:@"正在处理" andView:self.view andHUD:hud];
    [client POST:kFPPost parameters:paramters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [hud hide:YES];
        
        if ([[responseObject objectForKey:@"result"] boolValue] == YES) {
            NSDictionary *arrtibutes = [responseObject objectForKey:@"returnObj"];
            _redPackteInfo = [[FPRedPackteInfo alloc]initWithArrtibutes:arrtibutes];
            _hasRedPackteDistrbute = _redPackteInfo.haveRedPacketDistribute;
            [self refreshView];
                    }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [hud hide:YES];
        FPDEBUG(@"%@",error);
        [self showToastMessage:kNetworkErrorMessage];
    }];
}

#pragma mark addsubview

- (void)addRedPacketImage{
    //CGRectMake(ScreenWidth * 20/320, ScreenWidth * 20/320, ScreenWidth-(2*ScreenWidth * 20/320), ScreenWidth-(2*ScreenWidth * 20/320))
    UIImageView *image = [[UIImageView alloc]initWithFrame:ScreenBounds];
    image.userInteractionEnabled = YES;
    image.backgroundColor =COLOR_STRING(@"FF5B5C");
    
    //480 × 322
    
    UIImageView *imageView = [[UIImageView alloc]initWithImage:MIMAGE(@"redPacket_home_image")];
    imageView.frame = CGRectMake(0, 0, ScreenWidth, ScreenWidth*322/480);
    [image addSubview:imageView];
    
    float top = ScreenHigh > 560? imageView.bottom+47:imageView.bottom+30;
    UIButton *buttonDispacth = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonDispacth.frame = CGRectMake(0, top, image.width-80, 45);
    buttonDispacth.left = 40;
    [buttonDispacth setTitleColor:COLOR_STRING(@"FF5B5C") forState:UIControlStateNormal];
    [buttonDispacth setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    buttonDispacth.backgroundColor = COLOR_STRING(@"FFDD5F");
    [buttonDispacth setTitle:@"当土豪  发红包" forState:UIControlStateNormal];
    buttonDispacth.titleLabel.font = [UIFont boldSystemFontOfSize:20];

    [buttonDispacth addTarget:self action:@selector(tapButtonDispatch) forControlEvents:UIControlEventTouchUpInside];
    buttonDispacth.layer.masksToBounds = YES;
    buttonDispacth.layer.cornerRadius = 5;
    [image addSubview:buttonDispacth];
    
//    UIButton *buttonReceive = [UIButton buttonWithType:UIButtonTypeCustom];
//    buttonReceive.frame = CGRectMake(0, top, buttonDispacth.width, 40);
//    buttonReceive.left = image.width/2+5;
//    [buttonReceive setTitleColor:COLOR_STRING(@"FF5B5C") forState:UIControlStateNormal];
//    [buttonReceive setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
//    buttonReceive.backgroundColor = COLOR_STRING(@"FFDD5F");
//    [buttonReceive setTitle:@"扫码领红包" forState:UIControlStateNormal];
//    buttonReceive.titleLabel.font = [UIFont boldSystemFontOfSize:15];
//    
//    [buttonReceive addTarget:self action:@selector(tapButtonReceive) forControlEvents:UIControlEventTouchUpInside];
//    buttonReceive.layer.masksToBounds = YES;
//    buttonReceive.layer.cornerRadius = 5;
//    [image addSubview:buttonReceive];
    
    [image addSubview:[self createThreeButtons:buttonDispacth.bottom+21]];

    [self.view addSubview:image];
}

- (UIView*)createThreeButtons:(float)top{

    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(20, top, ScreenWidth-40, 20)];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, view.width/3, view.height);
    [button setTitleColor:COLOR_STRING(@"FFFFFF") forState:UIControlStateNormal];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [button setTitle:@"发出的红包" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button addTarget:self action:@selector(tapButtonFirst) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];

    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button2.frame = CGRectMake(view.width/3, 0, view.width/3, view.height);
    [button2 setTitleColor:COLOR_STRING(@"FFFFFF") forState:UIControlStateNormal];
    [button2 setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [button2 setTitle:@"领到的红包" forState:UIControlStateNormal];
    button2.titleLabel.font = [UIFont systemFontOfSize:14];

    [button2 addTarget:self action:@selector(tapButtonSecond) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button2];
    
    UIButton *button3 = [UIButton buttonWithType:UIButtonTypeCustom];
    button3.frame = CGRectMake(2 * view.width/3, 0, view.width/3, view.height);
    [button3 setTitleColor:COLOR_STRING(@"FFFFFF") forState:UIControlStateNormal];
    [button3 setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [button3 setTitle:@"红包设置" forState:UIControlStateNormal];
    button3.titleLabel.font = [UIFont systemFontOfSize:14];

    [button3 addTarget:self action:@selector(tapButtonThirst) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button3];
    
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(view.width/3, 0, 1.5 , view.height)];
    line1.backgroundColor = COLOR_STRING(@"FFFFFF");
    [view addSubview:line1];
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(2*view.width/3, 0, 1.5 , view.height)];
    line2.backgroundColor = COLOR_STRING(@"FFFFFF");
    [view addSubview:line2];
    
    return view;
}

- (void)addBottomView{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHigh-60-60, ScreenWidth, 60)];
    UIView *left = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth-70, view.height)];
    left.backgroundColor = COLOR_STRING(@"333333");
    
    _lbl_withDrawCash                 = [[UILabel alloc]initWithFrame:CGRectMake(10, 20, 3*left.width/4, 20)];
    _lbl_withDrawCash.backgroundColor = [UIColor clearColor];
    _lbl_withDrawCash.textColor       = COLOR_STRING(@"808080");
    _lbl_withDrawCash.text            = @"可提取现金：0.00 元";
    _lbl_withDrawCash.font            = [UIFont systemFontOfSize:14];
    [left addSubview:_lbl_withDrawCash];
    
    UIButton *refresh = [UIButton buttonWithType:UIButtonTypeCustom];
    refresh.frame = CGRectMake(0, 15, 30, 30);
    refresh.right = left.width - 30;
    [refresh setImage:MIMAGE(@"redPackte_home_refresh") forState:UIControlStateNormal];
    [refresh setBackgroundColor:[UIColor clearColor]];
    [refresh addTarget:self action:@selector(tapButtonRefresh) forControlEvents:UIControlEventTouchUpInside];
    [left addSubview:refresh];
    [view addSubview:left];
    
    UIButton *withdrawCash = [UIButton buttonWithType:UIButtonTypeCustom];
    withdrawCash.frame  = CGRectMake(left.right, 0, ScreenWidth-left.right, view.height);
    [withdrawCash setBackgroundColor:COLOR_STRING(@"FFDD5F")];
    [withdrawCash setTitle:@"提现" forState:UIControlStateNormal];
    withdrawCash.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [withdrawCash setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [withdrawCash addTarget:self action:@selector(tapButtonWithdrawCash) forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:withdrawCash];
    
    [self.view addSubview:view];
    
}

#pragma mark refreshView
- (void)refreshView{
    NSString *text =[NSString stringWithFormat:@"可提取现金：%0.2f 元",_redPackteInfo.accountBalance/100];
    NSMutableAttributedString *attribute = [text transformNumberColorOfString:COLOR_STRING(@"#FFFFFF")];
    _lbl_withDrawCash.attributedText = attribute;

}

#pragma mark buttonActions

- (void)tapButtonDispatch{
    if (_hasRedPackteDistrbute) {
        FPDispatch2DCodeViewController *controller = [[FPDispatch2DCodeViewController alloc]init];
        controller.currentRePacketId = _redPackteInfo.distributeItem.redPackteId;
        [self.navigationController pushViewController:controller animated:YES];
    }else{
        FPDispatchRedPacketViewController *controller =[[FPDispatchRedPacketViewController alloc]init];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (void)tapButtonRefresh{
    [self findCurrentRePacketInfo];
}

- (void)tapButtonWithdrawCash{
    FPRedPacketWithDrawCashViewController *controller = [[FPRedPacketWithDrawCashViewController alloc]init];
    controller.redPackteInfo = self.redPackteInfo;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)tapButtonFirst{
    FPRedPacketGroupListViewController *controller = [[FPRedPacketGroupListViewController alloc]init];
    controller.viewComeFrom = RedPacketGroupListViewFromDispatch;
    [self.navigationController pushViewController:controller animated:YES];
}
- (void)tapButtonSecond{
    FPRedPacketGroupListViewController *controller = [[FPRedPacketGroupListViewController alloc]init];
    controller.viewComeFrom = RedPacketGroupListViewFromRecevie;
    [self.navigationController pushViewController:controller animated:YES];
}
- (void)tapButtonThirst{
    FPRedPacketSetViewController *controller = [[FPRedPacketSetViewController alloc]init];
    controller.redPackteItem = self.redPackteInfo.distributeItem;
    [self.navigationController pushViewController:controller animated:YES];
}
- (void)tapButtonReceive{
    FPDimScanViewController *controller = [[FPDimScanViewController alloc] init];
    controller.viewComeFrom = DimScanViewComeFromRedPackte;
    
    [self.navigationController pushViewController:controller animated:YES];

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
