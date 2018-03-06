//
//  NSObject+PPRuntime.m
//  nullable
//
//  Created by wangchao on 2018/3/6.
//  Copyright © 2018年 vincent. All rights reserved.
//

#import "NSObject+PPRuntime.h"
#import <objc/runtime.h>

@implementation NSObject (PPRuntime)

///交换实例方法
- (void)exchangeInstanceMethod:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector {
    Class class = [self class];
    
//    SEL originalSelector = @selector(viewWillAppear:);
//    SEL swizzledSelector = @selector(xxx_viewWillAppear:);
    
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    // When swizzling a class method, use the following:
    // Class class = object_getClass((id)self);
    // ...
    // Method originalMethod = class_getClassMethod(class, originalSelector);
    // Method swizzledMethod = class_getClassMethod(class, swizzledSelector);
    
    BOOL didAddMethod =
    class_addMethod(class,
                    originalSelector,
                    method_getImplementation(swizzledMethod),
                    method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(class,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

/// 交换类方法
+ (void)exchangeClassMethodWithOriginalSel:(SEL)originalSel newSel:(SEL)newSel {
    Method method1 = class_getClassMethod([self class], originalSel);
    Method method2 = class_getClassMethod([self class], newSel);
    method_exchangeImplementations(method1, method2);
}




@end
