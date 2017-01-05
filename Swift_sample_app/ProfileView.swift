//
//  ProfileView.swift
//  Swift_sample_app
//
//  Created by apple on 2016. 12. 31..
//  Copyright © 2016년 apple. All rights reserved.
//

import Foundation
import UIKit
import Alamofire //네트워크 라이브러리//
import SwiftyJSON //JSON파싱 라이브러리//
import Kingfisher //이미지 로더 클래스//

class ProfileView : UIViewController, UITableViewDataSource, UITableViewDelegate{
    //서버의 ip주소와 포트번호//
    var server_ip_address:String = "192.168.0.7"
    var server_port_number = "3000"
    
    //Key//
    let userNameKeyConstant = "userid"
    
    @IBOutlet weak var name_label: UILabel!
    @IBOutlet weak var email_label: UILabel!
    @IBOutlet weak var gender_label: UILabel!
    @IBOutlet weak var profile_imageview: UIImageView!
    @IBOutlet weak var user_id_label: UILabel!
    
    @IBOutlet weak var user_tableview: UITableView!
    
    var info_text:String = "User Profile info"
    var user_id_str:String = "";
    var user_profileimage_str:String = ""
    
    /** TableView 관련 Swipe Refresh 이벤트 **/
    var refreshControl: UIRefreshControl!
    
    // Don't forget to enter this in IB also
    let cellReuseIdentifier = "usertableviewcell" //UITableViewCell의 id가 된다.//
    let listviewheaderIdentifier = "usertableviewheader"
    let listviewfooterIdentifier = "usertableviewfooter"
    
    //데이터에 필요한 배열 및 변수//
    var page_count:String = "10"; //기본 10//
    
    var user_id_array = [String]()
    var user_name_array = [String]()
    var user_email_array = [String]()
    var user_gender_array = [String]()
    var user_profile_array = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /** CustomCell 설정 **/
        self.user_tableview.delegate = self
        self.user_tableview.dataSource = self
        
