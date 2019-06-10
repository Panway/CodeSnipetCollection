//
//  NSNull+Safe.m
//  nullable
//
//  Created by vincent on 16/3/7.
//  Copyright © 2016年 vincent. All rights reserved.
//

#import "NSNull+Safe.h"

@implementation NSNull (Safe)

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
    NSMethodSignature *signature = [super methodSignatureForSelector:sel];
    if (!signature) {
        signature = [NSMethodSignature signatureWithObjCTypes:@encode(void)];
    }
    return signature;
}

/*
 避免这种crash:
 NSString *nilObj = (NSString *)[NSNull null];
 
 NSLog(@"null:%d", [nilObj length]);
 */
- (void)forwardInvocation:(NSInvocation *)invocation {
}

@end
