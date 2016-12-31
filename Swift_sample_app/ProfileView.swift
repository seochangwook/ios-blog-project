//
//  ProfileView.swift
//  Swift_sample_app
//
//  Created by apple on 2016. 12. 31..
//  Copyright © 2016년 apple. All rights reserved.
//

import Foundation
import UIKit

class ProfileView : UIViewController{
    //Key//
    let userNameKeyConstant = "userid"
    
    @IBOutlet weak var info_label: UILabel!
    
    var info_text:String = "User Profile info"
    var user_id_str:String = "";
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        //공유저장소에 저장된 값을 불러온다.//
        let defaults = UserDefaults.standard
        
        if let user_id = defaults.string(forKey: userNameKeyConstant) {
            //print("user id: ", user_id)
            user_id_str = user_id
        }
        
        info_label.text = user_id_str
        
        get_userProfile(user_id: info_label.text!)
    }
    
    func get_userProfile(user_id:String){
        print("user_id : " ,user_id)
    }
}
