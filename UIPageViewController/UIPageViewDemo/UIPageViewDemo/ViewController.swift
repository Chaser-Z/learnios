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
    fileprivate var TempNumber:NSInteger = 1
    fileprivate var currentPageVC: ContentViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let initalViewController = self.viewControllerAtIndex(index: index)
        
        createPageViewController(initalViewController)
    }
    
    
    func createPageViewController(_ displayController:UIViewController?) {
        
        let options = [UIPageViewControllerOptionSpineLocationKey:NSNumber(value: UIPageViewControllerSpineLocation.min.rawValue as Int)]
        pageViewController = UIPageViewController(transitionStyle:UIPageViewControllerTransitionStyle.pageCurl,navigationOrientation:UIPageViewControllerNavigationOrientation.horizontal,options: options)
        pageViewController?.delegate = self
        pageViewController?.dataSource = self
        view.insertSubview(pageViewController!.view, at: 0)
        addChildViewController(pageViewController!)
        //pageViewController?.isDoubleSided = true
        currentPageVC = viewControllerAtIndex(index: 0)
        pageViewController!.setViewControllers((displayController != nil ? [displayController!] : nil), direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
    }
    
    //自定义方法，创建显示视图
    func viewControllerAtIndex(index:Int) -> ContentViewController? {
        let dataViewController = ContentViewController()
        dataViewController.text = index
        self.index = index
        print("\(index)")
        return dataViewController
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    fileprivate func updateProgressUI(_ VC: UIViewController) {
        let lookBookVC = VC as! ContentViewController;
        currentPageVC = nil;
        currentPageVC = lookBookVC;
        currentPageVC.text = index
    }
    
}

extension ViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
//        if completed {
//        } else {
//            self.updateProgressUI(previousViewControllers[0])
//        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
         //self.updateProgressUI(pendingViewControllers[0])
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        print("viewControllerBefore")
        TempNumber -= 1
        
//        if abs(TempNumber) % 2 == 0 { // 背面
//            return UIViewController()
//        } else { // 内容
            let beforeLookVC: ContentViewController = viewController as! ContentViewController;
            let beforeindex = beforeLookVC.text - 1
            return viewControllerAtIndex(index: beforeindex)
       // }
        
    }
    
    // 获取下一页
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        print("viewControllerAfter")

        TempNumber += 1
        
//        if abs(TempNumber) % 2 == 0 { // 背面
//            return UIViewController()
//        }else{ // 内容
            let afterLookVC: ContentViewController = viewController as! ContentViewController;
            let afterindex = afterLookVC.text + 1
            return viewControllerAtIndex(index: afterindex)
        //}

    }
    
}
