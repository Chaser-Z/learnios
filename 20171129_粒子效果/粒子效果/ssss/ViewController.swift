//
//  ViewController.swift
//  ssss
//
//  Created by 张莹莹 on 2017/5/18.
//  Copyright © 2017年 张莹莹. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        animation()
        
    }
    
    //烟花动画
    func animation() {
        let fireworksEmitter = CAEmitterLayer() //粒子发射系统的初始化
        fireworksEmitter.emitterPosition = CGPoint(x: view.frame.width / 2, y: view.frame.height / 2) // 发射源的位置
        fireworksEmitter.emitterSize = CGSize(width: 100, height: 100) //发射源的大小
        fireworksEmitter.emitterMode = kCAEmitterLayerOutline //发射模式
        fireworksEmitter.emitterShape = kCAEmitterLayerLine //发射源的形状
        fireworksEmitter.renderMode = kCAEmitterLayerAdditive // 发射源的渲染模式
        fireworksEmitter.seed = (arc4random() % 100) + 1 // 发射源初始化随机数产生的种子
        // 发射点
        let rocket = CAEmitterCell()
        rocket.birthRate = 1.0 // 每秒某个点产生的effectCell数量
        rocket.emissionRange = CGFloat(0.25 * Double.pi) //周围发射角度
        rocket.velocity = 380 //速度
        rocket.yAcceleration = 75 //粒子y方向的加速度分量
        rocket.lifetime = 1.02
        rocket.contents = UIImage(named: "DazRing")?.cgImage
        rocket.scale = 0.2
        rocket.color = UIColor.red.cgColor
        rocket.greenRange = 1.0
        rocket.redRange = 1.0
        rocket.blueRange = 1.0
        rocket.spinRange = CGFloat(Double.pi) //子旋转角度范围
        //爆炸
        let burst = CAEmitterCell()
        burst.birthRate = 1.0
        burst.velocity = 0
        burst.scale = 2.5
        burst.redRange = -1.5
        burst.blueRange = 1.5
        burst.greenRange = 1.0
        burst.lifetime = 0.35
        //扩散
        let spark = CAEmitterCell()
        spark.birthRate = 400
        spark.velocity = 125
        spark.emissionRange = CGFloat(Double.pi)
        spark.yAcceleration = 75
        spark.lifetime = 3
        spark.contents = UIImage(named: "DazStarOutline")?.cgImage
        spark.scale = -0.2
        spark.greenRange = -0.1
        spark.redRange = 0.4
        spark.blueRange = -0.1
        spark.alphaSpeed = -0.25 // 例子透明度的改变速度
        spark.spin = CGFloat(Double.pi) * 2 // 子旋转角度
        spark.spinRange = CGFloat(Double.pi) * 2
        
        fireworksEmitter.emitterCells = [rocket]
        rocket.emitterCells = [burst]
        burst.emitterCells = [spark]
        self.view.layer.addSublayer(fireworksEmitter)
    }
    
    /* 可能用到的属性
    * birthRate 这个必须要设置，具体含义是每秒某个点产生的effectCell数量
    * alphaRange:  一个粒子的颜色alpha能改变的范围；
    * alphaSpeed:粒子透明度在生命周期内的改变速度；
    * blueRange：一个粒子的颜色blue 能改变的范围；
    * blueSpeed: 粒子blue在生命周期内的改变速度；
    * color:粒子的颜色
    * contents：是个CGImageRef的对象,既粒子要展现的图片；
    * contentsRect：应该画在contents里的子rectangle：
    * emissionLatitude：发射的z轴方向的角度
    * emissionLongitude:x-y平面的发射方向
    * emissionRange；周围发射角度
    * emitterCells：粒子发射的粒子
    * enabled：粒子是否被渲染
    * greenrange: 一个粒子的颜色green 能改变的范围；
    * greenSpeed: 粒子green在生命周期内的改变速度；
    * lifetime：生命周期
    * lifetimeRange：生命周期范围
    * magnificationFilter：不是很清楚好像增加自己的大小
    * minificatonFilter：减小自己的大小
    * minificationFilterBias：减小大小的因子
    * name：粒子的名字
    * redRange：一个粒子的颜色red 能改变的范围；
    * redSpeed; 粒子red在生命周期内的改变速度；
    * scale：缩放比例：
    * scaleRange：缩放比例范围；
    * scaleSpeed：缩放比例速度：
    * spin：子旋转角度
    * spinrange：子旋转角度范围
    * style：不是很清楚：
    * velocity：速度
    * velocityRange：速度范围
    * xAcceleration:粒子x方向的加速度分量
    * yAcceleration:粒子y方向的加速度分量
    * zAcceleration:粒子z方向的加速度分量
 */
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

