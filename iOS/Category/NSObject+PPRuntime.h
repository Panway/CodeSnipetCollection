//
//  NSObject+PPRuntime.h
//  nullable
//
//  Created by wangchao on 2018/3/6.
//  Copyright © 2018年 vincent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface NSObject (PPRuntime)
/**
 * @abstract swizzling methods.
 *
 */
void WXSwizzleInstanceMethod(_Nonnull Class className, _Nonnull SEL original, _Nonnull SEL replaced);



@end
