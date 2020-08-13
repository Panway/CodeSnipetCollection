//
//  UINavigationController+SXFullScreen.m
//  UINavigationItem-SXFixSpace
//
//  Created by charles on 2017/9/8.
//  Copyright © 2017年 None. All rights reserved.
//

#import "UINavigationController+SXFullScreen.h"
#import "NSObject+SXRuntime.h"

@implementation UIViewController (SXFullScreen)

-(BOOL)xd_disableInteractivePop{
    return [objc_getAssociatedObject(self, @selector(xd_disableInteractivePop)) boolValue];
}

-(void)setXd_disableInteractivePop:(BOOL)xd_disableInteractivePop{
    objc_setAssociatedObject(self, @selector(xd_disableInteractivePop), @(xd_disableInteractivePop), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

@interface UINavigationController()<UIGestureRecognizerDelegate>

@end

@implementation UINavigationController (SXFullScreen)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleInstanceMethodWithOriginSel:@selector(viewDidLoad)
                                     swizzledSel:@selector(sx_viewDidLoad)];
    });
}

-(void)sx_viewDidLoad {
    //接替系统滑动返回手势
    NSArray *internalTargets = [self.interactivePopGestureRecognizer valueForKey:@"targets"];
    id internalTarget = [internalTargets.firstObject valueForKey:@"target"];
    SEL handler = NSSelectorFromString(@"handleNavigationTransition:");
    
    UIPanGestureRecognizer * fullScreenGesture = [[UIPanGestureRecognizer alloc]initWithTarget:internalTarget action:handler];
    fullScreenGesture.delegate = self;
    fullScreenGesture.maximumNumberOfTouches = 1;
    
    UIView *targetView = self.interactivePopGestureRecognizer.view;
    [targetView addGestureRecognizer:fullScreenGesture];
    
    [self.interactivePopGestureRecognizer setEnabled:NO];
    
    [self sx_viewDidLoad];
}

/**
 全屏滑动返回判断
 
 @param gestureRecognizer 手势
 @return 是否响应
 */
- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
    if (self.topViewController.xd_disableInteractivePop) {
        return NO;
    }
    // iOS13碰到如下错误，所以判断是不是UIPanGestureRecognizer：
    // -[_UIBarTapGestureRecognizer translationInView:]: unrecognized selector sent to instance 0x10fd9d630
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && [gestureRecognizer translationInView:gestureRecognizer.view].x <= 0) {
        return NO;
    }
    
    if ([[self valueForKey:@"_isTransitioning"] boolValue]) {
        return NO;
    }
    
    return (self.childViewControllers.count != 1);
}

//修复有水平方向滚动的ScrollView时边缘返回手势失效的问题
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return (otherGestureRecognizer.state == UIGestureRecognizerStateBegan && [otherGestureRecognizer.view isKindOfClass:NSClassFromString(@"UILayoutContainerView")]);
}
//触发之后是否响应手势事件
//处理侧滑返回与UISlider的拖动手势冲突
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    //如果手势是触摸的UISlider滑块触发的，侧滑返回手势就不响应
    if ([touch.view isKindOfClass:[UISlider class]]) {
        return NO;
    }
    return YES;
}
@end
