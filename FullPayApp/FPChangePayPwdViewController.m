//
//  FPChangePayPwdViewController.m
//  FullPayApp
//
//  Created by mark zheng on 14-2-27.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPChangePayPwdViewController.h"
#import "ZHCheckBoxButton.h"

@interface FPChangePayPwdViewController ()<ZHCheckBoxButtonDelegate,FPPassCodeViewDelegate>

@property (nonatomic,strong) NSString *orgPwd;
@property (nonatomic,strong) NSString *pwd;

@end

@implementation FPChangePayPwdViewController

-(void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    
    UIImageView *background = [[UIImageView alloc] initWithFrame:view.bounds];
    background.image = [UIImage imageNamed:@"BG"];
    [view addSubview:background];
    
    self.fieldOrgPwd = [[FPPassCodeView alloc] initWithFrame:CGRectMake(20, 22, 278, 70) withSimple:YES];
    self.fieldOrgPwd.securet = YES;
    self.fieldOrgPwd.delegate = self;
    self.fieldOrgPwd.titleLabel.text = @"当前支付密码:";
    
    [view addSubview:self.fieldOrgPwd];
    
    self.fieldPwd = [[FPPassCodeView alloc] initWithFrame:CGRectMake(20, 100, 278, 70) withSimple:YES];
    self.fieldPwd.securet = YES;
    self.fieldPwd.titleLabel.text = @"新的支付密码:";
    self.fieldPwd.delegate = self;
    [view addSubview:self.fieldPwd];
    
    /* 密码可见button */
    NSString *pwdString = @"显示密码";
    ZHCheckBoxButton *boxButton = [[ZHCheckBoxButton alloc] initWithFrame:CGRectMake(20, 180, 80, 15)];
    [boxButton.label setText:pwdString];
    [boxButton setChecked:NO];
    boxButton.delegate = self;
    [view addSubview:boxButton];
    
    UILabel *tip = [[UILabel alloc] init];
    tip.frame = CGRectMake(122, 177, 278, 21);
    tip.text = @"提示：支付密码由6位数字组成";
    tip.textColor = MCOLOR(@"text_color");
    tip.font = [UIFont systemFontOfSize:10.0f];
    tip.backgroundColor = [UIColor clearColor];
    tip.textAlignment = NSTextAlignmentLeft;
    tip.numberOfLines = 0;
    [view addSubview:tip];
    
    UIButton *btnNextStep = [UIButton buttonWithType:UIButtonTypeCustom];
    btnNextStep.frame = CGRectMake(15, 205, 290, 45);
    [btnNextStep setBackgroundImage:MIMAGE_COLOR_SIZE([UIColor orangeColor],btnNextStep.frame.size) forState:UIControlStateNormal];
    [btnNextStep setBackgroundImage:MIMAGE_COLOR_SIZE([UIColor darkGrayColor],btnNextStep.frame.size) forState:UIControlStateDisabled];
    [btnNextStep setTitle:@"确定" forState:UIControlStateNormal];
    [btnNextStep setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnNextStep addTarget:self action:@selector(clickConfirm:) forControlEvents:UIControlEventTouchUpInside];
    btnNextStep.tag = 101;
    btnNextStep.enabled = NO;
    [view addSubview:btnNextStep];
    
    self.view = view;
}

#pragma mark FPPassCodeView delegate
-(void)passCodeView:(FPPassCodeView *)sender checkPassCodeLength:(NSString *)passCode{
    UIButton *btn_NextStep = (UIButton *)[self.view viewWithTag:101];
    
    if(self.fieldOrgPwd.passcode.length == 6 && self.fieldPwd.passcode.length == 6){
        btn_NextStep.enabled = YES;
    }else{
        btn_NextStep.enabled = NO;
    }

}

#pragma mark ZHCheckBoxButton delegate
- (void)onCheckButtonClicked:(id)control{
    [self fieldResignFirstResponder];
    self.fieldOrgPwd.securet = !self.fieldOrgPwd.securet;
    self.fieldPwd.securet = !self.fieldPwd.securet;
    
    //刷新视图
    [self.fieldOrgPwd refeshView];
    [self.fieldPwd refeshView];
}
-(void)fieldResignFirstResponder
{
    if ([self.fieldOrgPwd isFirstResponder]) {
        [self.fieldOrgPwd resignFirstResponder];
    }
    
    if ([self.fieldPwd isFirstResponder]) {
        [self.fieldPwd resignFirstResponder];
    }
}


