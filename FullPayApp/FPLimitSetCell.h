//
//  FPLimitSetCell.h
//  FullPayApp
//
//  Created by mark zheng on 14-2-17.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FPLimitSet.h"

@class FPLimitSetCell;
@protocol FPLimitSetCellDelegate <NSObject>

-(void)updateLimitSet:(FPLimitSetCell *)sender;

@end

@interface FPLimitSetCell : UITableViewCell

@property (nonatomic,weak) id<FPLimitSetCellDelegate> delegate;

@property (nonatomic,strong)UIButton *btn_Switch;

@property (nonatomic,strong)FPLimitSet *limitItem;

@end
