//
//  StackViewController.swift
//  Demo
//
//  Created by 张莹莹 on 2017/7/25.
//  Copyright © 2017年 yingying. All rights reserved.
//

import UIKit

class StackViewController: UIViewController {

    @IBOutlet weak var bottomStackView: UIStackView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    @IBAction func add(_ sender: UIButton) {
        
        let img = UIImageView(image: UIImage(named: "2.jpg"))
//        img.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: 100, height: 100))
        img.contentMode = .scaleAspectFill
        bottomStackView.addArrangedSubview(img)
        UIView.animate(withDuration: 0.25, animations: {
            self.bottomStackView.layoutIfNeeded()
        })
        
    }
    
    @IBAction func decerase(_ sender: Any) {
        
        let lastView: UIView? = bottomStackView.arrangedSubviews.last
        if let lastView = lastView {
            
            bottomStackView.removeArrangedSubview(lastView)
            lastView.removeFromSuperview()
            UIView.animate(withDuration: 0.25, animations: {
                self.bottomStackView.layoutIfNeeded()
            })

        }
        
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
