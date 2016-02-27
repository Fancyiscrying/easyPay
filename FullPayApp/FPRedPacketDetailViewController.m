//
//  FPRedPacketDetailViewController.m
//  FullPayApp
//
//  Created by 刘通超 on 14/12/5.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPRedPacketDetailViewController.h"
#import "UIImageView+AFNetworking.h"

@interface FPRedPacketDetailViewController ()

@end

@implementation FPRedPacketDetailViewController

- (void)loadView{
    UIView *view = [[UIView alloc]initWithFrame:ScreenBounds];
    UIImageView *background = [[UIImageView alloc] initWithFrame:view.bounds];
    background.image = [UIImage imageNamed:@"redPacket_detail_image"];
    [view addSubview:background];
    self.view = view;
    
    if (_viewComeFrom == RedPacketDetailViewComeFromDispatch) {
        [self installDispatchCoustomView];
    }else if(_viewComeFrom == RedPacketDetailViewComeFromReceive){
        [self installReceiveCoustomView];
    }
    
    //[self installReceiveCoustomView];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    self.tabBarController.tabBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"红包详情";
    
    // Do any additional setup after loading the view.
}
- (void)installDispatchCoustomView{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, ScreenWidth-30, 20)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = COLOR_STRING(@"#808080");
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont boldSystemFontOfSize:16];
    label.text = @"接收人";
    [self.view addSubview:label];
    
    UIView *receivePerson = [[UIView alloc]initWithFrame:CGRectMake(0, label.bottom+5, ScreenWidth, 50)];
    receivePerson.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imageHead = [[UIImageView alloc]initWithFrame:CGRectMake(20, 5, 40, 40)];
    [imageHead setImageWithURL:[NSURL URLWithString:HeadImageByMember(_item.receiveNo)] placeholderImage:MIMAGE(@"home_head_none")];
    imageHead.layer.masksToBounds = YES;
    imageHead.layer.cornerRadius = 20;
    [receivePerson addSubview:imageHead];
    
    UILabel *personName = [[UILabel alloc]initWithFrame:CGRectMake(imageHead.right+10, 15, 100, 20)];
    personName.backgroundColor = [UIColor clearColor];
    personName.textColor = COLOR_STRING(@"#808080");
    personName.textAlignment = NSTextAlignmentLeft;
    personName.font = [UIFont boldSystemFontOfSize:16];
    personName.text = _item.receiveName;
    [personName sizeToFit];
    [receivePerson addSubview:personName];
    
    UILabel *personMobile = [[UILabel alloc]initWithFrame:CGRectMake(personName.right+20, 15, 100, 20)];
    personMobile.backgroundColor = [UIColor clearColor];
    personMobile.textColor = COLOR_STRING(@"#808080");
    personMobile.textAlignment = NSTextAlignmentLeft;
    personMobile.font = [UIFont boldSystemFontOfSize:16];
    [receivePerson addSubview:personMobile];
    
    NSMutableString *mobile = [NSMutableString stringWithString:_item.receiveMobile];
    if (mobile.length >= 11) {
        [mobile replaceCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    }
    personMobile.text = mobile;
    [personMobile sizeToFit];

    [self.view addSubview:receivePerson];
    
    UILabel *label5 = [[UILabel alloc]initWithFrame:CGRectMake(20, receivePerson.bottom+10, ScreenWidth-30, 20)];
    label5.backgroundColor = [UIColor clearColor];
    label5.textColor = COLOR_STRING(@"#808080");
    label5.textAlignment = NSTextAlignmentLeft;
    label5.font = [UIFont boldSystemFontOfSize:16];
    label5.text = @"答谢";
    [self.view addSubview:label5];
    
    UIView *receiveMarkView = [[UIView alloc]initWithFrame:CGRectMake(0, label5.bottom+5, ScreenWidth, 80)];
    receiveMarkView.backgroundColor = [UIColor whiteColor];
    
    UILabel *receiveMark = [[UILabel alloc]initWithFrame:CGRectMake(imageHead.left, 5, ScreenWidth-2*imageHead.left, 0)];
    receiveMark.backgroundColor = [UIColor clearColor];
    receiveMark.textColor = COLOR_STRING(@"#EA905F");
    receiveMark.textAlignment = NSTextAlignmentLeft;
    receiveMark.font = [UIFont systemFontOfSize:14];
    receiveMark.numberOfLines = 5;
    
    NSString *remark = _item.receiveRemark;
    if (remark.length<=0) {
        remark = @"此人很懒，什么都没留下。";
    }
    receiveMark.text = remark;
    receiveMark.height =[remark getHeightWithFontSize:14 andWidth:receiveMark.width];
    [receiveMark sizeToFit];
    
    [receiveMarkView addSubview:receiveMark];

    receiveMarkView.height =[remark getHeightWithFontSize:14 andWidth:receiveMark.width]+10;

    [self.view addSubview:receiveMarkView];
    
    UILabel *thanksTime = [[UILabel alloc]initWithFrame:CGRectMake(label.left, receiveMarkView.bottom+5, ScreenWidth, 20)];
    thanksTime.backgroundColor = [UIColor clearColor];
    thanksTime.textAlignment = NSTextAlignmentLeft;
    thanksTime.text =_item.receiveTime;
    thanksTime.textColor = COLOR_STRING(@"#8B8AFC");
    thanksTime.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:thanksTime];
    
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(label.left, thanksTime.bottom+30, ScreenWidth-30, 20)];
    label2.backgroundColor = [UIColor clearColor];
    label2.textColor = COLOR_STRING(@"#808080");
    label2.textAlignment = NSTextAlignmentLeft;
    label2.font = [UIFont boldSystemFontOfSize:16];
    label2.text = @"红包内容";
    [self.view addSubview:label2];
    
    UIView *dispatchDetil = [[UIView alloc]initWithFrame:CGRectMake(0, label2.bottom+5, ScreenWidth, 100)];
    dispatchDetil.backgroundColor = [UIColor whiteColor];
    
    UILabel *label3 = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 50, 20)];
    label3.backgroundColor = [UIColor clearColor];
    label3.textColor = COLOR_STRING(@"#808080");
    label3.textAlignment = NSTextAlignmentLeft;
    label3.font = [UIFont boldSystemFontOfSize:16];
    label3.text = @"金额";
    [label3 sizeToFit];
    [dispatchDetil addSubview:label3];
    
    UILabel *money = [[UILabel alloc]initWithFrame:CGRectMake(label3.right+20, 10, 50, 20)];
    money.backgroundColor = [UIColor clearColor];
    money.textColor = COLOR_STRING(@"#FF5B5C");
    money.textAlignment = NSTextAlignmentLeft;
    money.font = [UIFont boldSystemFontOfSize:16];
    money.text = [NSString stringWithFormat:@"%0.2f 元",_item.amt];
    [money sizeToFit];
    [dispatchDetil addSubview:money];
    
    UILabel *label4 = [[UILabel alloc]initWithFrame:CGRectMake(label3.left,label3.bottom+10, 50, 20)];
    label4.backgroundColor = [UIColor clearColor];
    label4.textAlignment = NSTextAlignmentLeft;
    label4.text = @"祝语";
    label4.font = [UIFont boldSystemFontOfSize:16];
    label4.textColor = COLOR_STRING(@"#808080");
    [dispatchDetil addSubview:label4];
    
    UILabel *dispatchMark = [[UILabel alloc]initWithFrame:CGRectMake(money.left, label4.top, ScreenWidth-money.left-10, 0)];
    dispatchMark.backgroundColor = [UIColor clearColor];
    dispatchMark.textColor = COLOR_STRING(@"#EA905F");
    dispatchMark.textAlignment = NSTextAlignmentLeft;
    dispatchMark.font = [UIFont systemFontOfSize:14];
    dispatchMark.text = _item.distributeRemark;
    dispatchMark.numberOfLines = 5;
    dispatchMark.height = [_item.distributeRemark getHeightWithFontSize:14 andWidth:dispatchMark.width];
    [dispatchMark sizeToFit];
    [dispatchDetil addSubview:dispatchMark];
    
    dispatchDetil.height = dispatchMark.bottom+5;
    [self.view addSubview:dispatchDetil];
    
    UILabel *dispatchTime = [[UILabel alloc]initWithFrame:CGRectMake(label.left, dispatchDetil.bottom+5, ScreenWidth, 20)];
    dispatchTime.backgroundColor = [UIColor clearColor];
    dispatchTime.textAlignment = NSTextAlignmentLeft;
    dispatchTime.text =_item.createTime;
    dispatchTime.textColor = COLOR_STRING(@"#8B8AFC");
    dispatchTime.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:dispatchTime];


}

