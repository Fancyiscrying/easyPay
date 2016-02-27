//
//  FPCommitBankCardController.m
//  FullPayApp
//
//  Created by lc on 14-7-2.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPCommitBankCardController.h"
#import "FPBillDetailCell.h"
#import "FPMyBankCardsCell.h"
#import "FPCardRechargeViewController.H"

@interface FPCommitBankCardController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
@property (strong, nonatomic) UITableView *tableView;

@property (nonatomic,strong) NSArray    *itemTitles;
@property (nonatomic,strong) NSArray    *itemDetails;
@property (copy, nonatomic) NSString *bankCardId;
@property (copy, nonatomic) NSString *bankCardNo;
@end

@implementation FPCommitBankCardController

static NSString *myTableViewCellIndentifier = @"itemBankCardInfoCell";
static NSString *myTableViewCellIndentifier1 = @"itemBankCardInfoCell1";

- (void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    UIImageView *background = [[UIImageView alloc] initWithFrame:view.bounds];
    background.image = [UIImage imageNamed:@"BG"];
    [view addSubview:background];
    
    self.view = view;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(15, 10, 290, 198) style:UITableViewStylePlain];
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
    
    [view addSubview:self.tableView];
    
    self.btn_Delete = [UIButton buttonWithType:UIButtonTypeCustom];
    
    self.btn_Delete.frame = CGRectMake(15, 245, 290, 40);
    [self.btn_Delete setBackgroundColor:[UIColor orangeColor]];
    [self.btn_Delete setTitle:@"下一步" forState:UIControlStateNormal];
    [self.btn_Delete setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btn_Delete addTarget:self action:@selector(click_Delete:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:self.btn_Delete];
    
    self.view = view;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.title = @"确认银行卡信息";
    self.navigationController.navigationBar.translucent = NO;
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    self.navigationItem.backBarButtonItem = backItem;
    backItem.title = @"";
    
    [self.tableView
     registerClass:[FPBillDetailCell class] forCellReuseIdentifier:myTableViewCellIndentifier];
    [self.tableView
     registerClass:[FPMyBankCardsCell class] forCellReuseIdentifier:myTableViewCellIndentifier1];
    
    self.itemTitles = @[@"卡号",@"姓名",@"身份证号码"];
    
    NSString *memberName = [self.bankCard objectForKey:@"memberName"];
    
    FPPersonMember *personMember = [Config Instance].personMember;
    NSString *idNumber = @"";
    if (personMember.nameAuthFlag) {
        NSString *idInfo = [personMember.certNo copy];
        if (idInfo.length > 7) {
            NSUInteger len = idInfo.length - 7;
            NSMutableString *replaceStr = [[NSMutableString alloc] initWithCapacity:0];
            for (int i = 0; i < len; i++) {
                [replaceStr appendString:@"*"];
            }
            
            idNumber = [idInfo stringByReplacingCharactersInRange:NSMakeRange(6, len) withString:replaceStr];
        }
    }
    NSString *cardNum = [self.bankCard objectForKey:@"cardNo"];
    cardNum = [cardNum formateCardNo];
    
    self.itemDetails = @[cardNum,memberName,idNumber];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)click_Delete:(UIButton *)sender
{
    
    NSString *cardNo = [self.bankCard objectForKey:@"cardNo"];
    NSString *bankName = [self.bankCard objectForKey:@"bankName"];
    NSString *bankCode = [self.bankCard objectForKey:@"bankCode"];
    NSString *memberNo = [Config Instance].memberNo;
    self.bankCardNo = cardNo;

    FPClient *urlClient = [FPClient sharedClient];
    NSDictionary *parameters = [urlClient userAddBankCard:memberNo andBankCardNo:cardNo andBankCode:bankCode andBankName:bankName];
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    [UtilTool showHUD:@"正在处理" andView:self.view andHUD:hud];
    
    [urlClient POST:kFPPost parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [hud hide:YES];
        FPDEBUG(@"%@",responseObject);
        if ([[responseObject objectForKey:@"result"] boolValue] == YES) {
            NSDictionary *object = [responseObject objectForKey:@"returnObj"];
            FPDEBUG(@"%@",object);
            if (object) {
                self.bankCardId = [object objectForKey:@"id"];
                
                NSArray *viewControllers = self.navigationController.viewControllers;
                for (UIViewController *temp in viewControllers) {
                    if ([temp isKindOfClass:NSClassFromString(@"FPPayTypeViewController")]) {
                        
                        UIAlertView *alter = [[UIAlertView alloc]initWithTitle:nil message:@"添加成功!" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
                        alter.tag = 103;
                        [alter show];
                        
                        return;
                    }
                    
                    if ([temp isKindOfClass:NSClassFromString(@"FPMyBankCardsViewController")]) {
                        
                        UIAlertView *alter = [[UIAlertView alloc]initWithTitle:nil message:@"添加成功!" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
                        alter.tag = 102;
                        [alter show];
                        
                        return;
                    }

                }
                
                UIAlertView *alter = [[UIAlertView alloc]initWithTitle:nil message:@"添加成功!" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:@"给账户充值", nil];
                alter.tag = 101;
                [alter show];
                
            } else {
                UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"添加银行卡信息失败!" message:@"" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                
                [alter setContentMode:UIViewContentModeCenter];
                [alter show];
                
            }
        }else{
            NSString *errInfo = [responseObject objectForKey:@"errorInfo"];
            UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"添加银行卡信息失败!" message:errInfo delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            
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
    if (alertView.tag == 101) {
        if (buttonIndex == 0) {
            UIViewController *controller = self.navigationController.viewControllers[1];
            [self.navigationController popToViewController:controller animated:YES];
        }else if (buttonIndex == 1){
            FPCardRechargeViewController *controller = [[FPCardRechargeViewController alloc]init];
            controller.bankCardId = self.bankCardId;
            controller.bankCardNo = self.bankCardNo;
            [self.navigationController pushViewController:controller animated:YES];
        }
    }
    
    if (alertView.tag == 102) {
        UIViewController *controller = self.navigationController.viewControllers[1];
        [self.navigationController popToViewController:controller animated:YES];
    }
    
    if (alertView.tag == 103) {
        UIViewController *controller = self.navigationController.viewControllers[2];
        [self.navigationController popToViewController:controller animated:YES];
    }

}

#pragma mark table view datasource methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        return [self.itemTitles count];
    } else  {
        return 1;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        FPMyBankCardsCell* cell;
        if ([tableView respondsToSelector:@selector(dequeueReusableCellWithIdentifier:forIndexPath:)]) {
            cell = [tableView dequeueReusableCellWithIdentifier:myTableViewCellIndentifier1 forIndexPath:indexPath];
        } else {
            cell = [tableView dequeueReusableCellWithIdentifier:myTableViewCellIndentifier1];
            if (cell == nil) {
                cell = [[FPMyBankCardsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myTableViewCellIndentifier1];
            }
        }
        
        NSString *imageName = @"user_ic_bankc";
        
        [cell.imageView setContentMode:UIViewContentModeScaleToFill];
        cell.imageView.image = [UIImage imageNamed:imageName];
        
        cell.textLabel.text = [self.bankCard objectForKey:@"bankName"];
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
        cell.textLabel.textColor = [UIColor darkGrayColor];
        
        cell.detailTextLabel.text = @"储蓄卡";
        
        cell.backgroundView = nil;
        cell.accessoryView.hidden = YES;
        
        return cell;
    } else {
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
        if (indexPath.row == 0) {
            cell.detailTextLabel.textColor = [UIColor orangeColor];
        }else{
            cell.detailTextLabel.textColor = [UIColor grayColor];
        }
        
        return cell;
    }
}

#pragma mark tableview data delegate methods
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 60.0f;
    }
    
    return 40.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.0f;
    }
    
    return 18.0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


@end
