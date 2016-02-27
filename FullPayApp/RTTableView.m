//
//  RTTableView.m
//  ReadilyTao
//
//  Created by lc on 14-8-4.
//  Copyright (c) 2014年 FZF. All rights reserved.
//

#import "RTTableView.h"
#import "MJRefresh.h"

@interface RTTableView()<MJRefreshBaseViewDelegate>{
    MJRefreshHeaderView *_header;
    MJRefreshFooterView *_footer;
}

@end

@implementation RTTableView

- (id)initWithFrame:(CGRect)frame andNeedRefresh:(BOOL) refresh{
    self.isNeedPullRefresh = refresh;
    self = [self initWithFrame:frame];
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initCustom];
        [self insertTableFootView];
        self.tableFooterView.hidden = YES;
    }
    return self;
}

- (void)initCustom{
    if (_isNeedPullRefresh) {
        [self addHeader];
        [self addFooter];
    }
}

- (void)addFooter
{
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.delegate = self;
    footer.scrollView = self;
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        
        if([self.refreshDelegate respondsToSelector:@selector(tablePullUp:)]){
            [self.refreshDelegate tablePullUp:refreshView];
        }
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
    header.delegate = self;
    header.scrollView = self;
    header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
     
        if ([self.refreshDelegate respondsToSelector:@selector(tablePullDown:)]) {
            [self.refreshDelegate tablePullDown:refreshView];
        }
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
                FPDEBUG(@"%@----切换到：普通状态", refreshView.class);
                break;
                
            case MJRefreshStatePulling:
                FPDEBUG(@"%@----切换到：松开即可刷新的状态", refreshView.class);
                break;
                
            case MJRefreshStateRefreshing:
                FPDEBUG(@"%@----切换到：正在刷新状态", refreshView.class);
                break;
            default:
                break;
        }
    };
   // [header beginRefreshing];
    _header = header;
}

- (void)setFooterHidden:(BOOL)hidden{
    _footer.hidden = hidden;
}

- (void)doneWithView:(MJRefreshBaseView *)refreshView
{
    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [refreshView endRefreshing];
}

- (void)insertTableFootView{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
    label.backgroundColor = [UIColor clearColor];
    label.text = @"已经加载全部";
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor grayColor];
    label.textAlignment = NSTextAlignmentCenter;
    
    [self setTableFooterView:label];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
