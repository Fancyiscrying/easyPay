//
//  FPRedPacketGroupListViewController.h
//  FullPayApp
//
//  Created by 刘通超 on 14/12/1.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPViewController.h"

typedef enum {
    RedPacketGroupListViewFromDispatch,
    RedPacketGroupListViewFromRecevie
}RedPacketGroupListComeFrom;

@interface FPRedPacketGroupListViewController : FPViewController

@property(nonatomic)RedPacketGroupListComeFrom viewComeFrom;
@end
