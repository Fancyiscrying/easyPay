//
//  FPRedPacketWithDarwTable.m
//  FullPayApp
//
//  Created by 刘通超 on 14/12/9.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPRedPacketWithDarwTable.h"
#import "FPRedPacketWithDarwListCell.h"

static NSString *redPacketWithDarwListCellIdentifier = @"redPacketWithDarwListCellIdentifier";
@implementation FPRedPacketWithDarwTable


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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _withDrawCashList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FPRedPacketWithDarwListCell *cell;
    cell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:redPacketWithDarwListCellIdentifier];
    if (cell == nil) {
        cell = [[FPRedPacketWithDarwListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:redPacketWithDarwListCellIdentifier];
    }
    
    WithDrawCashItem *item = _withDrawCashList[indexPath.row];
    cell.item = item;
    return cell;
}

#pragma UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 61;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.refreshDelegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
        [self.refreshDelegate tableView:self didSelectRowAtIndexPath:indexPath];
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
