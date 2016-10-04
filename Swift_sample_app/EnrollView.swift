//
//  EnrollView.swift
//  Swift_sample_app
//
//  Created by apple on 2016. 7. 14..
//  Copyright © 2016년 apple. All rights reserved.
//

import UIKit //ios에서 코코아 프레임워크를 사용하기 위한 것//
import AssetsLibrary //이미지, 동영상 등 리소스 작업을 하기 위한 라이브러리//

//Object-C처럼 @interface->@implements로 복잡하게 하지 않아도 되고 자바처럼 class -> 필드(아웃렛 변수), 메소드로 구현해준다.//
class EnrollView : UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    //아이디 체크를 위한 불리언 값.//
    //Swift에서 '?'의 값은 Optional한 특징이다. 즉 하나의 Box의 개념이다. 따라서 사용 시 박스를 해제해야 한다.
    //박스를 해제하는 방법엔 '!'하는 강제해제와 'if let'방식의 안전한 해제가 있다.//
    //스위프트에서는 변수도 하나의 객체가 된다.//
    
    var id_check : Bool? //'?'는 nil을 의미한다.(옵셔널)//
    var password_check : Bool?
    
    var db_connection_check : Bool?
    var db_table_check : Bool?
    
    let DB_Func_class = DB_Func(); //기본적으로 디폴트 생성자 호출//
    
    var asset = ALAssetsLibrary()
    //스위프트에서는 변수도 하나의 객체가 되기에 외부 클래스를 가질때는 let(상수)으로 설정.//
    //이렇게 할 시 필드에 정의되어 있기에 디비의 객체를 어디서든지 사용가능하다.//
    //만약에 해당 객체를 싱글톤 디자인 패턴으로 해도 문제가 없다. 이유는 let키워드는 기본적으로 Thread-safe를 보장한다.//
    //* 싱글톤 패턴 : 여러개의 스레드가 동시에 객체를 만들어서 생기는 문제를 방지하기 위해서 오직 하나의 스레드만 진입하여
    //단 하나의 인스턴스(객체 혹은 오브젝트)를 만들어 두는것.//
    
    @IBOutlet weak var confirm_password_label: UILabel!
    @IBOutlet weak var id_textfield: UITextField!
    @IBOutlet weak var password_field: UITextField!
    @IBOutlet weak var password_confirm: UITextField!
    @IBOutlet weak var email_textfield: UITextField!
    @IBOutlet weak var tel_textfield: UITextField!
    @IBOutlet weak var address_textfield: UITextField!
    @IBOutlet weak var name_textfield: UITextField!
    @IBOutlet weak var thumbnail_image: UIImageView!
    @IBOutlet weak var image_url_label: UILabel!
    
    //이미지 불러오기//
    let imagePicker = UIImagePickerController() //UIImagePickerController()객체 선언//
    
    @IBAction func get_image_button(_ sender: UIButton)
    {
        //ios에서 이미지를 불러온다.//
        imagePicker.allowsEditing = true //사진을 Crop등 수정가능하게 설정//
        imagePicker.sourceType = .photoLibrary //사진라이브러리에서 이미지를 가져온다.(모드는 다양하다.)//
        
        present(imagePicker, animated:true, completion:nil)
    }
    
    //UIImagePicker에 대한 delegate구현//
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo editingInfo: [String : Any]) {
        if let pickedImage = editingInfo[UIImagePickerControllerOriginalImage] as? UIImage
        {
            //선택된 이미지 정보를 추출//
            let imageUrl          = editingInfo[UIImagePickerControllerReferenceURL] as! URL
            let imageName         = imageUrl.lastPathComponent
            let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first as String!
            let photoURL          = URL(fileURLWithPath: documentDirectory!)
            let localPath         = photoURL.appendingPathComponent(imageName)
            let data              = UIImagePNGRepresentation(pickedImage)
            
            print("image path:", imageUrl)
            //ex) assets-library://asset/asset.JPG?id=20BA9B63-354F-4B2C-AB30-DB453BF03ACD&ext=JPG 형식으로 출력//
            //ios는 기본적으로 assets-library로 경로를 출력한다. -> ALAssetsLibrary 사용해서 작업//
            print("image name:", imageName)
            //ex) asset.JPG 형식으로 출력//
            print("photoURL:", photoURL)
            //ex) file:///var/mobile/Containers/Data/Application/C7BA5314-0853-4284-B122-4698A2E014D7/Documents/ 형식으로 출력//
            print("local path:", localPath)
            //ex) file:///var/mobile/Containers/Data/Application/A2C931B8-5388-4C1A-934A-5003C2E6DAB9/Documents/asset.JPG 형식으로 출력//
            
            let string_url = imageUrl.relativeString //해당값을 디비에 저장하면 된다.(NSURL -> String)//
            
            print("string path url:", string_url)
            
            image_url_label.text = string_url
            
            //let test_url = NSURL(string: string_url!) (String -> NSURL)
            
            getUIImagefromAsseturl(imageUrl) //assets-library형식으로 저장된 NSURL을 가지고 UIImage를 반환(이미지 적용)//
        }
        
        dismiss(animated: true, completion: nil) //사진 불러오기 뷰를 종료//
    }
    
    func getUIImagefromAsseturl (_ url: URL)
    {
        asset.asset(for: url, resultBlock: { asset in
            if let ast = asset
            {
                let assetRep = ast.defaultRepresentation()
                let iref = assetRep?.fullResolutionImage().takeUnretainedValue()
                let image = UIImage(cgImage: iref!)
                
                DispatchQueue.main.async(execute: {
                    // ...Update UI with image here
                    self.thumbnail_image.contentMode = .scaleAspectFit
                    self.thumbnail_image.image = image //썸네일 이미지 적용//
                })
            }
            }, failureBlock: { error in
                print("Error: \(error)")
        })
    }
    
    @IBAction func back_button(_ sender: UIBarButtonItem) //뒤로가기 버튼을 눌렀을 경우//
    {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func enroll_button(_ sender: AnyObject)
    {
        //회원가입을 위한 정보를 불러온다. 필요한 변수를 선언(Optional)//
        var input_name : String?
        var input_password : String?
        var input_confirm_password : String?
        var input_tel : String?
        var input_emailaddress : String?
        var input_id : String?
        var input_address : String?
        var input_imagepath : String?
        
        //승리/실패에 대한 기본값설정//
        let success = "0";
        let lose = "0";
        
        input_id = id_textfield.text //현재 변수가 '?'이니 박스에 id_textfield.text의 값을 저장하는 것과 같다.//
        input_password = password_field.text
        input_confirm_password = password_confirm.text
        input_name = name_textfield.text
        input_tel = tel_textfield.text
        input_emailaddress = email_textfield.text
        input_address = address_textfield.text
        input_imagepath = image_url_label.text
        
        print("id : "+input_id!) //출력을 할 때는 박스안에 저장되어 있는 값을 참조해야 하기 때문에 '!'로 강제해제 한다.//
        print("password : "+input_password!)
        print("confirm password : "+input_confirm_password!)
        print("tel : "+input_tel!)
        print("address : "+input_address!)
        print("email address : "+input_emailaddress!)
        print("name : "+input_name!)
        print("image path:", input_imagepath!)
        print("success value:", success)
        print("lose value:", lose)
        //assets-library://asset/asset.JPG?id=951AEE74-1474-4A4E-9B01-8E1A670640BD&ext=JPG//
        
        //enroll을 하기전 사용자는 모든 검사를 하고 해당 버튼을 누른다면 모든 정보가 무결성이 보장되는 정보가 된다.//
        //하지만 사용자가 실수로 등록버튼을 누를때를 대비해서 예외처리를 해준다.//
        if(id_check == false)
        {
            //비밀번호는 따로 버튼이 없기에 enroll로 등록//
            password_check = password_check_func(input_password!, input_confirm_password: input_confirm_password!);
            
            if(password_check == true)
            {
                //모든 검사조건이 만족할 경우 데이터베이스에 저장//
                let input_name_size = input_name?.lengthOfBytes(using: String.Encoding.utf8);
                
                if(input_name_size == 0) //이름도 반드시 입력하였는지 체크//
                {
                    let refreshAlert = UIAlertController(title: "enroll fail", message: "user name blank", preferredStyle: UIAlertControllerStyle.alert)
                    
                    //다이얼로그에 버튼 등록//
                    refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                        print("Handle Ok logic here")
                    }))
                    
                    present(refreshAlert, animated: true, completion: nil) //작성된 다이얼로그를 만들어 준다.//
                }
                
                else //이름이 입력된 경우//
                {
                    let refreshAlert = UIAlertController(title: "사용자 등록", message: "입력된 정보로 사용자 등록을 하시겠습니까?", preferredStyle: UIAlertControllerStyle.alert)
                    
                    //다이얼로그에 버튼 등록//
                    refreshAlert.addAction(UIAlertAction(title: "등록", style: .default, handler: { (action: UIAlertAction!) in
                        self.enroll_user_info(input_id!, user_password: input_password!, user_email: input_emailaddress!, user_tel: input_tel!,
                            user_address: input_address!, user_name: input_name!, user_profile_image: input_imagepath!, user_success:success, user_lose:lose) //해당 함수를 실행.//
                    }))
                    
                    refreshAlert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: { (action: UIAlertAction!) in
                        print("cancel enroll")
                    }))
                    
                    present(refreshAlert, animated: true, completion: nil) //작성된 다이얼로그를 만들어 준다.//
                }
            }
            
            else{
                let refreshAlert = UIAlertController(title: "enroll fail", message: "password not corrent", preferredStyle: UIAlertControllerStyle.alert)
                
                //다이얼로그에 버튼 등록//
                refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                    print("Handle Ok logic here")
                }))
                
                present(refreshAlert, animated: true, completion: nil) //작성된 다이얼로그를 만들어 준다.//
            }
        }
        
        else
        {
            let refreshAlert = UIAlertController(title: "enroll fail", message: "id not check", preferredStyle: UIAlertControllerStyle.alert)
            
            //다이얼로그에 버튼 등록//
            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                print("Handle Ok logic here")
            }))
            
            /*refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action: UIAlertAction!) in
                print("Handle Cancel Logic here")
            }))*/
            
            //다이얼로그를 실행.//
            present(refreshAlert, animated: true, completion: nil)
        }
    }
    
    @IBAction func id_check_button(_ sender: AnyObject)
    {
        //id검사를 해준다.//
        var id : String?
        
        id = id_textfield.text; //id를 불러온다.//
        
        //해당 id값을 가지고 데이터베이스에 저장되어 있는지 비교//
        id_check(id!) //두번째 인자부터는 받을 매개변수 명을 같이 적어준다.//
    }
    
    @IBOutlet weak var value: UILabel! //이전화면에서 받을 값//
    //var value_str : String = ""
    
    override func viewDidLoad()
    {
        super.viewDidLoad();
        
        //value.text = value_str; //이전 뷰로부터 데이터를 받는다.//
        imagePicker.delegate = self //해당 swift파일에서 delegate처리를 하겠다. (delegate == callback)
    }
    
    override func viewDidAppear(_ animated: Bool) //중복으로 호출가능.//
    {
        super.viewDidAppear(true)
        
        print("----<viewDidAppear>----")
        //기본적으로 데이터베이스의 연결과 테이블 생성작업을 한다.//
        //데이터베이스 연결. 우선적으로 데이터베이스에 연결을 하여야 해당 연결객체를 가지고 디비 자원을 이용할 수 있다.//
        db_connection_check = DB_Func_class.DB_Connection()
        
        print("DB Connection Check : ", db_connection_check)
        
        //테이블 생성. 테이블 생성은 기존에 있는 테이블일 경우 실패를 하기에 에러가 나도 예외처리의 문제는 없다.//
        db_table_check = DB_Func_class.DB_Table_Create()
        
        print("db table check : ", db_table_check)
        
        print("-----------------------")
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //빈 공간을 눌렀을때 키보드가 종료되는 것. 오버라이드해서 사용한다.//
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        id_textfield.resignFirstResponder();
        password_field.resignFirstResponder();
        password_confirm.resignFirstResponder();
        email_textfield.resignFirstResponder();
        tel_textfield.resignFirstResponder();
        address_textfield.resignFirstResponder();
        name_textfield.resignFirstResponder();
    }
    
    //아이디 검사함수//
    func id_check(_ search_id : String) //불값을 변화시킨다.//
    {
        print("----<Search id>-----")
        
        id_check = true //우선은 id체크가 실패했다고 가정//
        
        print("search id : "+search_id);
        print("check : ", id_check!) //'!'을 함으로서 박스를 강제적으로 해제하여 내부에 값을 사용한다.//
        
        if(db_connection_check == true)
        {
            //id 검색.//
            id_check = DB_Func_class.DB_Search_id(search_id); //DB Function class에 DB_Search()함수 호출.//
            //DB Function은 스위프트 디비관리 클래스이고, DB_Search클래스는 Object-C를 클래스로 구성된 함수//
            
            if(id_check == true)
            {
                var refreshAlert = UIAlertController(title: "ERROR Message", message: "이미 가입된 아이디 입니다. 다시 입력해주세요.", preferredStyle: UIAlertControllerStyle.alert)
                
                //다이얼로그에 버튼 등록//
                refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                    print("Handle Ok logic here")
                }))
                
                present(refreshAlert, animated: true, completion: nil)
            }
            
            else
            {
                var refreshAlert = UIAlertController(title: "Message", message: "사용가능한 아이디입니다.", preferredStyle: UIAlertControllerStyle.alert)
                
                //다이얼로그에 버튼 등록//
                refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                    print("Handle Ok logic here")
                }))
                
                present(refreshAlert, animated: true, completion: nil)
            }
        }
        
        else //데이터베이스 연결이 실패한 경우//
        {
            var refreshAlert = UIAlertController(title: "ERROR Message", message: "db connect error", preferredStyle: UIAlertControllerStyle.alert)
            
            //다이얼로그에 버튼 등록//
            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                print("Handle Ok logic here")
            }))
            
            //취소버튼 등록//
            /*refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action: UIAlertAction!) in
             print("Handle Cancel Logic here")
             }))*/
            
            present(refreshAlert, animated: true, completion: nil)
        }
        
        print("--------------------")
    }
    
    //패스워드 검사 함수//
    func password_check_func(_ input_password:String, input_confirm_password:String) -> Bool //Bool값으로 변환.//
    {
        var is_password_check = false; //우선은 잘못된 패스워드라 가정(변하는 변수이니 let말고 var를 사용)//
        
        print("----<Confirm password>-----")
        
        print("input password : ", input_password)
        print("input confirm password : ", input_confirm_password)
        
        //비밀번호 비교 및 유효성(최소 8자리이상) 검사//
        let input_size = input_password.lengthOfBytes(using: String.Encoding.utf8);
        
        print("input password size:", input_size)
        
        if(input_size >= 8)
        {
            //한번 더 확인차원에서 입력한 값하고 같은지 비교(스위프트에서는 문자열비교를 동등비교연산자로 가능)//
            if(input_password == input_confirm_password)
            {
                print("password correct")
                
                is_password_check = true
            }
        }
        
        else
        {
            is_password_check = false
        }
        
        return is_password_check
    }
    
    //사용자 정보 등록 메소드//
    func enroll_user_info(_ user_id:String, user_password:String, user_email:String, user_tel:String, user_address:String,user_name:String, user_profile_image:String, user_success:String, user_lose:String)
    {
        var is_enroll = false //처음 등록이 정상적으로 되지 않았다는 가정//
        
        print("----<Enroll user info>-----")
        
        print("user id:", user_id)
        print("user password:", user_password)
        print("user email:", user_email)
        print("user tel:", user_tel)
        print("user address:", user_address)
        print("user name:", user_name)
        print("user image:", user_profile_image)
        print("user success:", user_success)
        print("user lose:", user_lose)
    
        //브릿징 헤더로 디비 작업으로 넘긴다.//
        is_enroll = DB_Func_class.DB_Enroll_user_info(user_id, user_password: user_password, user_email: user_email, user_tel: user_tel, user_address: user_address, user_name: user_name,
        user_image: user_profile_image, user_success: user_success, user_lose: user_lose);
        
        if(is_enroll == true)
        {
            var refreshAlert = UIAlertController(title: "등록 성공", message: "사용자 정보를 등록하였습니다. 재미있게 게임을 즐기세요", preferredStyle: UIAlertControllerStyle.alert)
            
            //다이얼로그에 버튼 등록//
            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                self.success_enroll()
            }))
            
            present(refreshAlert, animated: true, completion: nil) //작성된 다이얼로그를 만들어 준다.//
        }
        
        else if(is_enroll == false)
        {
            var refreshAlert = UIAlertController(title: "등록 실패", message: "입력된 내용을 다시 확인하세요", preferredStyle: UIAlertControllerStyle.alert)
            
            //다이얼로그에 버튼 등록//
            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                print("Handle Ok logic here")
            }))
            
            present(refreshAlert, animated: true, completion: nil) //작성된 다이얼로그를 만들어 준다.//
        }
    }
    
    func success_enroll()
    {
        dismiss(animated: true, completion: nil)
        
        print("--------------------")
    }
}

