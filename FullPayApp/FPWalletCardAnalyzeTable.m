//
//  FPWalletCardAnalyzeTable.m
//  FullPayApp
//
//  Created by 刘通超 on 15/4/12.
//  Copyright (c) 2015年 fullpay. All rights reserved.
//

#import "FPWalletCardAnalyzeTable.h"
#import "FPWalletCardAnalyzeCell.h"
#import "FPWalletCardAnalyzeModel.h"

static NSString *walletCardAnalyzeCellIdentifier = @"walletCardAnalyzeCellIdentifier";

@implementation FPWalletCardAnalyzeTable
- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        self.backgroundColor = [UIColor clearColor];
        self.separatorColor = [UIColor clearColor];
        self.allowsSelection = NO;
    }
    
    return self;
}

#pragma UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.analyzeList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *temp = self.analyzeList[section];
    return temp.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FPWalletCardAnalyzeCell *cell;
    cell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:walletCardAnalyzeCellIdentifier];
    if (cell == nil) {
        cell = [[FPWalletCardAnalyzeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:walletCardAnalyzeCellIdentifier];
    }
    
    AnalyzeMonthItem *item = self.analyzeList[indexPath.section][indexPath.row];
    cell.analyzeItem = item;
    
    return cell;
}

#pragma UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 35)];
    headView.backgroundColor = ClearColor;
    
    UIView *right = [[UIView alloc]initWithFrame:CGRectMake(0, 10, 10, 20)];
    right.backgroundColor = COLOR_STRING(@"#FED030");
    [headView addSubview:right];
    
    UILabel *year = [[UILabel alloc] initWithFrame:CGRectMake(right.right+5, 10, 100, 20)];
    year.backgroundColor = [UIColor clearColor];
    year.font = [UIFont boldSystemFontOfSize:14];
    year.textColor = COLOR_STRING(@"4D4D4D");
    year.textAlignment = NSTextAlignmentLeft;
    [headView addSubview:year];
    
    NSArray *temp = self.analyzeList[section];
    AnalyzeMonthItem *item = temp[0];
    year.text = [NSString stringWithFormat:@"%d 年",item.stsMonth/100];

    return headView;
}
@end
