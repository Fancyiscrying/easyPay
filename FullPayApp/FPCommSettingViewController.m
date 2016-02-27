//
//  FPCommSettingViewController.m
//  FullPayApp
//
//  Created by mark zheng on 14-2-25.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPCommSettingViewController.h"
#import "FPFeedBackViewController.h"
#import "FPHelpViewController.h"
#import "FPAboutViewController.h"

#import <StoreKit/StoreKit.h>

#import "FPAppVersion.h"

#define IMAGE_APP_BACKGROUND @"BG.png"

@interface FPCommSettingViewController () <SKStoreProductViewControllerDelegate>

@property (nonatomic,strong) UIAlertView *warning;
@property (nonatomic,strong) NSString *updateUrl;

@property (nonatomic,strong) NSString *clientVersion;
@property (assign,nonatomic) BOOL needUpdate;


@end

@implementation FPCommSettingViewController

#define APPID @"713469903"
#define HOTLINE [self getCustomerServiceTelephone:YES]
#define HOTLINE1 [self getCustomerServiceTelephone:NO]

static NSString *myTableViewCellIndentifier = @"myTableViewCellIndentifier";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    UIImageView *background = [[UIImageView alloc] initWithFrame:view.bounds];
    background.image = [UIImage imageNamed:IMAGE_APP_BACKGROUND];
    [view addSubview:background];
    
    self.view = view;
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 6, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundView = nil; //去掉默认的横条背景
    self.tableView.backgroundColor = [UIColor clearColor];
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
    v.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:v];
    
    [self.view addSubview:self.tableView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.tabBarController.tabBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.title = @"通用设置";
    self.hidesBottomBarWhenPushed = YES;
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    self.navigationItem.backBarButtonItem = backItem;
    backItem.title = @"";
    
    _clientVersion = @"  ";
   // _clientVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
    
    NSArray *common = [[NSArray alloc] initWithObjects:@"版本",@"用户反馈",@"关于",@"帮助",@"评价",nil];
    settings = common;
    
    [self.tableView
         registerClass:[UITableViewCell class] forCellReuseIdentifier:myTableViewCellIndentifier];
    
    [self mobileVersion];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)getCustomerServiceTelephone:(BOOL)format
{
    NSString *serviceTelephone = [Config Instance].appParams.customerServiceTelephone;
    if (serviceTelephone && serviceTelephone.length > 0) {
        if (format) {
            [serviceTelephone formatPhoneNumber];
        }
    }else{
        serviceTelephone = @"0755-33687917";
    }
    return serviceTelephone;
}

#pragma mark table view datasource methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return [settings count];
        
    } else {
        return 1;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if ([tableView respondsToSelector:@selector(dequeueReusableCellWithIdentifier:forIndexPath:)]) {
        cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:myTableViewCellIndentifier forIndexPath:indexPath];
    } else {
        cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:myTableViewCellIndentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myTableViewCellIndentifier];
        }
    }
    
    if ([indexPath section] == 0) {
        cell.textLabel.text = [settings objectAtIndex:[indexPath row]];
    } else {
        cell.textLabel.text = [NSString stringWithFormat:@"客服热线 %@(点击拨打)",HOTLINE1];
    }
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    cell.textLabel.font = [UIFont systemFontOfSize:15.0];
    cell.textLabel.textColor = [UIColor darkGrayColor];
    
    if (indexPath.row == 0 && indexPath.section == 0) {
        if (_clientVersion.length>0) {
            UILabel *version = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 40)];
            version.right = ScreenWidth -40;
            version.backgroundColor = [UIColor clearColor];
            version.font = [UIFont systemFontOfSize:16];
            version.text = _clientVersion;
            version.textAlignment = NSTextAlignmentRight;
            version.textColor = [UIColor darkGrayColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.contentView addSubview:version];
        }else{
            UILabel *version = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 40)];
            version.backgroundColor = [UIColor clearColor];
            version.font = [UIFont systemFontOfSize:16];
            version.text = @"New";
            version.textAlignment = NSTextAlignmentRight;
            version.textColor = [UIColor redColor];
            version.right = ScreenWidth -40;

            [cell.contentView addSubview:version];
        }
    }else{
        UIImageView *accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_ic_enter"]];
        cell.accessoryView = accessoryView;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
  
    return cell;
}

