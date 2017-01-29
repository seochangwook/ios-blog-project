//
//  MessageRoom.swift
//  Swift_sample_app
//
//  Created by apple on 2017. 1. 3..
//  Copyright © 2017년 apple. All rights reserved.
//

import Foundation
import UIKit
import Alamofire //네트워크 라이브러리//
import SwiftyJSON //JSON파싱 라이브러리//
import Kingfisher //이미지 로더 클래스//

class MessageRoom : UIViewController, UITableViewDataSource, UITableViewDelegate{
    //서버의 ip주소와 포트번호//
    var server_ip_address:String = "192.168.0.10"
    var server_port_number = "3000"
    
    @IBOutlet weak var receiver_info_label: UILabel!
    @IBOutlet weak var sender_info_label: UILabel!
    
    @IBOutlet weak var chatting_table: UITableView!
    @IBOutlet weak var message_edittext: UITextField!
    
    var sender_id:String = ""
    var receiver_id:String = ""
    var sender_name:String = ""
    var receiver_name:String = ""
    var sender_profileimage:String = ""
    var receiver_profileimage:String = ""
    
    //채팅 서비스에 필요한 변수 및 배열 선언//
    /** TableView 관련 Swipe Refresh 이벤트 **/
    var refreshControl: UIRefreshControl!
    
    // Don't forget to enter this in IB also
    let cellReuseIdentifier = "messagetablecell" //UITableViewCell의 id가 된다.//
    let listviewfooterIdentifier = "messagetablefootercell"
    
    //데이터에 필요한 배열 및 변수//
    var page_count:String = "10"; //기본 10(이전 메세지 내용은 사용자가 필요로 하면 조회하는 방식)//
    
    var sender_id_array = [String]() //전송자 id를 가지고 있는 배열//
    var message_array = [String]() //메세지의 내용을 저장할 배열//
    var message_date = [String]() //메세지 전송 시간에 관한 배열//
    var name_array = [String]() //메세지 전송자 이름 배열//
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /** CustomCell 설정 **/
        self.chatting_table.delegate = self
        self.chatting_table.dataSource = self
        
