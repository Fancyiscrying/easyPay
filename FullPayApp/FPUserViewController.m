//
//  FPUserViewController.m
//  FullPayApp
//
//  Created by mark zheng on 14-2-11.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPUserViewController.h"

#import "FPUserCell.h"
#import "FPMyAssetViewController.h"
#import "FPPersonalInfoViewController.h"
#import "FPMyFutongCardsViewController.h"
#import "FPMyBankCardsViewController.h"
#import "FPLimitSetViewController.h"
#import "FPSecuritySetViewController.h"
#import "FPNavLoginViewController.h"
#import "FPCommSettingViewController.h"

#import "FPAccountInfo.h"

#define USER_PASSWORD @"userpassword"

@interface FPUserViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NSArray *userItems;
@property (nonatomic,strong) FPPersonMember *personMember;
@property (nonatomic,strong) FPAccountInfoItem *accountItem;

@property (nonatomic,copy) NSString *accountAmount;
@property (nonatomic,copy) NSString   *fumiCount;
@property (nonatomic,assign) NSInteger cardsAccount;
@property (nonatomic,assign) NSInteger bankCardCount;

@end

@implementation FPUserViewController

static NSString *myTableViewCellIndentifier = @"itemUserCell";

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
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.tabBarController.tabBar.hidden = NO;
    self.tabBarController.tabBar.translucent=NO;  //tabbar不透明
    
    if([Config Instance].isAutoLogin){
        FPUser *user1 = self.userItems[0][0];
        if (user1 != nil) {
            if ([Config Instance].personMember.nameAuthFlag) {
                user1.textTitle = @"个人信息";
            }else{
                user1.textTitle = @"未实名认证";
            }
            user1.subTitle = [Config Instance].personMember.mobile;
        }
        
        [self getAccountInfo];
        self.tableView.tableFooterView.hidden = NO;
    }else{
        self.tableView.tableFooterView.hidden = YES;

    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onUpdateUserData:) name:kNotificationUser object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationUser object:nil];
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"个人中心";
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    self.navigationItem.backBarButtonItem = backItem;
    backItem.title = @"";
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"user_bt_set"] style:UIBarButtonItemStylePlain target:self action:@selector(click_RightButton:)];
    [self.navigationItem setRightBarButtonItem:rightButton];
    
    //加载数据
    if ([Config Instance].personMember.nameAuthFlag && [Config Instance].isAutoLogin) {
        [self performSelector:@selector(getDataByAsyn) withObject:nil afterDelay:0];
    }
    
    CGRect tableRect = CGRectMake(0, 0, 320, self.view.bounds.size.height);
    self.tableView = [[UITableView alloc] initWithFrame:tableRect style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    
    [self.tableView
     registerClass:[FPUserCell class] forCellReuseIdentifier:myTableViewCellIndentifier];

    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.scrollEnabled = YES;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
//    [self.tableView setClipsToBounds:YES];
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    UIButton *btnResign = [UIButton buttonWithType:UIButtonTypeCustom];
    btnResign.frame = CGRectMake(0, 0, 320, 45);
    [btnResign setTitle:@"退出登录" forState:UIControlStateNormal];
    [btnResign setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnResign setBackgroundColor:[ColorUtils hexStringToColor:@"#FF5B5C"]];
    [btnResign addTarget:self action:@selector(click_Resign:) forControlEvents:UIControlEventTouchUpInside];
    [self.tableView setTableFooterView:btnResign];
   
    [self initData];

}

- (void)getDataByAsyn
{
    @synchronized(self){
//        dispatch_queue_t userQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_queue_t userQueue = dispatch_queue_create("accountItem.com", NULL);        dispatch_async(userQueue, ^{
            [self getAccountInfo];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                
//            });
        });
        
    }
}

- (void)onUpdateUserData:(NSNotification *)notification
{
    self.accountItem = (FPAccountInfoItem *)[notification.userInfo objectForKey:kUserNotificationKey];
    if (self.accountItem) {
        [self updateBaseMethod];
    }
}

- (void)updateDataByOldData
{
    self.accountItem = [[Config Instance] accountItem];
    if (self.accountItem) {
        [self updateBaseMethod];
    }
}

