//
//  FPMainViewController.m
//  FullPayApp
//
//  Created by mark zheng on 14-2-11.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPMainViewController.h"
#import "FPTradeBillsViewController.h"
#import "FPBankCardListViewController.h"
#import "FPPreferentialViewController.h"
#import "FPPrivateMessageViewController.h"
#import "FPDimScanViewController.h"
#import "FPNavigationViewController.h"
#import "FPNameAndStaffIdViewController.h"
#import "FPCardRechargeViewController.h"
#import "FPPayTypeViewController.h"
#import "FPLockViewController.h"
#import "FPMy2DimCodeViewController.h"
#import "FPAppDelegate.h"
#import "FPAppVersion.h"

#import "FPNavLoginViewController.h"
#import "FPLoginViewController.h"

#import "FPPersonalInfoViewController.h"
#import "FPShortcutPayView.h"

#import "FPTradeBillsCell.h"
#import "FPMainCell.h"
#import "FPBillModel.h"
#import "Config.h"


#define kImageOriginHight 120.0f

enum{
 DIMSCAN_TAG = 101,
 CHECKAPPVERSON_TAG,
};

@interface FPMainViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,FPShortcutPayViewDelegate>

@property (nonatomic,strong) FPPersonMember *personMember;

@property (nonatomic,strong) NSMutableArray *msgArray;

@property (nonatomic,strong) NSArray *itemTitles;
@property (nonatomic,strong) NSArray *itemImages;

@property (assign, nonatomic) int marketingCount;
@property (assign, nonatomic) int messageCount;

@property (assign, nonatomic) BOOL hasTapMarketing;
@property (nonatomic,strong) NSString *updateUrl;

@property (nonatomic,strong) FPShortcutPayView *shortcutPayView;

@end

@implementation FPMainViewController

static NSString *myTableViewCellIndentifier = @"itemMainCell";
static NSString *myTableViewCellIndentifier1 = @"itemMainCell1";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (id)msgArray
{
    if (!_msgArray) {
        _msgArray  = [[NSMutableArray alloc] initWithCapacity:1];
    }
    
    return _msgArray;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.tabBarController.tabBar.hidden = NO;
    
    if ([Config Instance].isAutoLogin) {
        
        //self.launch_state == FPControllerStateAuthorization
        self.personMember = [Config Instance].personMember;
        
        if (self.personMember.nameAuthFlag) {
            self.lbl_UserName.text = self.personMember.memberName;
            self.btn_IdVerificate.enabled = NO;
        }else{
            self.lbl_UserName.text = @"未实名认证";
            self.btn_IdVerificate.enabled = YES;
        }
        
        self.lbl_UserPhone.text = self.personMember.mobile;
        
        
        [self initTradeOne];
    } else {
        self.lbl_UserName.text = @"登录账号";
        self.lbl_UserPhone.text = @"点击查看个人信息";
        self.personMember = nil;
        self.msgArray = nil;
        [_tableView reloadData];
    }
    [self initUserImage];
    [self getNewMessageCount];

}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    FPAppDelegate *delegate = (FPAppDelegate *)[UIApplication sharedApplication].delegate;
    if (delegate.hasCheckAppVersion == NO) {
        [self checkMobileVersion];
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self installCustom];
    self.hasTapMarketing = NO;
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initUserImage
{
    UITapGestureRecognizer *guesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseImage:)];
    guesture.numberOfTapsRequired = 1;
    [self.img_UserImage addGestureRecognizer:guesture];
    [self.img_UserImage setUserInteractionEnabled: YES];
    ImageUtils *imgUtils = [ImageUtils Instance];
    if ([Config Instance].isAutoLogin) {
        
        [imgUtils getImage:self.img_UserImage andMemberNo:self.personMember.memberNo andHeadAddress:self.personMember.headAddress];
    }else{
        self.img_UserImage.image = [UIImage imageNamed:@"home_head_none"];
        [imgUtils getImage:nil andMemberNo:nil andHeadAddress:nil];
    }
    
    
}

