# Runtime


* [多线程](#1_1)
   + [1.交换实例方法](#1.交换实例方法)
	+ [2.交换类方法](#2.交换类方法)
* [2.BBB](#2.BBB)
* [3.CCC](#3.CCC)


---------------------------------------------------------------------


<h3 id="1_1">多线程</h3>

```objc
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{

        });
    });
    
    
```
<h3 id="2.交换类方法">1.2 交换类方法</h3>



```objc


//usage:
void dispatch_queue_async_safe2(dispatch_queue_t queue, dispatch_block_t block) {
    if (strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), dispatch_queue_get_label(queue)) == 0) {
        block();
    } else {
        dispatch_async(queue, block);
    }
}

```
<h3 id="2.BBB">3.CCC</h3>
<h3 id="3.CCC">3.CCC</h3>


