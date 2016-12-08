//
//  MemberDeleteView.swift
//  Swift_sample_app
//
//  Created by apple on 2016. 10. 27..
//  Copyright © 2016년 apple. All rights reserved.
//

import Foundation
import UIKit

class MemberDeleteView : UIViewController
{
    let DB_Func_class = DB_Func(); //기본적으로 디폴트 생성자 호출//
    
    var info_str_title : String = ""
    var delete_result : Bool = false //처음은 삭제 실패라 가정.//
    
    @IBOutlet weak var info_str: UILabel!
    @IBOutlet weak var input_id_textfield: UITextField!
    
    @IBAction func memberout_button(_ sender: UIButton) {
        //아이디를 받아서 제거작업 진행(다이얼로그를 띄워준다.)//
        var str = input_id_textfield.text!
        
        str = str + "정말로 탈퇴하시겠습니까?"
        
        let refreshAlert = UIAlertController(title: "맴버탈퇴", message: str, preferredStyle: UIAlertControllerStyle.alert)
        
        //다이얼로그에 버튼 등록//
        refreshAlert.addAction(UIAlertAction(title: "탈퇴", style: .default, handler: { (action: UIAlertAction!) in
            self.delete_user(self.input_id_textfield.text!)
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: { (action: UIAlertAction!) in
            print("cancel enroll")
        }))
        
        present(refreshAlert, animated: true, completion: nil) //작성된 다이얼로그를 만들어 준다.//
    }
    
    func delete_user(_ input_id : String)
    {
        print("delete user")
        
        self.delete_result = DB_Func_class.DB_user_delete(input_id) //이름을 불러온다.//
        
        if(self.delete_result == true)
        {
            let refreshAlert = UIAlertController(title: "맴버탈퇴", message: "탈퇴에 성공했습니다.", preferredStyle: UIAlertControllerStyle.alert)
            
            //다이얼로그에 버튼 등록//
            refreshAlert.addAction(UIAlertAction(title: "확인", style: .default, handler: { (action: UIAlertAction!) in
                print("member delete ok")
            }))
            
            present(refreshAlert, animated: true, completion: nil) //작성된 다이얼로그를 만들어 준다.//
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        info_str.text = info_str_title
    }
    
    //빈 공간을 눌렀을때 키보드가 종료되는 것. 오버라이드해서 사용한다.//
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        input_id_textfield.resignFirstResponder()
    }
}
