//
//  UIImage+ImageExtension.h
//  Taoguba App Client
//
//  Created by taoguba on 13-10-30.
//  Copyright (c) 2013年 taoguba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ImageExtension)
//- (UIImage *)imageByScalingToSize:(CGSize)targetSize;
//获取图片的格式类型
//-(NSString *)getTypeForImageData:(NSData *)data;
//进行图片的大小压缩(如果原图片的宽>高,则高等比例压缩；如果原图片的宽<高,则宽等比例压缩);目前项目中不需要该大小压缩
//-(UIImage *)imageSizeZip:(UIImage *)oldImage width:(float)w height:(float)h;
//进行图片的质量压缩到指定最大大小（单位:byte）
//-(UIImage *)imageQualityZip:(UIImage *)oldImage size:(float)maxByte;

//- (UIImage *)compressedImage;

- (UIImage *)scaledToSize:(CGSize)newSize
                   inRect:(CGRect)rect
         opaqueBackground:(BOOL)opaque;
/**
 *  不按原比例缩放（拉伸）
 *
 *  @param newSize 新的尺寸
 *  @param opaque  背景是否透明（如果为NO，透明的PNG图片背景也会不透明）
 *
 *  @return 拉伸后的图片
 */
- (UIImage *)scaledToSize:(CGSize)newSize
         opaqueBackground:(BOOL)opaque;

- (UIImage *)imageByScalingToSize:(CGSize)targetSize;

- (CGFloat)compressionQuality;

- (NSData *)compressedData;

- (NSData *)compressedData:(CGFloat)compressionQuality;

- (UIImage *)imageWithTintColor:(UIColor *)tintColor;

- (UIImage *)imageWithGradientTintColor:(UIColor *)tintColor;

- (UIImage *)imageWithTintColor:(UIColor *)tintColor blendMode:(CGBlendMode)blendMode;

+(NSData *)compressImage:(NSData *)imageData toSize:(float)size;

+(NSData *)compressImage:(NSData *)image;

-(UIImage *)thumbnilImage;

+(UIImage*)crop:(UIImage*)theImage;

- (UIImage *)fixOrientation;

/**
 创建并返回一个1x1大小的图像,给定颜色
 Create and return a 1x1 point size image with the given color.
 
 @param color  The color.
 */
+ (UIImage *)imageWithColor:(UIColor *)color;

/**
 创建和返回一个给定颜色和大小的纯色图像
 Create and return a pure color image with the given color and size.
 
 @param color  The color.
 @param size   New image's type.
 */
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

/**
 *  创建一个圆形纯色图片
 *
 *  @param color  圆的颜色
 *  @param radius 圆的半径
 *
 *  @return 圆形图片
 */
+ (UIImage *)circleImageWithColor:(UIColor *)color radius:(CGFloat)radius;
@end
