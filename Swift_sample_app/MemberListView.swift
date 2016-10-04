//
//  MemberListView.swift
//  Swift_sample_app
//
//  Created by apple on 2016. 9. 17..
//  Copyright © 2016년 apple. All rights reserved.
//

import UIKit //ios에서 코코아 프레임워크를 사용하기 위한 것(UI작업을 하기위해서 import)//
import AssetsLibrary //이미지, 동영상 등 리소스 작업을 하기 위한 라이브러리//

//TableView를 사용하기 위해서 UIViewController, UITableViewDataSource, UITableDelegate 3개의 프로토콜을 정의한다.//
class MemberListView : UIViewController, UITableViewDataSource, UITableViewDelegate
{
    @IBOutlet weak var member_tableview: UITableView!
    @IBOutlet weak var sort_select_button: UISegmentedControl!
    
    @IBAction func sort_button(_ sender: UISegmentedControl)
    {
        switch sort_select_button.selectedSegmentIndex //스위치 선택에 따른 액션처리//
        {
        case 0:
            OrderMaxValue_member() //내림차순 정렬//
            
            break;
        case 1:
            OrderMinValue_member() //오름차순 정렬//
            
            break;
            
        default:
            break; 
        }
    }
    
    // Don't forget to enter this in IB also
    let cellReuseIdentifier = "membertableviewcell" //UITableViewCell의 id가 된다.//
    
    //이전 스토리보드에서 값을 전달받음.//
    var screen_message = ""
    
    /** TableView에 사용될 배열변수**/
    var member_image = [String]()
    var member_name = [String]()
    var member_id = [String]()
    
    //미리 저장하고 있는 정보들//
    var member_address = [String]()
    var member_email_address = [String]()
    var member_phone_number = [String]()
    var member_success = [String]()
    var member_fail = [String]()
    
    /** 데이터베이스 관련 변수 **/
    var db_connection_check : Bool?
    var db_table_check : Bool?
    
    let DB_Func_class = DB_Func(); //기본적으로 디폴트 생성자 호출//
    var asset = ALAssetsLibrary()
    
    var button_number = 0;
    
    /** 정렬에 사용될 배열변수 **/
    var member_desc_list = [String]()
    var member_asc_list = [String]()
    
    /** TableView 관련 Swipe Refresh 이벤트 **/
    var refreshControl: UIRefreshControl!
    
    //멤버리스트를 보여줄 리스트뷰 작업//
    @IBAction func back_screen(_ sender: UIBarButtonItem)
    {
        dismiss(animated: true, completion: nil)
    }
    
