//
//  FPWalletTradeViewController.m
//  FullPayApp
//
//  Created by lc on 14-8-13.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPWalletTradeViewController.h"
#import "FPWalletCardTradeAnalyzeController.h"
#import "MJRefresh.h"
#import "FPTradeBillsCell.h"
#import "FPWalletTradeList.h"

#define kFPCount @"20"

@interface FPWalletTradeViewController ()<RTSelectTabDelegate,UITableViewDataSource,UITableViewDelegate>
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


@implementation FPWalletTradeViewController

static NSString *myTableViewCellIndentifier = @"itemTradeBillsCell";
static NSString *selectDate = @"7";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView{
    UIView *view = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.view = view;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"收支查询";
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSDictionary *attribute = [NSDictionary dictionaryWithObjectsAndKeys:SystemFontSize(12),NSFontAttributeName, nil];
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithTitle:@"统计" style:UIBarButtonItemStylePlain target:self action:@selector(tapRightButton)];
    [right setTitleTextAttributes:attribute forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = right;
    
    UIBarButtonItem *back = [[UIBarButtonItem alloc]init];
    [back setTitle:@""];
    self.navigationItem.backBarButtonItem = back;

    
    RTSelectTab *selectTab = [[RTSelectTab alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 40) andButtonTitles:@[@"过去7天",@"过去30天",@"过去90天"]];
    [selectTab setLineLeft:21 andWidth:65];
    selectTab.delegate = self;
    [self.view addSubview:selectTab];


    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.top = 43;
    self.tableView.height = ScreenHigh-40-50-60;
    [self.tableView
     registerClass:[FPTradeBillsCell class] forCellReuseIdentifier:myTableViewCellIndentifier];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.scrollEnabled = YES;
    //    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
    v.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:v];
    
    
    UILabel *footLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
    footLabel.backgroundColor = [UIColor clearColor];
    footLabel.textAlignment = NSTextAlignmentCenter;
    footLabel.font = [UIFont systemFontOfSize:14];
    footLabel.text = @"已加载全部";
    
    [self.tableView setTableFooterView:footLabel];
    
    [self.view addSubview:self.tableView];
    msgTotal = 0;
    msgIndex = 0;
    isLoadOver = NO;
    
    [self addHeader];
    [self addFooter];
    
    [self clickButtonWithButtonIndex:0];
}
- (void)addFooter
{
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = self.tableView;
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {

        [self tradeQuery:NSStringFromInt((int)msgIndex)];

        // 模拟延迟加载数据，因此2秒后才调用）
        // 这里的refreshView其实就是footer
        [self performSelector:@selector(doneWithView:) withObject:refreshView afterDelay:2.0];
        
        NSLog(@"%@----开始进入刷新状态", refreshView.class);
    };
    _footer = footer;
}

- (void)addHeader
{
    
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = self.tableView;
    header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        // 进入刷新状态就会回调这个Block
        [self clear];
        [self tradeQuery:@"0"];
        // 模拟延迟加载数据，因此2秒后才调用）
        // 这里的refreshView其实就是header
        [self performSelector:@selector(doneWithView:) withObject:refreshView afterDelay:2.0];
        
        NSLog(@"%@----开始进入刷新状态", refreshView.class);
    };
    header.endStateChangeBlock = ^(MJRefreshBaseView *refreshView) {
        // 刷新完毕就会回调这个Block
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

- (void)clear
{
    msgIndex = 0;
    [self.msgArray removeAllObjects];
    isLoadOver = NO;
}


-(void)tradeQuery:(NSString *)start{
    if (isLoading == YES || isLoadOver == YES) {
        return;
    }
    
    isLoading = YES;
    MBProgressHUD *hud;
    if ([start isEqualToString:@"0"]) {
        hud = [[MBProgressHUD alloc] initWithView:self.view];
        [UtilTool showHUD:@"正在处理" andView:self.view andHUD:hud];
        [self dataLoadOver:NO];

    }
    
    [FPWalletTradeList getFPBillModelWithCardNo:self.cardItem.cardNo andMemberNo:[Config Instance].memberNo andStart:start andLimit:kFPCount andRecentDate:selectDate andBlock:^(FPWalletTradeList *billModel, NSError *error) {
        
        if ([start isEqualToString:@"0"]) {
            [hud hide:YES];
        }
        
        isLoading = NO;
        
        if (error) {
            [self showMojiNotice:YES];
            [self showToastMessage:kNetworkErrorMessage];
        } else {
            if (billModel.result) {
                
                if (billModel.total > 0) {
                    if (self.msgArray == nil) {
                        self.msgArray = [[NSMutableArray alloc] init];
                    }
                    
                    if ([start isEqualToString:@"0"]) {
                        if (self.msgArray) {
                            [self.msgArray removeAllObjects];
                        }
                    }
                    [self.msgArray addObjectsFromArray:billModel.tradeList];
                }
                
                if ([billModel.tradeList count] < [kFPCount intValue]) {
                    isLoadOver = YES;
                    [self dataLoadOver:YES];
                    if ([start isEqualToString:@"0"]) {
                        self.tableView.tableFooterView.hidden = YES;
                    }


                }else{
                    msgIndex += [kFPCount integerValue];
                }
                
                [self showMojiNotice:NO];
            } else {
                isLoadOver = YES;
                [self dataLoadOver:YES];
                [self showMojiNotice:YES];
                
                if ([start isEqualToString:@"0"]) {
                    self.tableView.tableFooterView.hidden = YES;
                }
            }
        }
        
        [self.tableView reloadData];
        
    }];
    
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
            WalletTradeItem *item = self.msgArray[indexPath.row];
            if (item.inFlag == YES) {
                NSString *typeStr = @"收入";
                tradeStr = [NSString stringWithFormat:@"%@ | %@",typeStr,item.tradeOtherSide];
            } else {
                NSString *typeStr = @"支出";
                tradeStr = [NSString stringWithFormat:@"%@ | %@",typeStr,item.tradeOtherSide];
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
            
            cell.lbl_TradeStatus.text = item.tradeStatus;
        }
    }
    
    return cell;
}
#pragma mark 显示加载完成

- (void)dataLoadOver:(BOOL)over{
    self.tableView.tableFooterView.hidden = !over;
    _footer.hidden = over;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark RTSelectTabDelegate

- (void)clickButtonWithButtonIndex:(int)buttonIndex{
    if (buttonIndex == 0) {
        selectDate = @"7";
    }
    if (buttonIndex == 1) {
        selectDate = @"30";
    }
    if (buttonIndex == 2) {
        selectDate = @"90";
    }
    [self clear];
    [self tradeQuery:@"0"];
}

- (void)tapRightButton{
    FPWalletCardTradeAnalyzeController *controller = [[FPWalletCardTradeAnalyzeController alloc]init];
    controller.cardItem = self.cardItem;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
