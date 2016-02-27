//
//  FPWalletCardListTable.m
//  FullPayApp
//
//  Created by 刘通超 on 15/4/7.
//  Copyright (c) 2015年 fullpay. All rights reserved.
//

#import "FPWalletCardListTable.h"
#import "FPWalletCardListModel.h"
#import "FPWalletCardListCell.h"

static NSString *walletCardListTableCellIdentifier = @"walletCardListTableCellIdentifier";

@implementation FPWalletCardListTable
- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        self.backgroundColor = [UIColor clearColor];
        self.separatorColor = [UIColor clearColor];
        self.allowsSelection = YES;
    }
    
    return self;
}

#pragma UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _cardList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FPWalletCardListCell *cell;
    cell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:walletCardListTableCellIdentifier];
    if (cell == nil) {
        cell = [[FPWalletCardListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:walletCardListTableCellIdentifier];
    }
    WalletCardListItem *temp = _cardList[indexPath.row];
    cell.item = temp;
    return cell;
}

#pragma UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.refreshDelegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
        [self.refreshDelegate tableView:self didSelectRowAtIndexPath:indexPath];
    }
}

@end
