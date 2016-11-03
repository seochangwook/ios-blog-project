//
//  MainTabView.swift
//  Swift_sample_app
//
//  Created by apple on 2016. 10. 29..
//  Copyright © 2016년 apple. All rights reserved.
//

import Foundation
import UIKit

class MainTabView : UIViewController, UIPageViewControllerDataSource{
    var info_str : String = ""
    
    var pageViewController : UIPageViewController!
    var pageTitles : Array<String> = Array<String>()
    var pageImages : Array<String> = Array<String>()
    var page_indicator_rightImages : Array<String> = Array<String>()
    var page_indicator_leftImages : Array<String> = Array<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //페이지 정보 설정(하나의 뷰 컨트롤러를 가지고 여러개의 페이지를 만드는 개념)//
        self.pageTitles.append("게임설명 - 1")
        self.pageTitles.append("게임설명 - 2")
        self.pageTitles.append("게임설명 - 3")
        
        self.pageImages.append("login_image")
        self.pageImages.append("enroll_image")
        self.pageImages.append("password_search_image")
        
        self.page_indicator_leftImages.append("")
        self.page_indicator_leftImages.append("indicator_left_image")
        self.page_indicator_leftImages.append("indicator_left_image")
        
        self.page_indicator_rightImages.append("indicator_right_image")
        self.page_indicator_rightImages.append("indicator_right_image")
        self.page_indicator_rightImages.append("")
        
        //페이지 뷰 컨트롤러 정보 가져오기(캐스팅)//
        self.pageViewController = self.storyboard?.instantiateViewController(withIdentifier: "pageviewcontroller") as! UIPageViewController
        self.pageViewController.dataSource = self
        
        //처음 시작할 페이지 뷰를 정의//
        let startVC = self.viewControllerAtIndex(index: 0) as! ContentViewController
        let viewControllers = NSArray(object: startVC)
        
        self.pageViewController.setViewControllers(viewControllers as? [UIViewController], direction: .forward, animated: true, completion: nil)
        
        self.addChildViewController(self.pageViewController)
        self.view.addSubview(self.pageViewController.view)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        print("tab1 view")
        
        print("trans data: ", info_str)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     * viewPageController 구성 함수
     */
    func viewControllerAtIndex (index : Int) -> ContentViewController {
        
        let vc : ContentViewController = self.storyboard?.instantiateViewController(withIdentifier: "ContentViewController") as! ContentViewController
        
        //각 속성에 할당//
        vc.pageIndex = index
        
        vc.imageFile = self.pageImages[index] as! String
        vc.titleText = self.pageTitles[index] as! String
        vc.left_image = self.page_indicator_leftImages[index] as! String
        vc.right_image = self.page_indicator_rightImages[index] as! String
        
        print("page move...")
        
        return vc
    }
    
    /**
     * 이전 ViewPageController 구성(콜백)
     */
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let vc = viewController as! ContentViewController
        var index = vc.pageIndex as Int
        
        if( index == 0 || index == NSNotFound) {
            return nil
        }
        
        index -= 1
        
        return self.viewControllerAtIndex(index: index)
    }
    
    /**
     * 이후 ViewPageController 구성(콜백)
     */
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let vc = viewController as! ContentViewController
        
        var index = vc.pageIndex as Int
        
        if( index == NSNotFound) {
            return nil
        }
        
        index += 1
        
        if (index == self.pageTitles.count) {
            return nil
        }
        
        return self.viewControllerAtIndex(index: index)
    }
    
    /**
     * 인디케이터의 총 갯수
     */
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return self.pageTitles.count
    }
    
    
    /**
     * 인디케이터의 시작 포지션
     */
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
}
