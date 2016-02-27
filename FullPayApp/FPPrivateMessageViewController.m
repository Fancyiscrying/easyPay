//
//  FPPrivateMessageViewController.m
//  FullPayApp
//
//  Created by mark zheng on 14-2-18.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//
#import <AudioToolbox/AudioToolbox.h>
#import "FPPrivateMessageViewController.h"
#import "FPPrivateMessageCell.h"
#import "FPMsgDetailViewController.h"
#import "FPMessageList.h"
#import "MJRefresh.h"

#define LIMIT @"20"

static int messageStart = 0;

@interface FPPrivateMessageViewController () <UITableViewDelegate,UITableViewDataSource,MJRefreshBaseViewDelegate>

@property (nonatomic,strong) NSArray    *itemTitles;
@property (nonatomic,strong) NSArray    *itemDetails;
@property (nonatomic, strong) NSMutableArray *messageList;

@property (nonatomic, assign) BOOL isLoadOver;
@property (nonatomic, assign) BOOL isLoading;

@property (strong, nonatomic) MJRefreshHeaderView *header;
@property (strong, nonatomic) MJRefreshFooterView *footer;

@property (strong, nonatomic) UIButton *footButton;

@end

@implementation FPPrivateMessageViewController

static NSString *myTableViewCellIndentifier = @"itemPrivateMessageCell";

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
    self.tabBarController.tabBar.hidden = YES;
    
    [self downloadMessageWithStart:@"0"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.title = @"我的私信";
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    self.navigationItem.backBarButtonItem = backItem;
    backItem.title = @"";
    
    self.tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    
    [self.tableView
     registerClass:[FPPrivateMessageCell class] forCellReuseIdentifier:myTableViewCellIndentifier];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.scrollEnabled = YES;
    //    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.height = ScreenHigh-70;
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    v.backgroundColor = [UIColor clearColor];
    _footButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _footButton.frame = v.frame;
    _footButton.backgroundColor = [UIColor clearColor];
    [_footButton addTarget:self action:@selector(getMoreMessage) forControlEvents:UIControlEventTouchUpInside];
    [_footButton setTitle:@"上拉获取更多数据" forState:UIControlStateNormal];
    _footButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [_footButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [v addSubview:_footButton];
    [self.tableView setTableFooterView:v];
    
    [self.view addSubview:self.tableView];
    
    NSArray *titles = @[@"富之富APP2.0即将发布，更多超爽无比的功能......",@"恭喜你，晋升为VIP2会员，获取更多地返利和特权!"];
    NSArray *details = @[@"时间：2014-01-22 14:38:22",@"时间：2014-01-22 14:38:22"];
    self.itemTitles = titles;
    self.itemDetails = details;
    
    [self addRefreshView];
    
    [self.view bringSubviewToFront:defaultBackView];
    
    [self downloadMessageWithStart:@"0"];
}

- (void)getMoreMessage{
    NSString *start = [NSString stringWithFormat:@"%d",messageStart];
    [self downloadMessageWithStart:start];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark table view datasource methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.messageList count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FPPrivateMessageCell* cell;
    if ([tableView respondsToSelector:@selector(dequeueReusableCellWithIdentifier:forIndexPath:)]) {
        cell = [tableView dequeueReusableCellWithIdentifier:myTableViewCellIndentifier forIndexPath:indexPath];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:myTableViewCellIndentifier];
        if (cell == nil) {
            cell = [[FPPrivateMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myTableViewCellIndentifier];
        }
    }
    userMessage *message = self.messageList[indexPath.row];
    cell.textLabel.text = message.content;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"时间:%@",message.createDate];
    
    if (!message.readed) {
        cell.lbl_Status.text = @"New";
    }else{
        cell.lbl_Status.text = @"";
    }
    
    return cell;
}

#pragma mark tableview data delegate methods
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0f;
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
    FPMsgDetailViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"FPMsgDetailView"];
    userMessage *message = self.messageList[indexPath.row];
    controller.mes = message;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)downloadMessageWithStart:(NSString *)start{
    if ([start isEqualToString:@"0"]) {
        _isLoadOver = NO;
        messageStart = 0;
        
        [_footButton setTitle:@"上拉获取更多数据"forState:UIControlStateNormal];

        _footButton.titleLabel.text = @"上拉获取更多数据";
        _footButton.enabled = YES;
    }
    
    if (_isLoadOver == YES || _isLoading == YES) {
        
        return;
    }
    _isLoading = YES;
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    [UtilTool showHUD:@"正在处理" andView:self.view andHUD:hud];
    
   [FPMessageList findMessageList:start andLimit:LIMIT andMemberNo:[Config Instance].memberNo and:^(FPMessageList *messageList, NSError *error) {
       
       _isLoading = NO;
       
       [hud hide:YES];
       if (messageList == nil) {
           NSString *errorInfo = [NSString stringWithFormat:@"%@",error];
           [self showToastMessage:errorInfo];
           return ;
       }
       
       BOOL result = messageList.result;
       if (result) {
           if ([start isEqualToString:@"0"]) {
               if (self.messageList == nil) {
                   self.messageList = [[NSMutableArray alloc]init];
               }
               
               [self.messageList removeAllObjects];
               [self.messageList addObjectsFromArray:messageList.messageItems];
               
           }else{
               [self.messageList addObjectsFromArray:messageList.messageItems];
           }
           
           messageStart += messageList.messageItems.count;

           if (messageList.messageItems.count < [LIMIT intValue]) {
               _isLoadOver = YES;
               [_footButton setTitle:@"没有更多数据了"forState:UIControlStateNormal];
               _footButton.titleLabel.text = @"没有更多数据了";
               _footButton.enabled = NO;
           }else{
               _isLoadOver = NO;
               [_footButton setTitle:@"上拉获取更多数据"forState:UIControlStateNormal];
               _footButton.titleLabel.text = @"上拉获取更多数据";
               _footButton.enabled = YES;
           }
           
           [self.tableView reloadData];
           [self showMojiNotice:NO];
           self.tableView.tableFooterView.hidden = NO;
       }else{
           //[self showToastMessage:messageList.errorInfo];
           [self showMojiNotice:YES];
           self.tableView.tableFooterView.hidden = YES;
       }
       
   }];
}

#pragma mark  refresh view
- (void)addRefreshView{
    [self addHeader];
    [self addFooter];
}

- (void)addFooter
{
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = self.tableView;
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        
        [self downloadMessageWithStart:[NSString stringWithFormat:@"%d",messageStart]];
        
        // 模拟延迟加载数据，因此2秒后才调用）
        // 这里的refreshView其实就是footer
        [self performSelector:@selector(doneWithView:) withObject:refreshView afterDelay:1.5];
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
        [self downloadMessageWithStart:@"0"];
        
        // 模拟延迟加载数据，因此2秒后才调用）
        // 这里的refreshView其实就是header
        [self performSelector:@selector(doneWithView:) withObject:refreshView afterDelay:1.5];
        
        NSLog(@"%@----开始进入刷新状态", refreshView.class);
    };
    header.endStateChangeBlock = ^(MJRefreshBaseView *refreshView) {
        // 刷新完毕就会回调这个Block
       // [self performSelectorInBackground:@selector(playSound) withObject:nil];
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

-(void)playSound
{
    //取消声音
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"msgcome" ofType:@"wav"];
//    NSURL *url = [NSURL fileURLWithPath:path];
//    SystemSoundID soundId;
//    AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &soundId);
//    AudioServicesPlaySystemSound(soundId);
}




@end
