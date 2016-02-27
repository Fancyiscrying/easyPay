//
//  FPBillDetailsViewController.m
//  FullPayApp
//
//  Created by mark zheng on 14-2-18.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPBillDetailsViewController.h"
#import "FPBillDetailCell.h"

@interface FPBillDetailsViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSArray    *itemTitles;
@property (nonatomic,strong) NSArray    *itemDetails;

@end

@implementation FPBillDetailsViewController

static NSString *myTableViewCellIndentifier = @"itemBillDetailCell";

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
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.title = @"账单详情";
    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = [ColorUtils hexStringToColor:@"#ECEDEE"];

    [self.tableView
     registerClass:[FPBillDetailCell class] forCellReuseIdentifier:myTableViewCellIndentifier];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorColor = [UIColor clearColor];
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
    if (self.trade_fee > 0) {
        NSString *fee = [NSString stringWithFormat:@"%0.2f 元",self.trade_fee];
        self.itemTitles = @[@"交易对方",@"交易类型",@"交易金额",@"手  续  费",@"交易时间",@"备   注"];
        self.itemDetails = @[self.trade_name,self.trade_type,self.trade_amt,fee,self.trade_time,self.trade_remark];
    }else{
        self.itemTitles = @[@"交易对方",@"交易类型",@"交易金额",@"交易时间",@"备   注"];
        self.itemDetails = @[self.trade_name,self.trade_type,self.trade_amt,self.trade_time,self.trade_remark];
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
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.itemTitles count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
    cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14.0f];

    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGRect  tableRect = tableView.frame;
    UIView *headView = [[UIView alloc] initWithFrame:tableRect];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(90, 10, 30, 30)];
    
    UIImage *image = [UIImage imageNamed:@"billdet_ic_right"];
    imgView.image = image;
    [headView addSubview:imgView];
    
    CGRect lblFrame = CGRectOffset(imgView.frame, 40, 0);
    lblFrame.size.width = 180.0f;
    lblFrame.size.height = 30.0f;
    UILabel *lblView = [[UILabel alloc] init];
    lblView.frame = lblFrame;
    lblView.text = self.trade_status;
    lblView.textColor = MCOLOR(@"color_billdetail_label");
    [headView addSubview:lblView];
    
    return headView;
}

#pragma mark tableview data delegate methods
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 50.0f;
    }
    return 18.0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
