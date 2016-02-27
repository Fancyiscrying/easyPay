//
//  FPBankCardListViewController.m
//  FullPayApp
//
//  Created by mark zheng on 14-2-28.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPBankCardListViewController.h"
#import "FPAddBankCardViewController.h"
#import "FPCardRechargeViewController.h"
#import "FPMyBankCardsCell.h"
#import "FPPayAmtToCardViewController.h"


@interface FPBankCardListViewController ()

@property (nonatomic,strong) NSArray *itemDetails;

@property(nonatomic,strong) NSMutableArray *bankCardList;

@end

@implementation FPBankCardListViewController

static NSString *myTableViewCellIndentifier = @"FPBankCardListViewCell";

- (id)initWithStyle:(UITableViewStyle)style
{
    UITableViewStyle types = UITableViewStyleGrouped;
    self = [super initWithStyle:types];
    if (self) {
        // Custom initialization
        
        CGRect tableRect = [UIScreen mainScreen].applicationFrame;
        self.tableView.frame = tableRect;
        
        self.tableView.backgroundView = [[UIImageView alloc] initWithImage:MIMAGE(@"BG")];
        self.tableView.backgroundColor = [UIColor clearColor];
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
        v.backgroundColor = [UIColor clearColor];
        [self.tableView setTableFooterView:v];
        
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tabBarController.tabBar setHidden:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    if (self.viewComeForm == BankCardListViewComeFormCardRecharge) {
        self.title = @"账户充值";
    }else if(self.viewComeForm == BankCardListViewComeFormPayAmtCard){
        self.title = @"我要转账";
        
    }
    
    [self getCurstomBankCardList];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.translucent = NO;
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    self.navigationItem.backBarButtonItem = backItem;
    backItem.title = @"";
    
    [self.tableView
     registerClass:[FPMyBankCardsCell class] forCellReuseIdentifier:myTableViewCellIndentifier];
    
    NSArray *detail = @[@"尾号2014 乔布斯",@"尾号2012 孙悟空",@"尾号2012 孙悟空"];
    
    self.itemDetails = @[detail];
    
    
    self.tableView.scrollEnabled = YES;
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark table view datasource methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.bankCardList && [self.bankCardList count] > 0) {
        return 2;
    }
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.bankCardList && [self.bankCardList count] > 0) {
        if (section == 0) {
            return [self.bankCardList count];
        } else {
            return 1;
        }
    }
    
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FPMyBankCardsCell* cell;
    if ([tableView respondsToSelector:@selector(dequeueReusableCellWithIdentifier:forIndexPath:)]) {
        cell = [tableView dequeueReusableCellWithIdentifier:myTableViewCellIndentifier forIndexPath:indexPath];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:myTableViewCellIndentifier];
        if (cell == nil) {
            cell = [[FPMyBankCardsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myTableViewCellIndentifier];
        }
    }
    
    if ([self numberOfSectionsInTableView:tableView] == 1) {
        
        cell.textLabel.text = @"添加银行卡";
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mybankcard_bt_add"]];
        cell.accessoryView.hidden = YES;
        
    } else {
        if (indexPath.section == 0) {
            cell.imageView.hidden = YES;
            cell.detailTextLabel.hidden = NO;
            
            NSString *imageName = @"home_ic_backc";
            
//            [cell.imageView setContentMode:UIViewContentModeScaleToFill];
//            cell.imageView.image = [UIImage imageNamed:imageName];
            cell.imageBack.image = [UIImage imageNamed:imageName];
            
            NSDictionary *bankCard = self.bankCardList[indexPath.row];
            
            cell.textLabel.text = [bankCard objectForKey:@"bankName"];
            cell.textLabel.textAlignment = NSTextAlignmentLeft;
            cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
            cell.textLabel.textColor = [UIColor darkGrayColor];
            
            NSString * bankcardNoLastFour = [bankCard objectForKey:@"bankcardNoLastFour"];
            NSString *memberName = [bankCard objectForKey:@"memberName"];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"尾号 %@ %@",bankcardNoLastFour,memberName];
            
            cell.backgroundView = nil;
            cell.accessoryView.hidden = NO;
        } else {
            cell.imageView.hidden = YES;
            cell.detailTextLabel.hidden = YES;
            cell.textLabel.text = @"添加银行卡";
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
            cell.textLabel.textColor = [UIColor whiteColor];
            cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mybankcard_bt_add"]];
            cell.accessoryView.hidden = YES;
        }
    }
    
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"  选择银行卡";
    }
    return nil;
}