        // set up the refresh control
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        
        //Swift3에서부터는 action사용 시 #selector가 필요.//
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: UIControlEvents.valueChanged)
        
        user_tableview.addSubview(refreshControl) //리플래시 화면을 보일(빙글빙글 돌아가는 프로그래스바)뷰를 장착.//
        
        load_userlist(page_count: page_count) //데이터 로드//
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        //공유저장소에 저장된 값을 불러온다.//
        let defaults = UserDefaults.standard
        
        if let user_id = defaults.string(forKey: userNameKeyConstant) {
            //print("user id: ", user_id)
        
            user_id_str = user_id
        }
        
        get_userProfile(user_id: user_id_str) //데이터 로드//
        load_userlist(page_count: page_count) //데이터 로드//
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func refresh_button(_ sender: UIBarButtonItem) {
        print("refresh user info")
        
        //공유저장소에 저장된 값을 불러온다.//
        let defaults = UserDefaults.standard
        
        if let user_id = defaults.string(forKey: userNameKeyConstant) {
            //print("user id: ", user_id)
            user_id_str = user_id
        }
        
        get_userProfile(user_id: user_id_str)
        
        //페이지카운트 초기화 및 배열 초기화//
        page_count = "10"
        
        self.user_profile_array.removeAll()
        self.user_gender_array.removeAll()
        self.user_email_array.removeAll()
        self.user_name_array.removeAll()
        self.user_id_array.removeAll()
        
        load_userlist(page_count: page_count) //데이터 로드//
    }
    
    //적용된 UITableView관련 필수 메소드를 오버라이드 해준다.(테이블의 행의 개수를 설정)//
    //UITableView는 옵셔널이기에 사용 시 '!'로 강제 풀어준다.//
    func tableView(_ tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return self.user_id_array.count //자기자신은 제외되기에 -1//
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        //각 테이블뷰의 섹션을 나눈다(섹션이 나누어진다.)//
        return 1
    }
    
    //리스트뷰 데이터 초기화 부분//
    func tableView(_ tableView: UITableView!, cellForRowAt indexPath: IndexPath) -> UITableViewCell!
    {
        //UITableCell이 아닌 Custom된(UITableCell을 상속하여 구현된 클래스)것을 적어준다.//
        //dequeueReusableCellWithIdentifier로 RecyclerView의 원리를 적용한다.//
        let cell:UserListViewTableCell = self.user_tableview.dequeueReusableCell(withIdentifier: self.cellReuseIdentifier) as! UserListViewTableCell
        let row = indexPath.row
        
        /** 커스텀 Cell에 데이터 초기화 **/
        cell.user_id_label?.text = self.user_id_array[row]
        cell.user_name_label?.text = self.user_name_array[row]
        cell.user_email_label?.text = self.user_email_array[row]
        cell.user_gender_label?.text = self.user_gender_array[row]
        
        //이미지 셋팅//
        //이미지 로드//
        let url = URL(string: self.user_profile_array[row]) //이미지 로딩(비동기, 캐싱기능 포함)//
        let processor = RoundCornerImageProcessor(cornerRadius: 80) //이미지 변형(동그랗게 자르기)//
        //let processor_multi = BlurImageProcessor(blurRadius: 4) >> RoundCornerImageProcessor(cornerRadius: 40)
        
        cell.profile_imageview?.kf.setImage(with: url, options: [.processor(processor)])
        //profile_imageview.kf.setImage(with: url)
        
        //버튼 설정//
        if(self.user_id_array[row] == self.user_id_str){
            cell.chatting_button?.setImage(UIImage(named: "my_info_button.png"), for: UIControlState.normal)
        }
        
        cell.chatting_button?.tag = row //태그등록//
        //cell.chatting_button?.addTarget(self, action: #selector(self.makeSegue), for: UIControlEvents.touchUpInside)
        
        return cell
    }
    
    /*func makeSegue()
    {
        //TODO: 버튼클릭 이벤트 처리//
        print("button click")
    }*/
    
    func more_content()
    {
        //TODO: 버튼클릭 이벤트 처리//
        print("more content button click")
        
        page_count = String(Int(page_count)! + 10) //페이지 카운트 증가//
        
        print("more page count : ", page_count)
        
        //증가된 페이지 카운트 수를 가지고 다시 재구성(refresh 시 다시 초기 10으로 돌아감)//
        self.user_profile_array.removeAll()
        self.user_gender_array.removeAll()
        self.user_email_array.removeAll()
        self.user_name_array.removeAll()
        self.user_id_array.removeAll()
        
        load_userlist(page_count: page_count) //데이터 로드//
    }
    
    //당겨서 새로고침//
    func refresh(_ sender:AnyObject) {
        // Code to refresh table view
        print("refresh table")
        
        self.user_profile_array.removeAll()
        self.user_gender_array.removeAll()
        self.user_email_array.removeAll()
        self.user_name_array.removeAll()
        self.user_id_array.removeAll()
        
        load_userlist(page_count: page_count) //데이터 로드//
    }
    
    //리스트뷰 선택//
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \((indexPath as NSIndexPath).row).")
    }
    
    //테이블뷰 헤더뷰 설정//
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = self.user_tableview.dequeueReusableCell(withIdentifier: self.listviewheaderIdentifier)as? UserListViewHeader
        
        //headerCell?.backgroundColor = UIColor.cyan
        
        //각 섹션마다 정보를 다르게 해준다.(복합리스트 가능)//
        switch (section)
        {
        case 0:
            //해당 섹션에서 필요한 작업을 해준다.(셀)//
            headerCell?.user_count_label?.text = String(self.user_id_array.count)
            
            break
            
        default:
            
            break
            
        }
        
        
        return headerCell
    }
    
    //테이블에 대한 푸터뷰 작업//
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerCell = self.user_tableview.dequeueReusableCell(withIdentifier: self.listviewfooterIdentifier)as? UserListViewFooter
        
        //버튼 설정//
        footerCell?.more_button?.addTarget(self, action: #selector(self.more_content), for: UIControlEvents.touchUpInside)
        
        return footerCell
    }
    
    //헤더뷰의 높이 설정//
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch(section)
        {
        case 0:
            return 30.0
            
            break
        default:
            return 40.0
            
            break
        }
    }
    
    //푸터뷰의 높이 설정//
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 30.0
    }
    
    //스토리보드 이동(Modal방식,Push방식)//
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        //이동할 스토리보드의 id저장.값이 변할 수 있는 것은 가변타입(var)로 한다. 고정값(상수)이면 let//
        var segue_id : String = ""
        segue_id = segue.identifier!
        
        //identifier값으로 비교한다.//
        print("segue id : [",segue_id+"] id")
        
        //스토리보드의 id값을 가지고 이동할 스토리보드를 선택한다.//
        if(segue_id == "messageroom")
        {
            let button = sender as? UIButton //현재 UIButton의 프로토콜로 왔으니 sender를 UIButton으로 캐스팅한다.//
            let cell_position = button?.tag //버튼의 tag값을 가져온다.(tag: 선택된 셀의 row값)//
            
            //UINavigation에서의 값 전달도 일반적으로 destination을 설정해서 한다.//
            let destination = segue.destination as! MessageRoom //이동할 스토리보드를 정의//
                
            print("move sotryboard...")
                
            //이동할 스토리보드에 있는 값을 받을 변수설정(안드로이드에서는 해당 기능을 인텐트로 구현)//
            destination.sender_id = self.user_id_label.text!
            destination.sender_name = self.name_label.text!
            destination.sender_profileimage = self.user_profileimage_str
            destination.receiver_id = self.user_id_array[cell_position!]
            destination.receiver_name = self.user_name_array[cell_position!]
            destination.receiver_profileimage = self.user_profile_array[cell_position!]
        }
    }
    
    func get_userProfile(user_id:String){
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
        
        name_label.text = user_name
        email_label.text = user_email
        user_id_label.text = user_id
        user_profileimage_str = user_profileimageurl
        
        if(user_gender == "male"){
            gender_label.text = user_gender + "(남자)"
        }
        
        else if(user_gender == "female"){
            gender_label.text = user_gender + "(여자)"
        }
        
        //이미지 로드//
        let url = URL(string: user_profileimageurl) //이미지 로딩(비동기, 캐싱기능 포함)//
        let processor = RoundCornerImageProcessor(cornerRadius: 80) //이미지 변형(동그랗게 자르기)//
        //let processor_multi = BlurImageProcessor(blurRadius: 4) >> RoundCornerImageProcessor(cornerRadius: 40)
        
        profile_imageview.kf.setImage(with: url, options: [.processor(processor)])
        //profile_imageview.kf.setImage(with: url)
    }
    
    func load_userlist(page_count:String){
        if(self.user_id_array.count != 0){
            print("refresh table")
            
            user_tableview.reloadData() //뷰를 재로드//
            
            refreshControl.endRefreshing() //다시 새로고침을 끝낸다.//
        }
        
        else{
            print("---------------------------")
            
            print("page count: ", page_count)
            
            //파라미터 설정//
            let parameters = [
                "pagecount":page_count
            ]
            
            //네트워크로 유저의 정보를 검색한다.//
            var progress = ProgressDialog(delegate: self)
            progress.Show(true, mesaj: "Loading...")
            
            //테이블뷰에 나타날 데이터를 셋팅//
            //호출//
            //GET방식은 URLEncoding//
            Alamofire.request("http://"+server_ip_address+":"+server_port_number+"/user/list", method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
                
                switch(response.result) {
                case .success(_):
                    if let data = response.result.value{
                        //print(response.result.value!)
                        
                        //JSON값을 가지고 파싱//
                        let json = JSON(data)
                        
                        for item in json["results"].arrayValue {
                            //print(item)
                            //각 파싱한 값들을 배열에 설정//
                           self.user_id_array.append(item["id"].stringValue)
                            self.user_name_array.append(item["name"].stringValue)
                            self.user_email_array.append(item["email"].stringValue)
                            self.user_gender_array.append(item["gender"].stringValue)
                            self.user_profile_array.append(item["profile_image"].stringValue)
                        }
                        
                        //네트워크 작업을 다 완료 후 수행(async - 비동기 작업)//
                        DispatchQueue.main.async {
                            progress.Close()
                            
                            print("finish get user list")
                            
                            print("---------------------------")
                            
                            self.user_tableview.reloadData() //뷰를 재로드//
                            
                            self.refreshControl.endRefreshing() //다시 새로고침을 끝낸다.//
                        }
                    }
                    break
                    
                case .failure(_):
                    print(response.result.error)
                    
                    print("---------------------------")
                    break
                    
                }
            }
        }
    }
}
