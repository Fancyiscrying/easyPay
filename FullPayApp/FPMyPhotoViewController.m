//
//  FPMyPhotoViewController.m
//  FullPayApp
//
//  Created by mark zheng on 13-7-20.
//  Copyright (c) 2013年 fullpay. All rights reserved.
//

#import "FPMyPhotoViewController.h"
//#import "FPIdentityVerificationViewController.h"
#import "AFHTTPRequestOperation.h"

#define IMG_ADDPHOTO @"Photo 04.png"

@interface FPMyPhotoViewController ()
{
    MBProgressHUD *uploadHud;
    BOOL isFullScreen;
    CGRect orgFrame;
    
    long long totalBytes, totalBytesExpected;
}

@property (nonatomic,retain) FPPersonMember *personMember;
@property (nonatomic,retain) NSString *imageName;

@end

@implementation FPMyPhotoViewController

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
    UIView *view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    
    UIImageView *backgroundImage = [[UIImageView alloc] initWithFrame:view.bounds];
    [backgroundImage setImage:[UIImage imageNamed:@"BG"]];
    [view addSubview:backgroundImage];
    
    self.imageView = [[UIImageView alloc] init];
    self.imageView.frame = CGRectMake(75, 50, 170, 170);
    [self.imageView setImage:[UIImage imageNamed:IMG_ADDPHOTO]];
    self.imageView.layer.cornerRadius = 85;
    self.imageView.layer.masksToBounds = YES;
    self.imageView.backgroundColor = [UIColor clearColor];
    self.imageView.userInteractionEnabled = YES;
    [view addSubview:self.imageView];
    
    self.labelMobileNo = [[UILabel alloc] init];
    self.labelMobileNo.frame = CGRectMake(75, 233, 170, 21);
    self.labelMobileNo.backgroundColor = [UIColor clearColor];
    self.labelMobileNo.font = [UIFont systemFontOfSize:15.0f];
    self.labelMobileNo.textAlignment = NSTextAlignmentCenter;
    self.labelMobileNo.textColor = MCOLOR(@"text_color");
    [view addSubview:self.labelMobileNo];
    
//    self.btnInformation = [[UIButton alloc] init];
//    self.btnInformation.frame = CGRectMake(75, 264, 170, 33);
//    [self.btnInformation setTitle:@"点击这里完善资料" forState:UIControlStateNormal];
//    [self.btnInformation setTitleColor:MCOLOR(@"text_color") forState:UIControlStateNormal];
//    self.btnInformation.titleLabel.font = [UIFont systemFontOfSize:15.0f];
//    [self.btnInformation addTarget:self action:@selector(clickInformation:) forControlEvents:UIControlEventTouchUpInside];
//    [view addSubview:self.btnInformation];
    
    self.labelRealName = [[UILabel alloc] init];
    self.labelRealName.frame = CGRectMake(75, 264, 170, 33);
    self.labelRealName.backgroundColor = [UIColor clearColor];
    self.labelRealName.font = [UIFont systemFontOfSize:15.0f];
    self.labelRealName.textAlignment = NSTextAlignmentCenter;
    self.labelRealName.textColor = MCOLOR(@"text_color");
    [view addSubview:self.labelRealName];
    
    self.view = view;
}
#pragma mark - view lifecycle
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.title = @"我的头像";
    
    self.personMember = [Config Instance].personMember;
    self.labelMobileNo.text = self.personMember.mobile;
    
    if (self.personMember.nameAuthFlag) {
        self.labelRealName.text = self.personMember.memberName;
        self.btnInformation.hidden = YES;
    } else {
        self.btnInformation.hidden = NO;
    }
    
    UITapGestureRecognizer *guesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseImage:)];
    guesture.numberOfTapsRequired = 1;
    [self.imageView addGestureRecognizer:guesture];
    
    self.imageName = [NSString stringWithFormat:@"%@.png",self.personMember.memberNo];
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:self.imageName];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:fullPath]) {
        UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:fullPath];
        self.imageView.image = savedImage;
        if (savedImage == nil) {
            UIImage *image = [UIImage imageNamed:@"home_head_none.png"];
            self.imageView.image = image;
        }
        CALayer *layer = [self.imageView layer];
        layer.borderColor = [[UIColor whiteColor] CGColor];
        layer.borderWidth = 2.0f;
        layer.cornerRadius = 85.0f;
        layer.masksToBounds = YES;
    }else{
        UIImage *image = [UIImage imageNamed:@"home_head_none.png"];
        self.imageView.image = image;

    }
    
    orgFrame = CGRectMake(75, 90, 170, 170);
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)chooseImage:(UITapGestureRecognizer *)sender
{
    //    if ([sender state] == UIGestureRecognizerStateBegan) {
    UIActionSheet *sheet;
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        
    {
        sheet  = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择", nil];
    }
    else {
        sheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选择", nil];
    }
    
    sheet.tag = 255;
    
    [sheet showFromToolbar:self.navigationController.toolbar];
    //    }
}

