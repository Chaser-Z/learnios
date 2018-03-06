//
//  ViewController.swift
//  GCDDemo
//
//  Created by 张海南 on 2017/8/7.
//  Copyright © 2017年 Beijing Han-sky Education Technology Co. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1.2
        //oneExample()
        //twoExample()
        //threeExample()
        
        // 队列的循环、挂起、恢复
        // dispatch_apply
        // dispatch_apply函数是用来循环来执行队列中的任务的。在Swift 3.0里面对这个做了一些优化，使用以下方法：
        // public class func concurrentPerform(iterations: Int, execute work: (Int) -> Swift.Void)
        // 本来循环执行就是为了节约时间的嘛，所以默认就是用了并行队列。我们尝试一下用这个升级版的dispatch_apply让它执行10次打印任务。
        //fourExample()
        
        // 队列的挂起与唤醒
        //sixExample()
        
        
        // 2 同步, 异步, 串行, 并发组合测试
        // 测试一: 用同步函数往串行队列中添加任务
        // 不会开启新的线程:
        //testOne()
        
        
        // 测试二: 用异步函数往串行队列中添加任务
        // 会开启线程，但是只开启一个线程:
        //testTwo()
        
        // 测试三: 用同步函数往并发队列中添加任务
        // 不会开启新的线程((同步函数不具备开启新线程的能力))，并发队列失去了并发的功能:
        //testThree()
        
        // 测试四. 用异步函数往并发队列中添加任务
        // 同时开启多个子线程执行任务:
        //testFour()
        
        // 测试五. 控制最大并发数
        // 在进行并发操作的时候, 如果任务过多, 开启很多线程, 会导致APP卡死. 所以, 我们要控制最大并发数, 这就用到了信号量DispatchSemaphore, 我们可以这样创建一个信号量:
        // 这个示例就是每十个任务并发执行.
        //testFive()
        
        // 测试六: 使用DispatchWorkItem
        //testSix()
        // 在另一个队列执行任务(异步):
        //testSeven()
        
        // 3 一些应用
        // 3.1 延迟执行
        //testEight()
        
        // 3.2 汇总执行
        // 如果, 你想某个任务在其他任务执行之后再执行, 或者必须某个任务执行完,才能执行下面的任务, 可以使用DispatchGroup:
        //testNine()'
    }
    
    @IBAction func oneExample(_ sender: Any) {
        print("当前线程: \(Thread.current)")
        let queue = DispatchQueue(label: "开始不活跃的串行队列", attributes: .initiallyInactive)
        queue.async {
            print("执行了么?")
        }
        print("任务结束")
    }
    
    @IBAction func twoExample(_ sender: Any) {
        print("当前线程: \(Thread.current)")
        let queue = DispatchQueue(label: "开始不活跃的串行队列", attributes: .initiallyInactive)
        queue.async {
            print("执行了么?")
        }
        queue.activate()
        print("任务结束")
    }
    
    @IBAction func threeExample(_ sender: Any) {
        print("当前线程: \(Thread.current)")
        let queue = DispatchQueue(label: "开始不活跃的并行队列", attributes: [.concurrent, .initiallyInactive])
        queue.async {
            print("执行了么?")
        }
        queue.activate()
        print("任务结束")
    }
    
    @IBAction func fourExample(_ sender: Any) {
        print("Begin to start a DispatchApply")
        let queue = DispatchQueue.global()
        
        queue.async {
            
            DispatchQueue.concurrentPerform(iterations: 10) { (index) in
                
                print("Iteration times:\(index),Thread = \(Thread.current)")
            }
            
            print("Iteration have completed.")

        }
    }
    
    @IBAction func fiveExample(_ sender: Any) {
        let queue = DispatchQueue(label: "new thread")
        //        挂起
        queue.suspend()
        
        queue.async {
            print("The queue is suspended. Now it has completed.\n The queue is \"\(queue.label)\". ")
        }
        
        print("The thread will sleep for 3 seconds' time")
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.seconds(3)) {
            //            唤醒，开始执行
            queue.resume()
        }
    }
    
    @IBAction func sixExample(_ sender: Any) {
        var value = 10
        
        let workItem = DispatchWorkItem {
            value += 5
        }
        
        // 执行
        //workItem.perform()
        
        let queue = DispatchQueue.global(qos: .utility)
        
        queue.async(execute: workItem)
        
        workItem.notify(queue: queue) {
            print("value = ", value)
        }
    }
    
    @IBAction func testOne(_ sender: Any) {
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
    }
    
    @IBAction func testTwo(_ sender: Any) {
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
    }
    
    @IBAction func testThree(_ sender: Any) {
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
    }
    
    @IBAction func testFour(_ sender: Any) {
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
    }
    
    @IBAction func testFive(_ sender: Any) {
        print("当前线程: \(Thread.current)")
        
        let group = DispatchGroup()
        let queue = DispatchQueue.global()
        
        let semaphore = DispatchSemaphore(value: 10)
        
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
        print("结束了")
    }
    
    @IBAction func testSix(_ sender: Any) {
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
        print("任务结束")
    }
    
    @IBAction func testSeven(_ sender: Any) {
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
    }
    
    @IBAction func testEight(_ sender: Any) {
        print("当前线程: \(Thread.current)")
        print("开始时间\(Date())")
        let delayQueue = DispatchQueue(label: "delayQueue")
        // 延迟 2s
        let delayTime = DispatchTimeInterval.seconds(2)
        
        delayQueue.asyncAfter(deadline: .now() + delayTime) {
            print("这是延迟2s后执行的任务, 结束时间\(Date())")
        }
    }
    
    @IBAction func testNine(_ sender: Any) {
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
        
        DispatchGroup().notify(qos: .default, flags: .barrier, queue: queue) {
            print("所有任务结束")
        }
        print("任务结束")
    }
    
    @IBAction func testTen(_ sender: Any) {
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
    }


    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

