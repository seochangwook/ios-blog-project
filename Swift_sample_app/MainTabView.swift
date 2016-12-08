//
//  MainTabView.swift
//  Swift_sample_app
//
//  Created by apple on 2016. 10. 29..
//  Copyright © 2016년 apple. All rights reserved.
//

import Foundation
import UIKit

class MainTabView : UIViewController, UIPageViewControllerDataSource,UIPageViewControllerDelegate{
    var info_str : String = ""
    
    var pageViewController : UIPageViewController!
    let pageControl: UIPageControl = UIPageControl()
    let pageControlHeight: CGFloat = 20
    
    var pageTitles : Array<String> = Array<String>()
    var pageImages : Array<String> = Array<String>()
    var page_indicator_rightImages : Array<String> = Array<String>()
    var page_indicator_leftImages : Array<String> = Array<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //페이지 정보 설정(하나의 뷰 컨트롤러를 가지고 여러개의 페이지를 만드는 개념)//
        //DataSource정의//
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
        
        //콜백들을 현재의 클래스에서 구현하기 위함.//
        self.pageViewController.dataSource = self
        self.pageViewController.delegate = self
        
        //페이지의 영역을 지정(-180)//
        self.pageViewController.view.frame = CGRectMake(0, 65, self.view.frame.width, self.view.frame.height - 180)
        
        //페이지에 나타낼 뷰를 정의//
        let startVC = self.viewControllerAtIndex(0) 
        let viewControllers = NSArray(object: startVC)
        
        self.pageViewController.setViewControllers(viewControllers as? [UIViewController], direction: .forward, animated: true, completion: nil)
        
        self.addChildViewController(self.pageViewController)
        self.view.addSubview(self.pageViewController.view)
        self.pageViewController.didMove(toParentViewController: self)
        
        stylePageControl() //indicator속성정의//
    }
    
    //indicator정의(PageControl)//
    func stylePageControl() -> Void
    {
        //indicator의 색갈//
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        pageControl.currentPageIndicatorTintColor = UIColor.orange
        pageControl.backgroundColor = UIColor.black
        
        //커스텀 위치//
        pageControl.frame = CGRectMake(0, 490, self.view.bounds.size.width, pageControlHeight)
        pageControl.numberOfPages = pageTitles.count;
        
        self.view.addSubview(pageControl) //현재 뷰(페이지 루트 뷰)에 적용//
    }
    
    //현재의 페이지 index를 알 수 있는 콜백//
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool){
        let pageContentViewController = pageViewController.viewControllers![0] as! ContentViewController
        let index = pageContentViewController.pageIndex
        
        pageControl.currentPage = index! //indicator위치 수정//
    }
    
    @IBAction func back_button(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    //첫번째 페이지로 이동//
    @IBAction func firstview_move_button(_ sender: UIBarButtonItem) {
        let pageContentViewController = self.viewControllerAtIndex(0)
        
        pageControl.currentPage = 0 //indicator위치도 초기화//
        
        //설정한 인덱스의 위치로 페이지 네비게이션 적용//
        self.pageViewController.setViewControllers([pageContentViewController], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
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
    func viewControllerAtIndex (_ index : Int) -> ContentViewController {
        
        let vc : ContentViewController = self.storyboard?.instantiateViewController(withIdentifier: "ContentViewController") as! ContentViewController
        
        //각 속성에 할당//
        vc.pageIndex = index
        
        vc.imageFile = self.pageImages[index] 
        vc.titleText = self.pageTitles[index] 
        vc.left_image = self.page_indicator_leftImages[index] 
        vc.right_image = self.page_indicator_rightImages[index] 
        
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
        
        return self.viewControllerAtIndex(index)
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
        
        return self.viewControllerAtIndex(index)
    }
    
    func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
        return CGRect(x: x, y: y, width: width, height: height)
    }
}
