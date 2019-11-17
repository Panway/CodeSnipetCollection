//
//  UIImage+ImageExtension.m
//  Taoguba App Client
//
//  Created by taoguba on 13-10-30.
//  Copyright (c) 2013年 taoguba. All rights reserved.
//
#define MAX_IMAGEDATA_LEN  300000                       //最大300K
#import "UIImage+ImageExtension.h"

@implementation UIImage (ImageExtension)

static NSString * const FORM_FLE_INPUT = @"file";

- (UIImage *)imageByScalingToSize:(CGSize)targetSize {
	
	UIImage *sourceImage = self;
	UIImage *newImage = nil;
	
	CGFloat targetWidth = targetSize.width;
	CGFloat targetHeight = targetSize.height;
	
	CGFloat scaledWidth = targetWidth;
	CGFloat scaledHeight = targetHeight;
	
	CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
	
	UIGraphicsBeginImageContext(targetSize);
	
	CGRect thumbnailRect = CGRectZero;
	thumbnailRect.origin = thumbnailPoint;
	thumbnailRect.size.width  = scaledWidth;
	thumbnailRect.size.height = scaledHeight;
	
	[sourceImage drawInRect:thumbnailRect];
	
	newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return newImage ;
}

//https://developer.apple.com/library/ios/samplecode/sc2273/Listings/AirDropSample_UIImage_Resize_m.html
- (UIImage *)scaledToSize:(CGSize)newSize
                   inRect:(CGRect)rect
         opaqueBackground:(BOOL)opaque
{
    //Determine whether the screen is retina
    if ([[UIScreen mainScreen] scale] == 2.0) {
        UIGraphicsBeginImageContextWithOptions(newSize, opaque, 2.0);
    }
    else
    {
        UIGraphicsBeginImageContext(newSize);
    }
    
    //Draw image in provided rect
    [self drawInRect:rect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    //Pop this context
    UIGraphicsEndImageContext();
    
    return newImage;
}
- (UIImage *)scaledToSize:(CGSize)newSize
         opaqueBackground:(BOOL)opaque
{
    return [self scaledToSize:newSize inRect:CGRectMake(0.0, 0.0, newSize.width, newSize.height) opaqueBackground:opaque];
}

-(UIImage *)thumbnilImage
{
    CGSize targetSize;
    if (self.size.width>self.size.height) {
        if (self.size.height>100) {
            targetSize = CGSizeMake(100*self.size.width/self.size.height,100.f);
        }else{
            if (self.size.width>120) {
                targetSize = CGSizeMake(120, self.size.height/self.size.width*120);
            }else{
                targetSize = self.size;
            }
        }
    }else{
        if (self.size.width>100) {
            targetSize = CGSizeMake(100, self.size.height/self.size.width*100);
        }else{
            if (self.size.height>120) {
                targetSize = CGSizeMake(120*self.size.width/self.size.height,120);
            }else{
                targetSize = self.size;
            }
        }
    }
    return [self imageByScalingToSize:targetSize];
}

-(NSString *)getTypeForImageData:(NSData *)data{
    if (!data){
        return nil;
    }
    uint8_t c;
    [data getBytes:&c length:1];
    switch (c) {
        case 0xFF:
            return @"image/jpeg";
        case 0x89:
            return @"image/png";
        case 0x47:
            return @"image/gif";
        case 0x49:
        case 0x4D:
            return @"image/tiff";
    }
    return nil;
}

-(UIImage *)imageSizeZip:(UIImage *)oldImage width:(float)w height:(float)h
{
    UIImage *newImage = nil;
    
    if (oldImage.size.width > oldImage.size.height)
    {
       
        float _imagescale = oldImage.size.width/w;
        if (_imagescale > 0)
        {
            h = oldImage.size.height/_imagescale;
            newImage = [oldImage imageByScalingToSize:CGSizeMake(w, h)];
        }
        
        return newImage;
    }
    else
    {
        float _imagescale = oldImage.size.height/h;
        if (_imagescale > 0)
        {
            w = oldImage.size.width/_imagescale;
            newImage = [oldImage imageByScalingToSize:CGSizeMake(w, h)];
        }
        
        return newImage;
    }
}
/*
-(UIImage *)imageQualityZip:(UIImage *)oldImage size:(float)maxByte
{
    //将图片转换为jpng
    NSData *imageData = UIImageJPEGRepresentation(oldImage,1);
    //获取原图的大小
    float imageByte = [imageData length];
     NSLog(@"原图大小:%f",imageByte);
    if (imageByte > maxByte) {         //如果原图的大小大于设定的最大byte
        NSLog(@"压缩比率:%f",maxByte/imageByte);
        imageData = UIImageJPEGRepresentation(oldImage, maxByte/imageByte);
    }
    NSLog(@"图片压缩后的大小%i",[imageData length]);
    return [UIImage imageWithData:imageData];
}
- (UIImage *)compressedImage {
    CGSize imageSize = self.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    if (width <= MAX_IMAGEPIX && height <= MAX_IMAGEPIX) {
        return self;
    }
    if (width == 0 || height == 0) {
        return self;
    }
    UIImage *newImage = nil;
    CGFloat widthFactor = MAX_IMAGEPIX / width;
    CGFloat heightFactor = MAX_IMAGEPIX / height;
    CGFloat scaleFactor = 0.0;
    if (widthFactor > heightFactor){
        scaleFactor = heightFactor;
    }else{
        scaleFactor = widthFactor;
    }
    CGFloat scaledWidth  = width * scaleFactor;
    CGFloat scaledHeight = height * scaleFactor;
    CGSize targetSize = CGSizeMake(scaledWidth, scaledHeight);
    UIGraphicsBeginImageContext(targetSize);
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [self drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}*/

- (NSData *)compressedData:(CGFloat)compressionQuality {
    assert(compressionQuality <= 1.0 && compressionQuality >= 0);
    return UIImageJPEGRepresentation(self, compressionQuality);
}

- (CGFloat)compressionQuality {
    NSData *data = UIImageJPEGRepresentation(self, 1.0);
    NSUInteger dataLength = [data length];
    
    if(dataLength > MAX_IMAGEDATA_LEN) {
        
        return MAX_IMAGEDATA_LEN / dataLength;
    } else {
        return 1.0;
    }
}

- (NSData *)compressedData {
    CGFloat quality = [self compressionQuality];
    return [self compressedData:quality];
}



- (UIImage *) imageWithTintColor:(UIColor *)tintColor
{
    return [self imageWithTintColor:tintColor blendMode:kCGBlendModeDestinationIn];
}

- (UIImage *) imageWithGradientTintColor:(UIColor *)tintColor
{
    return [self imageWithTintColor:tintColor blendMode:kCGBlendModeOverlay];
}

- (UIImage *) imageWithTintColor:(UIColor *)tintColor blendMode:(CGBlendMode)blendMode
{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    [tintColor setFill];
    CGRect bounds = CGRectMake(0, 0, self.size.width, self.size.height);
    UIRectFill(bounds);

    
    [self drawInRect:bounds blendMode:blendMode alpha:1.0f];
    
    if (blendMode != kCGBlendModeDestinationIn) {
        [self drawInRect:bounds blendMode:kCGBlendModeDestinationIn alpha:1.0f];
    }
    
    UIImage *tintedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return tintedImage;
}

+(NSData *)compressImage:(NSData *)imageData toSize:(float)size
{
    while (true) {
        float datalength = (float)[imageData length];
        NSLog(@"datalentgh:%f",datalength);
        if(datalength> size) {
            float rate = size/datalength;
            NSLog(@"image:%f",rate);
            UIImage *image = [UIImage imageWithData:imageData];
            imageData = UIImageJPEGRepresentation(image,rate);
        }else{
            return imageData;
        }
    }
}

+(NSData *)compressImage:(NSData *)imageData{
    UIImage *image = [UIImage imageWithData:imageData];
    float actualHeight = image.size.height;
    float actualWidth = image.size.width;
    float maxHeight = 600.0;
    float maxWidth = 800.0;
    float imgRatio = actualWidth/actualHeight;
    float maxRatio = maxWidth/maxHeight;
    float compressionQuality = 0.5;//50 percent compression
    
    if (actualHeight > maxHeight || actualWidth > maxWidth){
        if(imgRatio < maxRatio){
            //adjust width according to maxHeight
            imgRatio = maxHeight / actualHeight;
            actualWidth = imgRatio * actualWidth;
            actualHeight = maxHeight;
        }
        else if(imgRatio > maxRatio){
            //adjust height according to maxWidth
            imgRatio = maxWidth / actualWidth;
            actualHeight = imgRatio * actualHeight;
            actualWidth = maxWidth;
        }
        else{
            actualHeight = maxHeight;
            actualWidth = maxWidth;
        }
    }
    
    CGRect rect = CGRectMake(0.0, 0.0, actualWidth, actualHeight);
    UIGraphicsBeginImageContext(rect.size);
    [image drawInRect:rect];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    NSData *newimageData = UIImageJPEGRepresentation(img, compressionQuality);
    UIGraphicsEndImageContext();
    
    return newimageData;
}


+(UIImage*)crop:(UIImage*)theImage{
    CGSize size = [theImage size];
    // Create rectangle that represents a cropped image
    CGFloat desiredRatio = 1.0;
    CGFloat croppedWidth = 0.0;
    CGFloat croppedHeight = 0.0;
    CGRect rect;
    if (size.height/size.width >= desiredRatio) {
        croppedWidth = size.width;
        croppedHeight = size.width * desiredRatio;
        CGFloat difference = (size.height-croppedHeight)/2;
        rect = CGRectMake(0.0, difference ,croppedWidth, croppedHeight);
    }else{
        return theImage;
    }
    CGImageRef imageRef = CGImageCreateWithImageInRect([theImage CGImage], rect);
    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return croppedImage;
}

- (UIImage *)fixOrientation {
    
    if (self.imageOrientation == UIImageOrientationUp) return self;
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    UIImageOrientation io = self.imageOrientation;
    //    UIImageOrientation io = orention ;
    if (io == UIImageOrientationDown || io == UIImageOrientationDownMirrored) {
        transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
        transform = CGAffineTransformRotate(transform, M_PI);
        
        
    }
    if (io == UIImageOrientationLeft || io == UIImageOrientationLeftMirrored) {
        transform = CGAffineTransformTranslate(transform, self.size.width, 0);
        transform = CGAffineTransformRotate(transform, M_PI_2);
    }
    if (io == UIImageOrientationRight || io == UIImageOrientationRightMirrored) {
        transform = CGAffineTransformTranslate(transform, 0, self.size.height);
        transform = CGAffineTransformRotate(transform, -M_PI_2);
        
        
    }
    
    if (io == UIImageOrientationUpMirrored || io == UIImageOrientationDownMirrored) {
        transform = CGAffineTransformTranslate(transform, self.size.width, 0);
        transform = CGAffineTransformScale(transform, -1, 1);
    }
    if (io == UIImageOrientationLeftMirrored || io == UIImageOrientationRightMirrored) {
        transform = CGAffineTransformTranslate(transform, self.size.height, 0);
        transform = CGAffineTransformScale(transform,  -1, 1);
        
    }
    
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                                             CGImageGetBitsPerComponent(self.CGImage), 0,
                                             CGImageGetColorSpace(self.CGImage),
                                             CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    
    if (io == UIImageOrientationLeft || io == UIImageOrientationLeftMirrored || io == UIImageOrientationRight || io == UIImageOrientationRightMirrored) {
        CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage);
    }else{
        CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage);
    }
    
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    return [self imageWithColor:color size:CGSizeMake(1, 1)];
}

+ (UIImage *)circleImageWithColor:(UIColor *)color radius:(CGFloat)radius {
    CGRect rect = CGRectMake(0.0f, 0.0f, radius*2, radius*2);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextAddEllipseInRect(context, rect);
    CGContextFillEllipseInRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