        // set up the refresh control
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        
        //Swift3에서부터는 action사용 시 #selector가 필요.//
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: UIControlEvents.valueChanged)
        
        chatting_table.addSubview(refreshControl) //리플래시 화면을 보일(빙글빙글 돌아가는 프로그래스바)뷰를 장착.//
        
        //채팅 관련 데이터를 불러온다.//
        load_message_data();
    }
    
    //당겨서 새로고침//
    func refresh(_ sender:AnyObject) {
        // Code to refresh table view
        print("refresh table")
        
        print("more page count : ", page_count)
        
        //증가된 페이지 카운트 수를 가지고 다시 재구성(refresh 시 다시 초기 10으로 돌아감)//
        self.message_array.removeAll()
        self.message_date.removeAll()
        self.name_array.removeAll()
        self.sender_id_array.removeAll()
        
        //load_userlist(page_count: page_count) //데이터 로드//
        //채팅 관련 데이터를 불러온다.//
        load_message_data();
    }
    
    //적용된 UITableView관련 필수 메소드를 오버라이드 해준다.(테이블의 행의 개수를 설정)//
    //UITableView는 옵셔널이기에 사용 시 '!'로 강제 풀어준다.//
    func tableView(_ tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return self.message_array.count //자기자신은 제외되기에 -1//
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
        let cell:MessageTableCell = self.chatting_table.dequeueReusableCell(withIdentifier: self.cellReuseIdentifier) as! MessageTableCell
        let row = indexPath.row
        
        /** 커스텀 Cell에 데이터 초기화 **/
        cell.name_label?.text = self.name_array[row]
        cell.message_label?.text = self.message_array[row]
        cell.message_date_label?.text = self.message_date[row]
        
        //프로필 이미지//
        //이미지 셋팅//
        //이미지 로드//
        if(self.sender_id_array[row] == sender_id){
            //나의 계정일 경우//
            let url = URL(string: self.sender_profileimage) //이미지 로딩(비동기, 캐싱기능 포함)//
            let processor = RoundCornerImageProcessor(cornerRadius: 80) //이미지 변형(동그랗게 자르기)//
            //let processor_multi = BlurImageProcessor(blurRadius: 4) >> RoundCornerImageProcessor(cornerRadius: 40)
            
            cell.profileimageview?.kf.setImage(with: url, options: [.processor(processor)])
            //profile_imageview.kf.setImage(with: url)
        }
        
        else if(self.sender_id_array[row] == receiver_id){
            //상대방 계정일 경우//
            let url = URL(string: "https://raw.githubusercontent.com/seochangwook/ios-game-project/master/default_humanimage.png") //이미지 로딩(비동기, 캐싱기능 포함)//
            let processor = RoundCornerImageProcessor(cornerRadius: 80) //이미지 변형(동그랗게 자르기)//
            //let processor_multi = BlurImageProcessor(blurRadius: 4) >> RoundCornerImageProcessor(cornerRadius: 40)
            
            cell.profileimageview?.kf.setImage(with: url, options: [.processor(processor)])
            //profile_imageview.kf.setImage(with: url)
        }
        
        return cell
    }
    
    //리스트뷰 선택//
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \((indexPath as NSIndexPath).row).")
    }
    
    //테이블에 대한 푸터뷰 작업//
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerCell = self.chatting_table.dequeueReusableCell(withIdentifier: self.listviewfooterIdentifier)as? MessageTableFooterCell
        
        //버튼 설정//
        footerCell?.more_button?.addTarget(self, action: #selector(self.more_content), for: UIControlEvents.touchUpInside)
        
        return footerCell
    }
    
    //푸터뷰의 높이 설정//
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 30.0
    }
    
    func more_content()
    {
        //TODO: 버튼클릭 이벤트 처리//
        print("more content button click")
        
        page_count = String(Int(page_count)! + 10) //페이지 카운트 증가//
        
        print("more page count : ", page_count)
        
        //증가된 페이지 카운트 수를 가지고 다시 재구성(refresh 시 다시 초기 10으로 돌아감)//
        self.message_array.removeAll()
        self.message_date.removeAll()
        self.name_array.removeAll()
        self.sender_id_array.removeAll()
        
        //load_userlist(page_count: page_count) //데이터 로드//
        //채팅 관련 데이터를 불러온다.//
        load_message_data();
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        print("sender id: ", sender_id)
        print("sender name: ", sender_name)
        print("sender profileimage: ", sender_profileimage)
        print("receiver id: ", receiver_id)
        print("receiver name: ", receiver_name)
        print("receiver profileimage: ", receiver_profileimage)
        
        sender_info_label.text = sender_id + "/" + sender_name
        receiver_info_label.text = receiver_id + "/" + receiver_name
        
        //데이터를 로드//
        load_message_data();
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //빈 공간을 눌렀을때 키보드가 종료되는 것. 오버라이드해서 사용한다.//
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        message_edittext.resignFirstResponder()
    }
    
    //메세지 전송버튼//
    @IBAction func send_button(_ sender: UIButton) {
        print("message send");
        
        //메세지 전송은 전송 뒤 다시 테이블의 데이터를 로드하는 작업이 필요//
        var message_str:String = message_edittext.text!
        
        send_message(message:message_str);
        
        message_edittext.text = "";
    }
    
    func load_message_data(){
        if(self.message_array.count != 0){
            print("refresh table")
            
            chatting_table.reloadData() //뷰를 재로드//
            
            refreshControl.endRefreshing() //다시 새로고침을 끝낸다.//
        }
        
        else{
            print("---------------------------")
            
            print("page count: ", page_count)
            
            //파라미터 설정(송수신 관련 정보)//
            let parameters = [
                "pagecount":page_count,
                "senderid":sender_id,
                "receiverid":receiver_id
            ]
            
            //네트워크로 유저의 정보를 검색한다.//
            var progress = ProgressDialog(delegate: self)
            progress.Show(true, mesaj: "Loading...")
            
            //테이블뷰에 나타날 데이터를 셋팅//
            //호출//
            //GET방식은 URLEncoding//
            Alamofire.request("http://"+server_ip_address+":"+server_port_number+"/message/messagecontentlist", method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
                
                switch(response.result) {
                case .success(_):
                    if let data = response.result.value{
                        //print(response.result.value!)
                        
                        //JSON값을 가지고 파싱//
                        let json = JSON(data)
                        
                        for item in json["result"].arrayValue {
                            print(item)
                            //각 파싱한 값들을 배열에 설정//
                            self.sender_id_array.append(item["senderid"].stringValue)
                            self.message_date.append(item["date"].stringValue)
                            self.message_array.append(item["message"].stringValue)
                            self.name_array.append(item["sendername"].stringValue + "->" + item["receivername"].stringValue)
                        }
                        
                        //네트워크 작업을 다 완료 후 수행(async - 비동기 작업)//
                        DispatchQueue.main.async {
                            progress.Close()
                            
                            print("finish get user list")
                            print("---------------------------")
                            
                            //리스트를 변경 시 다시 테이블을 초기화//
                            self.chatting_table.reloadData() //뷰를 재로드//
                            
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
    
    func send_message(message:String){
        print("[" + message + "]send...[" + sender_id + "(" + sender_name + ") -> " + receiver_id + "(" + receiver_name + ")]");
        
        //파라미터 설정(송수신 관련 정보)//
        let parameters = [
            "senderid":sender_id,
            "receiverid":receiver_id,
            "message":message,
            "sendername":sender_name,
            "receivername":receiver_name
        ]
        
        var progress = ProgressDialog(delegate: self);
        progress.Show(true, mesaj: "Loading...")
        
        //호출//
        Alamofire.request("http://"+self.server_ip_address+":"+self.server_port_number+"/message/send", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            
            //swift-case로 응답성공/실패를 분리//
            switch(response.result) {
            case .success(_):
                if let data = response.result.value{
                    print(response.result.value!)
                    
                    //JSON값을 가지고 파싱//
                    let json = JSON(data)
                    
                    
                    //네트워크 작업을 다 완료 후 수행(async - 비동기 작업)//
                    DispatchQueue.main.async {
                        progress.Close()
                        
                        //다시 테이블을 데이터 리스트를 호출//
                        print("more page count : ", self.page_count)
                        
                        //증가된 페이지 카운트 수를 가지고 다시 재구성(refresh 시 다시 초기 10으로 돌아감)//
                        self.message_array.removeAll()
                        self.message_date.removeAll()
                        self.name_array.removeAll()
                        self.sender_id_array.removeAll()
                        
                        //load_userlist(page_count: page_count) //데이터 로드//
                        //채팅 관련 데이터를 불러온다.//
                        self.load_message_data();
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