-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 255) {
        
        NSUInteger sourceType = 0;
        
        // 判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            switch (buttonIndex) {
                case 0:
                    // 相机
                    sourceType = UIImagePickerControllerSourceTypeCamera;
                    break;
                case 1:
                    // 相册
                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    break;
                case 2:
                    // 取消
                    return;
            }
        }
        else {
            if (buttonIndex == 0) {
                sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            } else {
                return;
            }
        }
        
        // 跳转到相机或相册页面
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = sourceType;
        [self presentViewController:imagePickerController animated:YES completion:^{}];
    }
}

#pragma mark - image picker delegte
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    CGSize imageSize = CGSizeMake(170, 170);
    UIImage *image1 = [self scaleToSize:image size:imageSize];
    
    // 保存图片至本地，方法见下文
    
    [self saveImage:image1 withName:self.imageName];
    
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:self.imageName];
    
    UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:fullPath];
    
    isFullScreen = NO;
    
    [self.imageView setImage:savedImage];
    self.imageView.tag = 100;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}
#pragma mark - 保存图片至沙盒
- (void) saveImage:(UIImage *)currentImage withName:(NSString *)imageName
{
    
    NSData *imageData = UIImagePNGRepresentation(currentImage);
    // 获取沙盒目录
    
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:fullPath]) {
        [[NSFileManager defaultManager] removeItemAtPath:fullPath error:nil];
    }
    
    [self imageUpload:imageData];
    // 将图片写入文件
    [imageData writeToFile:fullPath atomically:NO];
}

-(void)imageUpload:(NSData *)imageData
{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    [UtilTool showHUD:@"正在处理" andView:self.navigationController.view andHUD:hud];
 
    NSString *memberNo = [Config Instance].memberNo;
    
    FPClient *httpClient = [FPClient sharedClient];
    NSDictionary *parameters = [httpClient userImageUpload:memberNo];
    
    [httpClient POST:kFPFilePost parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {

        [formData appendPartWithFileData:imageData name:@"uploadFile" fileName:self.imageName mimeType:@"image/jpg"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        hud.hidden = YES;
        
        //TODO:
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        hud.hidden = YES;
        //TODO:
        
    }];
    
//    NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST" path:kFPFilePost parameters:parameters constructingBodyWithBlock: ^(id <AFMultipartFormData>formData){
//        [formData appendPartWithFileData:imageData name:@"uploadFile" fileName:self.imageName mimeType:@"image/png"];
//    }];
//    
//    [hud hide:YES];
//    
//    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
//    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
//        NSLog(@"Sent %lld of %lld bytes", totalBytesWritten, totalBytesExpectedToWrite);
//        totalBytes = totalBytesWritten;
//        totalBytesExpected = totalBytesExpectedToWrite;
//        
//        uploadHud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
//        [self.navigationController.view addSubview:uploadHud];
//        
//        uploadHud.delegate = self;
//        uploadHud.tag = 100;
//        
//        // myProgressTask uses the HUD instance to update progress
//        [uploadHud showWhileExecuting:@selector(myProgressTask) onTarget:self withObject:nil animated:YES];
//        
//    }];
//    [operation start];
}

- (void)myProgressTask {
    // Set determinate bar mode
    uploadHud.mode = MBProgressHUDModeDeterminateHorizontalBar;
    uploadHud.labelText = @"图像处理中";
//    uploadHud.mode = MBProgressHUDModeDeterminate;
	// This just increases the progress indicator in a loop
	float progress = 0.0f;
	while (progress < 1.0f) {
//		progress += 0.01f;
        progress += totalBytes/totalBytesExpected;
		uploadHud.progress = progress;
		usleep(50000);
	}
    
    uploadHud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
	uploadHud.mode = MBProgressHUDModeCustomView;
	uploadHud.labelText = @"图像上传成功!";
    sleep(1);
}

- (void)hudWasHidden:(MBProgressHUD *)hud
{
    [hud removeFromSuperview];
    hud = nil;
}

- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0,0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    //返回新的改变大小后的图片
    return scaledImage;

}

- (void)viewDidUnload {
    [self setImageView:nil];
    [self setLabelMobileNo:nil];
    [self setLabelRealName:nil];
    [self setBtnInformation:nil];
    [super viewDidUnload];
}
- (void)clickInformation:(id)sender {
//    FPIdentityVerificationViewController *identificationView = [[FPIdentityVerificationViewController alloc] init];
//    
//    [self.navigationController pushViewController:identificationView animated:YES];
}
@end
