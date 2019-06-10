//
//  XDRuntimeUtility.h
//  nullable
//
//  Created by wangchao on 2018/3/6.
//  Copyright © 2018年 vincent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XDRuntimeUtility : NSObject
///交换实例方法
void pp_swizzleInstanceMethod(Class className, SEL original, SEL new);
/// 交换类方法
void pp_swizzleClassMethod(Class className, SEL original, SEL new);
@end
