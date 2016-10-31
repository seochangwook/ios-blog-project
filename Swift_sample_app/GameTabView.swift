//
//  GameTabView.swift
//  Swift_sample_app
//
//  Created by apple on 2016. 10. 29..
//  Copyright © 2016년 apple. All rights reserved.
//

import Foundation
import UIKit

class GameTabView : UIViewController{
    var info_str : String = "게임 탭"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBOutlet weak var info_str_textfield: UILabel!
    
    @IBAction func back_button(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        print("tab2 view")
        
        info_str_textfield.text = self.info_str
        
        //베지를 해제//
        for item in self.tabBarController!.tabBar.items!
        {
            if item.tag == 1
            {
                item.badgeValue = nil //해지하기 위해 nil을 해준다.//
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
