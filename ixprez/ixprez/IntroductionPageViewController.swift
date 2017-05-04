//
//  IntroductionPageViewController.swift
//  ixprez
//
//  Created by Quad on 4/28/17.
//  Copyright © 2017 Claritaz Techlabs. All rights reserved.
//

import UIKit

class IntroductionPageViewController: UIPageViewController,UIPageViewControllerDataSource,UIPageViewControllerDelegate {

    lazy var VCArray : [UIViewController]
   = {
        return [self.VCInstance(name: "FirstVC"),
                self.VCInstance(name: "SecondVC"),
                self.VCInstance(name: "ThirdVC")]
        
    }()
    
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
            
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
        
        
        
        // Do any additional setup after loading the view.
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
        
        
        let perviouIndex = viewControllerIndex - 1
        
        
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
        let nextIndex = viewControllerIndex + 1
        
        
        guard nextIndex < VCArray.count else
        {
            /*let otpvc = self.storyboard?.instantiateViewController(withIdentifier: "OTPVerificationViewController") as! OTPVerificationViewController
            
            
            self.present(otpvc, animated: true, completion: nil)
             
               return otpvc
             */
            
            
            return VCArray.first
            
          
            
        }
        
        guard VCArray.count > nextIndex else
        {
        
            return nil
            
        }
        
        print(viewControllerIndex)
        
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
