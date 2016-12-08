//
//  MemberIDSearchView.swift
//  Swift_sample_app
//
//  Created by apple on 2016. 10. 16..
//  Copyright © 2016년 apple. All rights reserved.
//

import UIKit //ios에서 코코아 프레임워크를 사용하기 위한 것//
import Foundation
import MessageUI //메시지 전송 클래스를 사용하기 위한 것//

class MemberIDSearchView : UIViewController, MFMailComposeViewControllerDelegate
{
    let DB_Func_class = DB_Func(); //기본적으로 디폴트 생성자 호출//
    
    //필요변수 선언//
    var get_info : String = ""
    
    var get_user_email : String = ""
    var get_user_id : String = ""
    
    @IBOutlet weak var info_label: UILabel!
    @IBOutlet weak var searchname_edittext: UITextField!
    
    @IBAction func search_button(_ sender: UIButton){
        let input_name = searchname_edittext.text
       
        self.get_info = DB_Func_class.DB_Select_user_info(input_name!) //이름을 불러온다.//
        
        print("info: ", self.get_info)
        
        //seperatedBy로 문자열을 분리한다.(Token)//
        let parsing_info = self.get_info.components(separatedBy: " ")
        
        let count = parsing_info.count
        
        print("count: ", count)
        
        for str in 0..<count{
            if(str == 0)
            {
                self.get_user_id = parsing_info[str]
            }
            
            else if(str == 1)
            {
                self.get_user_email = parsing_info[str]
            }
        }
        
        print("id: ", self.get_user_id)
        print("email: ", self.get_user_email)
        
        let mailComposeViewController = configuredMailComposeViewController()
        
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
            print("can send mail")
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setToRecipients([self.get_user_email])
        mailComposerVC.setSubject("Swift Game App ID Search")
        mailComposerVC.setMessageBody("아이디는 ["+self.get_user_id+"]입니다.", isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "메일을 전송 실패", message: "아이폰 이메일 설정을 확인하고 다시 시도해주세요.", delegate: self, cancelButtonTitle: "확인")
        sendMailErrorAlert.show()
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?)
    {
        print("mail send ok")
        
        controller.dismiss(animated: true, completion: nil)
    }
    
    //넘겨받을 값을 저장할 변수 저장//
    var info_label_str : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        info_label.text = info_label_str
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //빈 공간을 눌렀을때 키보드가 종료되는 것. 오버라이드해서 사용한다.//
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        searchname_edittext.resignFirstResponder()
    }
}
