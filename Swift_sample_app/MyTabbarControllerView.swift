//
//  MyTabbarControllerView.swift
//  Swift_sample_app
//
//  Created by apple on 2016. 10. 31..
//  Copyright © 2016년 apple. All rights reserved.
//

import Foundation
import UIKit

class MyTabbarControllerView : UITabBarController
{
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //custom tabbar tint//
        tabBar.barTintColor = UIColor(red: 49/255, green: 75/255, blue: 108/255, alpha: 1.0)
        
        let selectedColor   = UIColor(red: 246.0/255.0, green: 155.0/255.0, blue: 13.0/255.0, alpha: 1.0)
        let unselectedColor = UIColor(red: 16.0/255.0, green: 224.0/255.0, blue: 223.0/255.0, alpha: 1.0)
        
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: unselectedColor], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: selectedColor], for: .selected)
    }
}
