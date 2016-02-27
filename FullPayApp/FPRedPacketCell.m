//
//  FPRedPacketCell.m
//  FullPayApp
//
//  Created by 刘通超 on 14/12/1.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPRedPacketCell.h"
#import "FPRedPacketList.h"
#import "UIImageView+AFNetworking.h"

@implementation FPRedPacketCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andDispatch:(BOOL)dispatch{
    self = [self initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.isDispatch = dispatch;
    [self installView];

    return self;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
       
    }
    
    return self;
}

- (void)installView{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0.5, ScreenWidth, 59)];
    view.backgroundColor = [UIColor whiteColor];
//    view.layer.masksToBounds = YES;
//    view.layer.cornerRadius = 5;
    
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(8, 8, 44, 44)];
    image.backgroundColor = [UIColor grayColor];
    image.tag = 101;
    image.layer.masksToBounds = YES;
    image.layer.cornerRadius = 22;
    [view addSubview:image];
    
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(image.right+8, image.top-2, 200, 20)];
    name.backgroundColor = [UIColor clearColor];
    name.font = [UIFont boldSystemFontOfSize:14];
    name.textColor = COLOR_STRING(@"4D4D4D");
    name.tag = 102;
    [view addSubview:name];
    
//    UILabel *date = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, 15)];
//    date.center = CGPointMake(view.width/2+10, 18);
//    date.textColor = COLOR_STRING(@"CCCCCC");
//    date.font = [UIFont systemFontOfSize:12];
//    date.textAlignment = NSTextAlignmentCenter;
//    date.tag = 103;
//    [view addSubview:date];
    
    UILabel *remark = [[UILabel alloc]initWithFrame:CGRectMake(name.left, name.bottom+8, 150, 20)];
    remark.backgroundColor = [UIColor clearColor];
    remark.font = [UIFont systemFontOfSize:12];
    remark.textColor = COLOR_STRING(@"808080");
    remark.tag = 104;
    [view addSubview:remark];
    
    UILabel *money = [[UILabel alloc]initWithFrame:CGRectMake(view.width-170, name.top, 150, 20)];
    money.backgroundColor = [UIColor clearColor];
    money.font = [UIFont boldSystemFontOfSize:16];
    money.textColor = COLOR_STRING(@"FF5B5C");
    money.textAlignment = NSTextAlignmentRight;
    money.tag = 106;
    [view addSubview:money];
    
    UILabel *date = [[UILabel alloc]initWithFrame:CGRectMake(view.width-170, 0, 150, 15)];
    date.bottom = remark.bottom;
    date.textColor = COLOR_STRING(@"CCCCCC");
    date.font = [UIFont boldSystemFontOfSize:12];
    date.textAlignment = NSTextAlignmentRight;
    date.tag = 103;
    [view addSubview:date];
    
//    if (self.isDispatch) {
//        UILabel *hasGet = [[UILabel alloc]initWithFrame:CGRectMake(view.width-50, image.top, 40, 20)];
//        hasGet.backgroundColor = [UIColor clearColor];
//        hasGet.font = [UIFont systemFontOfSize:16];
//        hasGet.textColor = [UIColor grayColor];
//        hasGet.text = @"已领";
//        hasGet.tag = 105;
//        [view addSubview:hasGet];
//        
//        UILabel *money = [[UILabel alloc]initWithFrame:CGRectMake(0, hasGet.bottom+5, 100, 20)];
//        money.right = hasGet.right;
//        money.backgroundColor = [UIColor clearColor];
//        money.font = [UIFont systemFontOfSize:16];
//        money.textColor = COLOR_STRING(@"FF5B5C");
//        money.textAlignment = NSTextAlignmentRight;
//        money.tag = 106;
//        [view addSubview:money];
//    }else{
//        UILabel *money = [[UILabel alloc]initWithFrame:CGRectMake(view.width-110, 20, 100, 20)];
//        money.backgroundColor = [UIColor clearColor];
//        money.font = [UIFont systemFontOfSize:16];
//        money.textColor = COLOR_STRING(@"FF5B5C");
//        money.textAlignment = NSTextAlignmentRight;
//        money.tag = 106;
//        [view addSubview:money];
//    }
    
    
    [self addSubview:view];

}

- (void)setRedPacketItem:(RedPacketListItem *)RedPacketItem{
    _RedPacketItem = RedPacketItem;
    [self refreshView];
}

- (void)refreshView{
    UIImageView *image = (UIImageView *)[self viewWithTag:101];
    NSString *member = _isDispatch ? _RedPacketItem.receiveNo:_RedPacketItem.distributeNo;
    [image setImageWithURL:[NSURL URLWithString:HeadImageByMember(member)] placeholderImage:MIMAGE(@"home_head_none")];

    UILabel *name = (UILabel *)[self viewWithTag:102];
    if (_isDispatch) {
        name.text = [NSString stringWithFormat:@"%@ 领的红包",_RedPacketItem.receiveName];
    }else{
        name.text = [NSString stringWithFormat:@"%@ 发的红包",_RedPacketItem.distributeName];
    }
    //name.text = _isDispatch ? _RedPacketItem.receiveName:_RedPacketItem.distributeName;;

    UILabel *date = (UILabel *)[self viewWithTag:103];
    NSString *dateStr = _isDispatch? _RedPacketItem.receiveTime: _RedPacketItem.createTime;
    if (dateStr.length >= 16) {
        dateStr = [dateStr substringWithRange:NSMakeRange(5, 11)];
    }
    date.text = dateStr;

    UILabel *remark = (UILabel *)[self viewWithTag:104];
    remark.text = _isDispatch? _RedPacketItem.receiveRemark: _RedPacketItem.distributeRemark;
    
    UILabel *money = (UILabel *)[self viewWithTag:106];
    money.text = [NSString stringWithFormat:@"%0.2f 元",_RedPacketItem.amt];

    [self drawRect:self.frame];
    
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
