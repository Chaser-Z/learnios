# [Swift]多线程--GCD

## 1.队列

### 1.1 串行队列
创建串行队列的方式很简单:
```
DispatchQueue(label: <#T##String#>)
```

label : 队列的标识符

#### 例如：

```
let queue = DispatchQueue(label: "QueueIdentifier")
```

如果想指定串行队列的优先级, 可使用下面的方法来创建:
```
let queue = DispatchQueue(label: "QueueIdentifier", qos: .userInitiated)
```

参数qos: 用于指定队列的优先级, 是个枚举 -- 优先级, 由上往下依次降低

*  .userInteractive
*  .userInitiated
*  .default
*  .utility
*  .background
*  .unspecified

一个最常用的串行队列--主队列:

```
DispatchQueue.main
```
### 1.2 并行队列

并行队列, 可以使用下面这个方法进行创建:

```
DispatchQueue(label: <#T##String#>, qos: <#T##DispatchQoS#>, attributes: <#T##DispatchQueue.Attributes#>)
```
和创建串行队列的方法一样, 只不过多了一个参数attributes, 传 .concurrent 即可创建一个并行队列

```
let queue1 = DispatchQueue(label: "并行队列的创建", qos: .default, attributes: .concurrent)
```
在使用的时候, 我们一般不去创建并行队列, 而是使用系统为我们提供的全局的并行队列:

```
// 获取全局并行队列
let queue = DispatchQueue.global()
```

在获取的时候我们也可以指定其优先级:

```
let que = DispatchQueue.global(qos: .default)
```

####注意:
在创建串行并行队列的时候, 参数attributes, 可以指定创建的是串行还是并行队列, 他还有一个值: .initiallyInactive, 即: 创建的时候, 是处于不活跃状态, 即不会执行任务, 需要手动调用activate()来激活队列执行任务;

####例如

```
print("当前线程: \(Thread.current)")
        let queue = DispatchQueue(label: "开始不活跃的串行队列", attributes: .initiallyInactive)
        queue.async {
            print("执行了么?")
        }
        print("任务结束")

```

这个示例, 程序会crash, 应该这样:

```
print("当前线程: \(Thread.current)")
        let queue = DispatchQueue(label: "开始不活跃的串行队列", attributes: .initiallyInactive)
            queue.async {
            print("执行了么?")
        }
        queue.activate()
        print("任务结束")

```

上面这个是, 串行的不活跃队列, 如果想创建并行的不活跃队列呢? 可以这样:

```
print("当前线程: \(Thread.current)")
let queue = DispatchQueue(label: "开始不活跃的并行队列", attributes: [.concurrent, .initiallyInactive])
queue.async {
            print("执行了么?")
        }
        queue.activate()
        print("任务结束")

```

### 1.3 同步, 异步

同步/异步的执行, 只需要使用对了的实例对象调用sync(同步)/async(异步)方法即可, 这里可以使用闭包, 也可以使用DispatchWorkItem对象

```
queue.sync {
            <#code#>
        }
queue.async(execute: <#T##DispatchWorkItem#>)
```

##2.同步, 异步, 串行, 并发组合测试

#### 测试一: 用同步函数往串行队列中添加任务
不会开启新的线程:

```
print("当前线程: \(Thread.current)")

        let queue = DispatchQueue(label: "创建串行队列")

        queue.sync {
            print("串行队列中同步执行的第1个任务: \(Thread.current)")
            sleep(4)
        }

        queue.sync {
            print("串行队列中同步执行的第2个任务: \(Thread.current)")
            sleep(2)
        }

        queue.sync {
            print("串行队列中同步执行的第3个任务: \(Thread.current)")
        }

```

控制台输出:

```
当前线程: <NSThread: 0x600000065900>{number = 1, name = main}
串行队列中同步执行的第1个任务: <NSThread: 0x600000065900>{number = 1, name = main}
串行队列中同步执行的第2个任务: <NSThread: 0x600000065900>{number = 1, name = main}
串行队列中同步执行的第3个任务: <NSThread: 0x600000065900>{number = 1, name = main}
```
可以看出, 没有开启新的线程, 同时也是按照顺序依次执行的;

#### 测试二: 用异步函数往串行队列中添加任务

会开启线程，但是只开启一个线程:

```
print("当前线程: \(Thread.current)")


        let queue = DispatchQueue(label: "创建串行队列")

        queue.async {
            print("串行队列中同步执行的第1个任务: \(Thread.current)")
            sleep(4)
        }

        queue.async {
            print("串行队列中同步执行的第2个任务: \(Thread.current)")
            sleep(2)
        }

        queue.async {
            print("串行队列中同步执行的第3个任务: \(Thread.current)")
        }

```

控制台输出:

