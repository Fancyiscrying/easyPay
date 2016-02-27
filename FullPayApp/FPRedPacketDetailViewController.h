//
//  FPRedPacketDetailViewController.h
//  FullPayApp
//
//  Created by 刘通超 on 14/12/5.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPViewController.h"
#import "FPRedPacketList.h"

typedef enum {
    RedPacketDetailViewComeFromDispatch,
    RedPacketDetailViewComeFromReceive,
} RedPacketDetailViewComeFrom;

@interface FPRedPacketDetailViewController : FPViewController
@property (nonatomic, strong) RedPacketListItem *item;
@property (nonatomic, assign) RedPacketDetailViewComeFrom viewComeFrom;
@end
