//
//  FPFeedBackViewController.m
//  FullPayApp
//
//  Created by mark zheng on 14-2-25.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPFeedBackViewController.h"

#define IMAGE_APP_BACKGROUND @"BG.png"

#define TIP1  @"1、添加富之富微信公共账号foxconn-fuzhifu，反馈意见"
#define TIP2  @"2、点击二维码，保存到本机；用微信的扫一扫功能，选择图片识别，添加富之富微信公共账号，反馈意见"

@interface FPFeedBackViewController () <UIActionSheetDelegate>

@property (nonatomic,strong) UIImageView *img_DimCode;
@end

@implementation FPFeedBackViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    UIImageView *background = [[UIImageView alloc] initWithFrame:view.bounds];
    background.image = [UIImage imageNamed:IMAGE_APP_BACKGROUND];
   
    [view addSubview:background];
    
    self.img_DimCode = [[UIImageView alloc] init];
    self.img_DimCode.frame = CGRectMake(60, 53, 200, 200);
    self.img_DimCode.image = [UIImage imageNamed:@"feedback_2dimensioncode"];
    
    [view addSubview:self.img_DimCode];
    
    UILabel *lbl_Tip1 = [[UILabel alloc] init];
    CGRect rect_Name = CGRectMake(15, 280, 280, 30);

    lbl_Tip1.frame = rect_Name;
    lbl_Tip1.backgroundColor = [UIColor clearColor];
    lbl_Tip1.textColor = [UIColor grayColor];
    lbl_Tip1.font = [UIFont systemFontOfSize:12.0f];
    lbl_Tip1.textAlignment = NSTextAlignmentLeft;
    lbl_Tip1.lineBreakMode = NSLineBreakByWordWrapping;
    lbl_Tip1.numberOfLines = 0;
    lbl_Tip1.text = TIP1;
    [view addSubview:lbl_Tip1];
    
    UILabel *lbl_Tip2 = [[UILabel alloc] init];
    CGRect tip2Rect = CGRectOffset(rect_Name, 0, 40);
    tip2Rect.size.height = 60.0f;
    tip2Rect.size.width = 280.0f;
    lbl_Tip2.frame = tip2Rect;
    
    lbl_Tip2.backgroundColor = [UIColor clearColor];
    lbl_Tip2.textColor = [UIColor grayColor];
    lbl_Tip2.font = [UIFont systemFontOfSize:12.0f];
    lbl_Tip2.textAlignment = NSTextAlignmentLeft;
    lbl_Tip2.lineBreakMode = NSLineBreakByWordWrapping;
    lbl_Tip2.numberOfLines = 4;
    lbl_Tip2.text = TIP2;
    [view addSubview:lbl_Tip2];
    
    self.view = view;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.title = @"用户反馈";
    
    UIGestureRecognizer *guest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click_SaveImage:)];
    [self.img_DimCode addGestureRecognizer:guest];
    [self.img_DimCode setUserInteractionEnabled:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)click_SaveImage:(UIGestureRecognizer *)sender
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"保存至相册", nil];
    
    [sheet showFromToolbar:self.navigationController.toolbar];
}

-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self saveImageToPhotos:self.img_DimCode.image];
    } else {
        return;
    }
}

- (void)saveImageToPhotos:(UIImage*)savedImage
{
    UIImageWriteToSavedPhotosAlbum(savedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}

// 指定回调方法
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSString *msg = nil ;
    if(error != NULL){
        msg = @"保存图片失败" ;
    }else{
        msg = @"保存图片成功" ;
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    
    [alert show];
}

@end
