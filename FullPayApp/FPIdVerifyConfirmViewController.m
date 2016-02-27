//
//  FPIdVerifyConfirmViewController.m
//  FullPayApp
//
//  Created by mark zheng on 14-3-3.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPIdVerifyConfirmViewController.h"
#import "FPNameAndStaffIdViewController.h"
#import "UIButton+UIButtonImageWithLabel.h"
#import "FPTabBarViewController.h"
#import "FPMainViewController.h"
#import "FPBillDetailCell.h"
#import "FPLockViewController.h"

@interface FPIdVerifyConfirmViewController () <FPPassCodeViewDelegate,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

@property (strong, nonatomic) UITableView *tableView;

@property (nonatomic,strong) NSArray    *itemTitles;
@property (nonatomic,strong) NSArray    *itemDetails;

@end

@implementation FPIdVerifyConfirmViewController

static NSString *myTableViewCellIndentifier = @"itemIdVerifyConfirmCell";

- (void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    UIImageView *background = [[UIImageView alloc] initWithFrame:view.bounds];
    background.image = [UIImage imageNamed:@"BG"];
    [view addSubview:background];
    
    self.view = view;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(15, 10, 290, 170) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.scrollEnabled = NO;
    self.tableView.userInteractionEnabled = NO;
    //    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
    v.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:v];
    
    [self.view addSubview:self.tableView];
    
    self.imgLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 195, 320, 1)];
    self.imgLine.image = [UIImage imageNamed:@"confirmation_dottedline"];
    [self.view addSubview:self.imgLine];

    
    self.fld_PayPwd = [[FPPassCodeView alloc] initWithFrame:CGRectMake(20, 210, 278, 65) withSimple:YES];
    self.fld_PayPwd.titleLabel.text = @"请输入手机支付密码确认";
    //        self.fld_PayPwd.securet = NO;
    self.fld_PayPwd.delegate =self;
    [self.view addSubview:self.fld_PayPwd];
    
    self.btn_Refill = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btn_Refill.frame = CGRectMake(15, 210, 290, 45);
    [self.btn_Refill setBackgroundColor:[UIColor redColor]];
    [self.btn_Refill setTitle:@"重新填写" forState:UIControlStateNormal];
    [self.btn_Refill setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btn_Refill addTarget:self action:@selector(click_Refill:) forControlEvents:UIControlEventTouchUpInside];
    self.btn_Refill.hidden = YES;
    [self.view addSubview:self.btn_Refill];
    
    self.btn_Submit = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btn_Submit.frame = CGRectMake(15, 320, 290, 45);
    [self.btn_Submit setBackgroundImage:MIMAGE(COMM_BTN_YELL) forState:UIControlStateNormal];
    [self.btn_Submit setBackgroundImage:MIMAGE(COMM_BTN_GRAY) forState:UIControlStateDisabled];

    [self.btn_Submit setTitle:@"确定" forState:UIControlStateNormal];
    [self.btn_Submit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btn_Submit addTarget:self action:@selector(click_NextStep:) forControlEvents:UIControlEventTouchUpInside];
    self.btn_Submit.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    self.btn_Submit.enabled = NO;
    [self.view addSubview:self.btn_Submit];
    
    self.btn_BackHomeView = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btn_BackHomeView.frame = CGRectMake(15, 390, 290, 30);
    self.btn_BackHomeView.top = self.btn_Submit.bottom +20;
    [self.btn_BackHomeView setTitle:@"放弃，返回首页" forState:UIControlStateNormal];
    [self.btn_BackHomeView setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    self.btn_BackHomeView.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    [self.btn_BackHomeView addLine:self.btn_BackHomeView];
    [self.btn_BackHomeView addTarget:self action:@selector(click_BackHomeView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btn_BackHomeView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.title = @"信息确认 3/3";
    self.navigationController.navigationBar.translucent = NO;
    
    [self.tableView
     registerClass:[FPBillDetailCell class] forCellReuseIdentifier:myTableViewCellIndentifier];
    
    self.itemTitles = @[@"姓名",@"工号",@"身份证号码"];
    if (self.idVerifyInfo) {
        self.itemDetails = @[self.idVerifyInfo.realName,self.idVerifyInfo.staffId,self.idVerifyInfo.certNo];
    }
    
    [self.tableView reloadData];
    
    if (self.result) {
        self.imgLine.hidden = NO;
        self.fld_PayPwd.hidden = NO;
        self.btn_Submit.hidden = NO;
        
        self.btn_Refill.hidden = YES;
    } else {
        self.imgLine.hidden = YES;
        self.fld_PayPwd.hidden = YES;
        self.btn_Submit.hidden = YES;
        
        self.btn_Refill.hidden = NO;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)click_Refill:(UIButton *)sender
{
    BOOL found = NO;
    for (id controller in [self.navigationController viewControllers]) {
        if ([controller isKindOfClass:[FPNameAndStaffIdViewController class]]) {
            found = YES;
            [self.navigationController popToViewController:controller animated:YES];
            break;
        }
    }
    
    if (found == NO) {
        FPNameAndStaffIdViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"FPTabBarView"];
        [controller setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
        [self presentViewController:controller animated:YES completion:^{
            
        }];
    }
}

- (void)click_NextStep:(UIButton *)sender
{
    NSString *memberNo = [Config Instance].memberNo;
    
    NSString *payPWD = self.fld_PayPwd.passcode;
    self.idVerifyInfo.pwd = payPWD;
    
    FPClient *urlClient = [FPClient sharedClient];
    NSDictionary *parameters = [urlClient userIdCheckSubmit:memberNo andMemberName:self.idVerifyInfo.realName andCertNo:self.idVerifyInfo.certNo andCertTypeCode:self.idVerifyInfo.certType andJobNumFoxconn:self.idVerifyInfo.staffId andPayPwd:self.idVerifyInfo.pwd];
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    [UtilTool showHUD:@"正在处理中" andView:self.view andHUD:hud];
    
    [urlClient POST:kFPPost parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [hud hide:YES];
        FPDEBUG(@"%@",responseObject);
        if ([[responseObject objectForKey:@"result"] boolValue] == YES) {
            
            //同步更新个人信息
            FPPersonMember *person = [Config Instance].personMember;
            person.nameAuthFlag = YES;
            person.certNo = self.idVerifyInfo.certNo;
            person.certTypeCode = self.idVerifyInfo.certType;
            person.memberName = self.idVerifyInfo.realName;
            [[Config Instance] setPersonMember:person];
            
            UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"提示" message:@"恭喜，您的实名认证已提交成功！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            alter.tag = 101;
            alter.delegate = self;
            [alter setContentMode:UIViewContentModeCenter];
            [alter show];
            
            
        }else{
            NSString *errInfo = [responseObject objectForKey:@"errorInfo"];
            UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"实名认证失败" message:errInfo delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            
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

- (void)click_BackHomeView:(UIButton *)sender{
    [UtilTool setHomeViewRootController];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (![self.fld_PayPwd isHidden]) {
        if ([self.fld_PayPwd isFirstResponse]) {
            [self.fld_PayPwd resignFirstResponse];
            [self.view setFrame:CGRectMake(0, 64, 320, self.view.bounds.size.height)];
        } else {
            [self.fld_PayPwd becomeFirstResponse];
            
            /*iphone 键盘高度216*/
            CGFloat cy = self.fld_PayPwd.frame.origin.y + self.fld_PayPwd.frame.size.height;
            if (cy > self.view.bounds.size.height - 216.0) {
                
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:0.2];
                [self.view setFrame:CGRectMake(0,-cy + self.view.bounds.size.height - 216 - 44,320,self.view.frame.size.height)];
                [UIView commitAnimations];
            }
        }
    }
}
#pragma mark UIAlertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 101) {
        NSArray *controllers = self.navigationController.viewControllers;
        for (UIViewController *controller in controllers) {
            if ([controller isKindOfClass:NSClassFromString(@"FPRechargeConfirmViewController")]) {
                [self.navigationController popToViewController:controller animated:NO];
                
                return;
            }
        }
        
        [UtilTool setHomeViewRootController];
    }
}
#pragma mark - FPPassCodeView delegate
-(void)handleCompleteField:(FPPassCodeView*)sender
{
    [self.view setFrame:CGRectMake(0, 64, 320, self.view.bounds.size.height)];
}
-(void)passCodeView:(FPPassCodeView *)sender checkPassCodeLength:(NSString *)passCode;{
    
    if(passCode.length == 6){
        self.btn_Submit.enabled = YES;
    }else{
        self.btn_Submit.enabled = NO;
    }
    
}

#pragma mark table view datasource methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.itemTitles count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FPBillDetailCell* cell;
    if ([tableView respondsToSelector:@selector(dequeueReusableCellWithIdentifier:forIndexPath:)]) {
        cell = [tableView dequeueReusableCellWithIdentifier:myTableViewCellIndentifier forIndexPath:indexPath];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:myTableViewCellIndentifier];
        if (cell == nil) {
            cell = [[FPBillDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myTableViewCellIndentifier];
        }
    }
    
    cell.textLabel.text = self.itemTitles[indexPath.row];
    cell.detailTextLabel.text = self.itemDetails[indexPath.row];
    
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGRect  tableRect = tableView.frame;
    UIView *headView = [[UIView alloc] initWithFrame:tableRect];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 30, 30)];
    
    NSString *imgName = @"billdet_ic_right";
    if (self.result) {
        imgName = @"billdet_ic_right";
    } else {
        imgName = @"billdet_ic_error";
    }
    
    UIImage *image = [UIImage imageNamed:imgName];
    imgView.image = image;
    [headView addSubview:imgView];
    
    CGRect lblFrame = CGRectOffset(imgView.frame, 40, 0);
    lblFrame.size.width = 260.0f;
    lblFrame.size.height = 30.0f;
    UILabel *lblView = [[UILabel alloc] init];
    lblView.frame = lblFrame;
    if (self.result) {
        lblView.text = @"实名信息一经确认，不可修改!";
        lblView.textColor = MCOLOR(@"color_billdetail_label");
    } else {
        lblView.text = @"您的实名信息不匹配，请重新填写";
        lblView.textColor = [UIColor redColor];
    }
    
    lblView.font = [UIFont systemFontOfSize:15.0f];
    [headView addSubview:lblView];
    
    return headView;
}

#pragma mark tableview data delegate methods
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 50.0f;
    }
    return 18.0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
