//
//  UIImage+XiuDian.m
//  RetainCycleTest
//
//  Created by wangchao on 2018/2/28.
//  Copyright © 2018年 Panwei. All rights reserved.
//

#import "UIImage+XiuDian.h"
#import <SDWebImage/SDWebImageManager.h>

@implementation UIImage (XiuDian)

+ (void)generateGroupImageWithImageURLs:(NSArray <NSString *> *)avatars groupImageSize:(CGSize)imageSize groupImageName:(NSString *)groupImageName placeholderImage:(UIImage *)placeholderImage completion:(void (^)(UIImage * image, NSString *cacheImageURL))completion {
    if (avatars.count < 1) {
        return;
    }
    NSArray *imageURLs = avatars;
    if (avatars.count > 9) {
        imageURLs = [avatars subarrayWithRange:NSMakeRange(0, 9)];
    }
    __block NSInteger imageCount = avatars.count;
    __block NSInteger imageIndex = 0;
    __block NSMutableArray *imageArr = [NSMutableArray array];
    //    [UIView animateWithDuration:1 animations:nil completion:^(BOOL finished) {
    //
    //    }]
    //从最后一个开始排列
    for (NSInteger i = 0; i < imageURLs.count; i++) {
        [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:imageURLs[i]] options:0 progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
            imageIndex ++;
            if (image) {
                [imageArr addObject:image];
            } else {
                [imageArr addObject:placeholderImage];
            }
            if (imageIndex == imageCount || imageIndex == 9) {
                //开始合成
                UIImage *groupImage = [self createGroupImageWithAvatars:imageArr Size:imageSize];
                if (completion) {
                    [SDImageCache sharedImageCache].config.shouldCacheImagesInMemory = NO;
                    [[SDImageCache sharedImageCache] storeImage:groupImage imageData:nil forKey:groupImageName toDisk:YES completion:^{
                        [SDImageCache sharedImageCache].config.shouldCacheImagesInMemory = YES;
                    }];
                    NSString *cacheImagePath = [NSString stringWithFormat:@"file://%@",[[SDImageCache sharedImageCache] defaultCachePathForKey:groupImageName]];

                    completion(groupImage,cacheImagePath);
                }
                //                _imageView.image = groupImage;
            }
//            NSLog(@"下载的image===%@",image);
        }];
        
    }
    
}
+ (UIImage *)createGroupImageWithAvatars:(NSArray *)avatars Size:(CGSize)size {
    //列数
    NSInteger column_num = avatars.count<5?2:3;//ceil(avatars.count/2.0);
    //行数
    NSInteger row_num = ceil(avatars.count/(float)column_num);
    //第一行个数
    NSInteger first_row_num = avatars.count - column_num*(row_num-1);
    //    NSLog(@"\n N=%@ : %ld行  %ld列 第一行%ld个",@(avatars.count),row_num,column_num,first_row_num);
    //每个小图的宽度
    CGFloat eachImageW = size.width/column_num;
    //画布大小
    CGSize cavasSize = size;
    CGFloat bottomMargin = (cavasSize.height-eachImageW*row_num)/2;
    
    UIGraphicsBeginImageContextWithOptions(cavasSize, NO, [UIScreen mainScreen].scale);
    //从最后一个开始排列
    for (NSInteger i = avatars.count-1; i >=0; i --) {
        //        UIImage *image = [UIImage imageNamed:avatars[i]];
        UIImage *image = avatars[i];
        image = [image imageByRoundCornerRadius:image.size.width/2
                                        corners:UIRectCornerAllCorners
                                    borderWidth:image.size.width*0.05
                                    borderColor:[UIColor clearColor]
                                 borderLineJoin:kCGLineJoinMiter];
        CGFloat left = size.width - (avatars.count-(i+1))%column_num*eachImageW - eachImageW;
        //第一行特殊处理
        if (i+1 <= first_row_num) {
            if (i == 0&&first_row_num==1) {
                left = size.width/2 - eachImageW/2 ;
            }
            else if (avatars.count>4&& avatars.count%column_num == 2) {
                left = size.width/2 - eachImageW +i*eachImageW;
            }
        }
        CGFloat top = size.height - bottomMargin -(avatars.count-(i+1))/column_num*eachImageW - eachImageW;
        CGRect imageFrame = CGRectMake(left, top , eachImageW, eachImageW);
        //        NSLog(@"\n\ni=%@\nleft=%.1f\ntop=%.1f\nP=%ld",@(i),left,top,(avatars.count-(i+1))/3);
        [image drawInRect:imageFrame];
    }
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)imageByRoundCornerRadius:(CGFloat)radius
                              corners:(UIRectCorner)corners
                          borderWidth:(CGFloat)borderWidth
                          borderColor:(UIColor *)borderColor
                       borderLineJoin:(CGLineJoin)borderLineJoin {
    
    if (corners != UIRectCornerAllCorners) {
        UIRectCorner tmp = 0;
        if (corners & UIRectCornerTopLeft) tmp |= UIRectCornerBottomLeft;
        if (corners & UIRectCornerTopRight) tmp |= UIRectCornerBottomRight;
        if (corners & UIRectCornerBottomLeft) tmp |= UIRectCornerTopLeft;
        if (corners & UIRectCornerBottomRight) tmp |= UIRectCornerTopRight;
        corners = tmp;
    }
    
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextScaleCTM(context, 1, -1);
    CGContextTranslateCTM(context, 0, -rect.size.height);
    
    CGFloat minSize = MIN(self.size.width, self.size.height);
    if (borderWidth < minSize / 2) {
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(rect, borderWidth, borderWidth) byRoundingCorners:corners cornerRadii:CGSizeMake(radius, borderWidth)];
        [path closePath];
        
        CGContextSaveGState(context);
        [path addClip];
        CGContextDrawImage(context, rect, self.CGImage);
        CGContextRestoreGState(context);
    }
    
    if (borderColor && borderWidth < minSize / 2 && borderWidth > 0) {
        CGFloat strokeInset = (floor(borderWidth * self.scale) + 0.5) / self.scale;
        CGRect strokeRect = CGRectInset(rect, strokeInset, strokeInset);
        CGFloat strokeRadius = radius > self.scale / 2 ? radius - self.scale / 2 : 0;
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:strokeRect byRoundingCorners:corners cornerRadii:CGSizeMake(strokeRadius, borderWidth)];
        [path closePath];
        
        path.lineWidth = borderWidth;
        path.lineJoinStyle = borderLineJoin;
        [borderColor setStroke];
        [path stroke];
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end

