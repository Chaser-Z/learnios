//
//  ViewController.swift
//  qqq
//
//  Created by 张莹莹 on 2017/8/9.
//  Copyright © 2017年 yingying. All rights reserved.
//

import UIKit
import MyFramework

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Swift
        let str = String()
        let string = str.saySomething()
        print(string)
        
        
        // OC
        let sayHi = SayHi()
        print(sayHi.sayHi())
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

