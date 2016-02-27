//
//  RTTableView.h
//  ReadilyTao
//
//  Created by lc on 14-8-4.
//  Copyright (c) 2014年 FZF. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MJRefreshBaseView;
@class RTTableView;

@protocol UITableViewRefreshDelegate <NSObject>
@optional
- (void)tablePullDown:(MJRefreshBaseView *)refreshView;
- (void)tablePullUp:(MJRefreshBaseView *)refreshView;
- (void)tableView:(RTTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)tableView:(RTTableView *)tableView deleteRowAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface RTTableView : UITableView

@property (assign, nonatomic) BOOL isNeedPullRefresh;
@property (assign, nonatomic) id<UITableViewRefreshDelegate> refreshDelegate;


- (id)initWithFrame:(CGRect)frame andNeedRefresh:(BOOL) refresh;

//设置footer的可用性，用于数据加载完成
- (void)setFooterHidden:(BOOL)hidden;
@end
