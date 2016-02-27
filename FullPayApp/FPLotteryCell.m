//
//  FPLotteryCell.m
//  FullPayApp
//
//  Created by mark zheng on 13-11-19.
//  Copyright (c) 2013年 fullpay. All rights reserved.
//

#import "FPLotteryCell.h"
#import "FPLotteryStruct.h"

#define IMG_SSC @"lottery_ic_ssc"
#define IMG_SSQ @"lottery_ic_ssq"
#define IMG_DLT @"lottery_ic_dlt"
#define IMG_PL3 @"img_pl3.png"
#define IMG_PL5 @"img_pl5.png"
#define IMG_QXC @"img_qxc"
#define IMG_FC3D @"img_fc3d"
#define IMG_QLC @"img_qlc"
#define IMG_JXSSC @"img_jxssc"

@implementation FPLotteryCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) {
        return nil;
    }
    
    self.img_Title = [[UIImageView alloc] init];
    self.lbl_Title = [[UILabel alloc ]init];
    self.lbl_Desc1 = [[UILabel alloc] init];
    self.lbl_Desc2 = [[UILabel alloc] init];
    
    self.img_Title.frame = CGRectMake(10.0f, 10.0f, 50.0f, 50.0f);
    self.lbl_Title.frame = CGRectMake(70.0f, 10.0f, 40.0f, 20.0f);
    //self.lbl_Desc1.frame = CGRectMake(115.0f, 5.0f, 170.0f, 30.0f);
    self.lbl_Desc1.frame = CGRectMake(70.0f, 30.0f, 220.0f, 20.0f);
    self.lbl_Desc2.frame = CGRectMake(70.0f, 50.0f, 220.0f, 20.0f);
    
    [self.contentView addSubview:self.img_Title];
    
    self.lbl_Title.adjustsFontSizeToFitWidth = YES;
    self.lbl_Title.textColor = MCOLOR(@"text_color");
    self.lbl_Title.font = [UIFont boldSystemFontOfSize:13.0f];
    self.lbl_Title.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.lbl_Title];
    
//    self.lbl_Desc1.adjustsFontSizeToFitWidth = YES;
    self.lbl_Desc1.textColor = MCOLOR(@"text_color");
    self.lbl_Desc1.font = [UIFont systemFontOfSize:10.0f];
    self.lbl_Desc1.numberOfLines = 0;
    self.lbl_Desc1.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.lbl_Desc1];
    
    self.lbl_Desc2.font = [UIFont boldSystemFontOfSize:10.0f];
    self.lbl_Desc2.textColor = MCOLOR(@"text_color");
    self.lbl_Desc2.numberOfLines = 0;
    self.lbl_Desc2.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.lbl_Desc2];
    
    self.selectionStyle = UITableViewCellSelectionStyleGray;
    self.accessoryType = UITableViewCellAccessoryNone;
    
    self.ImageList = [NSDictionary dictionaryWithObjectsAndKeys:IMG_SSQ,@"ssq",IMG_SSC,@"ssc",IMG_DLT,@"cjdlt", IMG_PL3,@"pl3",IMG_PL5,@"pl5",IMG_QLC,@"qlc",IMG_QXC,@"qxc",IMG_FC3D,@"fc3d",IMG_JXSSC,@"jxssc",nil];
    
    return self;
}

- (void)setItem:(FPLotteryObject *)item
{
    _item = item;
    
    self.lbl_Title.text = _item.resourceName;
    self.lbl_Desc1.text = _item.desc1;
    self.lbl_Desc2.text = _item.desc2;
    
    NSString *imageName = [self.ImageList objectForKey:item.resourceCode];
    UIImage *lotteryImg = MIMAGE(imageName);
    [self.img_Title setImage:lotteryImg];
    
    FPDEBUG(@"resourceCode:%@",imageName);
    
    [self setNeedsLayout];
}

+ (CGFloat)heightForCellWithLottery:(FPLotteryObject *)item {

    CGSize boundedSize = CGSizeMake(220.0f, CGFLOAT_MAX);
    NSDictionary *titleStringAttributes = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:12.0f] forKey: NSFontAttributeName];
    CGSize sizeToFit = [item.desc2 boundingRectWithSize:boundedSize
                                                    options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin
                                                 attributes:titleStringAttributes
                                                    context:nil].size;
    
    return fmaxf(70.0f, sizeToFit.height + 45.0f);
}

@end
