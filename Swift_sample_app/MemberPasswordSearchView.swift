//
//  MemberPasswordSearchView.swift
//  Swift_sample_app
//
//  Created by apple on 2016. 10. 26..
//  Copyright © 2016년 apple. All rights reserved.
//

import Foundation
import UIKit

class MemberPasswordSearchView : UIViewController
{
    let DB_Func_class = DB_Func(); //기본적으로 디폴트 생성자 호출//
    
    //넘겨받을 값을 저장할 변수 저장//
    var info_label_str : String = ""
    var search_id : String = ""
    var search_name : String = ""
    var get_info : String = ""
    
    var get_password : String = ""
    var get_emailaddres : String = ""
    
    @IBOutlet weak var info_text: UILabel!
    @IBOutlet weak var input_id_textfield: UITextField!
    @IBOutlet weak var input_password_textfield: UITextField!
    
    @IBAction func send_emailbutton(_ sender: UIButton) {
        search_id = input_id_textfield.text!
        search_name = input_password_textfield.text!
        
        print("input id: ", search_id)
        print("input name: ", search_name)
        
        //비밀번호 찾기는 아이디와 이름을 주어서 조건이 2개이게 한다.//
        self.get_info = DB_Func_class.DB_Select_user_info_password(inputname : search_name, input_id : search_id) //이름을 불러온다.//
        
        print("info: ", self.get_info)
        
        //seperatedBy로 문자열을 분리한다.(Token)//
        let parsing_info = self.get_info.components(separatedBy: " ")
        
        var count = parsing_info.count
        
        print("count: ", count)
        
        for str in 0..<count{
            if(str == 0)
            {
                self.get_password = parsing_info[str]
            }
                
            else if(str == 1)
            {
                self.get_emailaddres = parsing_info[str]
            }
        }
        
        print("id: ", self.get_password)
        print("email: ", self.get_emailaddres)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        info_text.text = info_label_str
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //빈 공간을 눌렀을때 키보드가 종료되는 것. 오버라이드해서 사용한다.//
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        input_id_textfield.resignFirstResponder()
        input_password_textfield.resignFirstResponder()
    }
}
