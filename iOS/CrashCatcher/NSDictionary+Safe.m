//
//  NSDictionary+Safe.m
//  nullable
//
//  Created by vincent on 16/3/7.
//  Copyright © 2016年 vincent. All rights reserved.
//

#import "NSDictionary+Safe.h"
#import <objc/runtime.h>
#import "PPRuntimeTool.h"

@implementation NSDictionary (Safe)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        pp_swizzleClassMethod([self class], @selector(dictionaryWithObjects:forKeys:count:), @selector(na_dictionaryWithObjects:forKeys:count:));
    });
}
/// 避免这种crash：@{@"key1": nilObj, @"key2": @"obj2"};
+ (instancetype)na_dictionaryWithObjects:(const id [])objects forKeys:(const id <NSCopying> [])keys count:(NSUInteger)cnt {
    id nObjects[cnt];
    id nKeys[cnt];
    int i=0, j=0;
    for (; i<cnt && j<cnt; i++) {
        if (objects[i] && keys[i]) {
            nObjects[j] = objects[i];
            nKeys[j] = keys[i];
            j++;
        }
    }
    return [self na_dictionaryWithObjects:nObjects forKeys:nKeys count:j];
}

@end

@implementation NSMutableDictionary (Safe)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        Class dictCls = NSClassFromString(@"__NSDictionaryM");
        //Class dictCls = [[NSMutableDictionary new] class];
        pp_swizzleInstanceMethod(dictCls, @selector(setObject:forKey:), @selector(na_setObject:forKey:));
        pp_swizzleInstanceMethod(dictCls, @selector(removeObjectForKey:), @selector(safe_removeObjectForKey:));
//        pp_swizzleInstanceMethod(dictCls, @selector(setValue:forKey:), @selector(safe_setValue:forKey:));
        //这种方式天生就不会有问题，故忽略： mDict[@"key"] = nilObj;
//        pp_swizzleInstanceMethod(dictCls, @selector(setObject:forKeyedSubscript:), @selector(avoidCrashSetObject:forKeyedSubscript:));
    });
}
/// 避免这种crash：[myDict setObject:nilObj forKey:@"your_key"];
- (void)na_setObject:(id)anObject forKey:(id<NSCopying>)aKey {
    if (!anObject||!aKey)
        return;
    [self na_setObject:anObject forKey:aKey];
}

-(void)safe_removeObjectForKey:(id)aKey{
    if (!aKey) {
        NSLog(@"The Key of removeObjectForKey can not be nil");
    }else{
        [self safe_removeObjectForKey:aKey];
    }
}
@end
