//
//  PPRuntimeUtility.m
//  
//
//  Created by panda on 2018/3/6.
//  Copyright © 2018年 panda. All rights reserved.
//

#import "PPRuntimeTool.h"
#import <objc/runtime.h>

@implementation PPRuntimeTool
///交换实例方法
void pp_swizzleInstanceMethod(Class className, SEL original, SEL new) {
    Method originalMethod = class_getInstanceMethod(className, original);
    Method newMethod = class_getInstanceMethod(className, new);
    BOOL didAddMethod = class_addMethod(className, original, method_getImplementation(newMethod), method_getTypeEncoding(newMethod));
    if (didAddMethod) {
        class_replaceMethod(className, new, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, newMethod);
    }
}
/// 交换类方法
void pp_swizzleClassMethod(Class className, SEL original, SEL new) {
    Method originalMethod = class_getClassMethod(className, original);
    Method newMethod = class_getClassMethod(className, new);
    className = object_getClass((id)className);
    if(class_addMethod(className, original, method_getImplementation(newMethod), method_getTypeEncoding(newMethod)))
        class_replaceMethod(className, new, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    else
        method_exchangeImplementations(originalMethod, newMethod);
}
@end
