//
//  PageController.swift
//  MovieAppOnboarding
//
//  Created by KS_Emre_Celik on 22.01.2020.
//  Copyright © 2020 KS_Emre_Celik. All rights reserved.
//

import UIKit

class PageController: UIPageViewController {
    
    lazy var orderedVCList: [UIViewController] = {
        return [getVC(storyboardID: "FirstPageVC"),
                getVC(storyboardID: "SecondPageVC"),
                getVC(storyboardID: "ThirdPageVC")]
    }()
    
    var pageControl = UIPageControl()
    var currentPageIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        
        if let firstVC = orderedVCList.first {
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
        
        self.delegate = self
        configurePageControl()
        configureSkipButton()
    }
    
    func getVC(storyboardID: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: storyboardID)
    }
    
    func configurePageControl() {
        pageControl = UIPageControl(frame: CGRect(x: 0, y: UIScreen.main.bounds.maxY - 75, width: 100, height: 30))
        pageControl.addTarget(self, action: #selector(self.pageControlSelectionAction(_:)), for: .touchUpInside)
        pageControl.numberOfPages = orderedVCList.count
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = UIColor.black
        pageControl.currentPageIndicatorTintColor = UIColor.orange
        self.view.addSubview(pageControl)
    }
    
    func configureSkipButton() {
        let button:UIButton = UIButton(frame: CGRect(x: UIScreen.main.bounds.maxX - 100, y: UIScreen.main.bounds.maxY - 75, width: 80, height: 30))
        button.backgroundColor = UIColor(red: 21 / 255, green: 25 / 255, blue: 31 / 255, alpha: 1.0)
        button.layer.cornerRadius = 15.0
        button.layer.borderWidth = 2.0
        button.layer.borderColor = UIColor(red: 67 / 255, green: 67 / 255, blue: 79 / 255, alpha: 1.0).cgColor
        button.setTitle("Skip", for: .normal)
        button.titleLabel?.font = UIFont(name: "Futura", size: 14)
        button.setTitleColor(UIColor(red: 67 / 255, green: 67 / 255, blue: 79 / 255, alpha: 1.0), for: .normal)
        button.addTarget(self, action:#selector(self.buttonClicked), for: .touchUpInside)
        self.view.addSubview(button)
    }
    
    @objc
    func buttonClicked() {
        let viewController: UIViewController = UIStoryboard( name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeVC") as UIViewController
        self.present(viewController, animated: true, completion: nil)
    }
    
    @objc
    func pageControlSelectionAction(_ sender: UIPageControl) {
        //move page to wanted page
        let page: Int = sender.currentPage
        if page > currentPageIndex {
            self.setViewControllers([orderedVCList[page]], direction: .forward, animated: true, completion: nil)
        }
        else {
            self.setViewControllers([orderedVCList[page]], direction: .reverse, animated: true, completion: nil)
        }
        currentPageIndex = page
    }
    
}

extension PageController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let vcIndex = orderedVCList.firstIndex(of: viewController) else { return nil }
        let previousIndex = vcIndex - 1
        currentPageIndex = vcIndex
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard orderedVCList.count > previousIndex else {
            return nil
        }
        
        return orderedVCList[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let vcIndex = orderedVCList.firstIndex(of: viewController) else { return nil }
        let nextIndex = vcIndex + 1
        currentPageIndex = vcIndex
        guard orderedVCList.count != nextIndex else {
            return nil
        }
        
        guard orderedVCList.count > nextIndex else {
            return nil
        }
        
        return orderedVCList[nextIndex]
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let pageContentViewController = pageViewController.viewControllers![0]
        self.pageControl.currentPage = orderedVCList.firstIndex(of: pageContentViewController)!
    }
    
}

