//
//  FPMy2DimCodeViewController.h
//  FullPayApp
//
//  Created by mark zheng on 14-2-20.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPViewController.h"

typedef enum {
    comeFormHomePage,
    comeFormPersonIfo
} My2DimCodeComeForm;

@interface FPMy2DimCodeViewController : FPViewController
@property (strong, nonatomic) IBOutlet UIImageView *img_Photo;
@property (strong, nonatomic) IBOutlet UILabel *lbl_Name;
@property (strong, nonatomic) IBOutlet UILabel *lbl_MobileNo;

@property (strong, nonatomic) IBOutlet UILabel *lbl_alert;

@property (strong, nonatomic) IBOutlet UIImageView *img_2DimCode;

@property (nonatomic) My2DimCodeComeForm comeForm;

@end
