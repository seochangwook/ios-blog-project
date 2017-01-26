//
//  MapView.swift
//  Swift_sample_app
//
//  Created by apple on 2017. 1. 23..
//  Copyright © 2017년 apple. All rights reserved.
//

import Foundation
import UIKit
import SlideMenuControllerSwift

class MapView : SlideMenuController{
    var location_name : String = ""
    
    @IBOutlet weak var location_label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SlideMenuOptions.contentViewScale = 0.50
        SlideMenuOptions.hideStatusBar = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        print("location name : ", location_name)
        location_label.text = location_name
    }
    
    //현재 위치하고 있는 뷰를 변경(Slide적용)//
    override func awakeFromNib() {
        if let viewController = self.storyboard?.instantiateViewController(withIdentifier :"Right"){
            self.rightViewController = viewController
        }
        
        super.awakeFromNib()
    }
    
    @IBAction func slide_open_button(_ sender: UIBarButtonItem) {
        //현재 화면 상태에 따른 판단 후 액션 수행//
        if(self.slideMenuController()?.isRightOpen())!{
            self.slideMenuController()?.closeRight()
        }
        
        else{
            self.slideMenuController()?.openRight()
        }
    }
}
