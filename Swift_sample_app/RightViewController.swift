//
//  RightViewController.swift
//  Swift_sample_app
//
//  Created by apple on 2017. 1. 24..
//  Copyright © 2017년 apple. All rights reserved.
//

import Foundation
import UIKit
import Alamofire //네트워크 라이브러리//
import SwiftyJSON //JSON파싱 라이브러리//
import Kingfisher //이미지 로더 클래스//

class RightViewController : UIViewController, UITableViewDataSource, UITableViewDelegate{
    //서버의 ip주소와 포트번호//
    var server_ip_address:String = "192.168.0.9"
    var server_port_number = "3000"
    
    var user_id_str:String = ""
    //Key//
    let userNameKeyConstant = "userid"
    
    @IBOutlet weak var subview: UIView!
    @IBOutlet weak var menu_tableview: UITableView!
    
    @IBOutlet weak var profile_imageview: UIImageView!
    @IBOutlet weak var name_label: UILabel!
    @IBOutlet weak var gender_labbel: UILabel!
    @IBOutlet weak var id_label: UILabel!
    @IBOutlet weak var email_label: UILabel!
    
    /** TableView 관련 Swipe Refresh 이벤트 **/
    var refreshControl: UIRefreshControl!
    
    //메뉴항목 정의//
    var menu_name_array = ["사용자 정보 수정", "설정"] //위치정보를 가지고 있는 배열//
    var menu_icon_array = ["menu_edit_icon.png", "menu_setting_icon.png"] //메뉴정보 아이콘을 가지고 있는 배열//
    
    // Don't forget to enter this in IB also
    let cellReuseIdentifier = "rightviewtablecell" //UITableViewCell의 id가 된다.//
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /** CustomCell 설정 **/
        self.menu_tableview.delegate = self
        self.menu_tableview.dataSource = self
        
        // set up the refresh control
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        
        //Swift3에서부터는 action사용 시 #selector가 필요.//
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: UIControlEvents.valueChanged)
        
        menu_tableview.addSubview(refreshControl) //리플래시 화면을 보일(빙글빙글 돌아가는 프로그래스바)뷰를 장착.//
        
        //뷰의 배경화면을 설정//
        self.subview.backgroundColor = UIColor(patternImage: UIImage(named: "background_drawer.png")!)
        
        //공유저장소에 저장된 값을 불러온다.//
        let defaults = UserDefaults.standard
        
        if let user_id = defaults.string(forKey: userNameKeyConstant) {
            //print("user id: ", user_id)
            user_id_str = user_id
        }
        
        print("user id: ", user_id_str)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        //공유저장소에 저장된 값을 불러온다.//
        let defaults = UserDefaults.standard
        
        if let user_id = defaults.string(forKey: userNameKeyConstant) {
            //print("user id: ", user_id)
            user_id_str = user_id
        }
        
        print("user id: ", user_id_str)
        
        //프로필 정보를 불러온다.//
        get_user_profile_info(user_id:user_id_str)
    }
    
    //당겨서 새로고침//
    func refresh(_ sender:AnyObject) {
        // Code to refresh table view
        print("refresh table")
        
        menu_tableview.reloadData() //뷰를 재로드//
        
        refreshControl.endRefreshing() //다시 새로고침을 끝낸다.//
    }
    
    //적용된 UITableView관련 필수 메소드를 오버라이드 해준다.(테이블의 행의 개수를 설정)//
    //UITableView는 옵셔널이기에 사용 시 '!'로 강제 풀어준다.//
    func tableView(_ tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return self.menu_name_array.count //자기자신은 제외되기에 -1//
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        //각 테이블뷰의 섹션을 나눈다(섹션이 나누어진다.)//
        return 1
    }
    
    //리스트뷰 데이터 초기화 부분//
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell!
    {
        //UITableCell이 아닌 Custom된(UITableCell을 상속하여 구현된 클래스)것을 적어준다.//
        //dequeueReusableCellWithIdentifier로 RecyclerView의 원리를 적용한다.//
        let cell:RightViewTableCell = self.menu_tableview.dequeueReusableCell(withIdentifier: self.cellReuseIdentifier) as! RightViewTableCell
        let row = indexPath.row
        
        /** 커스텀 Cell에 데이터 초기화 **/
        cell.menu_label.text = self.menu_name_array[row]
        cell.menu_imageview.image = UIImage(named: self.menu_icon_array[row])!
        
        return cell
    }
    
    //리스트의 항목을 클릭할떄의 이벤트//
    //리스트뷰 선택//
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \((indexPath as NSIndexPath).row).")
        
        //각 인덱스에 따른 세그웨이 적용//
        switch indexPath.row{
            case 0: self.performSegue(withIdentifier: "usereditmove", sender: self);
                break;
            
            case 1: self.performSegue(withIdentifier: "settingview", sender: self);
                break;
            
            default:
                break
        }
    }
    
    func get_user_profile_info(user_id:String){
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
        
        //각 위젯에 등록//
        name_label.text = user_name
        id_label.text = user_id
        email_label.text = user_email
        
        if(user_gender == "male"){
            gender_labbel.text = "남성"
        }
            
        else if(user_gender == "female"){
            gender_labbel.text = "여성"
        }
        
        //이미지 로드//
        let url = URL(string: user_profileimageurl) //이미지 로딩(비동기, 캐싱기능 포함)//
        let processor = RoundCornerImageProcessor(cornerRadius: 90) //이미지 변형(동그랗게 자르기)//
        //let processor_multi = BlurImageProcessor(blurRadius: 4) >> RoundCornerImageProcessor(cornerRadius: 40)
        
        profile_imageview.kf.setImage(with: url, options: [.processor(processor)])
        //profile_imageview.kf.setImage(with: url)
    }
}
