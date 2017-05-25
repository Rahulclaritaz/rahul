    //
    //  WelcomePageViewController.swift
    //  ixprez
    //
    //  Created by Quad on 4/28/17.
    //  Copyright © 2017 Claritaz Techlabs. All rights reserved.
    //

    import UIKit

    class WelcomePageViewController: UIPageViewController,UIPageViewControllerDataSource,UIPageViewControllerDelegate {

        lazy var VCArray : [UIViewController]
       = {
            return [self.VCInstance(name: "FirstVC"),
                    self.VCInstance(name: "SecondVC"),
                    self.VCInstance(name: "ThirdVC"),
                  ]
        
        }()

        var index : Int!
        var currentview  : Int! = 0
        var perviouIndex : Int!
        var nextIndex : Int!
        
        var timer = Timer()
        

        private func VCInstance(name : String) -> UIViewController
        {
            return  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: name)

        }
        

        override func viewDidLoad() {
            super.viewDidLoad()
            self.delegate = self
            self.dataSource = self
            
            if let firstVC = VCArray.first
            {
                setViewControllers([firstVC], direction: .forward, animated: true, completion:nil)
           }
        }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        
         func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController?
        {
            guard let viewControllerIndex = VCArray.index(of: viewController) else
            {
            return nil
            }
            perviouIndex = viewControllerIndex - 1

            guard perviouIndex >= 0 else
            {
                return VCArray.last
            }
            
            
            guard VCArray.count > perviouIndex else
            {
                return nil
                
            }
            
            
            print(viewControllerIndex)
            
            return VCArray[perviouIndex]
            
        }
        
        
         func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?
        {
     
     
            guard let viewControllerIndex = VCArray.index(of: viewController) else
            {
                return nil
     
            }
            nextIndex = viewControllerIndex + 1
            
            
            currentview = nextIndex
            print("now on tutorial slide",currentview)
            
        
            if currentview == 3
            {
               /* UIView.animate(withDuration: 3.0, animations: {
                    let  nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "XPHomeDashBoardViewController") as! XPHomeDashBoardViewController
                    self.present(nextViewController, animated: false, completion: nil)
                }) */
           
                
            }
                
         
            let orderedViewControllersCount = VCArray.count
            
            
           guard nextIndex < orderedViewControllersCount else
            {
                return VCArray.first
            }
            
            guard orderedViewControllersCount != nextIndex else {
                return nil
            }
            
            guard orderedViewControllersCount > nextIndex else {
                return nil
            }
            
            return VCArray[nextIndex]
            
        }
      
        
        override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()

            
            
            for view in self.view.subviews
            {
                
                if view is UIScrollView
                {
                    view.frame = UIScreen.main.bounds
                }
                else if view is UIPageControl
                {
                    
                    view.backgroundColor = UIColor.clear
      
                    
                }
            }
            
        }
        
        func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
            
         
            
        }
        
        
        func presentationCount(for pageViewController: UIPageViewController) -> Int
          {
          
            return VCArray.count
            
        }
    
     
        func presentationIndex(for pageViewController: UIPageViewController) -> Int
        {
            guard let firstViewController = viewControllers?.first,
                let firstViewControllerIndex = VCArray.index(of:firstViewController) else
            {
                return 0
            }
            
            return firstViewControllerIndex

        }
        
       

    }