- (void)updateBaseMethod
{
    double amount = [self.accountItem.accountAmount doubleValue];
    
    self.accountAmount = [NSString stringWithFormat:@"%.02f",amount/100];
    
    self.cardsAccount = self.accountItem.cardsAccount;
    self.bankCardCount = self.accountItem.bankCardCount;
    
    FPUser *user = self.userItems[0][1];
    user.subTitle = [NSString stringWithFormat:@"余额%@元",self.accountAmount];
    
    user = self.userItems[1][0];
    user.subTitle = [NSString stringWithFormat:@"已关联%d张富通卡",(int)self.cardsAccount];
    
    user = self.userItems[1][1];
    user.subTitle = [NSString stringWithFormat:@"已关联%d张银行卡",(int)self.bankCardCount];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)click_RightButton:(id)sender
{
    FPCommSettingViewController *controller = [[FPCommSettingViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)click_Resign:(UIButton *)sender
{
    [[Config Instance] setAutoLogin:NO];
    
    //删除保存的登陆密码
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:USER_PASSWORD];
    [defaults synchronize];
    
    //删除个人信息
    self.accountItem = nil;
    //再次初始化
    [self initData];
    
    NSLog(@"[self presentingViewController]:%@,%@",[self presentingViewController],[self presentedViewController]);
    if ([self presentingViewController]) {
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    } else {
        FPNavLoginViewController   *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"FPNavLoginView"];
        [controller setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
        [self presentViewController:controller animated:YES completion:^{
            
        }];
    }
}

#pragma mark table view datasource methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.userItems count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.userItems[section] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FPUserCell* cell;
    if ([tableView respondsToSelector:@selector(dequeueReusableCellWithIdentifier:forIndexPath:)]) {
        cell = [tableView dequeueReusableCellWithIdentifier:myTableViewCellIndentifier forIndexPath:indexPath];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:myTableViewCellIndentifier];
        if (cell == nil) {
            cell = [[FPUserCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:myTableViewCellIndentifier];
        }
    }

    cell.userObject = self.userItems[indexPath.section][indexPath.row];
    cell.backgroundColor = [UIColor whiteColor];
    UIImageView *accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_ic_enter"]];
    cell.accessoryView = accessoryView;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

#pragma mark tableview data delegate methods
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.1;
    }
    
    return 3.5f;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (self.launch_state == FPControllerStateAuthorization) {
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                FPPersonalInfoViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"FPPersonalInfo"];
                [self.navigationController pushViewController:controller animated:YES];
            }else if (indexPath.row == 1){
//                FPMyAssetViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"FPMyAssetView"];
                FPMyAssetViewController *controller = [[FPMyAssetViewController alloc] init];
                controller.accountItem = self.accountItem;
                [self.navigationController pushViewController:controller animated:YES];
            }
        }else if (indexPath.section == 1) {
            if (indexPath.row == 0) {
                FPMyFutongCardsViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"FPMyFutongCardsView"];
                [self.navigationController pushViewController:controller animated:YES];
            } else if (indexPath.row == 1) {
                FPMyBankCardsViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"FPMyBankCardsView"];
                controller.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:controller animated:YES];
            }
        } else if (indexPath.section == 2) {
            if (indexPath.row == 0) {
                FPLimitSetViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"FPLimitSetView"];
                [self.navigationController pushViewController:controller animated:YES];
            } else if (indexPath.row == 1) {
                FPSecuritySetViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"FPSecuritySetView"];
                [self.navigationController pushViewController:controller animated:YES];
            }
        } else {
            
        }
    } else {
        [self click_Resign:nil];
    }
}

- (void)getAccountInfo
{
    [FPAccountInfo getFPAccountInfoWithBlock:^(FPAccountInfo *cardInfo,NSError *error){
        if (error) {
            
            [self showToastMessage:kNetworkErrorMessage];
        } else {
            if (cardInfo.result) {
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationUser object:nil userInfo:@{kUserNotificationKey:cardInfo.accountItem}];
                
//                [self performSelectorOnMainThread:@selector() withObject:; waitUntilDone:]
            } else {
                
                //[self showToastMessage:cardInfo.errorInfo];
            }
        }
    }];
    
}

- (void)initData
{
    FPUser *user1 = [[FPUser alloc] init];
    user1.imageName = @"user_ic_user";
    user1.textTitle = @"登录账号";
    user1.subTitle = @"未知";
    
    if ([Config Instance].isAutoLogin) {
        FPPersonMember *personMember = [Config Instance].personMember;
        if (personMember.nameAuthFlag) {
            user1.textTitle = @"个人信息";
        }else{
            user1.textTitle = @"未实名认证";
        }
        user1.subTitle = personMember.mobile;
    }
    
    FPUser *user2 = [[FPUser alloc] init];
    user2.imageName = @"user_ic_property";
    user2.textTitle = @"我的资产";
    user2.subTitle = @"余额0元";
    
    FPUser *user3 = [[FPUser alloc] init];
    user3.imageName = @"user_ic_futong";
    user3.textTitle = @"我的富通卡";
    user3.subTitle = @"已关联0张富通卡";
    
    FPUser *user4 = [[FPUser alloc] init];
    user4.imageName = @"user_ic_bankc";
    user4.textTitle = @"我的银行卡";
    user4.subTitle = @"已关联0张银行卡";
    
    FPUser *user5 = [[FPUser alloc] init];
    user5.imageName = @"user_ic_limitset";
    user5.textTitle = @"支付额度管理";
    user5.subTitle = @"免密金额设置、支付限制设置……";
    
    FPUser *user6 = [[FPUser alloc] init];
    user6.imageName = @"user_ic_pswset";
    user6.textTitle = @"密码管理";
    user6.subTitle = @"登录密码管理、支付密码管理……";
    
    self.userItems = @[@[user1,user2],@[user3,user4],@[user5,user6]];
    
    if ([Config Instance].autoLogin) {
        [self updateDataByOldData];
    }else{
        [self updateBaseMethod];
    }
}

@end
