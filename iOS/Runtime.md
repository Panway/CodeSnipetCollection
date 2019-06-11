# Runtime


* [1.交换方法](#1.交换实例方法)
   + [1.交换实例方法](#1.交换实例方法)
	+ [2.交换类方法](#2.交换类方法)
	+ [3.NSTimer循环引用解决](#2.NSTimer循环)
* [2.BBB](#2.BBB)
* [3.CCC](#3.CCC)


---------------------------------------------------------------------


<h3 id="1.交换实例方法">1.1交换实例方法</h3>

```objc
#import <objc/runtime.h>

static inline void pw_swizzleSelector(Class theClass, SEL originalSelector, SEL swizzledSelector) {
    Method originalMethod = class_getInstanceMethod(theClass, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(theClass, swizzledSelector);
    method_exchangeImplementations(originalMethod, swizzledMethod);
}

//usage:
- (NSString *)xd_substringFromIndex:(NSUInteger)from {
    if (from> self.length) {
        return @"";
    }
    return [self substringWithRange:NSMakeRange(from, self.length - from)];
}
+ (void)load {
    pw_swizzleSelector([NSString class],
                       @selector(substringFromIndex:),
                       @selector(xd_substringFromIndex:));
}

```
<h3 id="2.交换类方法">1.2 交换类方法</h3>



```objc
#import <objc/runtime.h>

void pw_swizzleClassMethod(Class c, SEL orig, SEL new) {
    Method origMethod = class_getClassMethod(c, orig);
    Method newMethod = class_getClassMethod(c, new);
    c = object_getClass((id)c);
    if(class_addMethod(c, orig, method_getImplementation(newMethod), method_getTypeEncoding(newMethod)))
        class_replaceMethod(c, new, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    else
        method_exchangeImplementations(origMethod, newMethod);
}

//usage:
+ (UIImage *)xd_imageNamed:(NSString *)name {
    return [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:name ofType:nil]];
}
+ (void)load {
    pw_swizzleClassMethod([UIImage class], @selector(imageNamed:), @selector(xd_imageNamed:));
}
```
<h3 id="#2.NSTimer循环">1.3 NSTimer循环引用解决</h3>

> NSTimer创建后 被 Runloop 强引用了，如果要释放就要调用 invalidate 方法。
 但是我想在 XXViewController 的 dealloc 里调用 invalidate 方法，但是 self 被 NSTimer 强引用了。所以我还是要释放 NSTimer 先，然而不调用invalidate 方法就不能释放它。然而你不进入到 dealloc 方法里我又不能调用 invalidate 方法。所以这个矛盾的问题会导致：即使你在dealloc方法里invalidate NSTimer，它绑定的方法还会一直走
 
解决办法: 用一个闭包来代替target action方法 防止创建timer循环引用

```
GBWeakTimer.h 具体内容可以参考.h文件方法描述
```

<h3 id="2.BBB">3.CCC</h3>
<h3 id="3.CCC">3.CCC</h3>


[NSHipster - Method Swizzling](http://nshipster.cn/method-swizzling/)

[使用method-swizzling让程序更健壮](https://www.jianshu.com/p/c89b2716d60d)

[Method Swizzling(一)](https://www.jianshu.com/p/14018a8ee221)