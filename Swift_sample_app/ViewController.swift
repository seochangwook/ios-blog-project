//
//  ViewController.swift
//  Swift_sample_app
//
//  Created by apple on 2016. 7. 10..
//  Copyright © 2016년 apple. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    let DB_Func_class = DB_Func(); //기본적으로 디폴트 생성자 호출//
    
    @IBOutlet weak var game_logo_imageview: UIImageView!
    @IBOutlet weak var id_textfield: UITextField!
    @IBOutlet weak var password_textfield: UITextField!
    
    //각 버튼들을 하나의 class에 콜백 메소드 형태로 구현//
    
    @IBAction func game_info_button(_ sender: UIBarButtonItem) {
    }
    

    @IBAction func exit_button(_ sender: UIBarButtonItem)
    {
        exit(0)
    }
    
    @IBAction func login_button(_ sender: UIButton)
    {
        //데이터베이스와 비교 후 로그인//
        let id_string = id_textfield.text
        let password_string = password_textfield.text
        
        login_method(id_string!, password_str : password_string!)
        
        print(id_string)
    }
    
    @IBAction func id_search_button(_ sender: UIButton)
    {
        
    }
    
    @IBAction func password_search_button(_ sender: UIButton)
    {
        
    }
    
    @IBAction func memberout_button(_ sender: UIButton)
    {
    
    }
    
    @IBAction func facebook_login(_ sender: UIButton) {
        
    }

    func set_game_logo_image() //이미지를 셋팅하는 메소드.//
    {
        //해당 구조는 이미지뷰에 있는 image의 메소드를 사용하는 것이고 UIImage클래스의 생성자로 named를 이용하여
        //해당 이미지의 값(파일명)을 넣어준다.//
        game_logo_imageview.image = UIImage(named: "game_logo_image.png");
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //이미지 설정//
        set_game_logo_image();
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //빈 공간을 눌렀을때 키보드가 종료되는 것. 오버라이드해서 사용한다.//
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        id_textfield.resignFirstResponder()
        password_textfield.resignFirstResponder()
    }
    
    func login_method(_ id_str : String, password_str : String)
    {
        print("login info : id - "+id_str+"/password - "+password_str)
        
        //아이디와 패스워드를 가지고 현재 가입되어있는지 데이터베이스 검사//
        var is_login : Bool
        
        is_login = DB_Func_class.DB_user_logincheck(id_str, input_password_str : password_str) //이름을 불러온다.//
        
        if(is_login == false)
        {
            let refreshAlert = UIAlertController(title: "로그인", message: "존재하지 않는 아이디이거나 패스워드 입니다. 다시 확인해주세요", preferredStyle: UIAlertControllerStyle.alert)
            
            //다이얼로그에 버튼 등록//
            refreshAlert.addAction(UIAlertAction(title: "확인", style: .default, handler: { (action: UIAlertAction!) in
                print("login check")
            }))
            
            present(refreshAlert, animated: true, completion: nil) //작성된 다이얼로그를 만들어 준다.//
        }
        
        else if(is_login == true)
        {
            print("login success... move main screen")
            
            //메인화면으로 이동//
            let refreshAlert = UIAlertController(title: "로그인", message: "로그인 성공. 즐거운 게임 되세요", preferredStyle: UIAlertControllerStyle.alert)
            
            //다이얼로그에 버튼 등록//
            refreshAlert.addAction(UIAlertAction(title: "확인", style: .default, handler: { (action: UIAlertAction!) in
                self.performSegue(withIdentifier: "mainview", sender: self) //화면 이동.(prepare적용)//
            }))
            
            present(refreshAlert, animated: true, completion: nil) //작성된 다이얼로그를 만들어 준다.//
        }
    }
    
    //스토리보드 이동(Modal, Push(Navigation)방식 모두 prepare에서 한다.)//
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        //이동할 스토리보드의 id저장.값이 변할 수 있는 것은 가변타입(var)로 한다. 고정값(상수)이면 let//
        var segue_id : String = ""
        segue_id = segue.identifier!
        
        //identifier값으로 비교한다.//
        print("segue id : ", segue_id+" id")
    
        //스토리보드의 id값을 가지고 이동할 스토리보드를 선택한다.//
        if(segue_id == "enrollview")
        {
            print("move sotryboard...")
            
            let destination = segue.destination as! EnrollView
        
            //destination.value_str = "회원가입 진행중..." //이동할 스토리보드에 있는 값을 받을 변수설정//
        }
        
        else if(segue_id == "memberlistview")
        {
            print("move sotryboard...")
            
            //새로운 UINavigation으로 분기할때는 UINavigationController를 먼저 클래스 할당 후 topViewController로 등록//
            let nav = segue.destination as! UINavigationController
            let destination = nav.topViewController as! MemberListView
            
            destination.screen_message = "멤버리스트를 불러오는 중입니다."; //값을 넘겨준다.//
        }
        
        //UINavigation의 원리도 modal이 아닌 push로 하고 값을 넘기는 segue 매커니즘은 동일//
        else if(segue_id == "memberidsearchview")
        {
            //값을 전달하기 위해서 목표 뷰를 설정(캐스팅)//
            let destination = segue.destination as! MemberIDSearchView
            
            //해당 뷰로 데이터 전송//
            destination.info_label_str = "Member ID Search"
            
            print("move sotryboard navigation...")
        }
        
        else if(segue_id == "memberpasswordsearchview")
        {
            let destination = segue.destination as! MemberPasswordSearchView
            
            destination.info_label_str = "Member Password Search"
            
            print("move storyboard navigation...")
        }
        
        else if(segue_id == "memberdeleteview")
        {
            let destination = segue.destination as! MemberDeleteView
            
            destination.info_str_title = "Member Delete"
            
            print("move storyboard navigation...")
        }
        
        else if(segue_id == "mainview")
        {
            let tabbarcontroller = segue.destination as! UITabBarController
            
            let destination = tabbarcontroller.viewControllers?[0] as! MainTabView //첫번째 탭에 데이터 전달//
            
            destination.info_str = "게임 설명 탭"
        }
        
        else if(segue_id == "facebooklogin"){
            print("move storyboard navigation...");
            
            //새로운 UINavigation으로 분기할때는 UINavigationController를 먼저 클래스 할당 후 topViewController로 등록//
            let destination = segue.destination as! FacebookloginView
            
            destination.text = "Game Messenger Login"
        }
    }
}