- (void)installReceiveCoustomView{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, ScreenWidth-30, 20)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = COLOR_STRING(@"#808080");
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont boldSystemFontOfSize:16];
    label.text = @"派发人";
    [self.view addSubview:label];
    
    UIView *dispatchPerson = [[UIView alloc]initWithFrame:CGRectMake(0, label.bottom+5, ScreenWidth, 50)];
    dispatchPerson.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imageHead = [[UIImageView alloc]initWithFrame:CGRectMake(20, 5, 40, 40)];
    [imageHead setImageWithURL:[NSURL URLWithString:HeadImageByMember(_item.distributeNo)] placeholderImage:MIMAGE(@"home_head_none")];
    imageHead.layer.masksToBounds = YES;
    imageHead.layer.cornerRadius = 20;
    [dispatchPerson addSubview:imageHead];
    
    UILabel *personName = [[UILabel alloc]initWithFrame:CGRectMake(imageHead.right+10, 15, 100, 20)];
    personName.backgroundColor = [UIColor clearColor];
    personName.textColor = COLOR_STRING(@"#808080");
    personName.textAlignment = NSTextAlignmentLeft;
    personName.font = [UIFont boldSystemFontOfSize:16];
    personName.text = _item.distributeName;
    [personName sizeToFit];
    [dispatchPerson addSubview:personName];
    
    UILabel *personMobile = [[UILabel alloc]initWithFrame:CGRectMake(personName.right+20, 15, 100, 20)];
    personMobile.backgroundColor = [UIColor clearColor];
    personMobile.textColor = COLOR_STRING(@"#808080");
    personMobile.textAlignment = NSTextAlignmentLeft;
    personMobile.font = [UIFont boldSystemFontOfSize:16];
    NSMutableString *mobile = [NSMutableString stringWithString:_item.distributeMobile];
    if (mobile.length >= 11) {
        [mobile replaceCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    }
    personMobile.text = mobile;
    [personMobile sizeToFit];
    [dispatchPerson addSubview:personMobile];
    
    [self.view addSubview:dispatchPerson];
    
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(label.left, dispatchPerson.bottom+30, ScreenWidth-30, 20)];
    label2.backgroundColor = [UIColor clearColor];
    label2.textColor = COLOR_STRING(@"#808080");
    label2.textAlignment = NSTextAlignmentLeft;
    label2.font = [UIFont boldSystemFontOfSize:16];
    label2.text = @"红包内容";
    [self.view addSubview:label2];
    
    UIView *dispatchDetil = [[UIView alloc]initWithFrame:CGRectMake(0, label2.bottom+5, ScreenWidth, 100)];
    dispatchDetil.backgroundColor = [UIColor whiteColor];
    
    UILabel *label3 = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 50, 20)];
    label3.backgroundColor = [UIColor clearColor];
    label3.textColor = COLOR_STRING(@"#808080");
    label3.textAlignment = NSTextAlignmentLeft;
    label3.font = [UIFont boldSystemFontOfSize:16];
    label3.text = @"金额";
    [label3 sizeToFit];
    [dispatchDetil addSubview:label3];
    
    UILabel *money = [[UILabel alloc]initWithFrame:CGRectMake(label3.right+20, 10, 50, 20)];
    money.backgroundColor = [UIColor clearColor];
    money.textColor = COLOR_STRING(@"#FF5B5C");
    money.textAlignment = NSTextAlignmentLeft;
    money.font = [UIFont boldSystemFontOfSize:16];
    money.text = [NSString stringWithFormat:@"%0.2f 元",_item.amt];
    [money sizeToFit];
    [dispatchDetil addSubview:money];
    
    UILabel *label4 = [[UILabel alloc]initWithFrame:CGRectMake(label3.left,label3.bottom+10, 50, 20)];
    label4.backgroundColor = [UIColor clearColor];
    label4.textAlignment = NSTextAlignmentLeft;
    label4.text = @"祝语";
    label4.font = [UIFont boldSystemFontOfSize:16];
    label4.textColor = COLOR_STRING(@"#808080");
    [dispatchDetil addSubview:label4];
    
    UILabel *dispatchMark = [[UILabel alloc]initWithFrame:CGRectMake(money.left, label4.top, ScreenWidth-money.left-10, 0)];
    dispatchMark.backgroundColor = [UIColor clearColor];
    dispatchMark.textColor = COLOR_STRING(@"#EA905F");
    dispatchMark.textAlignment = NSTextAlignmentLeft;
    dispatchMark.font = [UIFont systemFontOfSize:14];
    dispatchMark.text = _item.distributeRemark;
    dispatchMark.numberOfLines = 5;
    dispatchMark.height = [_item.distributeRemark getHeightWithFontSize:14 andWidth:dispatchMark.width];
    [dispatchMark sizeToFit];

    [dispatchDetil addSubview:dispatchMark];
    
    dispatchDetil.height = dispatchMark.bottom+5;
    
    [self.view addSubview:dispatchDetil];
    
    UILabel *dispatchTime = [[UILabel alloc]initWithFrame:CGRectMake(label.left, dispatchDetil.bottom+5, ScreenWidth, 20)];
    dispatchTime.backgroundColor = [UIColor clearColor];
    dispatchTime.textAlignment = NSTextAlignmentLeft;
    dispatchTime.text =_item.createTime;
    dispatchTime.textColor = COLOR_STRING(@"#8B8AFC");
    dispatchTime.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:dispatchTime];
    
    UILabel *label5 = [[UILabel alloc]initWithFrame:CGRectMake(label3.left,dispatchDetil.bottom+40, ScreenWidth, 20)];
    label5.backgroundColor = [UIColor clearColor];
    label5.textAlignment = NSTextAlignmentLeft;
    label5.text = @"我的答谢";
    label5.font = [UIFont boldSystemFontOfSize:16];
    label5.textColor = COLOR_STRING(@"#808080");
    [self.view addSubview:label5];
    
    UIView *thanksView = [[UIView alloc]initWithFrame:CGRectMake(0, label5.bottom+5, ScreenWidth, 0)];
    thanksView.backgroundColor = [UIColor whiteColor];
    
    UILabel *thanksMark = [[UILabel alloc]initWithFrame:CGRectMake(label.left, 5, ScreenWidth-2*label.left, 0)];
    thanksMark.backgroundColor = [UIColor clearColor];
    thanksMark.textColor = COLOR_STRING(@"#000000");
    thanksMark.textAlignment = NSTextAlignmentLeft;
    thanksMark.font = [UIFont systemFontOfSize:14];
    thanksMark.numberOfLines = 5;
    NSString *remark = _item.receiveRemark;
    if (remark.length<=0) {
        remark = @"此人很懒，什么都没留下。";
    }
    thanksMark.text = remark;
    thanksMark.height =[remark getHeightWithFontSize:14 andWidth:thanksMark.width];
    [thanksMark sizeToFit];
    [thanksView addSubview:thanksMark];
    
    thanksView.height = [remark getHeightWithFontSize:14 andWidth:thanksMark.width]+10;
    
    [self.view addSubview:thanksView];
    
    UILabel *thanksTime = [[UILabel alloc]initWithFrame:CGRectMake(label.left, thanksView.bottom+5, ScreenWidth, 20)];
    thanksTime.backgroundColor = [UIColor clearColor];
    thanksTime.textAlignment = NSTextAlignmentLeft;
    thanksTime.text =_item.receiveTime;
    thanksTime.textColor = COLOR_STRING(@"#8B8AFC");
    thanksTime.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:thanksTime];

}

