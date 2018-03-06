//
//  UIImage+XiuDian.h
//  RetainCycleTest
//
//  Created by wangchao on 2018/2/28.
//  Copyright © 2018年 Panwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (XiuDian)
- (UIImage *)imageByRoundCornerRadius:(CGFloat)radius
                              corners:(UIRectCorner)corners
                          borderWidth:(CGFloat)borderWidth
                          borderColor:(UIColor *)borderColor
                       borderLineJoin:(CGLineJoin)borderLineJoin;
/// 生成微信群头像
+ (void)generateGroupImageWithImageURLs:(NSArray <NSString *> *)avatars groupImageSize:(CGSize)imageSize  placeholderImage:(UIImage *)placeholderImage completion:(void (^)(UIImage * image))completion;
@end

