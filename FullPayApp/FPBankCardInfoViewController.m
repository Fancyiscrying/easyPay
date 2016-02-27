//
//  FPBankCardInfoViewController.m
//  FullPayApp
//
//  Created by mark zheng on 14-2-28.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPBankCardInfoViewController.h"
#import "FPBillDetailCell.h"
#import "FPMyBankCardsCell.h"

@interface FPBankCardInfoViewController () <UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

@property (strong, nonatomic) UITableView *tableView;

@property (nonatomic,strong) NSArray    *itemTitles;
@property (nonatomic,strong) NSArray    *itemDetails;

@end

@implementation FPBankCardInfoViewController

static NSString *myTableViewCellIndentifier = @"itemBankCardInfoCell";
static NSString *myTableViewCellIndentifier1 = @"itemBankCardInfoCell1";

- (void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    UIImageView *background = [[UIImageView alloc] initWithFrame:view.bounds];
    background.image = [UIImage imageNamed:@"BG"];
    [view addSubview:background];
    
    self.view = view;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(15, 10, 290, 158) style:UITableViewStylePlain];
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
    
    self.btn_Delete.frame = CGRectMake(15, 205, 290, 40);
    [self.btn_Delete setBackgroundColor:[UIColor redColor]];
    [self.btn_Delete setTitle:@"删除" forState:UIControlStateNormal];
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
    self.navigationItem.title = @"银行卡详情";
    self.navigationController.navigationBar.translucent = NO;
    
    [self.tableView
     registerClass:[FPBillDetailCell class] forCellReuseIdentifier:myTableViewCellIndentifier];
    [self.tableView
     registerClass:[FPMyBankCardsCell class] forCellReuseIdentifier:myTableViewCellIndentifier1];
    
    self.itemTitles = @[@"姓名",@"身份证号码"];
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
    
    self.itemDetails = @[memberName,idNumber];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)click_Delete:(UIButton *)sender
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"删除这张银行卡吗?" delegate:self cancelButtonTitle:@"按错了" otherButtonTitles:@"确认", nil];
    alert.tag = 101;
    [alert show];
    
}

-(BOOL)delCurstomBankCard:(NSString *)bankCardId
{
    __block BOOL result = NO;
    
    if (bankCardId.length == 0) {
        return NO;
    }
    
    NSString *memberNo = [Config Instance].memberNo;
    FPClient *urlClient = [FPClient sharedClient];
    NSDictionary *parameters = [urlClient userDelBankCard:memberNo andCardId:bankCardId];
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    [UtilTool showHUD:@"正在处理" andView:self.view andHUD:hud];
    
    [urlClient POST:kFPPost parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [hud hide:YES];
        FPDEBUG(@"%@",responseObject);
        if ([[responseObject objectForKey:@"result"] boolValue] == YES) {

            result = YES;
            
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            NSString *errInfo = [responseObject objectForKey:@"errorInfo"];
            UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"删除卡片失败!" message:errInfo delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            
            [alter setContentMode:UIViewContentModeCenter];
            [alter show];
        }
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [hud hide:YES];
        FPDEBUG(@"%@",error);
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"网络连接失败,请查看网络是否连接正常！" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }];
    
    return result;
}

#pragma mark UIAlertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 101 && buttonIndex == 1) {
        
        [self delCurstomBankCard:self.bankCardId];
        
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
        
        NSString *imageName = @"home_ic_backc";
        cell.imageBack.image = [UIImage imageNamed:imageName];
        
        cell.textLabel.text = [self.bankCard objectForKey:@"bankName"];
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
        cell.textLabel.textColor = [UIColor darkGrayColor];
        
        NSString *lastFour = [self.bankCard objectForKey:@"bankcardNoLastFour"];
        NSString *memberName = [self.bankCard objectForKey:@"memberName"];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"尾号 %@ %@",lastFour,memberName];
        
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
