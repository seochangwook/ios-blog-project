//
//  ProfileView.swift
//  Swift_sample_app
//
//  Created by apple on 2016. 12. 31..
//  Copyright © 2016년 apple. All rights reserved.
//

import Foundation
import UIKit
import Alamofire //네트워크 라이브러리//
import SwiftyJSON //JSON파싱 라이브러리//
import Kingfisher //이미지 로더 클래스//

class ProfileView : UIViewController{
    //서버의 ip주소와 포트번호//
    var server_ip_address:String = "192.168.0.11"
    var server_port_number = "3000"
    
    //Key//
    let userNameKeyConstant = "userid"
    
    @IBOutlet weak var info_label: UILabel!
    @IBOutlet weak var name_label: UILabel!
    @IBOutlet weak var email_label: UILabel!
    @IBOutlet weak var gender_label: UILabel!
    @IBOutlet weak var profile_imageview: UIImageView!
    
    
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
        
        info_label.text = info_text
        
        get_userProfile(user_id: user_id_str)
    }
    
    @IBAction func refresh_button(_ sender: UIBarButtonItem) {
        print("refresh user info")
        
        //공유저장소에 저장된 값을 불러온다.//
        let defaults = UserDefaults.standard
        
        if let user_id = defaults.string(forKey: userNameKeyConstant) {
            //print("user id: ", user_id)
            user_id_str = user_id
        }
        
        info_label.text = info_text
        
        get_userProfile(user_id: user_id_str)
    }
    
    
    func get_userProfile(user_id:String){
        print("user_id : " ,user_id)
        
        //네트워크로 유저의 정보를 검색한다.//
        var progress = ProgressDialog(delegate: self)
        
        //파라미터 설정//
        let parameters = [
            "user_id":user_id
        ]
        
        progress.Show(true, mesaj: "Loading...")
        
        //호출//
        Alamofire.request("http://"+self.server_ip_address+":"+self.server_port_number+"/user/profile", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            
            //swift-case로 응답성공/실패를 분리//
            switch(response.result) {
            case .success(_):
                if let data = response.result.value{
                    print(response.result.value!)
                    
                    //JSON값을 가지고 파싱//
                    let json = JSON(data)
                    
                    var result_str = json["results"] //객체를 파싱할 경우 아무것도 붙이지 않는다.//
                    
                    //results안에 있는 속성들에 접근//
                    var user_email = result_str["email"].stringValue
                    var user_gender = result_str["gender"].stringValue
                    var user_id = result_str["id"].stringValue
                    var user_name = result_str["name"].stringValue
                    var user_profileimageurl = result_str["profile_image"].stringValue
                    
                    //네트워크 작업을 다 완료 후 수행(async - 비동기 작업)//
                    DispatchQueue.main.async {
                        progress.Close()
                        
                        //이미지 로드 및 UI셋팅//
                        self.set_userinfo(user_email:user_email, user_gender:user_gender, user_id:user_id, user_name:user_name, user_profileimageurl:user_profileimageurl)
                    }
                }
                
                break
                
            case .failure(_):
                progress.Close()
                print(response.result.error!)
                
                break
                
            }
        }
    }
    
    func set_userinfo(user_email:String, user_gender:String, user_id:String, user_name:String, user_profileimageurl:String) {
        print("user email: ", user_email)
        print("user gender: ", user_gender)
        print("user id: ", user_id)
        print("user name: ", user_name)
        print("user profile:" , user_profileimageurl)
        
        name_label.text = user_name
        email_label.text = user_email
        
        if(user_gender == "male"){
            gender_label.text = user_gender + "(남자)"
        }
        
        else if(user_gender == "female"){
            gender_label.text = user_gender + "(여자)"
        }
        
        //이미지 로드//
        let url = URL(string: user_profileimageurl) //이미지 로딩(비동기, 캐싱기능 포함)//
        let processor = RoundCornerImageProcessor(cornerRadius: 80) //이미지 변형(동그랗게 자르기)//
        //let processor_multi = BlurImageProcessor(blurRadius: 4) >> RoundCornerImageProcessor(cornerRadius: 40)
        
        profile_imageview.kf.setImage(with: url, options: [.processor(processor)])
        //profile_imageview.kf.setImage(with: url)
    }
}
