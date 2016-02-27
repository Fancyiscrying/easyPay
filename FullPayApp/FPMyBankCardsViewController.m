//
//  FPMyBankCardsViewController.m
//  FullPayApp
//
//  Created by mark zheng on 14-2-17.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPMyBankCardsViewController.h"
#import "FPMyBankCardsCell.h"

#import "FPAddBankCardViewController.h"
#import "FPBankCardInfoViewController.h"
#import "FPNameAndStaffIdViewController.h"

@interface FPMyBankCardsViewController () <UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>

@property (nonatomic,strong) NSArray *itemDetails;

@property(nonatomic,strong) NSMutableArray *bankCardList;

@end

@implementation FPMyBankCardsViewController

static NSString *myTableViewCellIndentifier = @"itemMyBankCardsCell";

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
    [self getCurstomBankCardList];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.title = @"我的银行卡";
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    self.navigationItem.backBarButtonItem = backItem;
    backItem.title = @"";
    
    _tableView = [[UITableView alloc]initWithFrame:ScreenBounds];
    [self.tableView
     registerClass:[FPMyBankCardsCell class] forCellReuseIdentifier:myTableViewCellIndentifier];
    
    NSArray *detail = @[@"尾号2014 乔布斯",@"尾号2012 孙悟空",@"尾号2012 孙悟空"];
    
    self.itemDetails = @[detail];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.height = ScreenHigh-64;
    self.tableView.scrollEnabled = YES;
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
    v.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:v];
    
    [self.view addSubview:_tableView];
    [self getCurstomBankCardList];
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
        cell.textLabel.left = cell.textLabel.left - 10;
        cell.detailTextLabel.text = @"";
        cell.imageView.image = nil;

        
    } else {
        if (indexPath.section == 0) {
            NSString *imageName = @"home_ic_backc";
            
//            [cell.imageView setContentMode:UIViewContentModeScaleToFill];
//            cell.imageView.image = [UIImage imageNamed:imageName];
            cell.imageBack.image = [UIImage imageNamed:imageName];
            
            cell.textLabel.text = [self.bankCardList[indexPath.row] objectForKey:@"bankName"];
            cell.textLabel.textAlignment = NSTextAlignmentLeft;
            cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
            cell.textLabel.textColor = [UIColor darkGrayColor];
//            NSArray *detail = self.itemDetails[indexPath.section];
//            cell.detailTextLabel.text = detail[indexPath.row];
            NSString *lastFour = [self.bankCardList[indexPath.row] objectForKey:@"bankcardNoLastFour"];
            NSString *memberName = [self.bankCardList[indexPath.row] objectForKey:@"memberName"];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"尾号 %@ %@",lastFour,memberName];
            if (self.bankCardList.count == 0) {
                cell.detailTextLabel.text = @"";
            }
            cell.backgroundView = nil;
            cell.accessoryView.hidden = NO;
        } else {
            cell.textLabel.text = @"添加银行卡";
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
            cell.textLabel.textColor = [UIColor whiteColor];
            cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mybankcard_bt_add"]];
            cell.detailTextLabel.text = @"";
            cell.imageView.image = nil;
            cell.accessoryView.hidden = YES;
        }
    }
    
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"  储蓄卡";
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
        return self.bankCardList.count>0 ?  30.0f : 42.0f;
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
                if ([Config Instance].personMember.nameAuthFlag) {
                    FPAddBankCardViewController
                    *controllerView = [[FPAddBankCardViewController alloc] init];
                    
                    [self.navigationController pushViewController:controllerView animated:YES];
                }else{
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"此功能需实名认证才可使用!" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"前往实名", nil];
                    alert.tag = 101;
                    [alert show];
                
                }
                
            }
                break;
            default:
                break;
        }
        
    } else {
        NSInteger index = [indexPath row];
        if (indexPath.section == 0) {
           
            FPBankCardInfoViewController
            *controllerView = [[FPBankCardInfoViewController alloc] init];
            controllerView.bankCard = (NSDictionary *)self.bankCardList[index];
            controllerView.bankCardId = [self.bankCardList[index] objectForKey:@"id"];
            
            [self.navigationController pushViewController:controllerView animated:YES];
        } else {
            
            switch (index) {
                case 0:
                {
                    if ([Config Instance].personMember.nameAuthFlag) {
                        FPAddBankCardViewController
                        *controllerView = [[FPAddBankCardViewController alloc] init];
                        
                        [self.navigationController pushViewController:controllerView animated:YES];
                    }else{
                        
                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"此功能需实名认证才可使用!" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"前往实名", nil];
                        alert.tag = 101;
                        [alert show];
                    }

                    
                }
                    break;
                case 1:
                {
                    FPBankCardInfoViewController
                    *controllerView = [[FPBankCardInfoViewController alloc] init];
                    
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

#pragma mark UIAlertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 101 && buttonIndex == 1) {
        //前往实名
        FPNameAndStaffIdViewController *controller = [[FPNameAndStaffIdViewController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];

    }
    
}


@end
