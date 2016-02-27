//
//  FPPreferentialViewController.m
//  FullPayApp
//
//  Created by mark zheng on 14-2-18.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPPreferentialViewController.h"
#import "FPPreferentialCell.h"
#import "FPPreferDetailViewController.h"

#import "FPDefaultView.h"

#import "FPPreferModel.h"

@interface FPPreferentialViewController () <UITableViewDelegate,UITableViewDataSource>
{
    NSInteger msgIndex;
}
@property (nonatomic,strong) NSMutableArray *msgArray;


@end

@implementation FPPreferentialViewController

NSString *const kFPCount1 = @"10";

static NSString *myTableViewCellIndentifier = @"itemPreferentialCell";

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
    
    [self tradeQuery:@"0"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.title = @"优惠动态";
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    self.navigationItem.backBarButtonItem = backItem;
    backItem.title = @"";
    
    [self.tableView
     registerClass:[FPPreferentialCell class] forCellReuseIdentifier:myTableViewCellIndentifier];
    
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
    
    [self.view bringSubviewToFront:defaultBackView];
    
    //保存本次拉取时间戳
    //用于优惠动态提示
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *currentDateStr = [NSDate date];
    
    NSLog(@"%@",dateFormatter);
    
    NSString *dateStr = [dateFormatter stringFromDate:currentDateStr];
    NSLog(@"dateStr:%@",dateStr);
    if (dateStr.length>0) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:dateStr forKey:LAST_DATE];
        [defaults synchronize];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tradeQuery:(NSString *)start
{
    MBProgressHUD *hud;
    if ([start isEqualToString:@"0"]) {
        hud = [[MBProgressHUD alloc] initWithView:self.view];
        [UtilTool showHUD:@"正在处理" andView:self.view andHUD:hud];
    }
    
    [FPPreferModel getFPPreferModel:start andLimit:kFPCount1 andBlock:^(FPPreferModel *marketing,NSError *error){
        if ([start isEqualToString:@"0"]) {
            [hud hide:YES];
        }
        
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
                    [self.msgArray addObjectsFromArray:marketing.preferItems];
                } else {
                   
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
                
                msgIndex += [kFPCount1 integerValue];
                [self showMojiNotice:NO];

            } else {
                [self showMojiNotice:YES];
                
                //[self showToastMessage:marketing.errorInfo];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
                
            }
            [self.tableView reloadData];
        }
        
    }];
    
    [self.tableView reloadData];
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
    FPPreferentialCell* cell;
    if ([tableView respondsToSelector:@selector(dequeueReusableCellWithIdentifier:forIndexPath:)]) {
        cell = [tableView dequeueReusableCellWithIdentifier:myTableViewCellIndentifier forIndexPath:indexPath];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:myTableViewCellIndentifier];
        if (cell == nil) {
            cell = [[FPPreferentialCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myTableViewCellIndentifier];
        }
    }
    
    if ([self.msgArray count] > 0) {
        FPPreferItem *item = self.msgArray[indexPath.row];
        cell.textLabel.text = item.activityName;
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        NSDate *currentDateStr = [dateFormatter dateFromString:item.activityBeginDate];
        NSDate *currentDateStr1 = [dateFormatter dateFromString:item.activityEndDate];
        
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *dateStr = [dateFormatter stringFromDate:currentDateStr];
        NSString *dateStr1 = [dateFormatter stringFromDate:currentDateStr1];
        NSString *activeDate = [NSString stringWithFormat:@"活动有效期：%@ 至 %@",dateStr,dateStr1];
        cell.detailTextLabel.text = activeDate;
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
    
    FPPreferDetailViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"FPPreferDetailView"];
    
    FPPreferItem *item = self.msgArray[indexPath.row];
    controller.prefer_Title = item.activityName;
    controller.prefer_Business = item.merchantName;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *currentDateStr = [dateFormatter dateFromString:item.activityBeginDate];
    NSDate *currentDateStr1 = [dateFormatter dateFromString:item.activityEndDate];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr = [dateFormatter stringFromDate:currentDateStr];
    NSString *dateStr1 = [dateFormatter stringFromDate:currentDateStr1];
    controller.prefer_ValidTime = [NSString stringWithFormat:@"%@ 至 %@",dateStr,dateStr1];
    controller.prefer_Remark = item.remark;
    
    [self.navigationController pushViewController:controller animated:YES];
}

@end
