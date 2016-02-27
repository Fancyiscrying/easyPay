//
//  FPLimitSetViewController.m
//  FullPayApp
//
//  Created by mark zheng on 14-2-17.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPLimitSetViewController.h"
#import "FPLimitSetCell.h"
#import "FPLimitSet.h"

#define PWD_LIMIT @"开启后，付款金额不超过%d元，无需输入支付密码。"
#define SMS_NOTICE @"开启后，付款金额超过%d元，将提供短信提醒。"
#define TIP1 @"提示：每日支付上限，实名认证账户%d元，非实名账户%d元。"

@interface FPLimitSetViewController () <UITableViewDelegate,UITableViewDataSource,FPLimitSetCellDelegate>

@property (nonatomic,strong) NSArray *itemTitles;
@property (nonatomic,strong) NSArray *itemDetails;

@property (nonatomic,strong) FPPersonMember *personMember;

@property (nonatomic,strong) NSString *noticeTips;
@property(nonatomic,strong) NSMutableArray *cellItems;

@end

@implementation FPLimitSetViewController

static NSString *myTableViewCellIndentifier = @"itemLimitCell";

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
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self initData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.title = @"支付额度管理";
    [self.tableView
     registerClass:[FPLimitSetCell class] forCellReuseIdentifier:myTableViewCellIndentifier];
    
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
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return [self.cellItems count];
    } else {
        return 1;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FPLimitSetCell* cell;
    if ([tableView respondsToSelector:@selector(dequeueReusableCellWithIdentifier:forIndexPath:)]) {
        cell = [tableView dequeueReusableCellWithIdentifier:myTableViewCellIndentifier forIndexPath:indexPath];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:myTableViewCellIndentifier];
        if (cell == nil) {
            cell = [[FPLimitSetCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myTableViewCellIndentifier];
        }
    }

    if (indexPath.section == 0) {
        
        [cell setLimitItem:self.cellItems[indexPath.row]];
        cell.delegate = self;
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

        
    } else {
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.text = self.noticeTips;
        cell.textLabel.font = [UIFont systemFontOfSize:12.0f];
        cell.textLabel.textColor = [UIColor grayColor];
        
        cell.userInteractionEnabled = NO;
        cell.accessoryView.hidden = YES;
    }
    
    
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
        return 0;
    }
    return 18.0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - update paycredit delegate
-(void)updateLimitSet:(FPLimitSetCell *)sender
{

    FPLimitSetCell *payMgrCell = sender;
    UIButton *btnSwitch = payMgrCell.btn_Switch;
    FPDEBUG(@"%ld",(long)btnSwitch.tag);
    
    NSString *memberNo = [Config Instance].memberNo;
    FPClient *urlClient = [FPClient sharedClient];
    NSDictionary *parameters ;
    if (payMgrCell.tag == 101) {
        self.personMember.noPswLimitOn = !self.personMember.noPswLimitOn;
        parameters = [urlClient userInformationUpdate:memberNo andNoPswLimitOn:self.personMember.noPswLimitOn andPayLimitOn:-1 andNoteListOn:-1];
    } else if (payMgrCell.tag == 102){
        self.personMember.noteLimitOn = !self.personMember.noteLimitOn;
        parameters =  [urlClient userInformationUpdate:memberNo andNoPswLimitOn:-1 andPayLimitOn:-1 andNoteListOn:self.personMember.noteLimitOn];
    }
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    [UtilTool showHUD:@"正在处理中" andView:self.view andHUD:hud];
    
    [urlClient POST:kFPPost parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [hud hide:YES];
        FPDEBUG(@"%@",responseObject);
        if ([[responseObject objectForKey:@"result"] boolValue] == YES) {
            btnSwitch.selected = !btnSwitch.isSelected;
            
            [[Config Instance] setPersonMember:self.personMember];
            
            NSString *title = nil;
            if (btnSwitch.isSelected) {
                title = [NSString stringWithFormat:@"%@ 开启",payMgrCell.textLabel.text];
            } else {
                title = [NSString stringWithFormat:@"%@ 关闭",payMgrCell.textLabel.text];

            }
            
            UIAlertView *alter = [[UIAlertView alloc]initWithTitle:title message:nil delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
            
            [alter setContentMode:UIViewContentModeCenter];
            [alter show];
        }else{
            NSString *errInfo = [responseObject objectForKey:@"errorInfo"];
            UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"额度设置失败" message:errInfo delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            
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

-(void)initData
{
    NSInteger  noPswLimit = 20;
    NSInteger  minSmsSend = 50;
    
    NSInteger  realMaxPayLimit = 10;
    NSInteger  noRealMaxPayLimit = 10;
    //初始化frequentvariabl
    self.personMember = [Config Instance].personMember;
    //    noPswLimit = [self.frequentVariable.noPswLimit integerValue]/100;
    
    FPAppParams *appParams = [Config Instance].appParams;
    if (appParams.noPswAmountLimit && appParams.noPswAmountLimit.length > 0) {
        noPswLimit = [appParams.noPswAmountLimit integerValue]/100;
    }
    
    minSmsSend = [appParams.noteLimitOn integerValue]/100;

    
    realMaxPayLimit = [appParams.realNamePayAmountLimit integerValue]/100;
    noRealMaxPayLimit = [appParams.unRealNamePayAmountLimit integerValue]/100;
    self.noticeTips = [NSString stringWithFormat:TIP1,(int)realMaxPayLimit,(int)noRealMaxPayLimit];

    NSMutableArray *cellItems = [NSMutableArray arrayWithCapacity:3];
    FPLimitSet *payCredit = [[FPLimitSet alloc] init];
    payCredit.title = @"小额免密支付";
    payCredit.isOn = self.personMember.noPswLimitOn;
    payCredit.filedTag = 101;
    payCredit.notice = [NSString stringWithFormat:PWD_LIMIT,(int)noPswLimit];
    [cellItems addObject:payCredit];
    
    payCredit = [[FPLimitSet alloc] init];
    payCredit.title = @"付款短信提醒";
    payCredit.isOn = self.personMember.noteLimitOn;
    payCredit.filedTag = 102;
    payCredit.notice = [NSString stringWithFormat:SMS_NOTICE,(int)minSmsSend];
    [cellItems addObject:payCredit];
    
    self.cellItems = cellItems;
    
    [self.tableView reloadData];
    
}

@end