#pragma mark table view data delegate methods
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
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
    if ([indexPath section] == 0) {
        NSInteger index = [indexPath row];
        switch (index) {
            case 0:
            {
//                if (_clientVersion.length == 0) {
//                    [self alterWithTitle:@"立即更新到最新版本？" andMessage:nil andNeedUpdate:YES];
//                }
            }
                break;
            case 1:
            {
                FPFeedBackViewController *feedBack = [[FPFeedBackViewController alloc] init];
                
                [self.navigationController pushViewController:feedBack animated:YES];
            }
                break;
            case 2:
            {
                FPAboutViewController *about = [[FPAboutViewController alloc] init];
                [self.navigationController pushViewController:about animated:YES];
            }
                break;
            case 3:
            {
                FPHelpViewController *help = [[FPHelpViewController alloc] init];
                [self.navigationController pushViewController:help animated:YES];
            }
                break;
            case 4:
            {
//                if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0"))
//                {
//                    [self showStoreViewController:APPID];
//                } else {
                    NSString *evaluateString = [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@",APPID];
                    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
                        evaluateString = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@",APPID];
                    }
                    
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:evaluateString]];

//                }
            }
                break;
                
            default:
                break;
        }
    } else {
        NSInteger index = [indexPath row];
        switch (index) {
            case 0:
            {
                NSString *device = [[UIDevice currentDevice].model substringToIndex:4];
                if ([device isEqualToString:@"iPho"]) {
                    NSString *num = [[NSString alloc] initWithFormat:@"telprompt://%@",HOTLINE];
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]];
                } else {
                    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"当前设备不具备电话功能！" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
                    [alert show];
                }
            }
                break;
            default:
                break;
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)mobileVersion
{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    [UtilTool showHUD:@"正在检查" andView:self.view andHUD:hud];
    [FPAppVersion checkAppVersion:NO andBlock:^(FPAppVersion *appVersion,NSError *error) {
        [hud hide:YES];
        if (error) {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"网络连接失败,请查看网络是否连接正常！" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        } else {
            
            if (appVersion.result) {
                //NSString *msg = [NSString stringWithFormat:@"检查到最新版本:%@",appVersion.serverVersion];
                self.updateUrl = appVersion.updateUrl;

                if (appVersion.forceUpdate == YES) {
                    _clientVersion = @"";
                    //[self alterWithTitle:msg andMessage:nil andForceUpdate:YES];
                }else{
                    if (appVersion.needUpdate == NO) {
                        _clientVersion = [NSString stringWithFormat:@"V %@",appVersion.clientVersion];
                       // [self alterWithTitle:@"您当前已是最新版本!" andMessage:nil];
                    } else {
                        _clientVersion = @"";
                        //[self alterWithTitle:msg andMessage:nil andNeedUpdate:YES];
                    }
                }
                
                [self.tableView reloadData];
                
            } else {
                
                //[self alterWithTitle:@"检查更新失败" andMessage:appVersion.errorInfo];
            }
        }
    }];
}

-(void)alterWithTitle:(NSString *)title andMessage:(NSString *)message andNeedUpdate:(BOOL)needUpdate
{
    self.warning = [[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:@"暂不更新" otherButtonTitles:@"立即更新", nil];
    
    [self.warning setContentMode:UIViewContentModeCenter];
    [self.warning show];
}

-(void)alterWithTitle:(NSString *)title andMessage:(NSString *)message andForceUpdate:(BOOL)forceUpdate
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:@"立即更新" otherButtonTitles: nil];
    alert.tag = 102;
    [alert setContentMode:UIViewContentModeCenter];
    [alert show];
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 102) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.updateUrl]];
    }
    if (alertView == self.warning && buttonIndex == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.updateUrl]];
    }
}

-(void)alterWithTitle:(NSString *)title andMessage:(NSString *)message
{
    self.warning = [[UIAlertView alloc]initWithTitle:title message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    
    [self.warning setContentMode:UIViewContentModeCenter];
    [self.warning show];
}

- (void)showStoreViewController:(NSString *)appid
{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    [UtilTool showHUD:@"正在处理" andView:self.view andHUD:hud];
    SKStoreProductViewController *storeProductViewController = [[SKStoreProductViewController alloc] init];
    storeProductViewController.delegate = self;
    [storeProductViewController loadProductWithParameters:@{SKStoreProductParameterITunesItemIdentifier:appid} completionBlock:^(BOOL result,NSError *error){
        [hud hide:YES];
        if (error) {
            [self showToastMessage:[error localizedDescription]];
        } else {
            [self presentViewController:storeProductViewController animated:YES completion:^{
                
            }];
        }
    }];
}

#pragma mark - SKStoreProductViewControllerDelegate
- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController
{
    [self dismissViewControllerAnimated:YES completion:^{
    
    }];
}

@end
