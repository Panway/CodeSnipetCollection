//
//  NSArray+Safe.m
//  nullable
//
//  Created by vincent on 16/3/7.
//  Copyright © 2016年 vincent. All rights reserved.
//
// Tips: https://medium.com/@ngchiwang/nsarray-vs-nsmutablearray-in-ios10-and-ios11-beta-d2748ee58841

// https://www.jianshu.com/p/c89b2716d60d
// https://github.com/chenfanfang/AvoidCrash

// 自定义Log
#ifdef DEBUG
#define XDSAFELog(fmt, ...) NSLog((@"%s [Line %d] \n" fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define XDSAFELog(...)
#endif


#import "NSArray+Safe.h"
#import <objc/runtime.h>
#import "PPRuntimeTool.h"
#import <UIKit/UIDevice.h>

@implementation NSArray (Safe)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        pp_swizzleClassMethod([self class], @selector(arrayWithObjects:count:), @selector(na_arrayWithObjects:count:));
        pp_swizzleInstanceMethod([self class], @selector(objectAtIndexedSubscript:), @selector(safeObjectAtIndexedSubscript:));
        
//        Class __NSArray = NSClassFromString(@"NSArray");
        Class __NSArrayI = NSClassFromString(@"__NSArrayI");
        Class __NSSingleObjectArrayI = NSClassFromString(@"__NSSingleObjectArrayI");
        Class __NSArray0 = NSClassFromString(@"__NSArray0");
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 11.0) {
            pp_swizzleInstanceMethod(__NSArrayI, @selector(objectAtIndexedSubscript:), @selector(__NSArrayIAvoidCrashObjectAtIndexedSubscript:));
        }
        pp_swizzleInstanceMethod(__NSArrayI, @selector(objectAtIndex:), @selector(__NSArrayIAvoidCrashObjectAtIndex:));
        pp_swizzleInstanceMethod(__NSSingleObjectArrayI, @selector(objectAtIndex:), @selector(__NSSingleObjectArrayIAvoidCrashObjectAtIndex:));
        pp_swizzleInstanceMethod(__NSArray0, @selector(objectAtIndex:), @selector(__NSArray0AvoidCrashObjectAtIndex:));

        
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



//=================================================================
//                     objectAtIndexedSubscript:
//=================================================================
#pragma mark - objectAtIndexedSubscript:
- (id)__NSArrayIAvoidCrashObjectAtIndexedSubscript:(NSUInteger)idx {
    id object = nil;
    
    @try {
        object = [self __NSArrayIAvoidCrashObjectAtIndexedSubscript:idx];
    }
    @catch (NSException *exception) {
        //异常处理...
        NSLog(@"===%@",exception);
    }
    @finally {
        return object;
    }
    
}


//=================================================================
//                       objectsAtIndexes:
//=================================================================
#pragma mark - objectsAtIndexes:

- (NSArray *)avoidCrashObjectsAtIndexes:(NSIndexSet *)indexes {
    
    NSArray *returnArray = nil;
    @try {
        returnArray = [self avoidCrashObjectsAtIndexes:indexes];
    } @catch (NSException *exception) {
        //异常处理...
        NSLog(@"===%@",exception);
        
    } @finally {
        return returnArray;
    }
}


//=================================================================
//                         objectAtIndex:
//=================================================================
#pragma mark - objectAtIndex:

//__NSArrayI  objectAtIndex:
- (id)__NSArrayIAvoidCrashObjectAtIndex:(NSUInteger)index {
    id object = nil;
    
    @try {
        object = [self __NSArrayIAvoidCrashObjectAtIndex:index];
    }
    @catch (NSException *exception) {
        //异常处理...
        NSLog(@"===%@",exception);
    }
    @finally {
        return object;
    }
}



//__NSSingleObjectArrayI objectAtIndex:
- (id)__NSSingleObjectArrayIAvoidCrashObjectAtIndex:(NSUInteger)index {
    id object = nil;
    
    @try {
        object = [self __NSSingleObjectArrayIAvoidCrashObjectAtIndex:index];
    }
    @catch (NSException *exception) {
        //异常处理...
        NSLog(@"===%@",exception);
    }
    @finally {
        return object;
    }
}

//__NSArray0 objectAtIndex:
- (id)__NSArray0AvoidCrashObjectAtIndex:(NSUInteger)index {
    id object = nil;
    
    @try {
        object = [self __NSArray0AvoidCrashObjectAtIndex:index];
    }
    @catch (NSException *exception) {
        //异常处理...
        NSLog(@"===%@",exception);
    }
    @finally {
        return object;
    }
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
        //objectAtIndex:
        pp_swizzleInstanceMethod(arrayCls, @selector(objectAtIndex:), @selector(avoidCrashObjectAtIndex:));
        pp_swizzleInstanceMethod(arrayCls, @selector(removeObjectAtIndex:), @selector(avoidCrashRemoveObjectAtIndex:));

        if ([[UIDevice currentDevice].systemVersion floatValue] >= 11.0) {
            pp_swizzleInstanceMethod(arrayCls, @selector(objectAtIndexedSubscript:), @selector(avoidCrashObjectAtIndexedSubscript:));
        }


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
//=================================================================
//                    removeObjectAtIndex:
//=================================================================
#pragma mark - removeObjectAtIndex:

- (void)avoidCrashRemoveObjectAtIndex:(NSUInteger)index {
    @try {
        [self avoidCrashRemoveObjectAtIndex:index];
    }
    @catch (NSException *exception) {
        //异常处理...
        NSLog(@"===%@",exception);
    }
    @finally {
        
    }
}
//=================================================================
//                           objectAtIndex:
//=================================================================
#pragma mark - objectAtIndex:

- (id)avoidCrashObjectAtIndex:(NSUInteger)index {
    id object = nil;
    
    @try {
        object = [self avoidCrashObjectAtIndex:index];
    }
    @catch (NSException *exception) {
        //异常处理...
        NSLog(@"===%@",exception);
    }
    @finally {
        return object;
    }
}

//=================================================================
//                     objectAtIndexedSubscript:
//=================================================================
#pragma mark - objectAtIndexedSubscript:
- (id)avoidCrashObjectAtIndexedSubscript:(NSUInteger)idx {
    id object = nil;
    
    @try {
        object = [self avoidCrashObjectAtIndexedSubscript:idx];
    }
    @catch (NSException *exception) {
        //异常处理...
        NSLog(@"===%@",exception);
    }
    @finally {
        return object;
    }
    
}
@end
