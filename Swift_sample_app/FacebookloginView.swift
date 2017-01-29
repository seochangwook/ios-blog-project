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
import AssetsLibrary //이미지, 동영상 등 리소스 작업을 하기 위한 라이브러리//
import FacebookCore //페이스북 연동관련 코어 라이브러리//
import FacebookLogin //페이스북 로그인 관련 라이브러리//

class FacebookloginView : UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    //서버의 ip주소와 포트번호//
    var server_ip_address:String = "192.168.0.10"
    var server_port_number = "3000"
    
    //Key//
    let userNameKeyConstant = "userid"
    
    var text:String = "";
    var accesstoken:String = "";
    
    //데이터를 가지고 있을 배열//
    var message_array = [String]()
    var date_array = [String]()
    
    //파일 데이터를 가지고 있을 배열//
    var file_array = [String]()
    var file_num_array = [String]()
    
    @IBOutlet weak var info_label: UILabel!
    @IBOutlet weak var network_state_info: UILabel!
    @IBOutlet weak var info_label2: UILabel!
    @IBOutlet weak var info_label3: UILabel!
    @IBOutlet weak var imageview_thumbnail: UIImageView!
    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var imageview_2: UIImageView!
    @IBOutlet weak var imageview_3: UIImageView!
    @IBOutlet weak var image_path: UILabel!
    @IBOutlet weak var fb_login_status_label: UILabel!
    
    var upload_image_url:String = ""; //업로드할 파일의 경로가 저장되는 변수//
    
    var asset = ALAssetsLibrary()
    //이미지 불러오기//
    let imagePicker = UIImagePickerController() //UIImagePickerController()객체 선언//
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self //해당 swift파일에서 delegate처리를 하겠다. (delegate == callback)
        
        /*let myLoginButton = UIButton(type: .custom)
        myLoginButton.backgroundColor = UIColor.darkGray
        myLoginButton.frame = CGRectMake(0, 100, 100, 40);
        myLoginButton.center = view.center;
        myLoginButton.setTitle("FB Login", for: .normal)
        
        //Handle clicks on the button
        myLoginButton.addTarget(self, action: #selector(self.login_state), for: .touchUpInside)
        
        // Add the button to the view
        view.addSubview(myLoginButton)*/
    }
    
    /*func login_state() {
        let loginManager = LoginManager() //페이스북 로그인에 대한 상태를 관리를 클래스//
        
        //권한을 가지고 로그인 시도//
        loginManager.logIn([.publicProfile, .email], viewController: self){ LoginResult in
            //로그인 성공유무에 따른 판단//
            switch LoginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                self.accesstoken = accessToken as! String
                print("Logged in! (" + self.accesstoken + ")")
                
                self.fb_login_status_label.text = "login status..."
            }
        }
    }*/
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        print(text);
        
        info_label.text = text
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func get_image_button(_ sender: UIButton) {
        print("get image")
        
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
        
            //print("image path:", imageUrl)
            //ex) assets-library://asset/asset.JPG?id=20BA9B63-354F-4B2C-AB30-DB453BF03ACD&ext=JPG 형식으로 출력//
            //ios는 기본적으로 assets-library로 경로를 출력한다. -> ALAssetsLibrary 사용해서 작업//
            //print("image name:", imageName)
            //ex) asset.JPG 형식으로 출력//
            //print("photoURL:", photoURL)
            //ex) file:///var/mobile/Containers/Data/Application/C7BA5314-0853-4284-B122-4698A2E014D7/Documents/ 형식으로 출력//
            //print("local path:", localPath)
            //ex) file:///var/mobile/Containers/Data/Application/A2C931B8-5388-4C1A-934A-5003C2E6DAB9/Documents/asset.JPG 형식으로 출력//
            
            let string_url = imageUrl.relativeString //해당값을 디비에 저장하면 된다.(NSURL -> String)//
            
            print("string path url:", string_url)
            
            image_path.text = string_url
            
            //let test_url = URL(string: string_url) //(String -> NSURL)
            
            //print("URL: ", test_url)
            
            upload_image_url = string_url
            
            getUIImagefromAsseturl(imageUrl) //assets-library형식으로 저장된 NSURL을 가지고 UIImage를 반환(이미지 적용)//
        }
        
        dismiss(animated: true, completion: nil) //사진 불러오기 뷰를 종료//
    }
    
    func getUIImagefromAsseturl (_ url: URL)
    {
        print("image url: ", url)
        
        asset.asset(for: url, resultBlock: { asset in
            if let ast = asset
            {
                let assetRep = ast.defaultRepresentation()
                let iref = assetRep?.fullResolutionImage().takeUnretainedValue()
                let image = UIImage(cgImage: iref!)
                
                print("image value: ", iref)
                
                DispatchQueue.main.async(execute: {
                    // ...Update UI with image here
                    self.imageview_thumbnail.contentMode = .scaleAspectFit
                    self.imageview_thumbnail.image = image //썸네일 이미지 적용//
                })
            }
            }, failureBlock: { error in
                print("Error: \(error)")
        })
    }
    
    //페이스북 로그인(커스텀 버튼)//
    @IBAction func FB_loginbutton(_ sender: UIButton) {
        let loginManager = LoginManager() //페이스북 로그인에 대한 상태를 관리를 클래스//
        
        /*로그인을 하기 전 AccessToken.current를 가지고 중복 로그인에 대해서 검사할 수 있다. 자동로그인을 적용하면 로그인 페이지는
         생략하기에 우회할 수 있다.*/
        
        //권한을 가지고 로그인 시도(비동기)//
        loginManager.logIn([.publicProfile, .email], viewController: self){ LoginResult in
            //로그인 성공유무에 따른 판단//
            switch LoginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success( _, _, let accessToken):
                self.fb_login_status_label.text = "login status..."
                
                self.accesstoken = accessToken.authenticationToken //AccessToken값을 추출//
                print("accessToken : " + self.accesstoken)
                
                //서버로 AccessToken값 전송//
                print("Login data trans...")
                
                var progress = ProgressDialog(delegate: self)
                
                let fcmToken = "fcmtoken"
                
                //파라미터 설정//
                let parameters = [
                    "accessToken":self.accesstoken,
                    "fcmtoekn":fcmToken
                ]
                
                progress.Show(true, mesaj: "Loading...")
                
                //호출//
                Alamofire.request("http://"+self.server_ip_address+":"+self.server_port_number+"/login/auth/facebook", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
                    
                    //swift-case로 응답성공/실패를 분리//
                    switch(response.result) {
                    case .success(_):
                        if let data = response.result.value{
                            print(response.result.value!)
                            
                            //JSON값을 가지고 파싱//
                            let json = JSON(data)
                            
                            var result_str = json["message"].stringValue
                            var get_user_id = json["id"].stringValue
                            
                            print("result: " + result_str + "/" + get_user_id)
                            
                            //네트워크 작업을 다 완료 후 수행(async - 비동기 작업)//
                            DispatchQueue.main.async {
                                progress.Close()
                                print("Network job finish...(" + get_user_id + ")")
                                
                                //공유저장소등에 저장(최초 로그인 작업 시 유저의 정보를 저장)//
                                let defaults = UserDefaults.standard
                                defaults.set(get_user_id, forKey: self.userNameKeyConstant)
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
        }
    }
    
    //페이스북 로그아웃 버튼(커스텀 버튼)//
    @IBAction func FB_logoutbutton(_ sender: UIButton) {
        let loginManager = LoginManager()
        
        loginManager.logOut()
        
        self.fb_login_status_label.text = "logout status..."
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
        
        print("get Message list...")
        
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
    
    //사진첩에서 선택된 이미지파일의 URL을 서버로 전송(저장)//
    @IBAction func upload_button(_ sender: UIButton) {
        print("file upload(URL)...")
        
        var progress = ProgressDialog(delegate: self)
        
        let parameters = [
            "fileurl":upload_image_url,
        ]
        
        progress.Show(true, mesaj: "Loading...")
        
        //호출//
        Alamofire.request("http://"+server_ip_address+":"+server_port_number+"/function/ios_file_upload", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            
            //swift-case로 응답성공/실패를 분리//
            switch(response.result) {
            case .success(_):
                if let data = response.result.value{
                    print(response.result.value!)
                    
                    self.info_label3.text = "Success"
                    
                    progress.Close()
                }
                break
                
            case .failure(_):
                print(response.result.error!)
                break
                
            }
        }
    }
    
    @IBAction func get_filelist_button(_ sender: UIButton) {
        //배열 초기화//
        self.file_array.removeAll()
        self.file_num_array.removeAll()
        
        print("get filelist...")
        
        var progress = ProgressDialog(delegate: self)
        
        progress.Show(true, mesaj: "Loading...")
        
        //GET방식은 URLEncoding//
        Alamofire.request("http://"+server_ip_address+":"+server_port_number+"/function/ios_file_list", method: .get, encoding: URLEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                if let data = response.result.value{
                    print(response.result.value!)
                    
                    //JSON값을 가지고 파싱//
                    let json = JSON(data)
                    
                    for item in json["results"].arrayValue {
                        var filelist_str:String = item["file_num"].stringValue + ":" + item["file_url"].stringValue
                        
                        self.file_array.append(item["file_url"].stringValue)
                        self.file_num_array.append(item["file_num"].stringValue)
                        
                        print(filelist_str)
                    }
                    
                    //이미지 출력(테이블뷰랑 호환//
                    self.Print_get_image(file_array:self.file_array, file_num_array:self.file_num_array)
                    
                    progress.Close()
                }
                break
                
            case .failure(_):
                print(response.result.error)
                break
                
            }
        }
    }
    
    func Print_get_image(file_array:[String], file_num_array:[String]){
        for item in file_num_array{
            if(item == "3"){
                print("image num : ", item)
                print("image url : ", file_array[0])
                
                //String -> NSURL//
                let fileUrl = URL(string: file_array[0])
                
                asset.asset(for: fileUrl!, resultBlock: { asset in
                    if let ast = asset
                    {
                        let assetRep = ast.defaultRepresentation()
                        let iref = assetRep?.fullResolutionImage().takeUnretainedValue()
                        let image = UIImage(cgImage: iref!)
                        
                        DispatchQueue.main.async(execute: {
                            // ...Update UI with image here
                            self.imageview.contentMode = .scaleAspectFit
                            self.imageview.image = image //썸네일 이미지 적용//
                        })
                    }
                    }, failureBlock: { error in
                        print("Error: \(error)")
                })
            }
            
            else if(item == "4"){
                print("image num : ", item)
                print("image url : ", file_array[1])
                
                //String -> NSURL//
                let fileUrl = URL(string: file_array[1])
                
                asset.asset(for: fileUrl!, resultBlock: { asset in
                    if let ast = asset
                    {
                        let assetRep = ast.defaultRepresentation()
                        let iref = assetRep?.fullResolutionImage().takeUnretainedValue()
                        let image = UIImage(cgImage: iref!)
                        
                        DispatchQueue.main.async(execute: {
                            // ...Update UI with image here
                            self.imageview_2.contentMode = .scaleAspectFit
                            self.imageview_2.image = image //썸네일 이미지 적용//
                        })
                    }
                    }, failureBlock: { error in
                        print("Error: \(error)")
                })
            }
            
            else if(item == "5"){
                print("image num : ", item)
                print("image url : ", file_array[2])
                
                //String -> NSURL//
                let fileUrl = URL(string: file_array[2])
                
                asset.asset(for: fileUrl!, resultBlock: { asset in
                    if let ast = asset
                    {
                        let assetRep = ast.defaultRepresentation()
                        let iref = assetRep?.fullResolutionImage().takeUnretainedValue()
                        let image = UIImage(cgImage: iref!)
                        
                        DispatchQueue.main.async(execute: {
                            // ...Update UI with image here
                            self.imageview_3.contentMode = .scaleAspectFit
                            self.imageview_3.image = image //썸네일 이미지 적용//
                        })
                    }
                    }, failureBlock: { error in
                        print("Error: \(error)")
                })
            }
        }
    }
    
    func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
        return CGRect(x: x, y: y, width: width, height: height)
    }
}