#pragma mark - view lifecycle
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.fieldOrgPwd becomeFirstResponse];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.fieldOrgPwd clearPasscode];
    [self.fieldPwd clearPasscode];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    /* 导航栏设置*/
    self.navigationItem.title = @"修改手机支付密码";
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGFloat offset = 0;
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self.view];
    CGPoint imagePoint = self.fieldOrgPwd.frame.origin;
    imagePoint.y += offset;
    
    CGPoint pwdPoint = self.fieldPwd.frame.origin;
    pwdPoint.y += offset;
    
    NSLog(@"x,y:%f,%f",touchPoint.x,touchPoint.y);
    NSLog(@"%f,%f,%f,%f",imagePoint.x,imagePoint.y,self.fieldOrgPwd.frame.size.width,self.fieldOrgPwd.frame.size.height);
    
    //touchPoint.x ，touchPoint.y 就是触点的坐标
    if(imagePoint.x <= touchPoint.x && imagePoint.x +self.fieldOrgPwd.frame.size.width >=touchPoint.x && imagePoint.y <=  touchPoint.y && imagePoint.y+self.fieldOrgPwd.frame.size.height-offset >= touchPoint.y)
    {
        NSLog(@"1");
        if ([self.fieldPwd isFirstResponse]) {
            [self.fieldPwd resignFirstResponse];
        }
        
        [self.fieldOrgPwd becomeFirstResponse];
    } else if(pwdPoint.x <= touchPoint.x && pwdPoint.x +self.fieldPwd.frame.size.width >=touchPoint.x && pwdPoint.y <=  touchPoint.y && pwdPoint.y+self.fieldPwd.frame.size.height-offset >= touchPoint.y) {
        NSLog(@"2");
        if ([self.fieldOrgPwd isFirstResponse]) {
            [self.fieldOrgPwd resignFirstResponse];
        }
        
        [self.fieldPwd becomeFirstResponse];
    } else {
        NSLog(@"3");
        if ([self.fieldPwd isFirstResponse]) {
            [self.fieldPwd resignFirstResponse];
        }
        
        if ([self.fieldOrgPwd isFirstResponse]) {
            [self.fieldOrgPwd resignFirstResponse];
        }
    }
}

/*navigationbar leftbutton*/
-(void)clickLeftButton:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setFieldOrgPwd:nil];
    [self setFieldPwd:nil];
    [self setBtnShowPwd:nil];
    [super viewDidUnload];
}

- (void)clickConfirm:(UIButton *)sender {
    self.orgPwd = [self.fieldOrgPwd.passcode trimSpace];
    self.pwd = [self.fieldPwd.passcode trimSpace];
    
    if ([self.orgPwd checkPayPwd] == NO) {
        [self.fieldOrgPwd clearPasscode];
        
        [self.fieldOrgPwd becomeFirstResponse];
        return;
    }
    if ([self.pwd checkPayPwd] == NO) {
        [self.fieldPwd clearPasscode];
        [self.fieldPwd becomeFirstResponse];
        return;
    }
    
    NSString *memberNo = [Config Instance].memberNo;
    FPClient *urlClient = [FPClient sharedClient];
    NSDictionary *parameters = [urlClient userChangePayPwd:memberNo andPwd:self.pwd andOrgPwd:self.orgPwd];
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    [UtilTool showHUD:@"正在处理" andView:self.view andHUD:hud];
    [urlClient POST:kFPPost parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [hud hide:YES];
        NSLog(@"%@",responseObject);
        if ([[responseObject objectForKey:@"result"] boolValue] == YES) {

            UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"修改支付密码完成" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            
            [alter setContentMode:UIViewContentModeCenter];
            [alter show];
            
            [self.navigationController popViewControllerAnimated:YES];

            
            
        }else{
            NSString *errInfo = [responseObject objectForKey:@"errorInfo"];
            UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"修改支付密码失败" message:errInfo delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            
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

@end
