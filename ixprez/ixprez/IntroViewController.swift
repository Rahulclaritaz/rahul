//
//  IntroViewController.swift
//  ixprez
//
//  Created by Quad on 4/28/17.
//  Copyright © 2017 Claritaz Techlabs. All rights reserved.
//

import UIKit

class IntroViewController: UIViewController {

    @IBOutlet var pageControl: UIPageControl!
    
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
     // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
 
    
    
/*
 
 class ViewController: UIViewController, UIPageViewControllerDataSource {
 
 // MARK: - Variables
 private var pageViewController: UIPageViewController?
 
 // MARK: - View Lifecycle
 override func viewDidLoad() {
 super.viewDidLoad()
 populateControllersArray()
 createPageViewController()
 setupPageControl()
 }
 
 vrollers = [PageItemController]()
 
 
 func populateControllersArray() {
 for i in 0...3 {
 let controller = storyboard!.instantiateViewControllerWithIdentifier("ViewController\(i)") as PageItemController
 controller.itemIndex = i
 controllers.append(controller)
 }
 }
 
 private func createPageViewController() {
 
 let pageController = self.storyboard!.instantiateViewControllerWithIdentifier("PageController") as UIPageViewController
 pageController.dataSource = self
 
 if !controllers.isEmpty {
 pageController.setViewControllers([controllers[0]], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
 }
 
 pageViewController = pageController
 addChildViewController(pageViewController!)
 self.view.addSubview(pageViewController!.view)
 pageViewController!.didMoveToParentViewController(self)
 }
 
 private func setupPageControl() {
 let appearance = UIPageControl.appearance()
 appearance.pageIndicatorTintColor = UIColor.grayColor()
 appearance.currentPageIndicatorTintColor = UIColor.whiteColor()
 appearance.backgroundColor = UIColor.darkGrayColor()
 }
 
 // MARK: - UIPageViewControllerDataSource
 func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
 if let controller = viewController as? PageItemController {
 if controller.itemIndex > 0 {
 return controllers[controller.itemIndex - 1]
 }
 }
 return nil
 }
 func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
 if let controller = viewController as? PageItemController {
 if controller.itemIndex < controllers.count - 1 {
 return controllers[controller.itemIndex + 1]
 }
 }
 return nil
 }
 
 // MARK: - Page Indicator
 
 func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
 return controllers.count
 }
 
 func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
 return 0
 }*/
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
