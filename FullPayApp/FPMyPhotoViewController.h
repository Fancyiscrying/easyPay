//
//  FPMyPhotoViewController.h
//  FullPayApp
//
//  Created by mark zheng on 13-7-20.
//  Copyright (c) 2013年 fullpay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FPMyPhotoViewController : UIViewController<UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,MBProgressHUDDelegate>

@property (strong, nonatomic) UIImageView *imageView;

@property (strong, nonatomic) UILabel *labelMobileNo;
@property (strong, nonatomic) UILabel *labelRealName;
@property (strong, nonatomic) UIButton *btnInformation;

@end
