//
//  ImageUtils.m
//  FullPayApp
//
//  Created by mark zheng on 13-9-15.
//  Copyright (c) 2013年 fullpay. All rights reserved.
//

#import "ImageUtils.h"
#import "UIImageView+AFNetworking.h"

@implementation ImageUtils

-(UIImage *)getImageWithMemberNo:(NSString *)memberNo andHeadAddress:(NSString *)headAddress
{
    NSString *imageUrl = @"";
    if (headAddress != nil && headAddress.length > 0) {
        imageUrl = [NSString stringWithFormat:@"%@%@%@",[FPClient ServerAddress],kHEADIMGPATH,headAddress];
    }
    
    UIImageView *tempImgView = [[UIImageView alloc] init];
    
    NSString *imageName = memberNo;
    UIImage *showImage = nil;
    if (imageUrl.length > 0) {
        BOOL loadImgFromServer = NO;
        NSString *serverImgName = [[Config Instance] getHeadAddressByMemberNo:imageName];
        if (serverImgName) {
            if ([serverImgName isEqualToString:headAddress]) {
                UIImage *image = [self loadImage:imageName ofType:@"png"];
                if (image == nil) {
                    loadImgFromServer = YES;
                } else {
                    showImage = image;
                }
                
            } else {
                loadImgFromServer = YES;
            }
        } else {
            loadImgFromServer = YES;
        }
        
        if (loadImgFromServer) {
//            NSURL *url = [NSURL URLWithString:imageUrl];
//            BOOL result = [self saveImage:url withName:imageName];
            BOOL result = [self loadImage:tempImgView withUrlStr:imageUrl withName:imageName ofType:@"png" placeHolderImage:[UIImage imageNamed:@"perinfor_img_user_none.png"]];
            if (result) {
//                showImage = [self loadImage:imageName ofType:@"png"];
                showImage = tempImgView.image;
                [[Config Instance] setHeadAddress:imageName andName:headAddress];
            }
//            else {
//                showImage = [UIImage imageNamed:@"Photo Box 01.png"];
//            }
        }
        
    } else {
        UIImage *image = [self loadImage:imageName ofType:@"png"];
        if (image != nil) {
            showImage = image;
        }
//        else {
//            showImage = [UIImage imageNamed:@"Photo Box 01.png"];
//        }
    }
    
    return showImage;
}

-(UIImage *)getImageWithMemberNo:(NSString *)memberNo andHeadAddress:(NSString *)headAddress andBlock:(void(^)(UIImage *image, bool result))block
{
    NSString *imageUrl = @"";
    if (headAddress != nil && headAddress.length > 0) {
        imageUrl = [NSString stringWithFormat:@"%@%@%@",[FPClient ServerAddress],kHEADIMGPATH,headAddress];
    }
    
    UIImageView *tempImgView = [[UIImageView alloc] init];
    
    NSString *imageName = memberNo;
    UIImage *showImage = nil;
    if (imageUrl.length > 0) {
        BOOL loadImgFromServer = NO;
        NSString *serverImgName = [[Config Instance] getHeadAddressByMemberNo:imageName];
        if (serverImgName) {
            if ([serverImgName isEqualToString:headAddress]) {
                UIImage *image = [self loadImage:imageName ofType:@"png"];
                if (image == nil) {
                    loadImgFromServer = YES;
                } else {
                    showImage = image;
                }
                
            } else {
                loadImgFromServer = YES;
            }
        } else {
            loadImgFromServer = YES;
        }
        
        if (loadImgFromServer) {
            
            [self loadImage:tempImgView withUrlStr:imageUrl withName:imageName ofType:@"png" placeHolderImage:[UIImage imageNamed:@"perinfor_img_user_none.png"] andBlock:^(UIImage *image, BOOL result) {
                if (block) {
                    block(image,result);
                }
            }];
           
        }
        
    } else {
        UIImage *image = [self loadImage:imageName ofType:@"png"];
        if (image != nil) {
            showImage = image;
        }
        //        else {
        //            showImage = [UIImage imageNamed:@"Photo Box 01.png"];
        //        }
    }
    
    return showImage;
}

