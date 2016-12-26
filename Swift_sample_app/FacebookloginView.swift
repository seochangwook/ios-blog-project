//
//  FacebookloginView.swift
//  Swift_sample_app
//
//  Created by apple on 2016. 12. 26..
//  Copyright © 2016년 apple. All rights reserved.
//

import Foundation
import UIKit
import Alamofire //네트워크 라이브러리//
import SwiftyJSON //JSON파싱 라이브러리//

class FacebookloginView : UIViewController{
    
    //서버의 ip주소와 포트번호//
    var server_ip_address:String = "192.168.0.12"
    var server_port_number = "3000"
    
    var text:String = "";
    
    //데이터를 가지고 있을 배열//
    var message_array = [String]()
    var date_array = [String]()
    
    @IBOutlet weak var info_label: UILabel!
    @IBOutlet weak var network_state_info: UILabel!
    @IBOutlet weak var info_label2: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        print(text);
        
        info_label.text = text
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func get_listdata(_ sender: UIButton) {
        if(message_array.isEmpty || date_array.isEmpty){
            print("message list, date list not data")
        }
        
        else{
            for message_data in message_array{
                print(message_data)
            }
            
            for date_data in date_array{
                print(date_data)
            }
        }
        
        //후에 이 값들을 테이블뷰에 사용//
    }
    
    @IBAction func Login_button(_ sender: UIButton) {
        print("Login data trans...")
        
        var progress = ProgressDialog(delegate: self)
        
        /* Alamofire는 비동기로 네트워크 연동을 한다. 비동기적인 프로그래밍은 많은 장점이 있다. 서버로부터 응답을 받을 때까지 기다리지 않고
           콜백을 통해서 응답을 처리하는 구조입니다. 요청에 대한 응답은 이를 처리하는 핸들러 안에서만 유효하므로 수신한 응답이나 데이터에 의존
           적인 동작들은 반드시 해당 핸들러 내에서 완료*/
        
        let accessToken = "EAAQZCT5jou2UBAADT3GCorJnZAHrEGcsvpyZA7ZC2MErDQfN2mAZAZBtlX6PpqWdKnRgiFZBNkAATLKZAbXdNAMoJBlF5IuzKOlekjOKDAMg74p2PTuqV7hNDYBrtxPpWKzZAxvG7m9LEyCgaL8jCXofuXnl7bsxO8OZCosJFtvwLAuIaKa6eBIKK85tKFbneidFQq3Mozc3SxPyFirW921rZCF"
        let fcmToken = "fcmtoken"
        
        //파라미터 설정//
        let parameters = [
            "accessToken":accessToken,
            "fcmtoekn":fcmToken
        ]
        
        progress.Show(true, mesaj: "Loading...")
        
        //호출//
        Alamofire.request("http://"+server_ip_address+":"+server_port_number+"/login/auth/facebook", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            
            //swift-case로 응답성공/실패를 분리//
            switch(response.result) {
            case .success(_):
                if let data = response.result.value{
                    print(response.result.value!)
                    
                    self.network_state_info.text = "Success"
                    
                    //JSON값을 가지고 파싱//
                    let json = JSON(data)
                    
                    var result_str = json["message"].stringValue
                    
                    print("result: " + result_str)
                    
                    progress.Close()
                }
                break
                
            case .failure(_):
                print(response.result.error!)
                break
                
            }
        }
    }
    
    @IBAction func get_messagelist(_ sender: UIButton) {
        //배열 초기화//
        self.message_array.removeAll()
        self.date_array.removeAll()
        
        print("Message data trans...")
        
        var progress = ProgressDialog(delegate: self)
        
        let parameters = [
            "pagecount":"10",
            "senderid":"931211",
            "receiverid":"931206997011879"
        ]
        
        progress.Show(true, mesaj: "Loading...")
        
        //GET방식은 URLEncoding//
        Alamofire.request("http://"+server_ip_address+":"+server_port_number+"/message/messagecontentlist", method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                if let data = response.result.value{
                    print(response.result.value!)
                    
                    self.info_label2.text = "Success"
                    
                    //JSON값을 가지고 파싱//
                    let json = JSON(data)
                    
                    for item in json["result"].arrayValue {
                        var message_str:String = item["message"].stringValue + ":" + item["date"].stringValue
                        
                        //배열에 저장//
                        self.message_array.append(item["message"].stringValue)
                        self.date_array.append(item["date"].stringValue)
                        
                        print(message_str)
                    }
                    
                    progress.Close()
                }
                break
                
            case .failure(_):
                print(response.result.error)
                break
                
            }
        }
    }
}