/**
 *  此方法已废
 */

/*
- (void)installDispatchCoustomView{
    UIImage *image = MIMAGE(@"redPacket_receive_detail_BG.png");
    image = [image stretchableImageWithLeftCapWidth:139 topCapHeight:100];
    UIImageView *background = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHigh-64)];
    background.image = image;
    background.userInteractionEnabled = YES;
    [self.view addSubview:background];
    
    
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(10, 45, background.width-20, background.height - 95)];
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.showsVerticalScrollIndicator = NO;
    [background addSubview:scrollView];
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 20, scrollView.width, 20)];
    label1.backgroundColor = [UIColor clearColor];
    label1.textColor = COLOR_STRING(@"#808080");
    label1.textAlignment = NSTextAlignmentLeft;
    label1.font = [UIFont systemFontOfSize:16];
    label1.text = @"我派发的红包信息";
    [scrollView addSubview:label1];
    
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(label1.left+40, label1.bottom+30, scrollView.width, 20)];
    label2.backgroundColor = [UIColor clearColor];
    label2.textColor = COLOR_STRING(@"#808080");
    label2.textAlignment = NSTextAlignmentLeft;
    label2.font = [UIFont boldSystemFontOfSize:20];
    label2.text = @"金额:";
    [label2 sizeToFit];
    [scrollView addSubview:label2];
    
    UILabel *money = [[UILabel alloc]initWithFrame:CGRectMake(label2.right+20, 0, scrollView.width, 30)];
    money.bottom = label2.bottom;
    money.backgroundColor = [UIColor clearColor];
    money.textColor = COLOR_STRING(@"#FF5B5C");
    money.textAlignment = NSTextAlignmentLeft;
    money.font = [UIFont boldSystemFontOfSize:25];
    money.text = [NSString stringWithFormat:@"%0.2f 元",_item.amt];
    [scrollView addSubview:money];
    
    UIImageView *imageBlue = [[UIImageView alloc]initWithFrame:CGRectMake(10, money.bottom+30, 30, 30)];
    imageBlue.image = MIMAGE(@"redPacket_receive_detail_head_gray");
    [scrollView addSubview:imageBlue];
    
    UILabel *dispatch = [[UILabel alloc]initWithFrame:CGRectMake(imageBlue.right+5, 0, 30, 20)];
    dispatch.bottom = imageBlue.bottom;
    dispatch.backgroundColor = [UIColor clearColor];
    dispatch.textAlignment = NSTextAlignmentLeft;
    dispatch.text = @"祝语";
    dispatch.font = [UIFont systemFontOfSize:13];
    dispatch.textColor = COLOR_STRING(@"#CCCCCC");
    [scrollView addSubview:dispatch];
    
    UILabel *dispatchTime = [[UILabel alloc]initWithFrame:CGRectMake(dispatch.right+10, money.bottom+10, ScreenWidth, 20)];
    dispatchTime.bottom = imageBlue.bottom;
    dispatchTime.backgroundColor = [UIColor clearColor];
    dispatchTime.textAlignment = NSTextAlignmentLeft;
    dispatchTime.text =_item.createTime;
    dispatchTime.textColor = COLOR_STRING(@"#CCCCCC");
    dispatchTime.font = [UIFont systemFontOfSize:11];
    
    [scrollView addSubview:dispatchTime];
    
    
    UILabel *dispatchMark = [[UILabel alloc]initWithFrame:CGRectMake(dispatch.left+10, dispatch.bottom+30, scrollView.width-(2*(dispatch.left+10)), 0)];
    dispatchMark.backgroundColor = [UIColor clearColor];
    dispatchMark.textColor = COLOR_STRING(@"#808080");
    dispatchMark.textAlignment = NSTextAlignmentLeft;
    dispatchMark.font = [UIFont systemFontOfSize:14];
    dispatchMark.numberOfLines = 10;
    dispatchMark.text = _item.distributeRemark;
    [dispatchMark sizeToFit];
    dispatchMark.height = [_item.distributeRemark getHeightWithFontSize:14 andWidth:dispatchMark.width];
    [scrollView addSubview:dispatchMark];
    
    UIImage *grayBG = MIMAGE(@"redPacket_receive_detail_dialog_gray");
    grayBG = [grayBG stretchableImageWithLeftCapWidth:28 topCapHeight:29];
    UIImageView *dispatchMarkBG = [[UIImageView alloc]initWithFrame:CGRectMake(dispatch.left-5, dispatch.bottom, dispatchMark.width+30, 0)];
    dispatchMarkBG.image = grayBG;
    dispatchMarkBG.height = dispatchMark.height +40;
    [scrollView addSubview:dispatchMarkBG];
    
    UILabel *label3 = [[UILabel alloc]initWithFrame:CGRectMake(10, dispatchMarkBG.bottom+40, scrollView.width, 20)];
    label3.backgroundColor = [UIColor clearColor];
    label3.textColor = COLOR_STRING(@"#808080");
    label3.textAlignment = NSTextAlignmentLeft;
    label3.font = label1.font;
    label3.text = @"对方的答谢留言";
    [scrollView addSubview:label3];
    
    UIImageView *imageHead = [[UIImageView alloc]initWithFrame:CGRectMake(label3.left+10, label3.bottom+20, 50, 50)];
    [imageHead setImageWithURL:[NSURL URLWithString:HeadImageByMember(_item.receiveNo)] placeholderImage:MIMAGE(@"home_head_none")];
    imageHead.layer.masksToBounds = YES;
    imageHead.layer.cornerRadius = 25;
    [scrollView addSubview:imageHead];
    
    UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(imageHead.right+10, imageHead.top+15, scrollView.width, 20)];
    name.backgroundColor = [UIColor clearColor];
    name.textColor = COLOR_STRING(@"#333333");
    name.textAlignment = NSTextAlignmentCenter;
    name.font = [UIFont systemFontOfSize:16];
    name.text = _item.receiveName;
    [name sizeToFit];
    [scrollView addSubview:name];
    
    UILabel *thanksTime = [[UILabel alloc]initWithFrame:CGRectMake(name.right+10, dispatchMark.bottom+10, ScreenWidth, 20)];
    thanksTime.bottom = name.bottom;
    thanksTime.backgroundColor = [UIColor clearColor];
    thanksTime.textAlignment = NSTextAlignmentLeft;
    thanksTime.text = _item.receiveTime;
    thanksTime.textColor = COLOR_STRING(@"#CCCCCC");
    thanksTime.font = dispatchTime.font;
    [scrollView addSubview:thanksTime];
    
    NSString *receiveRemark = _item.receiveRemark;
    if (receiveRemark.length <= 0) {
        [scrollView setContentSize:CGSizeMake(scrollView.width, thanksTime.bottom+90)];
        return;
    }
    
    UILabel *thanksMark = [[UILabel alloc]initWithFrame:CGRectMake(imageHead.left+40, imageHead.bottom+40, scrollView.width-(2*(imageHead.left+40)), 0)];
    thanksMark.backgroundColor = [UIColor clearColor];
    thanksMark.textColor = COLOR_STRING(@"#808080");
    thanksMark.textAlignment = NSTextAlignmentLeft;
    thanksMark.font = [UIFont systemFontOfSize:14];
    thanksMark.numberOfLines = 10;
    thanksMark.text = _item.receiveRemark;
    [thanksMark sizeToFit];
    thanksMark.height = [_item.receiveRemark getHeightWithFontSize:14 andWidth:thanksMark.width];
    [scrollView addSubview:thanksMark];
    
    UIImage *blueBG = MIMAGE(@"redPacket_receive_detail_dialog_blue");
    blueBG = [blueBG stretchableImageWithLeftCapWidth:28 topCapHeight:29];
    UIImageView *thanksMarkBG = [[UIImageView alloc]initWithFrame:CGRectMake(imageHead.left+25, imageHead.bottom+10, thanksMark.width+30, 0)];
    thanksMarkBG.image = blueBG;
    thanksMarkBG.height = thanksMark.height +40;
    [scrollView addSubview:thanksMarkBG];
    
    [scrollView setContentSize:CGSizeMake(scrollView.width, thanksMarkBG.bottom+40)];

}
*/

