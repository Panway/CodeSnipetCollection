//
//  NSArray+Safe.m
//  nullable
//
//  Created by vincent on 16/3/7.
//  Copyright © 2016年 vincent. All rights reserved.
//
// Tips: https://medium.com/@ngchiwang/nsarray-vs-nsmutablearray-in-ios10-and-ios11-beta-d2748ee58841

// https://www.jianshu.com/p/c89b2716d60d

// 自定义Log
#ifdef DEBUG
#define XDSAFELog(fmt, ...) NSLog((@"%s [Line %d] \n" fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define XDSAFELog(...)
#endif


#import "NSArray+Safe.h"
#import <objc/runtime.h>
#import "XDRuntimeUtility.h"

@implementation NSArray (Safe)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        pp_swizzleClassMethod([self class], @selector(arrayWithObjects:count:), @selector(na_arrayWithObjects:count:));
        pp_swizzleInstanceMethod([self class], @selector(objectAtIndexedSubscript:), @selector(safeObjectAtIndexedSubscript:));
    });
}

- (id)safeObjectAtIndexedSubscript:(NSUInteger)index {
    if (index >= self.count) {
        return nil;
    } else {
        return [self objectAtIndex:index];
    }
}
/// 避免这种crash:@[@"aa", nilObj]
+ (instancetype)na_arrayWithObjects:(const id [])objects count:(NSUInteger)cnt {
    id nObjects[cnt];
    int i=0, j=0;
    for (; i<cnt && j<cnt; i++) {
        if (objects[i]) {
            nObjects[j] = objects[i];
            j++;
        }
    }
    return [self na_arrayWithObjects:nObjects count:j];
}
@end



@implementation NSMutableArray (Safe)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //    NSString *mArrayString = NSStringFromClass([[NSMutableArray new] class]);
        //    Class arrayCls1 = [[NSMutableArray new] class];
        Class arrayCls = NSClassFromString(@"__NSArrayM");
        pp_swizzleInstanceMethod(arrayCls, @selector(insertObject:atIndex:), @selector(na_insertObject:atIndex:));
        pp_swizzleInstanceMethod(arrayCls, @selector(setObject:atIndex:), @selector(na_setObject:atIndex:));
        pp_swizzleInstanceMethod(arrayCls, @selector(setObject:atIndexedSubscript:), @selector(safeSetObject:atIndexedSubscript:));
    });
}

/// 避免这种crash: [myArray addObject:nilObj];
- (void)na_insertObject:(id)anObject atIndex:(NSUInteger)index {
    if (!anObject)
        return;
    [self na_insertObject:anObject atIndex:index];
}
/// 避免这种crash: [myArray addObject:nilObj];
- (void)na_setObject:(id)anObject atIndex:(NSUInteger)index {
    if (!anObject)
        return;
    [self na_setObject:anObject atIndex:index];
}
///  避免这种crash: myArray[0] = nilObj;
- (void)safeSetObject:(id)obj atIndexedSubscript:(NSUInteger)idx {
    if (obj == nil ||self.count < idx) {
        return ;
    }
    if (idx == self.count) {
        [self addObject:obj];
    } else {
        [self replaceObjectAtIndex:idx withObject:obj];
    }
}

@end