```
当前线程: <NSThread: 0x608000064000>{number = 1, name = main}
串行队列中同步执行的第1个任务: <NSThread: 0x608000071dc0>{number = 4, name = (null)}
串行队列中同步执行的第2个任务: <NSThread: 0x608000071dc0>{number = 4, name = (null)}
串行队列中同步执行的第3个任务: <NSThread: 0x608000071dc0>{number = 4, name = (null)}
```
虽然是异步函数, 但是添加到了串行队列里, 只开启了一个新的线程, 添加到其中的任务还是按顺序依次执行的

#### 测试三: 用同步函数往并发队列中添加任务
不会开启新的线程((同步函数不具备开启新线程的能力))，并发队列失去了并发的功能:

```
print("当前线程: \(Thread.current)")


        let queue = DispatchQueue(label: "创建并行队列", attributes: .concurrent)

        queue.sync {
            print("串行队列中同步执行的第1个任务: \(Thread.current)")
            sleep(4)
        }

        queue.sync {
            print("串行队列中同步执行的第2个任务: \(Thread.current)")
            sleep(2)
        }

        queue.sync {
            print("串行队列中同步执行的第3个任务: \(Thread.current)")
        }

```

控制台输出:

```
当前线程: <NSThread: 0x600000077b80>{number = 1, name = main}
串行队列中同步执行的第1个任务: <NSThread: 0x600000077b80>{number = 1, name = main}
串行队列中同步执行的第2个任务: <NSThread: 0x600000077b80>{number = 1, name = main}
串行队列中同步执行的第3个任务: <NSThread: 0x600000077b80>{number = 1, name = main}

```
可以看出, 虽然使用的是并发队列, 但是使用的是同步函数, 由于同步函数没有开启新线程的能力, 所以并发队列就失去了并发性, 按照任务的添加顺序, 顺序执行;

#### 测试四. 用异步函数往并发队列中添加任务

同时开启多个子线程执行任务:

```
print("当前线程: \(Thread.current)")


        let queue = DispatchQueue(label: "创建并行队列", attributes: .concurrent)

        queue.async {
            print("串行队列中同步执行的第1个任务: \(Thread.current)")
            sleep(4)
        }

        queue.async {
            print("串行队列中同步执行的第2个任务: \(Thread.current)")
            sleep(2)
        }

        queue.async {
            print("串行队列中同步执行的第3个任务: \(Thread.current)")
        }

```
控制台输出:

```
当前线程: <NSThread: 0x60000007c6c0>{number = 1, name = main}
串行队列中同步执行的第2个任务: <NSThread: 0x600000270380>{number = 4, name = (null)}
串行队列中同步执行的第3个任务: <NSThread: 0x60800027dec0>{number = 5, name = (null)}
串行队列中同步执行的第1个任务: <NSThread: 0x60000026b600>{number = 3, name = (null)}

```
可以看出, 这里开启了三个子线程来执行任务, 互相之间没有影响.
只有在并发队列异步执行的时候才能真正起到 并发的作用.

#### 测试五. 控制最大并发数

在进行并发操作的时候, 如果任务过多, 开启很多线程, 会导致APP卡死. 所以, 我们要控制最大并发数, 这就用到了信号量DispatchSemaphore, 我们可以这样创建一个信号量:

```
let semaphore = DispatchSemaphore.init(value: 10)
```

参数为最大并发执行的任务数, 也即是信号量.
信号量减一:

```
semaphore.wait()
// 如果信号量大于1, 则会继续执行, 如果信号量等于0, 会等待timeout的时间, 在等待期间被semaphore.signal()加一了, 这里会继续执行, 并将信号量减一
semaphore.wait(timeout: <#T##DispatchTime#>)

```
上面函数的返回值为DispatchTimeoutResult, 是个枚举:

* success
* timedOut

DispatchTime的值可使用: .now() , 或者 .distantFuture
也可以创建:

```
DispatchTime.init(uptimeNanoseconds: <#T##UInt64#>)
```
这里的参数单位为纳秒: 1s = 10001000100ns

信号量加一:

```
semaphore.signal()
```

一个应用:

```
print("当前线程: \(Thread.current)")

        let group = DispatchGroup.init()
        let queue = DispatchQueue.global()

        let semaphore = DispatchSemaphore.init(value: 10)

        for i in 0...100 {

            let result = semaphore.wait(timeout: .distantFuture)
            if result == .success {

                queue.async(group: group, execute: {

                    print("队列执行\(i)--\(Thread.current)")
                    // 模拟执行任务时间
                    sleep(2)
                    // 任务结束, 信号量+1
                    semaphore.signal()
                })
            }

        }

        group.wait()

```

这个示例就是每十个任务并发执行.