/**
 *  此方法已废
 */

/*
- (void)installCoustomView{
    UIImage *image = MIMAGE(@"redPacket_receive_detail_BG.png");
    image = [image stretchableImageWithLeftCapWidth:139 topCapHeight:100];
    UIImageView *background = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHigh-64)];
    background.image = image;
    background.userInteractionEnabled = YES;
    [self.view addSubview:background];

    
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(10, 45, background.width-20, background.height - 95)];
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.showsVerticalScrollIndicator = NO;
    [background addSubview:scrollView];
    
    UIImageView *imageHead = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 70, 70)];
    [imageHead setImageWithURL:[NSURL URLWithString:HeadImageByMember(_item.distributeNo)] placeholderImage:MIMAGE(@"home_head_none")];
    imageHead.center = CGPointMake(ScreenWidth/2, 50);
    imageHead.layer.masksToBounds = YES;
    imageHead.layer.cornerRadius = 35;
    [scrollView addSubview:imageHead];
    
    UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(0, imageHead.bottom+10, ScreenWidth, 20)];
    name.backgroundColor = [UIColor clearColor];
    name.textColor = COLOR_STRING(@"#808080");
    name.textAlignment = NSTextAlignmentCenter;
    name.font = [UIFont systemFontOfSize:16];
    name.text = _item.distributeName;
    [scrollView addSubview:name];
    
    UILabel *mobile = [[UILabel alloc]initWithFrame:CGRectMake(0, name.bottom+10, ScreenWidth, 20)];
    mobile.backgroundColor = [UIColor clearColor];
    mobile.textColor = COLOR_STRING(@"#CCCCCC");
    mobile.textAlignment = NSTextAlignmentCenter;
    mobile.font = [UIFont systemFontOfSize:18];
    mobile.text = _item.distributeMobile;
    [scrollView addSubview:mobile];
    
    UILabel *money = [[UILabel alloc]initWithFrame:CGRectMake(0, mobile.bottom+10, ScreenWidth, 20)];
    money.backgroundColor = [UIColor clearColor];
    money.textAlignment = NSTextAlignmentCenter;
    money.textColor = COLOR_STRING(@"#FF5B5C");
    money.font = [UIFont boldSystemFontOfSize:20];
    money.text = [NSString stringWithFormat:@"%0.2f 元",_item.amt];
    [scrollView addSubview:money];
    
    UIImageView *imageBlue = [[UIImageView alloc]initWithFrame:CGRectMake(10, money.bottom+10, 30, 30)];
    imageBlue.image = MIMAGE(@"redPacket_receive_detail_head_blue");
    [scrollView addSubview:imageBlue];
    
    UILabel *dispatch = [[UILabel alloc]initWithFrame:CGRectMake(imageBlue.right+5, money.bottom+10, 30, 20)];
    dispatch.bottom = imageBlue.bottom;
    dispatch.backgroundColor = [UIColor clearColor];
    dispatch.textAlignment = NSTextAlignmentLeft;
    dispatch.text = @"祝语";
    dispatch.font = [UIFont systemFontOfSize:13];
    dispatch.textColor = COLOR_STRING(@"#CCCCCC");
    [scrollView addSubview:dispatch];

    UILabel *dispatchTime = [[UILabel alloc]initWithFrame:CGRectMake(dispatch.right+10, money.bottom+10, ScreenWidth, 20)];
    dispatchTime.bottom = imageBlue.bottom;
    dispatchTime.backgroundColor = [UIColor clearColor];
    dispatchTime.textAlignment = NSTextAlignmentLeft;
    dispatchTime.text =_item.createTime;
    dispatchTime.textColor = COLOR_STRING(@"#CCCCCC");
    dispatchTime.font = [UIFont systemFontOfSize:11];

    [scrollView addSubview:dispatchTime];
    

    UILabel *dispatchMark = [[UILabel alloc]initWithFrame:CGRectMake(dispatch.left+10, dispatch.bottom+30, scrollView.width-(2*(dispatch.left+10)), 0)];
    dispatchMark.backgroundColor = [UIColor clearColor];
    dispatchMark.textColor = COLOR_STRING(@"#808080");
    dispatchMark.textAlignment = NSTextAlignmentLeft;
    dispatchMark.font = [UIFont systemFontOfSize:14];
    dispatchMark.numberOfLines = 10;
    dispatchMark.text = _item.distributeRemark;
    [dispatchMark sizeToFit];
    dispatchMark.height = [_item.distributeRemark getHeightWithFontSize:14 andWidth:dispatchMark.width];
    [scrollView addSubview:dispatchMark];
    
    UIImage *blueBG = MIMAGE(@"redPacket_receive_detail_dialog_blue");
    blueBG = [blueBG stretchableImageWithLeftCapWidth:28 topCapHeight:29];
    UIImageView *dispatchMarkBG = [[UIImageView alloc]initWithFrame:CGRectMake(dispatch.left-5, dispatch.bottom, dispatchMark.width+30, 0)];
    dispatchMarkBG.image = blueBG;
    dispatchMarkBG.height = dispatchMark.height +40;
    [scrollView addSubview:dispatchMarkBG];
    
    
    UIImageView *imageYellow = [[UIImageView alloc]initWithFrame:CGRectMake(0, dispatchMarkBG.bottom+10, 30, 30)];
    imageYellow.right = ScreenWidth-30;
    imageYellow.image = MIMAGE(@"redPacket_receive_detail_head_yellow");
    [scrollView addSubview:imageYellow];
    
    UILabel *thanks = [[UILabel alloc]initWithFrame:CGRectMake(5, dispatchMark.bottom+10, 60, 20)];
    thanks.right = imageYellow.left-5;
    thanks.bottom = imageYellow.bottom;
    thanks.backgroundColor = [UIColor clearColor];
    thanks.textAlignment = NSTextAlignmentRight;
    thanks.textColor = COLOR_STRING(@"#CCCCCC");
    thanks.font = dispatch.font;
    thanks.text = @"我的答谢";
    [scrollView addSubview:thanks];
    
    UILabel *thanksTime = [[UILabel alloc]initWithFrame:CGRectMake(5, dispatchMark.bottom+10, ScreenWidth, 20)];
    thanksTime.right = thanks.left-10;
    thanksTime.bottom = imageYellow.bottom;
    thanksTime.backgroundColor = [UIColor clearColor];
    thanksTime.textAlignment = NSTextAlignmentRight;
    thanksTime.text = _item.receiveTime;
    thanksTime.textColor = COLOR_STRING(@"#CCCCCC");
    thanksTime.font = dispatchTime.font;
    [scrollView addSubview:thanksTime];
    
    NSString *receiveRemark = _item.receiveRemark;
    if (receiveRemark.length <= 0) {
        [scrollView setContentSize:CGSizeMake(scrollView.width, thanksTime.bottom+90)];
        return;
    }
    
    UILabel *thanksMark = [[UILabel alloc]initWithFrame:CGRectMake(0, thanksTime.bottom+30, scrollView.width-(2*(dispatch.left+10)), 0)];
    thanksMark.backgroundColor = [UIColor clearColor];
    thanksMark.textAlignment = NSTextAlignmentRight;
    thanksMark.text = _item.receiveRemark;
    thanksMark.textColor = COLOR_STRING(@"#808080");
    thanksMark.font = [UIFont systemFontOfSize:14];
    thanksMark.numberOfLines = 10;
    [thanksMark sizeToFit];
    thanksMark.height = [_item.receiveRemark getHeightWithFontSize:14 andWidth:thanksMark.width];
    thanksMark.right = thanks.right -5;

    [scrollView addSubview:thanksMark];
    
    UIImage *yellowBG = MIMAGE(@"redPacket_receive_detail_dialog_yellow");
    yellowBG = [yellowBG stretchableImageWithLeftCapWidth:5 topCapHeight:29];
    UIImageView *thanksMarkBG = [[UIImageView alloc]initWithFrame:CGRectMake(0, thanks.bottom, thanksMark.width+30, 0)];
    thanksMarkBG.right = thanks.right +10;
    thanksMarkBG.image = yellowBG;
    thanksMarkBG.height = thanksMark.height +40;
    [scrollView addSubview:thanksMarkBG];

    
    [scrollView setContentSize:CGSizeMake(scrollView.width, thanksMarkBG.bottom+40)];
}
 
 */

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
