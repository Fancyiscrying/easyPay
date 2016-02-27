//
//  LoadingCell.m
//  FullPayApp
//
//  Created by mark zheng on 13-8-7.
//  Copyright (c) 2013年 fullpay. All rights reserved.
//

#import "LoadingCell.h"

@implementation LoadingCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) {
        return nil;
    }
    self.lbl = [[UILabel alloc] init];
    self.lbl.frame = CGRectMake(20, 6, 280, 35);
    self.lbl.font = [UIFont boldSystemFontOfSize:21.0];
    self.lbl.textAlignment = NSTextAlignmentCenter;
    self.lbl.textColor = MCOLOR(@"text_color");
    [self.contentView addSubview:self.lbl];
    
    self.loading = [[UIActivityIndicatorView alloc] init];
    self.loading.frame = CGRectMake(280, 6, 35, 35);
    [self.contentView addSubview:self.loading];
    
    return self;
}

@end