-(void)getImage:(UIImageView *)imageView andMemberNo:(NSString *)memberNo andHeadAddress:(NSString *)headAddress
{
    NSString *imageUrl = @"";
    if (headAddress != nil && headAddress.length > 0) {
        imageUrl = [NSString stringWithFormat:@"%@%@%@",[FPClient ServerAddress],kHEADIMGPATH,headAddress];
    }
    NSLog(@"img:%@",imageUrl);
    
    NSString *imageName = memberNo;
    UIImage *showImage = nil;
    if (imageUrl.length > 0) {
        BOOL loadImgFromServer = NO;
        NSString *serverImgName = [[Config Instance] getHeadAddressByMemberNo:imageName];
        if (serverImgName) {
            if ([serverImgName isEqualToString:headAddress]) {
                UIImage *image = [self loadImage:imageName ofType:@"png"];
                if (image == nil) {
                    loadImgFromServer = YES;
                } else {
                    showImage = image;
                    imageView.image = showImage;
                }
                
            } else {
                loadImgFromServer = YES;
            }
        } else {
            loadImgFromServer = YES;
        }
//        loadImgFromServer = YES;
        if (loadImgFromServer) {

            [self loadImage:imageView withUrlStr:imageUrl withName:imageName ofType:@"png" placeHolderImage:nil];
            [[Config Instance] setHeadAddress:imageName andName:headAddress];

//            NSURL *url = [NSURL URLWithString:imageUrl];
//            [imageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"Photo Box 01.png"]];
        }
        
    } else {
        UIImage *image = [self loadImage:imageName ofType:@"png"];
        if (image != nil) {
            showImage = image;
            imageView.image = showImage;
        }
//        else {
//            showImage = [UIImage imageNamed:@"Photo Box 01.png"];
//        }
    }
}

-(BOOL)saveImage:(NSURL *)imgUrl withName:(NSString*)name
{
    NSError *error = nil;
    NSData *imageData = [NSData dataWithContentsOfURL:imgUrl options:NSDataReadingUncached error:&error];
    if (error) {
        FPDEBUG(@"ImageUtils.saveImage:%@",error);
        return NO;
    }
    UIImage *img = [UIImage imageWithData:imageData];
    NSString *path = [self imagePath];
    
    return [self saveImage:img withFileName:name ofType:@"png" inDerictory:path];
}

-(UIImage*)loadImage:(NSString*)imageName ofType:(NSString *)extension
{
    NSString *path = [self imagePath];
    
    return [self loadImage:imageName ofType:extension inDerictroy:path];
}

-(void)removeImageFile
{
    NSArray *extension = [NSArray arrayWithObjects:@"png",@"jpg",@"jpeg", nil];
    [self removeImageFileAtPath:[self imagePath] ofTypes:extension];
}

/*
 *保存图片到相应的目录，只支持png、jpg、jpeg三种格式的图片
 */
-(BOOL)saveImage:(UIImage*)image withFileName:(NSString*)imageName ofType:(NSString *)extension inDerictory:(NSString*)directoryPath
{
    if ([extension isEqualToString:@"png"] == NO && [extension isEqualToString:@"jpg"] == NO && [extension isEqualToString:@"jpeg"] == NO) {
        return NO;
    }
    NSString *filePath = [directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@",imageName,extension]];
    [self removedIfExistsAtPath:filePath];
    
    if ([[extension lowercaseString] isEqualToString:@"png"]) {
        [UIImagePNGRepresentation(image) writeToFile:filePath options:NSAtomicWrite error:nil];
    } else if([[extension lowercaseString] isEqualToString:@"jpg"] || [[extension lowercaseString] isEqualToString:@"jpeg"]){
        [UIImageJPEGRepresentation(image, 1.0) writeToFile:filePath options:NSAtomicWrite error:nil];
    } 
    
    return YES;
}

/*
 *从图片目录中加载图片
 */
-(UIImage *)loadImage:(NSString*)imageName ofType:(NSString*)extension inDerictroy:(NSString*)directory
{
    NSString *filePath = [NSString stringWithFormat:@"%@/%@.%@",directory,imageName,extension ];
    UIImage *image =nil;
    if ([self fileExistsAtPath:filePath]) {
        image = [UIImage imageWithContentsOfFile:filePath];
    }
    
    return  image;
}

/*
 *删除指定目录下指定格式的文件
 */
-(void)removeImageFileAtPath:(NSString *)filePath ofTypes:(NSArray *)extension
{
    NSFileManager *manager = [NSFileManager defaultManager];
    NSArray *fileList = [[manager contentsOfDirectoryAtPath:filePath error:nil] pathsMatchingExtensions:extension];
    
    for (NSString *file in fileList) {
        NSString *imgPath = [filePath stringByAppendingPathComponent:file];
        [manager removeItemAtPath:imgPath error:nil];
    }
}

/*
 *判断文件是否存在
 */
-(BOOL)fileExistsAtPath:(NSString*)filePath
{
    NSFileManager *manager = [NSFileManager defaultManager];
    
    return [manager fileExistsAtPath:filePath];
}

/*
 *如果文件存在则删除之
 */
-(BOOL)removedIfExistsAtPath:(NSString*)filePath
{
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]) {
        [manager removeItemAtPath:filePath error:nil];
    }
    
    return YES;
}

