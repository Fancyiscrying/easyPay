//
//  FPTradeBillsViewController.m
//  FullPayApp
//
//  Created by mark zheng on 14-2-18.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import <AudioToolbox/AudioToolbox.h>
#import "FPTradeBillsViewController.h"
#import "FPTradeBillsCell.h"
#import "FPBillDetailsViewController.h"
#import "FPBillAnalyseViewController.h"

#import "DataSingleton.h"
#import "MJRefresh.h"
#import "FPBillModel.h"

@interface FPTradeBillsViewController () <UITableViewDelegate,UITableViewDataSource>
{
    MJRefreshHeaderView *_header;
    MJRefreshFooterView *_footer;
    
    BOOL isLoading;
    BOOL isLoadOver;
    int msgTotal;
    BOOL _reloading;
    
    NSInteger msgIndex;
}
@property (nonatomic,strong) NSMutableArray *msgArray;

@end

@implementation FPTradeBillsViewController

NSString *const kFPCount = @"20";
static NSString *myTableViewCellIndentifier = @"itemTradeBillsCell";

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
        _msgArray  = [[NSMutableArray alloc] initWithCapacity:20];
    }
    
    return _msgArray;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.title = @"交易账单";
    self.navigationController.navigationBar.translucent = NO;
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    self.navigationItem.backBarButtonItem = backItem;
    backItem.title = @"";
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"user_bt_statistical"] style:UIBarButtonItemStylePlain target:self action:@selector(click_RightButton:)];
    [self.navigationItem setRightBarButtonItem:rightButton];
    
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    
    [self.tableView
     registerClass:[FPTradeBillsCell class] forCellReuseIdentifier:myTableViewCellIndentifier];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.scrollEnabled = YES;
    self.tableView.height = ScreenHigh - 64;
    //    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
    v.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:v];
    
    [self.view addSubview:self.tableView];
    
    msgTotal = 0;
    msgIndex = 0;
    isLoadOver = NO;
    
    [self addHeader];
    [self addFooter];
}

- (void)clear
{
    msgIndex = 0;
    [self.msgArray removeAllObjects];
    isLoadOver = NO;
}

