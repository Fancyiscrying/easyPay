//
//  ImageUtils.h
//  FullPayApp
//
//  Created by mark zheng on 13-9-15.
//  Copyright (c) 2013年 fullpay. All rights reserved.
//

/*
 //    UIImage *image = [self loadImage:item.title ofType:@"png" inDerictroy:[self imagePath]];
 //    if (image == nil) {
 //        [self saveImage:item.imageURL withName:item.title];
 //        image = [self loadImage:item.title ofType:@"png"];
 //    }
 */
#import <Foundation/Foundation.h>

@interface ImageUtils : NSObject

/*包含了不同设备上传图像同步的逻辑判断*/
-(UIImage *)getImageWithMemberNo:(NSString *)memberNo andHeadAddress:(NSString *)headAddress;
-(UIImage *)getImageWithMemberNo:(NSString *)memberNo andHeadAddress:(NSString *)headAddress andBlock:(void(^)(UIImage *image, bool result))block;
-(void)getImage:(UIImageView *)imageView andMemberNo:(NSString *)memberNo andHeadAddress:(NSString *)headAddress;

-(BOOL)saveImage:(NSURL *)imgUrl withName:(NSString*)name;
-(UIImage*)loadImage:(NSString*)imageName ofType:(NSString *)extension;
-(void)removeImageFile;

- (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize;

+ (UIImage*)createImageWithColor:(UIColor*)color size:(CGSize)imageSize;

+(ImageUtils *) Instance;
+(id)allocWithZone:(NSZone *)zone;


@end
