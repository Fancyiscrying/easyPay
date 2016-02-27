//
//  FPLotteryViewController.m
//  FullPayApp
//
//  Created by mark zheng on 13-11-18.
//  Copyright (c) 2013年 fullpay. All rights reserved.
//

#import "FPLotteryViewController.h"
#import "FPLotteryStruct.h"
#import "FPLotteryCell.h"
#import "FPLotteryOtherCell.h"
#import "FPLotteryWebViewController.h"
#import "FPLoginViewController.h"
#import "FPViewController.h"
//#import "FPIdentityVerificationViewController.h"
#import "FPLotterySign.h"
#import "FPAdvertiseInfo.h"
#import "FPNameAndStaffIdViewController.h"

#define IMAGE_APP_BACKGROUND @"BG"
#define IMG_MYLOTTERY  @"lottery_ic_mylottery"
#define IMG_LOTTERYINFO @"lottery_ic_announcement"

static NSString *myTableViewCellIndentifier = @"itemCell";
static NSString *myTableViewCellIndentifier1 = @"itemCell1";

@interface FPLotteryViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

@property( nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) FPLotteryStruct *lotteryItems;

@property(nonatomic,strong) NSDictionary *ImageList;

@property (nonatomic,strong) FPAdvertiseInfo *adInfo;

@end

@implementation FPLotteryViewController

const NSInteger kAlertTag = 100;

-(void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    
    UIImageView *backgroundImage = [[UIImageView alloc] initWithFrame:view.bounds];
    [backgroundImage setImage:[UIImage imageNamed:IMAGE_APP_BACKGROUND]];
    [view addSubview:backgroundImage];
        
    self.tableView = [[UITableView alloc] initWithFrame:view.bounds style:UITableViewStyleGrouped];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth; 
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = [UIColor clearColor];
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
    v.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:v];
    
    [self.tableView setTableHeaderView:v];
    
//    self.tableView.scrollEnabled = NO;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [view addSubview:self.tableView];
    
    self.view = view;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setToolbarHidden:YES animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.title = @"彩票";
    self.navigationController.navigationBar.translucent = NO;
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    self.navigationItem.backBarButtonItem = backItem;
    backItem.title = @"";
    
    self.ImageList = [NSDictionary dictionaryWithObjectsAndKeys:MIMAGE(IMG_MYLOTTERY),@"mylottery",MIMAGE(IMG_LOTTERYINFO),@"lotteryinformation", nil];
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0")) {
        [self.tableView
         registerClass:[FPLotteryCell class] forCellReuseIdentifier:myTableViewCellIndentifier];
        [self.tableView
         registerClass:[FPLotteryOtherCell class] forCellReuseIdentifier:myTableViewCellIndentifier1];
    }
    
    [self getConfigure];
    
    /*只有实名认证才去后台获取验证信息*/
    if (self.lotteryViewType == FPLotteryViewControllerTypeAuth) {
        if ([Config Instance].personMember.nameAuthFlag) {
            [self getGenerateSign];
        }
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reciveLotteryNotification:) name:kLotteryBackNotification object:nil];
}

#pragma mark NSNotification delegate
- (void)reciveLotteryNotification:(NSNotification *)notification{
    NSString *returnObjc = notification.object;
    if (returnObjc.length>0) {
        [self doWithNotification:returnObjc];
    }
}

- (void)doWithNotification:(NSString *)notification{
    FPLotteryObject *item;
    if ([notification isEqualToString:@"mylottery"]) {
        if (self.lotteryItems.othermode.count <= 0) {
            return;
        }
        for (FPLotteryObject *temp in self.lotteryItems.othermode) {
            if ([notification isEqualToString:temp.resourceCode]) {
                item = temp;
            }
        }
    }else{
        if (self.lotteryItems.lotteryList.count <= 0) {
            return;
        }
        for (FPLotteryObject *temp in self.lotteryItems.lotteryList) {
            if ([notification isEqualToString:temp.resourceCode]) {
                item = temp;
            }
        }
    }
    if (item == nil) {
        return;
    }
    if (self.lotteryViewType == FPLotteryViewControllerTypeAuth) {
        
        FPLotteryWebViewController *webController = [[FPLotteryWebViewController alloc] init];
        webController.title = item.resourceName;
        webController.webViewType = self.lotteryViewType;
        
        NSString *uriData = [webController getGenerateSign];
        if (uriData != nil) {
            
            if ([item.redirectUri rangeOfString:@"?"].location == NSNotFound) {
                webController.redirectUri = [NSString stringWithFormat:LOTTERYGETFORMART,item.redirectUri,uriData];
            } else {
                webController.redirectUri = [NSString stringWithFormat:LOTTERYGETFORMART_WITH_SYMBOL,item.redirectUri,uriData];
            }
            
            FPDEBUG(@"redirectUri:%@",webController.redirectUri);
            [self.navigationController pushViewController:webController animated:YES];
        }
    }
    
    
}

