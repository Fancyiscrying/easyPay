//
//  FPUserCell.m
//  FullPayApp
//
//  Created by mark zheng on 14-2-14.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPUserCell.h"

@implementation FPUserCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    style = UITableViewCellStyleSubtitle;
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.textLabel.adjustsFontSizeToFitWidth = YES;
        self.textLabel.textColor = [UIColor darkGrayColor];
        self.detailTextLabel.font = [UIFont systemFontOfSize:12.0f];
        self.detailTextLabel.textColor = [UIColor grayColor];
        self.detailTextLabel.numberOfLines = 0;
        self.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUserObject:(FPUser *)userObject
{
    _userObject = userObject;
    
    self.textLabel.text = _userObject.textTitle;
    self.detailTextLabel.text = _userObject.subTitle;
    self.imageView.image = [UIImage imageNamed:_userObject.imageName];
    
    [self setNeedsLayout];
}

+ (CGFloat)heightForCellWithPost:(FPUser *)user {

    NSDictionary *titleStringAttributes = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:12.0f] forKey: NSFontAttributeName];
    CGSize sizeToFit = [user.textTitle  boundingRectWithSize:CGSizeMake(220.0f, CGFLOAT_MAX)
                                                               options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin
                                                            attributes:titleStringAttributes
                                                               context:nil].size;
    
    return fmaxf(70.0f, sizeToFit.height + 45.0f);
}

#pragma mark - UIView

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.textLabel.frame = CGRectMake(50.0f, 10.0f, 240.0f, 20.0f);
    
    CGRect detailTextLabelFrame = CGRectOffset(self.textLabel.frame, 0.0f, 25.0f);

    detailTextLabelFrame.size.height = 20.0f;
    self.detailTextLabel.frame = detailTextLabelFrame;
}

@end
