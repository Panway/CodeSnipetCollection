//
//  GBWeakTimer.h
//  Taoguba App Client
//
//  Created by Panwei on 2017/8/4.
//  Copyright © 2017年 taoguba. All rights reserved.
//  参考自 https://blog.callmewhy.com/2015/07/06/weak-timer-in-ios/
/*
 为什么要创建这个类？
 
 NSTimer创建后 被 Runloop 强引用了，如果要释放就要调用 invalidate 方法。
 但是我想在 XXViewController 的 dealloc 里调用 invalidate 方法，但是 self 被 NSTimer 强引用了。
 所以我还是要释放 NSTimer 先，然而不调用 invalidate 方法就不能释放它。
 然而你不进入到 dealloc 方法里我又不能调用 invalidate 方法。
 所以这个矛盾的问题会导致：即使你在dealloc方法里invalidate NSTimer，它绑定的方法还会一直走
 于是有了这个解决方案
 */
#import <Foundation/Foundation.h>

typedef void (^GBTimerHandler)(id userInfo);

@interface GBWeakTimer : NSObject

+ (NSTimer *) scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                      target:(id)aTarget
                                    selector:(SEL)aSelector
                                    userInfo:(id)userInfo
                                     repeats:(BOOL)repeats;

+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                      block:(GBTimerHandler)block
                                   userInfo:(id)userInfo
                                    repeats:(BOOL)repeats;

@end


// 或者这种解决方案
@interface NSTimer (EZ_Helper)

+ (NSTimer *)ez_scheduledTimerWithTimeInterval:(NSTimeInterval)inTimeInterval block:(void (^)())inBlock repeats:(BOOL)inRepeats;

+ (NSTimer *)ez_timerWithTimeInterval:(NSTimeInterval)inTimeInterval block:(void (^)())inBlock repeats:(BOOL)inRepeats;

@end
