//
//  GameSettingTabView.swift
//  Swift_sample_app
//
//  Created by apple on 2016. 10. 29..
//  Copyright © 2016년 apple. All rights reserved.
//

import Foundation
import UIKit

class GameSettingTabView : UIViewController{
    var info_str : String = "게임 설정 탭"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBOutlet weak var info_str_textfield: UILabel!
    
    @IBAction func back_button(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        print("tab3 view")
        
        info_str_textfield.text = self.info_str
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //게임 설정 적용 버튼(게임 탭에 배지를 달아준다.)//
    @IBAction func adjust_gameset_button(_ sender: UIButton) {
        print("setting game option and badge")
        
        for item in self.tabBarController!.tabBar.items!
        {
            //게임하기 탭에 뱃지를 만들기 위해 플래그 설정//
            if item.tag == 1
            {
                item.badgeValue = "Adjust"
            }
        }
    }
}
