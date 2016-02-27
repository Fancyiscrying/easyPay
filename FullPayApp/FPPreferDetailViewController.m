//
//  FPPreferDetailViewController.m
//  FullPayApp
//
//  Created by mark zheng on 14-2-18.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPPreferDetailViewController.h"
#import "FPPreferDetailCell.h"

@interface FPPreferDetailViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSArray    *itemTitles;
@property (nonatomic,strong) NSArray    *itemDetails;

@end

@implementation FPPreferDetailViewController

static NSString *myTableViewCellIndentifier = @"itemPreferDetailCell";

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
    self.navigationItem.title = @"优惠详情";
    
    [self.tableView
     registerClass:[FPPreferDetailCell class] forCellReuseIdentifier:myTableViewCellIndentifier];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.scrollEnabled = NO;
    self.tableView.userInteractionEnabled = NO;
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
    v.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:v];
    
    self.itemTitles = @[@"标题",@"商家",@"有效期",@"备注"];
    self.itemDetails = @[self.prefer_Title,self.prefer_Business,self.prefer_ValidTime,self.prefer_Remark];
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
    FPPreferDetailCell* cell;
    if ([tableView respondsToSelector:@selector(dequeueReusableCellWithIdentifier:forIndexPath:)]) {
        cell = [tableView dequeueReusableCellWithIdentifier:myTableViewCellIndentifier forIndexPath:indexPath];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:myTableViewCellIndentifier];
        if (cell == nil) {
            cell = [[FPPreferDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myTableViewCellIndentifier];
        }
    }
    
    cell.textLabel.text = self.itemTitles[indexPath.row];
    cell.detailTextLabel.text = self.itemDetails[indexPath.row];
    
    return cell;
}

#pragma mark tableview data delegate methods
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 3) {
        return 100.0f;
    }
    return 40.0f;
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

@end
