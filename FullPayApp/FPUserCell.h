//
//  FPUserCell.h
//  FullPayApp
//
//  Created by mark zheng on 14-2-14.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FPUser.h"

@interface FPUserCell : UITableViewCell

@property (nonatomic,strong) FPUser *userObject;

+ (CGFloat)heightForCellWithPost:(FPUser *)user;

@end
