# Runtime


* [1.交换方法](#1.交换实例方法)
   + [1.交换实例方法](#1.交换实例方法)
	+ [2.交换类方法](#2.交换类方法)
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
<h3 id="2.BBB">3.CCC</h3>
<h3 id="3.CCC">3.CCC</h3>


