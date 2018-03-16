//
//  UIImage+XiuDian.h
//  RetainCycleTest
//
//  Created by wangchao on 2018/2/28.
//  Copyright © 2018年 Panwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (XiuDian)

+ (NSString *)groupImageCachedURLWithGroupID:(NSString *)groupID;

- (UIImage *)imageByRoundCornerRadius:(CGFloat)radius
                              corners:(UIRectCorner)corners
                          borderWidth:(CGFloat)borderWidth
                          borderColor:(UIColor *)borderColor
                       borderLineJoin:(CGLineJoin)borderLineJoin;
/// 生成微信群头像
/*
 avatars:图片URL数组(没头像的要为空字符串)
 imageSize:生成的群头像尺寸
 groupImageName:生成的群头像唯一名字，eg:[NSString stringWithFormat:@"GroupImage_%@.png",groupID]
 placeholderImage:无头像的群成员占位图
 completion:完成后的block
 */
+ (void)generateGroupImageWithImageURLs:(NSArray <NSString *> *)avatars
                         groupImageSize:(CGSize)imageSize
                         groupImageName:(NSString *)groupImageName
                       placeholderImage:(UIImage *)placeholderImage
                        backgroundColor:(UIColor *)backgroundColor
                             completion:(void (^)(UIImage * image, NSString *cacheImageURL))completion;
@end

