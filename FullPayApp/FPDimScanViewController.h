//
//  FPDimScanViewController.h
//  FullPayApp
//
//  Created by mark zheng on 14-2-21.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPViewController.h"
#import <AVFoundation/AVFoundation.h>

typedef enum{
    DimScanViewComeFromHomePage,
    DimScanViewComeFromRedPackte
} DimScanViewComeFrom;

@interface FPDimScanViewController : FPViewController <AVCaptureMetadataOutputObjectsDelegate>
{
    int num;
    BOOL upOrdown;
    NSTimer * timer;
    CAShapeLayer *cropLayer;
}
@property (strong,nonatomic)AVCaptureDevice * device;
@property (strong,nonatomic)AVCaptureDeviceInput * input;
@property (strong,nonatomic)AVCaptureMetadataOutput * output;
@property (strong,nonatomic)AVCaptureSession * session;
@property (strong,nonatomic)AVCaptureVideoPreviewLayer * preview;

@property (nonatomic, retain) UIImageView * line;

@property (nonatomic, assign) DimScanViewComeFrom viewComeFrom;

@end
