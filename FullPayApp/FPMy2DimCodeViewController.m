//
//  FPMy2DimCodeViewController.m
//  FullPayApp
//
//  Created by mark zheng on 14-2-20.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPMy2DimCodeViewController.h"
#import "UIImageView+AFNetworking.h"
#import "AESCrypt.h"
#import "QRCodeGenerator.h"

@interface FPMy2DimCodeViewController () <UIActionSheetDelegate>

@property (nonatomic,retain) FPPersonMember *personMember;

@end

@implementation FPMy2DimCodeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    if (_comeForm == comeFormHomePage) {
        self.navigationItem.title = @"收款码";
        _lbl_alert.text = @"让对方扫码付款给我";

    }else if (_comeForm == comeFormPersonIfo){
    
        self.navigationItem.title = @"我的二维码名片";
        
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"user_bt_option"] style:UIBarButtonItemStylePlain target:self action:@selector(click_RightButton:)];
        [self.navigationItem setRightBarButtonItem:rightButton];
    }
    
    
    self.personMember = [Config Instance].personMember;
    
    if (self.personMember.headAddress.length > 0) {
        ImageUtils *imgUtils = [ImageUtils Instance];
        UIImage *showImage = [imgUtils getImageWithMemberNo:self.personMember.memberNo andHeadAddress:self.personMember.headAddress];
        if (showImage) {
            UIImage *reSize = [[ImageUtils Instance] reSizeImage:showImage toSize:CGSizeMake(49, 49)];
            
            self.img_Photo.image = reSize;
            self.img_Photo.layer.masksToBounds = YES;
            self.img_Photo.layer.cornerRadius = 30.0;
            self.img_Photo.layer.borderColor = [UIColor whiteColor].CGColor;
            self.img_Photo.layer.borderWidth = 2.0f;
        }
    }
    
    if (self.personMember.nameAuthFlag) {
        self.lbl_Name.text = self.personMember.memberName;
    } else {
        self.lbl_Name.text = @"尚未实名认证";
    }
    
    self.lbl_MobileNo.text = self.personMember.mobile;
    
    if (_personMember.mobile.length>0) {
        [self made2DimageCode];
    }
    
    self.img_Photo.hidden = YES;
    self.lbl_Name.hidden = YES;
    self.lbl_MobileNo.hidden = YES;
    
//    //调整label位置
//    self.lbl_Name.left = self.img_Photo.right + 20;
//    self.lbl_MobileNo.left = self.img_Photo.right + 20;
}

//制作加密二维码
- (void)made2DimageCode{
    
    NSString *secrityName = @"";
   
    if (self.personMember.memberName.length>0) {
        NSString *name = self.personMember.memberName;

        secrityName = [name substringFromIndex:1];
        secrityName = [NSString stringWithFormat:@"*%@",secrityName];
    }
    
   
    NSString *message = [NSString stringWithFormat:@"%@|%@",self.personMember.mobile,secrityName];
    NSString *secrityMessage = [AESCrypt encrypt:message password:AESEncryKey];
    NSLog(@"%@",secrityMessage);
    
    
    
    //NSString *codeUrl = @"http://api.kuaipai.cn/qr?chs=350X350&chl=18718867801";
   // NSString *codeUrl = [NSString stringWithFormat:@"http://api.kuaipai.cn/qr?chs=350X350&chl=[fzf]%@",secrityMessage];
    
    NSString *QR2Dmessage = [NSString stringWithFormat:@"[fzf]%@",secrityMessage];
    UIImage *QR2Dimage = [QRCodeGenerator qrImageForString:QR2Dmessage imageSize:240];
    self.img_2DimCode.image = QR2Dimage;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)click_RightButton:(UIButton *)sender
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"保存至相册", nil];
    
    [sheet showFromToolbar:self.navigationController.toolbar];
    
    
}

-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self saveImageToPhotos:self.img_2DimCode.image];
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

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:msg message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];

    [alert show];
}

@end
