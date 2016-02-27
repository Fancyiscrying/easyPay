//
//  FPSecuritySetViewController.m
//  FullPayApp
//
//  Created by mark zheng on 14-2-17.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPSecuritySetViewController.h"
#import "FPLockViewController.h"
#import "FPChangeLoginPwdViewController.h"
#import "FPChangePayPwdViewController.h"
#import "FPCaptchaViewController.h"
#import "AESCrypt.h"
#import "FPCheckUserIdViewController.h"
#import "FPPaySecretCodeViewController.h"

#define USER_PASSWORD @"userpassword"

@interface FPSecuritySetViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>

@property (nonatomic,strong) NSArray *itemTitles;
@property (nonatomic,strong) UIButton *btn_Switch;

@end

@implementation FPSecuritySetViewController

static NSString *myTableViewCellIndentifier = @"itemSecurityCell";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tabBarController.tabBar setHidden:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.title = @"密码管理";
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    self.navigationItem.backBarButtonItem = backItem;
    backItem.title = @"";
    
    [self.tableView
     registerClass:[UITableViewCell class] forCellReuseIdentifier:myTableViewCellIndentifier];
    
    NSArray *names1 = @[@"修改手机支付密码",@"找回手机支付密码",@"修改登录密码"];
    NSArray *names2 = @[@"手势密码",@"修改手势密码"];
    NSArray *names3 = @[@"手机宝令"];

    self.itemTitles = @[names1,names2,names3];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.scrollEnabled = NO;
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
    v.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:v];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark table view datasource methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.itemTitles.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.itemTitles[section] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell;
    if ([tableView respondsToSelector:@selector(dequeueReusableCellWithIdentifier:forIndexPath:)]) {
        cell = [tableView dequeueReusableCellWithIdentifier:myTableViewCellIndentifier forIndexPath:indexPath];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:myTableViewCellIndentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myTableViewCellIndentifier];
        }
    }
    
    cell.textLabel.text = [self.itemTitles[indexPath.section] objectAtIndex:[indexPath row]];
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
    //    cell.textLabel.textColor = MCOLOR(@"text_color");
    
    UIImageView *accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_ic_enter"]];
    cell.accessoryView = accessoryView;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            //读取手势密码
            NSString *tel = [Config Instance].personMember.mobile;
            NSString *pattern = [FPTelGesturePWD objectValueForKey:tel];
            BOOL isPatternSet;
            if ([pattern isEqualToString:SET_GESUTREPWD_OFF]||[pattern isEqualToString:EVER_SET_GESUTREPWD]) {
                isPatternSet = NO;
            }else{
                isPatternSet = YES;
            }
            
            self.btn_Switch = [UIButton buttonWithType:UIButtonTypeCustom];
            self.btn_Switch.frame = CGRectMake(0, 0, 54.0, 26.0f);
            [self.btn_Switch setImage:[UIImage imageNamed:@"myfutong_bt_off"] forState:UIControlStateNormal];
            [self.btn_Switch setImage:[UIImage imageNamed:@"myfutong_bt_on"] forState:UIControlStateSelected];
            [self.btn_Switch addTarget:self action:@selector(click_switch:) forControlEvents:UIControlEventTouchUpInside];
            self.btn_Switch.selected = isPatternSet;
            cell.accessoryView = self.btn_Switch;
        }
    }
    
    return cell;
}

#pragma mark tableview data delegate methods
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    return 18.0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            //修改支付密码
            FPChangePayPwdViewController *controller = [[FPChangePayPwdViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        } else if (indexPath.row == 1) {
            //找回支付密码
            if ([Config Instance].personMember.nameAuthFlag) {
                FPCheckUserIdViewController *controller = [[FPCheckUserIdViewController alloc] init];
                controller.comeFrom = ComeFromSecuritySetView;
                [self.navigationController pushViewController:controller animated:YES];
            }else{
                FPCaptchaViewController *controller = [[FPCaptchaViewController alloc] init];
                [self.navigationController pushViewController:controller animated:YES];
                
            }
            
        } else {
            //修改登录密码
            FPChangeLoginPwdViewController *controller = [[FPChangeLoginPwdViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        }
    } else if (indexPath.section == 1){
        //修改手势密码
        if (indexPath.row == 1) {
            BOOL isPatternSet = self.btn_Switch.selected;
            if (isPatternSet) {
                [self checkLoginPwdWithTag:101];
            }
        }
    }else if (indexPath.section == 2){
        //手机宝令
        FPPaySecretCodeViewController *controller = [[FPPaySecretCodeViewController alloc]init];
        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (void)checkLoginPwdWithTag:(NSInteger)tagValue
{
    NSString *phoneNumber = [NSString stringWithFormat:@"富之富账户:%@",[Config Instance].personMember.mobile];
    UIAlertView *checkPwd = [[UIAlertView alloc] initWithTitle:phoneNumber message:@"请输入登录密码：" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    checkPwd.tag = tagValue;
    checkPwd.contentMode = UIViewContentModeLeft;
    checkPwd.alertViewStyle = UIAlertViewStyleSecureTextInput;
    checkPwd.delegate = self;
    [checkPwd show];
    
    UITextField *pwdField = [checkPwd textFieldAtIndex:0];
    [pwdField setPlaceholder:@"登录密码"];
}

-(void)click_switch:(UIButton *)sender
{
    [self checkLoginPwdWithTag:100];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //得到输入框
    UITextField *tf=[alertView textFieldAtIndex:0];
    NSString *getPWD = tf.text;
    if (buttonIndex == 0) {
        return;
    } else {
        
        NSString *scrityPass = [[NSUserDefaults standardUserDefaults] objectForKey:USER_PASSWORD];
        NSString *userPWD = [AESCrypt decrypt:scrityPass password:AESEncryKey];
        if (![getPWD isEqualToString:userPWD]) {
            [self showToastMessage:@"密码错误!"];
    
        }else{
        
            if (alertView.tag == 100) {
                self.btn_Switch.selected = !self.btn_Switch.selected;
                if (self.btn_Switch.isSelected) {
                    [self doPattern];
                } else {
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    [defaults removeObjectForKey:kCurrentPattern];
                    [defaults synchronize];
                    
                     [FPTelGesturePWD resetGesturePassword:SET_GESUTREPWD_OFF andTelNumber:[Config Instance].personMember.mobile];
                    
                }
            } else {
                [self doPattern];
            }
        }
    }
}

- (void) doPattern
{
    FPLockViewController *lockVc = [[FPLockViewController alloc]init];
    lockVc.infoLabelStatus = InfoStatusFirstTimeSetting;
    lockVc.isFirstTimeSetting = YES;
    [self.navigationController presentViewController:lockVc animated:YES completion:^{
        //
    }];
}

@end
