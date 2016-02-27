//
//  FPRedPacketCell.h
//  FullPayApp
//
//  Created by 刘通超 on 14/12/1.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RedPacketListItem;

@interface FPRedPacketCell : UITableViewCell

@property (nonatomic, assign) BOOL isDispatch;

@property (nonatomic, strong) RedPacketListItem *RedPacketItem;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andDispatch:(BOOL)dispatch;
@end
