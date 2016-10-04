//
//  MemberInfoDetailView.swift
//  Swift_sample_app
//
//  Created by apple on 2016. 9. 27..
//  Copyright © 2016년 apple. All rights reserved.
//

import UIKit //ios에서 코코아 프레임워크를 사용하기 위한 것(UI작업을 하기위해서 import)//
import AssetsLibrary //이미지 로드를 위해 필요한 라이브러리//

class MemberInfoDetailView : UIViewController
{
    //앞선 스토리보드에서 넘어온 값을 저장//
    var member_id : String = ""
    var member_name : String = ""
    var member_imageUrl : String = ""
    var member_address : String = ""
    var member_emailaddress : String = ""
    var member_phonenumber : String = ""
    var member_success : String = ""
    var member_lose : String = ""
    
    var asset = ALAssetsLibrary()
    
    //사용된 위젯정의//
    @IBOutlet weak var user_image: UIImageView!
    @IBOutlet weak var user_name: UILabel!
    @IBOutlet weak var user_phone: UILabel!
    @IBOutlet weak var user_address: UILabel!
    @IBOutlet weak var user_email: UILabel!
    @IBOutlet weak var user_success: UILabel!
    @IBOutlet weak var user_lose: UILabel!
    
    
    @IBAction func backbutton(_ sender: UIBarButtonItem)
    {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad();
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(true)
        
        load_user_info() //사용자의 정보를 설정//
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func load_user_info()
    {
        user_name.text = member_name
        user_email.text = member_emailaddress
        user_address.text = member_address
        user_phone.text = member_phonenumber
        user_success.text = member_success
        user_lose.text = member_lose
        
        //이미지 설정//
        //String -> NSURL//
        let fileUrl = URL(string: self.member_imageUrl)
        
        //이미지는 해당 함수를 호출하여 설정//
        //getUIImagefromAsseturl(fileUrl!) //assets-library형식으로 저장된 NSURL을 가지고 UIImage를 반환(이미지 적용)//
        
        asset.asset(for: fileUrl!, resultBlock: { asset in
            if let ast = asset
            {
                let assetRep = ast.defaultRepresentation()
                let iref = assetRep?.fullResolutionImage().takeUnretainedValue()
                let image = UIImage(cgImage: iref!)
                
                DispatchQueue.main.async(execute: {
                    // ...Update UI with image here
                    self.user_image?.image = image //썸네일 이미지 적용//
                })
            }
            }, failureBlock: { error in
                print("Error: \(error)")
        })
    }
}

