//
//  ViewController.swift
//  UIPageViewDemo
//
//  Created by 张海南 on 2017/7/19.
//  Copyright © 2017年 Beijing Han-sky Education Technology Co. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    private(set) var pageViewController: UIPageViewController?
    var index = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()

        let initalViewController = self.viewControllerAtIndex(index: index)
        
        createPageViewController(initalViewController)
    }
    
    
    func createPageViewController(_ displayController:UIViewController?) {
        
        let options = [UIPageViewControllerOptionSpineLocationKey:NSNumber(value: UIPageViewControllerSpineLocation.min.rawValue as Int)]
        pageViewController = UIPageViewController(transitionStyle:UIPageViewControllerTransitionStyle.scroll,navigationOrientation:UIPageViewControllerNavigationOrientation.horizontal,options: options)
        pageViewController?.delegate = self
        pageViewController?.dataSource = self
        view.insertSubview(pageViewController!.view, at: 0)
        addChildViewController(pageViewController!)
        pageViewController?.isDoubleSided = true
        pageViewController!.setViewControllers((displayController != nil ? [displayController!] : nil), direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
    }
    
    //自定义方法，创建显示视图
    func viewControllerAtIndex(index:Int) -> ContentViewController? {
        let dataViewController = ContentViewController()
        dataViewController.text = "\(index)"
        print("\(index)")
        return dataViewController
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        //print("didFinishAnimating")
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        //print("willTransitionTo")

    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if index == 0 {
//            pageViewController.
        } else {
            
            index -= 1
        }
        print("viewControllerBefore")
        return viewControllerAtIndex(index: index)
        
    }
    
    // 获取下一页
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        print("viewControllerAfter")
        index += 1
        return viewControllerAtIndex(index: index)
    }
    
}