/*
 *图片文件存放路径，默认是在Document目录下
 */
-(NSString *)imagePath
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    return path;
}


#pragma mark -

//-(void)loadImage:(UIImageView *)imageView withUrlStr:(id)urlStr withName:(NSString*)name
//{
//    NSString *strUrl = nil;
//    if ([urlStr isKindOfClass:[NSURL class]]) {
//        strUrl = [urlStr absoluteString];
//    } else {
//        strUrl = urlStr;
//    }
//    [self loadImage:imageView withUrlStr:strUrl withName:name ofType:@"png" placeHolderImage:placeHolder];
//}

-(BOOL)loadImage:(UIImageView *)imageView withUrlStr:(NSString *)urlStr withName:(NSString*)name ofType:(NSString *)extension placeHolderImage:(UIImage *)placeHolderImage
{
    __block BOOL result = NO;
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
    
    __block UIImageView *downimage = imageView;
    [imageView setImageWithURLRequest:request placeholderImage:placeHolderImage success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        downimage.image = image;
        [self saveImage:image withFileName:name ofType:extension inDerictory:[self imagePath]];
        result = YES;
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        NSLog(@"false");
//        downimage.image = placeHolderImage;
        result = NO;
    }];
    
    return result;
}

-(BOOL)loadImage:(UIImageView *)imageView
      withUrlStr:(NSString *)urlStr
        withName:(NSString*)name
          ofType:(NSString *)extension
placeHolderImage:(UIImage *)placeHolderImage
        andBlock:(void(^)(UIImage *image , BOOL result))block
{
    __block BOOL result = NO;
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
    
    __block UIImageView *downimage = imageView;
    [imageView setImageWithURLRequest:request placeholderImage:placeHolderImage success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        downimage.image = image;
        [self saveImage:image withFileName:name ofType:extension inDerictory:[self imagePath]];
        result = YES;
        if(block){
            block(image,YES);
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        NSLog(@"false");
        //        downimage.image = placeHolderImage;
        if(block){
            block(nil,NO);
        }
        result = NO;
    }];
    
    return result;
}


- (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize

{
    UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
    [image drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return reSizeImage;
    
}

/**
 *  UIColor生成UIImage
 *
 *  @param color     生成的颜色
 *  @param imageSize 生成的图片大小
 *
 *  @return 生成后的图片
 */
+ (UIImage*)createImageWithColor:(UIColor*)color size:(CGSize)imageSize {
    CGRect rect=CGRectMake(0.0f, 0.0f, imageSize.width, imageSize.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

//单例模式
static ImageUtils * instance = nil;
+(ImageUtils *) Instance
{
    @synchronized(self)
    {
        if(nil == instance)
        {
            [self new];
        }
    }
    return instance;
}

+(id)allocWithZone:(NSZone *)zone
{
    @synchronized(self)
    {
        if(instance == nil)
        {
            instance = [super allocWithZone:zone];
            return instance;
        }
    }
    return nil;
}

@end
