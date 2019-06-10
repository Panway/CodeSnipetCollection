//
//  PPRuntimeUtility.h
//  
//
//  Created by panda on 2018/3/6.
//  Copyright © 2018年 panda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PPRuntimeUtility : NSObject
///交换实例方法
void pp_swizzleInstanceMethod(Class className, SEL original, SEL new);
/// 交换类方法
void pp_swizzleClassMethod(Class className, SEL original, SEL new);
@end