#pragma mark BUTTON actions

-(void)clickLeftButton:(id)sender
{
    if (self.lotteryViewType == FPLotteryViewControllerTypeNoAuth) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        
        BOOL hasController = NO;
        for (id controller in [self.navigationController viewControllers]) {
            if ([controller isKindOfClass:[FPViewController class]]) {
                hasController = YES;
                FPDEBUG(@"hereasdsd");
                [self.navigationController popToViewController:controller animated:YES];
                break;
            }
        }
        if (hasController == NO) {
            FPViewController *controller = [[FPViewController alloc] init];
//            controller.personMember = [Config Instance].personMember;
            CATransition *transition = [CATransition animation];
            transition.duration = 0.4f;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            transition.type = kCATransitionPush;
            transition.delegate = self;
            transition.subtype = kCATransitionFromLeft;
            
            [self.navigationController.view.layer addAnimation:transition forKey:nil];
            [self.navigationController pushViewController:controller animated:YES];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getConfigure
{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    [UtilTool showHUD:@"正在通讯" andView:self.view andHUD:hud];
    [FPLotteryStruct getLotteryWithBlock:^(FPLotteryStruct *lotteryData,NSError *error) {
        [hud hide:YES];
        if (error) {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"网络连接失败,请查看网络是否连接正常！" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        } else {
            
            if (lotteryData.result) {
                self.lotteryItems = lotteryData;
                
                if (self.lotteryItems.marketingInfo) {
                    NSInteger seqNo = [self.lotteryItems.marketingInfo.seqNo integerValue];
                    Config *config = [Config Instance];
                    self.adInfo = [config getAdInfoWithMemberNo:config.memberNo];
                    if (!self.adInfo) {
                        self.adInfo = [[FPAdvertiseInfo alloc] initWithSeqNo:seqNo andHasSee:NO];

                        [config saveAdInfo:config.memberNo andObject:self.adInfo];
                    }
                    
                    FPDEBUG(@"ad:%d,%d,%d",self.adInfo.hasSee,(int)self.adInfo.seqNo,(int)seqNo);
                    BOOL showAd = NO;
                    if (self.adInfo.hasSee) {
                        if (self.adInfo.seqNo != seqNo) {
                            showAd = YES;
                            self.adInfo.seqNo = seqNo;
                        }
                    } else {
                        showAd = YES;
                        self.adInfo.seqNo = seqNo;
                    }
                    
                    if (showAd) {
                        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:self.lotteryItems.marketingInfo.modeName message:self.lotteryItems.marketingInfo.resourceName delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
                        alert.tag = kAlertTag;
                        [alert show];
                    } else {
                        [self showDisclaimer];
                    }
                }
                
            } else {
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:lotteryData.errorInfo delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
            [self.tableView reloadData];
        }
    }];
}

-(void)getGenerateSign
{
    FPLotterySign *lottery = [Config Instance].lotterySign;
    if (!lottery) {
        MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
        [UtilTool showHUD:@"正在通讯" andView:self.view andHUD:hud];
        [FPLotterySign getLotterySignWithBlock:^(FPLotterySign *lotterySign,NSError *error) {
            [hud hide:YES];
            if (error) {
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"网络连接失败,请查看网络是否连接正常！" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            } else {
                if (lotterySign.result) {
                    [[Config Instance] setLotterySign:lotterySign];
                } else {
                    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:lotterySign.errorInfo delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                }
                [self.tableView reloadData];
            }
        }];
    }
}

-(void)showDisclaimer
{
    if (self.lotteryViewType == FPLotteryViewControllerTypeAuth) {
        Config *config = [Config Instance];
        if (![config isShowDisclaimer:config.memberNo]) {
            NSString *errorInfo = @"    您点击\"立即进入\"按钮表明您同意本公司将您的用户识别码、富之富账户名、绑定 富之富账户的手机号码及个人身份等信息提供给彩票业务提供商\"我爱中彩票网\"，用于购彩业务。\n    您选择点击\"立即进入\"，表明您知晓本彩票业务由\"我爱中彩票网\"负责运营和维护 ，并对彩票业务过程和结果负责。富之富仅负责向\"我爱中彩票网\"传递用户的购彩需求、以及购彩资金的扣除转移。\n    您知晓，富之富账单里的支付成功，不代表彩票的最终成交结果，您知晓在\"购彩记录\"功能里的记录信息以及投注状态，才代表了彩票是否购买成功的最终结果。\n    如果您不同意以上授权和协议，请点击\"取消\"，退出彩票业务；否则，本公司将视 为您同意上述信息并愿意承担相应的一切后果。";
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:errorInfo delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"立即进入！",nil];
            alert.tag = kAlertTag + 3;
            [alert show];
        }
    }
}

#pragma mark table view datasource methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return [self.lotteryItems.lotteryList count];
    } else {
        return 2;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {

        FPLotteryCell* cell;
        if ([tableView respondsToSelector:@selector(dequeueReusableCellWithIdentifier:forIndexPath:)]) {
            cell = [tableView dequeueReusableCellWithIdentifier:myTableViewCellIndentifier forIndexPath:indexPath];
        } else {
            cell = [tableView dequeueReusableCellWithIdentifier:myTableViewCellIndentifier];
            if (cell == nil) {
                cell = [[FPLotteryCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:myTableViewCellIndentifier];
            }
        }
        
        FPLotteryObject *item = [self.lotteryItems.lotteryList objectAtIndex:indexPath.row];
        [cell setItem:item];
        
        return cell;
    } else {
        FPLotteryOtherCell* cell;
        if ([tableView respondsToSelector:@selector(dequeueReusableCellWithIdentifier:forIndexPath:)]) {
            cell = [tableView dequeueReusableCellWithIdentifier:myTableViewCellIndentifier1 forIndexPath:indexPath];
        } else {
            cell = [tableView dequeueReusableCellWithIdentifier:myTableViewCellIndentifier1];
            if (cell == nil) {
                cell = [[FPLotteryOtherCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:myTableViewCellIndentifier1];
            }
        }
        
        FPLotteryObject *item = [self.lotteryItems.othermode objectAtIndex:indexPath.row];
        cell.imageView.image = [self.ImageList objectForKey:item.resourceCode];
        cell.textLabel.text = item.resourceName;
        cell.textLabel.textColor = MCOLOR(@"text_color");
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        return cell;
    }
}

#pragma mark table view data delegate methods
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return [FPLotteryCell heightForCellWithLottery:[self.lotteryItems.lotteryList objectAtIndex:indexPath.row]];
    }
    else {
        return 40;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
     
     警告:
     
     1、身份证 和 姓名 是领奖的凭证，请在“我的账户”里确认信息；
     
     2、如因用户未填写正确的身份信息，而造成的一切的损失，富之富概不负责，是否前往填写真实信息?
     */
    NSString *warnMsg = @"1、身份证 和 姓名 是领奖的凭证，请在“我的账户”里确认信息；\n2、如因用户未填写正确的身份信息，而造成的一切的损失，富之富概不负责，是否前往填写真实信息?";
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 0) {
        NSInteger index = [indexPath row];
        
        FPLotteryObject *item = [self.lotteryItems.lotteryList objectAtIndex:index];
        if (self.lotteryViewType == FPLotteryViewControllerTypeAuth) {
            FPPersonMember *personMember = [Config Instance].personMember;
            if (!personMember.nameAuthFlag) {
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:warnMsg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"完善本人信息",nil];
                alert.tag = kAlertTag + 1;
                [alert show];
            }else{
                FPLotteryWebViewController *webController = [[FPLotteryWebViewController alloc] init];
                webController.title = item.resourceName;
                webController.webViewType = self.lotteryViewType;
                
                NSString *uriData = [webController getGenerateSign];
                if (uriData != nil) {
                    if ([item.redirectUri rangeOfString:@"?"].location == NSNotFound) {
                        webController.redirectUri = [NSString stringWithFormat:LOTTERYGETFORMART,item.redirectUri,uriData];
                    } else {
                        webController.redirectUri = [NSString stringWithFormat:LOTTERYGETFORMART_WITH_SYMBOL,item.redirectUri,uriData];
                    }                                                                                                                                                                                                                                           
                    
                    FPDEBUG(@"redirectUri:%@",webController.redirectUri);
                    [self.navigationController pushViewController:webController animated:YES];
                }
            }
        } else {
            FPLoginViewController *loginController = [[FPLoginViewController alloc] init];
            //    [self.navigationController setHidesBottomBarWhenPushed:YES];
            //            loginController.redirectUri = redirectUri;
            [self.navigationController pushViewController:loginController animated:YES];
            [self.navigationController setToolbarHidden:YES animated:NO];
        }

    } else {
        NSInteger index = [indexPath row];
        
        FPLotteryObject *item = [self.lotteryItems.othermode objectAtIndex:index];
        if ([item.resourceCode isEqualToString:@"mylottery"])
        {
            if (self.lotteryViewType == FPLotteryViewControllerTypeAuth) {

                FPPersonMember *personMember = [Config Instance].personMember;
                if (!personMember.nameAuthFlag) {
                    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:warnMsg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"完善本人信息",nil];
                    alert.tag = kAlertTag + 2;
                    [alert show];
                }else{

                    FPLotteryWebViewController *webController = [[FPLotteryWebViewController alloc] init];
                    webController.title = item.resourceName;
                    webController.webViewType = self.lotteryViewType;
                    
                    NSString *uriData = [webController getGenerateSign];
                    if (uriData != nil) {
                        
                        if ([item.redirectUri rangeOfString:@"?"].location == NSNotFound) {
                            webController.redirectUri = [NSString stringWithFormat:LOTTERYGETFORMART,item.redirectUri,uriData];
                        } else {
                            webController.redirectUri = [NSString stringWithFormat:LOTTERYGETFORMART_WITH_SYMBOL,item.redirectUri,uriData];
                        }
                        
                        FPDEBUG(@"redirectUri:%@",webController.redirectUri);
                        [self.navigationController pushViewController:webController animated:YES];
                    } 
                }
            } else {
                FPLoginViewController *loginController = [[FPLoginViewController alloc] init];
                //    [self.navigationController setHidesBottomBarWhenPushed:YES];
                //            loginController.redirectUri = redirectUri;
                [self.navigationController pushViewController:loginController animated:YES];
                [self.navigationController setToolbarHidden:YES animated:NO];
            }
        } else {
            FPLotteryWebViewController *webController = [[FPLotteryWebViewController alloc] init];
            webController.redirectUri = item.redirectUri;
            webController.title = item.resourceName;
            webController.webViewType = self.lotteryViewType;
            [self.navigationController pushViewController:webController animated:YES];
        }
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == kAlertTag) {
        //处理点击我知道了的处理动作
        self.adInfo.hasSee = YES;
        
        [[Config Instance] saveAdInfo:[Config Instance].memberNo andObject:self.adInfo];
        
        [self showDisclaimer];
        
    }else if (alertView.tag == kAlertTag + 1 || alertView.tag == kAlertTag + 2) {
        if (buttonIndex == 1) {
//            FPIdentityVerificationViewController *identificationView = [[FPIdentityVerificationViewController alloc] init];
//            [self.navigationController pushViewController:identificationView animated:YES];
            
            //前往实名
            FPNameAndStaffIdViewController *controller = [[FPNameAndStaffIdViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        }
    } else if(alertView.tag == kAlertTag + 3){
        if (buttonIndex == 0) {
            [self clickLeftButton:nil];
        } else {
            Config *config = [Config Instance];
            [config setShowDisclaimer:config.memberNo andFlag:YES];
        }
    }
    
}

@end
