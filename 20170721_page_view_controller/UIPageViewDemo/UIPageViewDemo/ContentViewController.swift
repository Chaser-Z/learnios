//
//  ContentViewController.swift
//  UIPageViewDemo
//
//  Created by 张海南 on 2017/7/19.
//  Copyright © 2017年 Beijing Han-sky Education Technology Co. All rights reserved.
//

import UIKit

class ContentViewController: UIViewController {

    var text: String = "1"
    
    override func viewDidLoad() {
        super.viewDidLoad()

    
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        label.backgroundColor = UIColor.cyan
        label.text = self.text
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 100)
        self.view.addSubview(label)
    
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