    func back()
    {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() //처음 뷰가 로드될때 실행(한번만 실행)//
    {
        super.viewDidLoad() //상위의 클래스에 자원을 반환//
        
        print("MemberListView init")
        
        /** CustomCell 설정 **/
        self.member_tableview.delegate = self
        self.member_tableview.dataSource = self
        
        self.db_connection_check = DB_Func_class.DB_Connection()
        
        print("DB Connection Check : ", db_connection_check)
        
        //테이블 생성. 테이블 생성은 기존에 있는 테이블일 경우 실패를 하기에 에러가 나도 예외처리의 문제는 없다.//
        self.db_table_check = DB_Func_class.DB_Table_Create()
        
        print("db table check : ", self.db_table_check)
        
        self.load_memberlist(flag: "2") //기본적용//
        
        // set up the refresh control
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        
        //Swift3에서부터는 action사용 시 #selector가 필요.//
        refreshControl.addTarget(self, action: #selector(self.refresh(sender:)), for: UIControlEvents.valueChanged)
        
        member_tableview.addSubview(refreshControl) //리플래시 화면을 보일(빙글빙글 돌아가는 프로그래스바)뷰를 장착.//
    }
    
    func refresh(sender:AnyObject) {
        // Code to refresh table view
        print("refresh table")
        
        member_tableview.reloadData() //뷰를 재로드//
        
        refreshControl.endRefreshing() //다시 새로고침을 끝낸다.//
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) //처음뷰가 호출될 때 실행(중복실행가능)//
    {
        super.viewDidAppear(true)
    }
    
    func load_memberlist(flag:String) //해당 부분이 네트워크로 데이터를 불러오는 경우도 된다//
    {
        print("load member list")
        
        //데이터베이스로 부터 멤버리스트의 정보를 가져온다.//
        if(self.db_connection_check == true)
        {
            //이름부분의 리스트 정보//
            self.member_name = DB_Func_class.DB_Select_user_name(flag: flag) //이름을 불러온다.//
            self.member_image = DB_Func_class.DB_Select_user_image(flag: flag) //이미지를 불러온다.//
            self.member_id = DB_Func_class.DB_Select_user_id(flag: flag) //id들을 불러온다.//
            //부가정보 로드//
            self.member_address = DB_Func_class.DB_Select_user_address(flag: flag) //주소정보들을 불러온다.//
            self.member_phone_number = DB_Func_class.DB_Select_user_phonenumber(flag: flag) //전화번호 정보들을 불러온다.//
            self.member_email_address = DB_Func_class.DB_Select_user_emailaddress(flag: flag) //이메일 정보들을 불러온다.//
            self.member_success = DB_Func_class.DB_Select_user_success(flag: flag) //승률정보들을 불러온다//
            self.member_fail = DB_Func_class.DB_Select_user_fail(flag: flag) //패전기록들을 불러온다//
            
            print("member name count:", self.member_name.count)
            print("member id count:", self.member_id.count)
            print("member image count:", self.member_image.count)
        }
        
        let id_table_size = self.member_id.count
        let name_table_size = self.member_name.count
        let image_table_size = self.member_image.count
        
        if(id_table_size == 0 || name_table_size == 0 || image_table_size == 0)
        {
            let refreshAlert = UIAlertController(title: "정보", message: "맴버가 존재하지 않습니다.", preferredStyle: UIAlertControllerStyle.alert)
            
            //다이얼로그에 버튼 등록//
            refreshAlert.addAction(UIAlertAction(title: "확인", style: .default, handler: { (action: UIAlertAction!) in
                self.back()
            }))
            
            present(refreshAlert, animated: true, completion: nil) //작성된 다이얼로그를 만들어 준다.//
        }
        
        else{
            member_tableview.reloadData() //데이터를 리스트뷰에 다시 셋팅시켜주는 것//
        }
    }
    
    //적용된 UITableView관련 필수 메소드를 오버라이드 해준다.(테이블의 행의 개수를 설정)//
    //UITableView는 옵셔널이기에 사용 시 '!'로 강제 풀어준다.//
    func tableView(_ tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return self.member_name.count
    }
    
    //리스트뷰 데이터 초기화 부분//
    func tableView(_ tableView: UITableView!, cellForRowAt indexPath: IndexPath) -> UITableViewCell!
    {
        //UITableCell이 아닌 Custom된(UITableCell을 상속하여 구현된 클래스)것을 적어준다.//
        //dequeueReusableCellWithIdentifier로 RecyclerView의 원리를 적용한다.//
        let cell:MemberListViewTableCell = self.member_tableview.dequeueReusableCell(withIdentifier: self.cellReuseIdentifier) as! MemberListViewTableCell
        let row = indexPath.row
        
        /** 커스텀 Cell에 데이터 초기화 **/
        cell.user_id_label?.text = self.member_id[row]
        cell.user_name_label?.text = self.member_name[row]
        
        //String -> NSURL//
        let fileUrl = URL(string: self.member_image[row])
        
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
                    cell.contentMode = .scaleAspectFit
                    cell.user_image_imageview?.image = image //썸네일 이미지 적용//
                })
            }
            }, failureBlock: { error in
                print("Error: \(error)")
        })
        
        cell.user_image_imageview?.image = UIImage(named: self.member_image[row])
        
        //테이블 내 버튼 설정//
        //action(#selector)을 이용한다.//
        cell.user_info_more_button?.tag = row //테이블의 row값을 각각의 버튼에 저장(정보탐색시 필요)
        //테이블 내 버튼 클릭 시 셀랙터 설정//
        //cell.user_info_more_button?.addTarget(self, action: #selector(self.makeSegue), for: UIControlEvents.touchUpInside)
        
        return cell
    }
    
    /*func makeSegue()
    {
        //TODO: 버튼클릭 이벤트 처리//
    }*/

    
    //리스트뷰 선택//
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \((indexPath as NSIndexPath).row).")
    }
    
    
    //스토리보드 이동(Modal방식)//
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        //이동할 스토리보드의 id저장.값이 변할 수 있는 것은 가변타입(var)로 한다. 고정값(상수)이면 let//
        var segue_id : String = ""
        segue_id = segue.identifier!
        
        //identifier값으로 비교한다.//
        print("segue id : ", segue_id+" id")
        
        //스토리보드의 id값을 가지고 이동할 스토리보드를 선택한다.//
        if(segue_id == "memberinfodetailview")
        {
            let button = sender as? UIButton //현재 UIButton의 프로토콜로 왔으니 sender를 UIButton으로 캐스팅한다.//
            let destination = segue.destination as! MemberInfoDetailView //이동할 스토리보드를 정의//
            
            let cell_position = button?.tag //버튼의 tag값을 가져온다.(tag: 선택된 셀의 row값)//
                
            print("move sotryboard...")
            
            //이동할 스토리보드에 있는 값을 받을 변수설정(안드로이드에서는 해당 기능을 인텐트로 구현)//
            destination.member_id = self.member_id[cell_position!]
            destination.member_name = self.member_name[cell_position!]
            destination.member_imageUrl = self.member_image[cell_position!]
            destination.member_phonenumber = self.member_phone_number[cell_position!]
            destination.member_emailaddress = self.member_email_address[cell_position!]
            destination.member_address = self.member_address[cell_position!]
            destination.member_success = self.member_success[cell_position!]
            destination.member_lose = self.member_fail[cell_position!]
            
        }
    }
    
    //정렬관련 메소드 정의//
    func OrderMaxValue_member() //내림차순(DESC)//
    {
        print("최고득점순으로 정렬")
        
        self.db_connection_check = DB_Func_class.DB_Connection()
         
         print("DB Connection Check : ", db_connection_check)
         
         //테이블 생성. 테이블 생성은 기존에 있는 테이블일 경우 실패를 하기에 에러가 나도 예외처리의 문제는 없다.//
         self.db_table_check = DB_Func_class.DB_Table_Create()
         
         print("db table check : ", self.db_table_check)
         
        self.load_memberlist(flag: "0") //내림차순 결과//
    }
    
    func OrderMinValue_member() //오름차순(ASC)//
    {
        print("최저득점순으로 정렬")
        
        self.db_connection_check = DB_Func_class.DB_Connection()
         
         print("DB Connection Check : ", db_connection_check)
         
         //테이블 생성. 테이블 생성은 기존에 있는 테이블일 경우 실패를 하기에 에러가 나도 예외처리의 문제는 없다.//
         self.db_table_check = DB_Func_class.DB_Table_Create()
         
         print("db table check : ", self.db_table_check)
         
        self.load_memberlist(flag: "1") //오름차순 결과//
    }
}