#pragma mark tableview data delegate methods
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return self.bankCardList.count>0 ?  60.0f : 44.0f;
    } else {
        return 44.0f;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 42;
    }
    return 18.0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if ([self numberOfSectionsInTableView:tableView] == 1) {
        NSInteger index = [indexPath row];
        switch (index) {
            case 0:
            {
                FPAddBankCardViewController
                *controllerView = [[FPAddBankCardViewController alloc] init];
                
                [self.navigationController pushViewController:controllerView animated:YES];
            }
                break;
            default:
                break;
        }
        
    } else {
        NSInteger index = [indexPath row];
        if (indexPath.section == 0) {
            if (self.viewComeForm == BankCardListViewComeFormCardRecharge) {
                /**
                 账户充值
                */
                FPCardRechargeViewController
                *controllerView = [[FPCardRechargeViewController alloc] init];
                NSDictionary *bankCard = (NSDictionary *)self.bankCardList[index];
                controllerView.bankCardId = [bankCard objectForKey:@"id"];
                controllerView.bankCardNo = [bankCard objectForKey:@"bankcardNo"];
                
                [self.navigationController pushViewController:controllerView animated:YES];
                
            }else if(self.viewComeForm == BankCardListViewComeFormPayAmtCard){
                /**
                 转账到银行卡
                 */
                
                FPPayAmtToCardViewController
                *controllerView = [[FPPayAmtToCardViewController alloc] init];
                NSDictionary *bankCard = (NSDictionary *)self.bankCardList[index];
                controllerView.bankCard = bankCard;
                [self.navigationController pushViewController:controllerView animated:YES];
            }
        } else {
            
            switch (index) {
                case 0:
                {
                    FPAddBankCardViewController
                    *controllerView = [[FPAddBankCardViewController alloc] init];
                    
                    [self.navigationController pushViewController:controllerView animated:YES];
                    
                }
                    break;
                case 1:
                {
                    FPCardRechargeViewController
                    *controllerView = [[FPCardRechargeViewController alloc] init];
        
                    NSDictionary *bankCard = (NSDictionary *)self.bankCardList[index];
                    controllerView.bankCardId = [bankCard objectForKey:@"id"];
                    controllerView.bankCardNo = [bankCard objectForKey:@"bankcardNo"];

                    [self.navigationController pushViewController:controllerView animated:YES];
                }
                    break;
                default:
                    break;
            }
        }
    }
}

-(void)getCurstomBankCardList
{
    NSString *memberNo = [Config Instance].memberNo;
    FPClient *urlClient = [FPClient sharedClient];
    NSDictionary *parameters = [urlClient userBankCardList:memberNo];
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    [UtilTool showHUD:@"正在处理" andView:self.view andHUD:hud];
    
    [urlClient POST:kFPPost parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [hud hide:YES];
        FPDEBUG(@"%@",responseObject);
        if ([[responseObject objectForKey:@"result"] boolValue] == YES) {
            NSArray *returnObj = responseObject[@"returnObj"];
            FPDEBUG(@"%@",returnObj);
            
            self.bankCardList = [NSMutableArray arrayWithArray:returnObj];
            [self.tableView reloadData];
            
        }else{
            NSString *errInfo = [responseObject objectForKey:@"errorInfo"];
            UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"充值失败!" message:errInfo delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            
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
