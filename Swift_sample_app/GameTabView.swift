//
//  GameTabView.swift
//  Swift_sample_app
//
//  Created by apple on 2016. 10. 29..
//  Copyright © 2016년 apple. All rights reserved.
//

import Foundation
import UIKit
import SwiftHTTP //HTTP통신을 쉽게 할 수 있는 모듈//
import AssetsLibrary //이미지, 동영상 등 리소스 작업을 하기 위한 라이브러리//
import JSONJoy

class GameTabView : UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    var info_str : String = "게임 탭"
    
    let server_domain = "http://192.168.0.11:3000"
    
    var upload_image_url : URL? = nil //업로드할 이미지의 경로가 저장되는 변수//
    
    var asset = ALAssetsLibrary()
    //이미지 불러오기//
    let imagePicker = UIImagePickerController() //UIImagePickerController()객체 선언//
    
    @IBOutlet weak var log_label: UILabel!
    @IBOutlet weak var param1_text: UITextField!
    @IBOutlet weak var param2_text: UITextField!
    @IBOutlet weak var imageurl_text: UILabel!
    @IBOutlet weak var imageview: UIImageView!
    
    @IBAction func get_imagebutton(_ sender: UIButton) {
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
            
            imageurl_text.text = string_url
            
            //let test_url = URL(string: string_url) //(String -> NSURL)
            
            //print("URL: ", test_url)
            
            getUIImagefromAsseturl(imageUrl) //assets-library형식으로 저장된 NSURL을 가지고 UIImage를 반환(이미지 적용)//
            
            upload_image_url = imageUrl as URL?
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
                
                print("image value: ", iref)
                
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self //해당 swift파일에서 delegate처리를 하겠다. (delegate == callback)
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
    
    //빈 공간을 눌렀을때 키보드가 종료되는 것. 오버라이드해서 사용한다.//
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        param1_text.resignFirstResponder()
        param2_text.resignFirstResponder()
    }
    
    @IBAction func GET_trans_button(_ sender: UIButton) {
        var progress = ProgressDialog(delegate: self)
        
        print("GET call")
        
        let params = ["text1":param1_text.text, "text2":param2_text.text]
        
        progress.Show(true, mesaj: "Loading...")
        
        //GET방식으로 호출//
        do{
            let opt = try HTTP.GET(server_domain+"/test/get", parameters: params)
            opt.start { response in
                if let err = response.error{
                    print("error:\(err.localizedDescription)")
                    return
                }
            }
            
            opt.onFinish = { response in
                //do stuff
                if(response.statusCode == 200)
                {
                    print("status-code:\(response.statusCode!)")
                    print("--------------")
                    print("text is:\(response.text!)")
                    
                    progress.Close()
                    
                    self.set_data(response_str: response.text!) //데이터를 셋팅//
                }
                    
                else{
                    print("error code");
                }
            }
        }
            
        catch let error{
            print("got an error creating the request: \(error)")
        }
        
        self.param1_text.text = ""
        self.param2_text.text = ""
    }
    
    @IBAction func POST_trans_button(_ sender: UIButton) {
        print("POST call");
        
        var progress = ProgressDialog(delegate: self)
        
        progress.Show(true, mesaj: "Loading...")
        
        //POST방식은 바디에 데이터가 들어간다.//
        let params = ["text1":param1_text.text, "text2":param2_text.text]
        
        do{
            let opt = try HTTP.POST(server_domain+"/test/post", parameters: params)
            opt.start { response in
            //do things...
                if let err = response.error
                {
                    print("error:\(err.localizedDescription)")
                    return
                }
            }
            
            opt.onFinish = { response in
                //do stuff
                if(response.statusCode == 200)
                {
                    print("status-code:\(response.statusCode!)")
                    print("--------------")
                    print("text is:\(response.text!)")
                    
                    progress.Close()
                    
                    self.set_data(response_str: response.text!) //데이터를 셋팅//
                }
                    
                else{
                    print("error code");
                }
            }
        }
            
        catch let error {
            print("got an error creating the request: \(error)")
        }
        
        self.param1_text.text = ""
        self.param2_text.text = ""
    }
    
    @IBAction func post_multipart_button(_ sender: UIButton) {
        print("upload file")
        
        var progress = ProgressDialog(delegate: self)
        progress.Show(true, mesaj: "Loading...")
        
        //let fileUrl = URL(fileURLWithPath: upload_image_url)
        
        do {
            let opt = try HTTP.POST(server_domain+"/test/file_upload", parameters: ["text1":param1_text.text,"text2":param2_text.text, "file": Upload(fileUrl:upload_image_url!)])
            opt.start { response in
                //do things...
                if let err = response.error
                {
                    print("error:\(err.localizedDescription)")
                    return
                }
            }
            
            opt.onFinish = { response in
                //do stuff
                
                if(response.statusCode == 200)
                {
                    print("status-code:\(response.statusCode!)")
                    print("--------------")
                    print("text is:\(response.text!)")
                    
                    progress.Close()
                    
                    self.set_data(response_str: response.text!) //데이터를 셋팅//
                }
                    
                else{
                    print("error code");
                }
            }
        }
            
        catch let error {
            print("got an error creating the request: \(error)")
        }
        
        self.param1_text.text = ""
        self.param2_text.text = ""
    }
    
    func set_data(response_str : String)
    {
        var response_data = response_str
        
        print("response data: ", response_data)
        
        //JSON Parsing//
        do {
            var result = try Request(JSONDecoder(response_data))
            
            var method_str : String = result.method
            var text1_str : String = result.data.text1
            var text2_str : String = result.data.text2
            var question : String = result.data.question
            
            print("method: \(result.method)")
            print("text1: \(result.data.text1)")
            print("text2: \(result.data.text2)")
            print("question: \(result.data.question)")
            
            self.log_label.text = method_str + "/" + text1_str + "/" + text2_str + "/ 퀴즈: " + question
            
            //That's it! The object has all the appropriate properties mapped.
        } catch {
            print("unable to parse the JSON")
        }
    }
}