#### 测试六: 使用DispatchWorkItem
使用DispatchWorkItem代替原来的 dispatch_block_t

DispatchWorkItem是一个代码块，它可以被分到任何的队列，包含的代码可以在后台或主线程中被执行，简单来说:它被用于替换我们前面写的代码block来调用

```
print("当前线程: \(Thread.current)")

        // 新建一个任务
        let workItem = DispatchWorkItem { 

            print("执行一个任务\(Thread.current)")
            sleep(3)
        }
        // 在当前线程执行任务
        workItem.perform()

        // 执行完成后, 通知主队列
        workItem.notify(queue: DispatchQueue.main) { 

            print("任务完成了")
        }

```

输出:

```
当前线程: <NSThread: 0x6000000774c0>{number = 1, name = main}
执行一个任务<NSThread: 0x6000000774c0>{number = 1, name = main}
任务完成了
```

在另一个队列执行任务(异步):

```
print("当前线程: \(Thread.current)")

        // 新建一个任务
        let workItem = DispatchWorkItem { 

            print("执行一个任务\(Thread.current)")
            sleep(3)
        }

        let queue = DispatchQueue.global()
        // 执行任务
        queue.async(execute: workItem)
        // 执行完成后, 通知主队列
        workItem.notify(queue: DispatchQueue.main) { 

            print("任务完成了")
        }

        print("任务结束")

```

输出:

```
当前线程: <NSThread: 0x608000261700>{number = 1, name = main}
任务结束
执行一个任务<NSThread: 0x6080004661c0>{number = 4, name = (null)}
任务完成了
```

在创建任务的时候, 可使用下面的参数来设置其优先级:

```
let workItem = DispatchWorkItem(qos: <#T##DispatchQoS#>, block: <#T##() -> Void#>)
```


## 3.一些应用

### 3.1 延迟执行

```
print("当前线程: \(Thread.current)")
        print("开始时间\(Date())")
        let delayQueue = DispatchQueue(label: "delayQueue")
        // 延迟 2s
        let delayTime = DispatchTimeInterval.seconds(2)

        delayQueue.asyncAfter(deadline: .now() + delayTime) {
            print("这是延迟2s后执行的任务, 结束时间\(Date())")

        }

```

输出:

```
当前线程: <NSThread: 0x600000073ec0>{number = 1, name = main}
开始时间2017-08-09 03:33:19 +0000
这是延迟2s后执行的任务, 结束时间2017-08-09 03:33:21 +0000
```

这里的时间有以下几种方式设置:

```
let delayTime = DispatchTimeInterval.seconds(2)// 秒
let delayTime = DispatchTimeInterval.milliseconds(2*1000)// 毫秒
let delayTime = DispatchTimeInterval.microseconds(2*1000*1000)// 微秒
let delayTime = DispatchTimeInterval.nanoseconds(2*1000*1000*1000)// 纳秒

```

这里都是设置的延迟2s
也可以如下, 直接加上要延迟的时间间隔:

```
print("当前线程: \(Thread.current)")
        print("开始时间\(Date())")
        let delayQueue = DispatchQueue(label: "delayQueue")
        // 延迟 2s
        delayQueue.asyncAfter(deadline: .now() + 2) {
            print("这是延迟2s后执行的任务, 结束时间\(Date())")
        }
        print("任务结束")

```


### 3.2 汇总执行

如果, 你想某个任务在其他任务执行之后再执行, 或者必须某个任务执行完,才能执行下面的任务, 可以使用DispatchGroup:

```
print("当前线程: \(Thread.current)")
        let queue = DispatchQueue(label: "queueName", attributes: .concurrent)

        queue.async {
            sleep(4)
            print("任务 1")
        }

        queue.async {
            sleep(2)
            print("任务 2")
        }

        queue.async {
            sleep(6)
            print("任务 3")
        }

        DispatchGroup.init().notify(qos: .default, flags: .barrier, queue: queue) { 

            print("所有任务结束")
        }
        print("任务结束")

```
输出:

```
当前线程: <NSThread: 0x608000078b00>{number = 1, name = main}
任务结束
任务 2
任务 1
任务 3
所有任务结束
```

还有另一种方式

```
print("当前线程: \(Thread.current)")
        let queue = DispatchQueue(label: "queueName", attributes: .concurrent)
        let group = DispatchGroup()
        
        queue.async(group: group) {
            sleep(4)
            print("任务 1")
        }
        
        queue.async(group: group) {
            sleep(2)
            print("任务 2")
        }
        
        queue.async(group: group) {
            sleep(6)
            print("任务 3")
        }
        
        group.wait()
        print("任务结束")
```
输入

```
当前线程: <NSThread: 0x60800006b6c0>{number = 1, name = main}
任务 2
任务 1
任务 3
任务结束
```