- (void)click_RightButton:(UIButton *)sender
{
    FPBillAnalyseViewController *controller = [[FPBillAnalyseViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addFooter
{
    __unsafe_unretained FPTradeBillsViewController *vc = self;
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = self.tableView;
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {

        if (!isLoading) {
            [self reload:YES];
        }
        
        // 模拟延迟加载数据，因此2秒后才调用）
        // 这里的refreshView其实就是footer
        [vc performSelector:@selector(doneWithView:) withObject:refreshView afterDelay:2.0];
        
        NSLog(@"%@----开始进入刷新状态", refreshView.class);
    };

    _footer = footer;
    
}

- (void)addHeader
{
    __unsafe_unretained FPTradeBillsViewController *vc = self;
    
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = self.tableView;
    header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        // 进入刷新状态就会回调这个Block
        [self reload:NO];
        
        // 模拟延迟加载数据，因此2秒后才调用）
        // 这里的refreshView其实就是header
        [vc performSelector:@selector(doneWithView:) withObject:refreshView afterDelay:2.0];
        
        NSLog(@"%@----开始进入刷新状态", refreshView.class);
    };
    header.endStateChangeBlock = ^(MJRefreshBaseView *refreshView) {
        // 刷新完毕就会回调这个Block
        [self performSelectorInBackground:@selector(playSound) withObject:nil];
        NSLog(@"%@----刷新完毕", refreshView.class);
    };
    header.refreshStateChangeBlock = ^(MJRefreshBaseView *refreshView, MJRefreshState state) {
        // 控件的刷新状态切换了就会调用这个block
        switch (state) {
            case MJRefreshStateNormal:
                NSLog(@"%@----切换到：普通状态", refreshView.class);
                break;
                
            case MJRefreshStatePulling:
                NSLog(@"%@----切换到：松开即可刷新的状态", refreshView.class);
                break;
                
            case MJRefreshStateRefreshing:
                NSLog(@"%@----切换到：正在刷新状态", refreshView.class);
                break;
            default:
                break;
        }
    };
    [header beginRefreshing];
    _header = header;
}

- (void)doneWithView:(MJRefreshBaseView *)refreshView
{
    // 刷新表格
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [refreshView endRefreshing];
}

/**
 为了保证内部不泄露，在dealloc中释放占用的内存
 */
- (void)dealloc
{
    NSLog(@"MJTableViewController--dealloc---");
    [_header free];
    [_footer free];
}

- (void)reload:(BOOL)noRefresh
{
    //如果有网络连接
//    if ([Config Instance].isNetworkRunning) {
        if (isLoading || isLoadOver) {
            return;
        }
        if (!noRefresh) {
            msgIndex = 0;
        }
        
        [self tradeQuery:[NSString stringWithFormat:@"%d",(int)msgIndex]];
        
//    }
}

-(void)tradeQuery:(NSString *)start
{
    isLoading = YES;
    MBProgressHUD *hud;
    if ([start isEqualToString:@"0"]) {
        hud = [[MBProgressHUD alloc] initWithView:self.view];
        [UtilTool showHUD:@"正在处理" andView:self.view andHUD:hud];
    }
    
    [FPBillModel getFPBillModel:start andLimit:kFPCount andBlock:^(FPBillModel *marketing,NSError *error){
        if ([start isEqualToString:@"0"]) {
            [hud hide:YES];
        }
        
        isLoading = NO;
        
        if (error) {
            [self showMojiNotice:YES];
            [self showToastMessage:kNetworkErrorMessage];
        } else {
            if (marketing.result) {
                
                if (marketing.total > 0) {
                    if ([start isEqualToString:@"0"]) {
                        if (self.msgArray) {
                            [self.msgArray removeAllObjects];
                        }
                    }
                    [self.msgArray addObjectsFromArray:marketing.billItems];
                }
                
                if ([marketing.billItems count] < [kFPCount intValue]) {
                    isLoadOver = YES;
                }
                
                msgIndex += [kFPCount integerValue];
                [self showMojiNotice:NO];

            } else {
                isLoadOver = YES;
                [self showMojiNotice:YES];
            }
        }
        
    }];
    
    isLoading = NO;
}

#pragma mark table view datasource methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.msgArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    FPTradeBillsCell* cell;
    if ([tableView respondsToSelector:@selector(dequeueReusableCellWithIdentifier:forIndexPath:)]) {
        cell = [tableView dequeueReusableCellWithIdentifier:myTableViewCellIndentifier forIndexPath:indexPath];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:myTableViewCellIndentifier];
        if (cell == nil) {
            cell = [[FPTradeBillsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myTableViewCellIndentifier];
        }
    }
    
    if ([self.msgArray count] > 0) {
        if (indexPath.row < [self.msgArray count]) {
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
            cell.detailTextLabel.text = item.tradeTime;
            if (item.inFlag == YES) {
                cell.lbl_TradeAmt.text = [NSString stringWithFormat:@"+%.02f 元",item.amt/100] ;
                cell.lbl_TradeAmt.textColor = [ColorUtils hexStringToColor:@"FFAA22"];

            } else {
                cell.lbl_TradeAmt.text = [NSString stringWithFormat:@"-%.02f 元",item.amt/100] ;
                cell.lbl_TradeAmt.textColor =[ColorUtils hexStringToColor:@"33CC33"];

            }
            
            cell.lbl_TradeStatus.text = item.businessStatusName;
        }
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
        return 0.0f;
    }
    return 18.0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (indexPath.row < [self.msgArray count]) {
        FPBillDetailsViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"FPBillDetailsView"];
        FPBillItem *item = self.msgArray[indexPath.row];
        controller.trade_name = item.memberCardName;
        controller.trade_type = item.businessName;
        if (item.inFlag == YES) {
            controller.trade_amt = [NSString stringWithFormat:@"%.02f 元",item.amt/100] ;
        } else {
            controller.trade_amt = [NSString stringWithFormat:@"%.02f 元",item.amt/100] ;
        }
        controller.trade_fee = item.fee/100;
        controller.trade_time = item.tradeTime;
        controller.trade_remark = item.tradeInfo;
        controller.trade_status = item.businessStatusName;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

-(void)playSound
{
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"msgcome" ofType:@"wav"];
//    NSURL *url = [NSURL fileURLWithPath:path];
//    SystemSoundID soundId;
//    AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &soundId);
//    AudioServicesPlaySystemSound(soundId);
}

@end