-(void)chooseImage:(UITapGestureRecognizer *)sender
{
    if ([Config Instance].isAutoLogin) {
        FPPersonalInfoViewController *myPhotoView = [self.storyboard instantiateViewControllerWithIdentifier:@"FPPersonalInfo"];
        
        [self.navigationController pushViewController:myPhotoView animated:YES];
    }else{
        [self click_ToLoginViewController];
    }
    
}

- (void)initTradeOne
{
    [FPBillModel getFPBillModel:@"0" andLimit:@"1" andBlock:^(FPBillModel *marketing,NSError *error){
        if (error) {
            [self showToastMessage:kNetworkErrorMessage];
        } else {
            if (marketing.result) {
                if (marketing.total > 0) {
                    if (self.msgArray) {
                        [self.msgArray removeAllObjects];
                    }
                    [self.msgArray addObjectsFromArray:marketing.billItems];

                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.tableView reloadData];
                    });
                }
            } else {
                //[self showToastMessage:marketing.errorInfo];
            }
        }
        
    }];
}

#pragma mark table view datasource methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    
    return [self.itemTitles count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        FPTradeBillsCell* cell;
        if ([tableView respondsToSelector:@selector(dequeueReusableCellWithIdentifier:forIndexPath:)]) {
            cell = [tableView dequeueReusableCellWithIdentifier:myTableViewCellIndentifier1 forIndexPath:indexPath];
        } else {
            cell = [tableView dequeueReusableCellWithIdentifier:myTableViewCellIndentifier1];
            if (cell == nil) {
                cell = [[FPTradeBillsCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:myTableViewCellIndentifier1];
            }
        }
    
        if ([self.msgArray count] > 0) {
            
            NSString *tradeStr = nil;
            FPBillItem *item = self.msgArray[indexPath.row];
            if (item.inFlag == YES) {
                NSString *typeStr = @"收入";

                tradeStr = [NSString stringWithFormat:@"%@ | %@",typeStr,item.businessTypeName];
            } else {
                NSString *typeStr = @"支出";

                tradeStr = [NSString stringWithFormat:@"%@ | %@",typeStr,item.businessTypeName];
            }
            
            cell.textLabel.text = tradeStr;
            cell.textLabel.textColor = [UIColor blackColor];
            cell.detailTextLabel.text = item.tradeTime;
         
            if (item.inFlag == YES) {
                cell.lbl_TradeAmt.text = [NSString stringWithFormat:@"+%.02f 元",item.amt/100] ;
                cell.lbl_TradeAmt.textColor = [ColorUtils hexStringToColor:@"FFAA22"];

            } else {
                cell.lbl_TradeAmt.text = [NSString stringWithFormat:@"-%.02f 元",item.amt/100] ;
                cell.lbl_TradeAmt.textColor =[ColorUtils hexStringToColor:@"33CC33"];

            }
            
            cell.lbl_TradeStatus.text = item.businessStatusName;
        } else {
            if (![Config Instance].isAutoLogin) {
                cell.textLabel.text = @"登陆后点击查看";
                cell.textLabel.textColor = [UIColor orangeColor];
                cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
                cell.lbl_TradeAmt.text = @"0.00元";
                cell.lbl_TradeAmt.textColor = [UIColor redColor];
                cell.lbl_TradeStatus.hidden = YES;
                cell.detailTextLabel.hidden= YES;
            }else{
                cell.textLabel.text = @"暂无交易记录!";
                cell.textLabel.textColor = [UIColor orangeColor];
                cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
        
            }
        }
        
        return cell;
        
    } else {
        FPMainCell* cell;
        if ([tableView respondsToSelector:@selector(dequeueReusableCellWithIdentifier:forIndexPath:)]) {
            cell = [tableView dequeueReusableCellWithIdentifier:myTableViewCellIndentifier forIndexPath:indexPath];
        } else {
            cell = [tableView dequeueReusableCellWithIdentifier:myTableViewCellIndentifier];
            if (cell == nil) {
                cell = [[FPMainCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:myTableViewCellIndentifier];
            }
        }
        
        NSString *imageName = [self.itemImages objectAtIndex:indexPath.row];
        cell.iconImage.image = [UIImage imageNamed:imageName];
        
        cell.textLabel.text = [self.itemTitles objectAtIndex:[indexPath row]];
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        cell.textLabel.font = [UIFont systemFontOfSize:16.0f];
        cell.textLabel.textColor = MCOLOR(@"text_color");
        if (indexPath.row == 2) {
            if (_marketingCount > 0 && _hasTapMarketing == NO) {
                cell.detailTextLabel.text = @"New";
            }else{
                cell.detailTextLabel.text = @"";
            }
          
        } else if(indexPath.row == 3) {
            if (_messageCount > 0) {
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%d",_messageCount];
            }else{
                cell.detailTextLabel.text = @"";
            }
        }
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
        
        
        UIImageView *accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_ic_enter"]];
        cell.accessoryView = accessoryView;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        return cell;

    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        UIView *headView = [[UIView alloc] initWithFrame:tableView.tableHeaderView.frame];
        headView.backgroundColor = [UIColor whiteColor];
        UIImageView *imgLeft = [[UIImageView alloc] initWithFrame:CGRectMake(15, 7, 2, 26)];
        imgLeft.image = [UIImage imageNamed:@"home_mark"];
        [headView addSubview:imgLeft];
        
        UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(23, 5, 150, 30)];
        lblTitle.text = @"最近交易账单";
        lblTitle.font = [UIFont systemFontOfSize:14.0f];
        [headView addSubview:lblTitle];
        
        UIButton * btnMore = [UIButton buttonWithType:UIButtonTypeCustom];
        btnMore.frame = CGRectMake(240, 7, 60, 26);
        [btnMore setBackgroundImage:[UIImage imageNamed:@"home_bt_more"] forState:UIControlStateNormal];
        [btnMore setTitle:@"更多..." forState:UIControlStateNormal];
        [btnMore setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btnMore.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [btnMore addTarget:self action:@selector(click_MoreTradeBills:) forControlEvents:UIControlEventTouchUpInside];
        
        if (self.msgArray.count > 0) {
            // 显示更多按钮
            btnMore.hidden = NO;
        }else{
            // 隐藏更多按钮
            btnMore.hidden = YES;
        }
        
        [headView addSubview:btnMore];
        
        return headView;
    }
    
    return nil;
}

#pragma mark tableview data delegate methods
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 55.0f;
    }
    return 60.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 40.0f;
    }
    return 10.0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if ([Config Instance].isAutoLogin) {

        if (indexPath.section == 0) {
            if (self.msgArray.count > 0) {
                FPTradeBillsViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"FPTradeBillsView"];
                controller.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:controller animated:YES];
            }
            
        }else if (indexPath.section == 1) {
            if (indexPath.row == 0) {
                
                if (self.personMember.nameAuthFlag) {
                    
                    FPPayTypeViewController *controller = [[FPPayTypeViewController alloc] init];
                    controller.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:controller animated:YES];
                }else{
                    
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"此功能需实名认证才可使用!" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"前往实名", nil];
                    alert.tag = DIMSCAN_TAG;
                    [alert show];
                }

             
            }else if (indexPath.row == 1) {
                
                if (self.personMember.nameAuthFlag) {
                    
                    FPBankCardListViewController *controller = [[FPBankCardListViewController alloc] init];
                    controller.viewComeForm = BankCardListViewComeFormCardRecharge;
                    //FPCardRechargeViewController *controller = [[FPCardRechargeViewController alloc]init];
                    controller.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:controller animated:YES];
                    
                }else{
                    
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"此功能需实名认证才可使用!" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"前往实名", nil];
                    alert.tag = DIMSCAN_TAG;
                    [alert show];
                }
                
       
            } else if (indexPath.row == 2) {
                self.hasTapMarketing = YES;
                
                FPPreferentialViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"FPPreferentialView"];
                controller.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:controller animated:YES];
                
            } else if (indexPath.row == 3) {
                
                FPPrivateMessageViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"FPPrivateMessageView"];
                controller.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:controller animated:YES];
                
            }
        }
    }
        else {
         if (indexPath.row == 2) {
            self.hasTapMarketing = YES;
            
            FPPreferentialViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"FPPreferentialView"];
            controller.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:controller animated:YES];
        }else{
            [self click_ToLoginViewController];

        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat yOffset  = scrollView.contentOffset.y;
    if (yOffset < -kImageOriginHight) {
        CGRect f = self.img_HeadBackground.frame;
        f.origin.y = yOffset;
        f.size.height =  -yOffset;
        self.img_HeadBackground.frame = f;
    }
}

