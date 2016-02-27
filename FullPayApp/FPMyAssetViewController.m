//
//  FPMyAssetViewController.m
//  FullPayApp
//
//  Created by mark zheng on 14-2-14.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPMyAssetViewController.h"
#import "FPMyAssertCell.h"

#import "FPBankCardListViewController.h"

@interface FPMyAssetViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSArray *itemTitles;
@property (nonatomic,strong) NSArray *itemImages;
@property (nonatomic,strong) NSArray *itemDetails;

@end

@implementation FPMyAssetViewController

static NSString *myTableViewCellIndentifier = @"itemMyAssetCell";

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
    self.tabBarController.tabBar.hidden = YES;
    
    [self initData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onUpdateUserData:) name:kNotificationUser object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationUser object:nil];
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.title = @"我的资产";
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    self.navigationItem.backBarButtonItem = backItem;
    backItem.title = @"";
    
    UIImageView *background = [[UIImageView alloc] initWithFrame:self.view.bounds];
    background.image = [UIImage imageNamed:@"BG"];
    [self.view addSubview:background];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHigh) style:UITableViewStylePlain];
    [self.tableView
     registerClass:[FPMyAssertCell class] forCellReuseIdentifier:myTableViewCellIndentifier];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.scrollEnabled = NO;
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
    v.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:v];
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onUpdateUserData:(NSNotification *)notification
{
    self.accountItem = [notification.userInfo objectForKey:kUserNotificationKey];
    double amount = [self.accountItem.accountAmount doubleValue];
    
    NSString *accountAmount = [NSString stringWithFormat:@"%.02f元",amount/100];
    
    self.itemDetails[0][0] = accountAmount;
    
    [self.tableView reloadData];
}

#pragma mark table view datasource methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.itemTitles[section] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FPMyAssertCell* cell;
    if ([tableView respondsToSelector:@selector(dequeueReusableCellWithIdentifier:forIndexPath:)]) {
        cell = [tableView dequeueReusableCellWithIdentifier:myTableViewCellIndentifier forIndexPath:indexPath];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:myTableViewCellIndentifier];
        if (cell == nil) {
            cell = [[FPMyAssertCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myTableViewCellIndentifier];
        }
    }
    
    NSString *imageName = [self.itemImages[indexPath.section] objectAtIndex:indexPath.row];
    
    [cell.imageView setContentMode:UIViewContentModeScaleToFill];
    cell.imageView.image = [UIImage imageNamed:imageName];
    
    cell.textLabel.text = [self.itemTitles[indexPath.section] objectAtIndex:[indexPath row]];
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
    //    cell.textLabel.textColor = MCOLOR(@"text_color");
    
    if (indexPath.section == 0) {
        NSArray *detail = self.itemDetails[indexPath.section];
        cell.detailTextLabel.text = (detail != nil ? detail[indexPath.row] : @"");
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    } else {
    
        UIImageView *accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_ic_enter"]];
        cell.accessoryView = accessoryView;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
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
    if (indexPath.section == 1) {
        FPBankCardListViewController *controller = [[FPBankCardListViewController alloc] init];
        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

#pragma mark -
- (void)initData
{
    NSArray *names1 = @[@"账户余额",@"富米"];
    NSArray *names2 = @[@"充值"];
    NSArray *images1 = @[@"myasset_ic_property",@"myasset_ic_fumi"];
    NSArray *images2 = @[@"myasset_ic_recharge"];
    NSMutableArray *detail1 = [NSMutableArray arrayWithArray:@[@"0.00元",@"0个"]];
    
    if (self.accountItem) {
        double amount = [self.accountItem.accountAmount doubleValue];
        long fumiCount = (long)[self.accountItem.fumiCount longLongValue];
        
        NSString *accountAmount = [NSString stringWithFormat:@"%.02f元",amount/100];
        NSString *fumiAmount = [NSString stringWithFormat:@"%ld个",fumiCount];
        
        detail1[0] = accountAmount;
        detail1[1] = fumiAmount;
    }
    
    self.itemTitles = @[names1,names2];
    self.itemImages = @[images1,images2];
    self.itemDetails = @[detail1];
    
    [_tableView reloadData];
}

@end
