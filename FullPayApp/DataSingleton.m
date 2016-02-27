//
//  DataSingleton.m
//  FullPayApp
//
//  Created by mark zheng on 13-8-7.
//  Copyright (c) 2013年 fullpay. All rights reserved.
//

#import "DataSingleton.h"
#import <QuartzCore/QuartzCore.h>

@implementation DataSingleton

- (UITableViewCell *)getLoadMoreCell:(UITableView *)tableView
                       andIsLoadOver:(BOOL)isLoadOver
                   andLoadOverString:(NSString *)loadOverString
                    andLoadingString:(NSString *)loadingString
                        andIsLoading:(BOOL)isLoading
{
    static NSString *reuseableCell = @"loadingCell";
    LoadingCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseableCell];
    if (!cell) {
        cell = [[LoadingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseableCell];
    }
    
    cell.lbl.text = isLoadOver ? loadOverString : loadingString;
    if (isLoading) {
        cell.loading.hidden = NO;
        [cell.loading startAnimating];
    }
    else
    {
        cell.loading.hidden = YES;
        [cell.loading stopAnimating];
    }
    return cell;
}

#pragma 单例模式定义
static DataSingleton * instance = nil;
+(DataSingleton *) Instance
{
    @synchronized(self)
    {
        if(nil == instance)
        {
            [self new];
        }
    }
    return instance;
}
+(id)allocWithZone:(NSZone *)zone
{
    @synchronized(self)
    {
        if(instance == nil)
        {
            instance = [super allocWithZone:zone];
            return instance;
        }
    }
    return nil;
}
@end
