//
//  FPRedPacketTable.m
//  FullPayApp
//
//  Created by 刘通超 on 14/12/2.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPRedPacketTable.h"
#import "FPRedPacketCell.h"
#import "FPRedPacketList.h"

static NSString *redPacketIdentifierDispatch = @"redPacketIdentifierDispatch";
static NSString *redPacketIdentifierRecevie = @"redPacketIdentifierRecevie";

@implementation FPRedPacketTable

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style andDispatch:(BOOL)dispatch{
    self = [self initWithFrame:frame andNeedRefresh:YES];
    self.isDispatch = dispatch;
    
    return self;
}

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        self.backgroundColor = [UIColor clearColor];
        self.separatorColor = [UIColor clearColor];
    }
    
    return self;
}

#pragma UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _redPacketList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FPRedPacketCell *cell;
    if (_isDispatch) {
        cell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:redPacketIdentifierDispatch];
        if (cell == nil) {
            cell = [[FPRedPacketCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:redPacketIdentifierDispatch andDispatch:YES];
        }
    }else{
        cell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:redPacketIdentifierRecevie];
        if (cell == nil) {
            cell = [[FPRedPacketCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:redPacketIdentifierRecevie andDispatch:NO];
        }
    }
    
    RedPacketListItem *item = _redPacketList[indexPath.row];
    cell.RedPacketItem = item;
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