#pragma mark -----Button ACTIONS

-(void)click_MoreTradeBills:(UIButton *)sender
{
    if (![Config Instance].isAutoLogin) {
        return;
    }
    FPTradeBillsViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"FPTradeBillsView"];
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];

}

-(void)click_DimScan:(UIButton *)sender
{
    if (![Config Instance].isAutoLogin) {
        [UtilTool setLoginViewRootController];
        return;
    }
    
    if (self.personMember.nameAuthFlag) {
        [self createShortcutPayView];
        
    }else{
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"此功能需实名认证才可使用!" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"前往实名", nil];
        alert.tag = DIMSCAN_TAG;
        [alert show];
    }
  
}

- (void)click_IdVerificate:(UIButton *)sender
{
    if ([Config Instance].isAutoLogin) {
        FPNameAndStaffIdViewController *controller = [[FPNameAndStaffIdViewController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
    } else {
        [self click_ToLoginViewController];
    }
}

- (void)click_ToLoginViewController
{
    [[Config Instance] setAutoLogin:NO];
    NSLog(@"[self presentingViewController]:%@,%@",[self presentingViewController],[self presentedViewController]);
    if ([self presentingViewController]) {
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    } else {
        
        FPLoginViewController * loginVc = [self.storyboard instantiateViewControllerWithIdentifier:@"FPLoginView"];
        
        FPNavLoginViewController   *controller = [[FPNavLoginViewController alloc] initWithRootViewController:loginVc];
        [controller setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
        [self presentViewController:controller animated:YES completion:^{
            
        }];
    }
}
#pragma mark FPShortcutPayViewDelegate
-(void)shortcutPayViewClickButtonAtIdexth:(int)buttonIndex{
    if(buttonIndex == 0){
        FPDimScanViewController *controller = [[FPDimScanViewController alloc] init];
        controller.viewComeFrom = DimScanViewComeFromHomePage;
        [self.navigationController pushViewController:controller animated:YES];
        
    }else if (buttonIndex == 1){
        FPMy2DimCodeViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"FPMy2DimCodeView"];
        controller.comeForm = comeFormHomePage;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

#pragma mark ---UIAlertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == DIMSCAN_TAG && buttonIndex == 1) {
        //前往实名
        FPNameAndStaffIdViewController *controller = [[FPNameAndStaffIdViewController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
    }
    //前往更新
    if (alertView.tag == CHECKAPPVERSON_TAG && buttonIndex ==0 ) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.updateUrl]];
    }
}

- (void)createShortcutPayView{
    if (_shortcutPayView == nil) {
        _shortcutPayView = [[FPShortcutPayView alloc]init];
        _shortcutPayView.delegate = self;
        
        [self.tabBarController.view addSubview:_shortcutPayView];
    }
    else {
        [_shortcutPayView removeFromSuperview];
        _shortcutPayView = [[FPShortcutPayView alloc]init];
        _shortcutPayView.delegate = self;
        
        [self.tabBarController.view addSubview:_shortcutPayView];
    }
}

- (void)installCustom
{
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    self.navigationItem.backBarButtonItem = backItem;
    backItem.title = @"";
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.height = ScreenHigh - 50;
    [self.view addSubview:self.tableView];

    self.img_HeadBackground = [[UIImageView alloc] init];
    self.img_HeadBackground.frame = CGRectMake(0, -kImageOriginHight, self.tableView.frame.size.width, kImageOriginHight);
    self.img_HeadBackground.image = [UIImage imageNamed:@"home_user_bg.png"];
    self.img_HeadBackground.userInteractionEnabled = YES;
    [self ImageHeadViewAddSubView];
    
    
    [self.tableView
     registerClass:[FPMainCell class] forCellReuseIdentifier:myTableViewCellIndentifier];
    [self.tableView
     registerClass:[FPTradeBillsCell class] forCellReuseIdentifier:myTableViewCellIndentifier1];
    
    NSArray *names = @[@"我要转账",@"账户充值",@"优惠动态",@"我的私信"];
    NSArray *images = @[@"home_ic_pay",@"home_ico_recharge",@"home_ic_favorable",@"home_ic_email"];
    
    self.itemTitles = names;
    self.itemImages = images;
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.scrollEnabled = YES;
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
    v.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:v];
    
    
    self.tableView.contentInset = UIEdgeInsetsMake(kImageOriginHight, 0, 0, 0);
    [self.tableView addSubview:self.img_HeadBackground];
    self.tableView.contentOffset = CGPointMake(0, -kImageOriginHight);
    
    self.btn_IdVerificate = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btn_IdVerificate.frame = CGRectMake(88, 44, 96, 21);
    [self.btn_IdVerificate setBackgroundColor:[UIColor clearColor]];
    [self.btn_IdVerificate setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btn_IdVerificate addTarget:self action:@selector(click_IdVerificate:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btn_IdVerificate];
    
    
}

- (void)ImageHeadViewAddSubView
{
//    UIImageView *img_UserBackImage = [[UIImageView alloc] init];
//    img_UserBackImage.frame = CGRectMake(14, 39, 61, 61);
//    img_UserBackImage.layer.cornerRadius = 30;
//    img_UserBackImage.layer.masksToBounds = YES;
////    img_UserBackImage.layer.borderWidth = 2;
////    img_UserBackImage.layer.borderColor = [UIColor whiteColor].CGColor;
//    
//    img_UserBackImage.image = MIMAGE(@"home_head_none");
//    [_img_HeadBackground addSubview:img_UserBackImage];
    
    _img_UserImage = [[UIImageView alloc] init];
    _img_UserImage.backgroundColor = [UIColor clearColor];
    _img_UserImage.frame = CGRectMake(14, 39, 61, 61);
    _img_UserImage.layer.cornerRadius = 30;
    _img_UserImage.layer.masksToBounds = YES;
    _img_UserImage.layer.borderWidth = 2;
    _img_UserImage.layer.borderColor = [UIColor whiteColor].CGColor;
    _img_UserImage.image = MIMAGE(@"home_head_none");
    [_img_HeadBackground addSubview:_img_UserImage];
    
    _lbl_UserName = [[UILabel alloc] init];
    _lbl_UserName.frame = CGRectMake(88, 44, 96, 21);
    _lbl_UserName.backgroundColor = [UIColor clearColor];
    _lbl_UserName.font = [UIFont systemFontOfSize:15.0f];
    _lbl_UserName.textAlignment = NSTextAlignmentLeft;
    _lbl_UserName.textColor = [UIColor whiteColor];
    [_img_HeadBackground addSubview:_lbl_UserName];
    
    _lbl_UserPhone = [[UILabel alloc] init];
    _lbl_UserPhone.frame = CGRectMake(88, 70, 100, 21);
    _lbl_UserPhone.backgroundColor = [UIColor clearColor];
    _lbl_UserPhone.font = [UIFont systemFontOfSize:12.0f];
    _lbl_UserPhone.textAlignment = NSTextAlignmentLeft;
    _lbl_UserPhone.textColor = [UIColor whiteColor];
    [_img_HeadBackground addSubview:_lbl_UserPhone];
    
    _btn_DimScan = [UIButton buttonWithType:UIButtonTypeCustom];
    _btn_DimScan.frame = CGRectMake(ScreenWidth-80, 44, 50, 50);
    [_btn_DimScan setBackgroundColor:[UIColor clearColor]];
    [_btn_DimScan setImage:MIMAGE(@"home_shortcut_pay.png") forState:UIControlStateNormal];

    [_btn_DimScan addTarget:self action:@selector(click_DimScan:) forControlEvents:UIControlEventTouchUpInside];
    [self.img_HeadBackground addSubview:_btn_DimScan];
}

- (void)getNewMessageCount{
    
    FPClient *clientUrl = [FPClient sharedClient];
    
    NSString *lasrDate = [[NSUserDefaults standardUserDefaults] objectForKey:LAST_DATE];
    if (lasrDate == nil) {
        lasrDate = @"";
    }
    
    NSString *memberNO = [Config Instance].memberNo;
    if ([Config Instance].isAutoLogin) {
        if (memberNO == nil) {
            memberNO = @"";
        }
    }else{
        memberNO = @"";
        self.msgArray = nil;
    }
    
    FPPersonMember *person = [Config Instance].personMember;
    
    NSDictionary *parameters = [clientUrl findTheNewMarketingAndMessageCount:lasrDate andSignDate:person.createDate and:memberNO];
    FPDEBUG(@"parmetes:%@",parameters);
    
    [clientUrl POST:kFPPost parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        BOOL result = [[responseObject objectForKey:@"result"] boolValue];
        FPDEBUG(@"returnObj: %@",responseObject);

        if (result) {
            NSDictionary *returnObj = [responseObject objectForKey:@"returnObj"];
            _marketingCount = [[returnObj objectForKey:@"newMarketingActivityNumber"] intValue]
            ;
            _messageCount = [[returnObj objectForKey:@"newMessageCount"] intValue];
            
            [self.tableView reloadData];
            
        }else{
            
           // NSString *errorInfo = [responseObject objectForKey:@"errorInfo"];
            //[self showToastMessage:errorInfo];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showToastMessage:kNetworkErrorMessage];
    }];
}

//检测版本更新
-(void)checkMobileVersion
{
    [FPAppVersion checkAppVersion:NO andBlock:^(FPAppVersion *appVersion,NSError *error) {
        if (error) {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"网络连接失败,请查看网络是否连接正常！" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        } else {
            
            if (appVersion.result) {
                
                self.updateUrl = appVersion.updateUrl;
                FPAppDelegate *delegate = (FPAppDelegate *)[UIApplication sharedApplication].delegate;
                delegate.hasCheckAppVersion = YES;
                
                if (appVersion.forceUpdate == YES) {
                    NSString *msg = [NSString stringWithFormat:@"检查到最新版本:%@",appVersion.serverVersion];
                    
                    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:msg message:nil delegate:self cancelButtonTitle:@"立即更新" otherButtonTitles:nil];
                    alert.tag = CHECKAPPVERSON_TAG;
                    [alert show];
                }else{
                    if (appVersion.needUpdate == YES) {
                        NSString *msg = [NSString stringWithFormat:@"检查到最新版本:%@",appVersion.serverVersion];
                        
                        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:msg message:nil delegate:self cancelButtonTitle:@"立即更新" otherButtonTitles:@"知道了",nil];
                        alert.tag = CHECKAPPVERSON_TAG;
                        [alert show];
                    }

                }
                
            }
        }
    }];
}

@end
