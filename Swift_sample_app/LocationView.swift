//
//  LocationView.swift
//  Swift_sample_app
//
//  Created by apple on 2017. 1. 21..
//  Copyright © 2017년 apple. All rights reserved.
//

import Foundation
import UIKit
import Alamofire //네트워크 라이브러리//
import SwiftyJSON //JSON파싱 라이브러리//

class LocationView : UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate{
    //서버의 ip주소와 포트번호//
    var server_ip_address:String = "192.168.0.9"
    var server_port_number = "3000"
    
    @IBOutlet weak var location_table: UITableView!
    @IBOutlet weak var searchbar: UISearchBar! //테이블뷰 내부에 포함된다.//
    
    //검색바를 위한 필요 변수//
    var filteredData: [String]!
    
    var location_name_array = [String]() //위치정보를 가지고 있는 배열//
    
    //채팅 서비스에 필요한 변수 및 배열 선언//
    /** TableView 관련 Swipe Refresh 이벤트 **/
    var refreshControl: UIRefreshControl!
    
    // Don't forget to enter this in IB also
    let cellReuseIdentifier = "locationtablecell" //UITableViewCell의 id가 된다.//
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /** CustomCell 설정 **/
        self.location_table.dataSource = self
        self.location_table.delegate = self
        self.searchbar.delegate = self //SearchBar 관련 이벤트 처리//
        self.searchbar.placeholder = "Input location name" //hint 등록//
        
        self.filteredData = self.location_name_array //필터링 배열에 원본데이터배열을 등록//
        
        // set up the refresh control
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        
        //Swift3에서부터는 action사용 시 #selector가 필요.//
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: UIControlEvents.valueChanged)
        
        location_table.addSubview(refreshControl) //리플래시 화면을 보일(빙글빙글 돌아가는 프로그래스바)뷰를 장착.//
        
        //지역정보 관련 데이터를 불러온다.//
        load_location_data();
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //당겨서 새로고침//
    func refresh(_ sender:AnyObject) {
        // Code to refresh table view
        print("refresh table")
        
        //증가된 페이지 카운트 수를 가지고 다시 재구성(refresh 시 다시 초기 10으로 돌아감)//
        self.location_name_array.removeAll()
        
        //load_userlist(page_count: page_count) //데이터 로드//
        //채팅 관련 데이터를 불러온다.//
        load_location_data();
    }
    
    //적용된 UITableView관련 필수 메소드를 오버라이드 해준다.(테이블의 행의 개수를 설정)//
    //UITableView는 옵셔널이기에 사용 시 '!'로 강제 풀어준다.//
    //SearchBar에서의 테이블뷰 작업은 필터링 배열을 가지고 한다.//
    func tableView(_ tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return self.filteredData.count
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
        let cell:LocationTableCell = self.location_table.dequeueReusableCell(withIdentifier: self.cellReuseIdentifier) as! LocationTableCell
        let row = indexPath.row
        
        cell.location_name_label?.text = self.filteredData[row]
        
        cell.location_view_button?.tag = row //태그등록//
        //cell.chatting_button?.addTarget(self, action: #selector(self.makeSegue), for: UIControlEvents.touchUpInside)
        
        return cell
    }
    
    //리스트뷰 선택//
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \((indexPath as NSIndexPath).row).")
    }
    
    func load_location_data(){
        if(self.location_name_array.count != 0){
            print("refresh table")
            
            location_table.reloadData() //뷰를 재로드//
            
            refreshControl.endRefreshing() //다시 새로고침을 끝낸다.//
        }
            
        else{
            print("---------------------------")
            
            //네트워크로 유저의 정보를 검색한다.//
            var progress = ProgressDialog(delegate: self)
            progress.Show(true, mesaj: "Loading...")
            
            //테이블뷰에 나타날 데이터를 셋팅//
            //호출//
            //GET방식은 URLEncoding//
            Alamofire.request("http://"+server_ip_address+":"+server_port_number+"/location/location_info", method: .get,  encoding: URLEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
                
                switch(response.result) {
                case .success(_):
                    if let data = response.result.value{
                        //print(response.result.value!)
                        
                        //JSON값을 가지고 파싱//
                        let json = JSON(data)
                        
                        for item in json["results"].arrayValue {
                            //print(item)
                            //각 파싱한 값들을 배열에 설정//
                            self.location_name_array.append(item["location_name"].stringValue)
                        }
                        
                        //네트워크 작업을 다 완료 후 수행(async - 비동기 작업)//
                        DispatchQueue.main.async {
                            progress.Close()
                            
                            print("finish get location list")
                            
                            print("---------------------------")
                            
                            self.filteredData = self.location_name_array //네트워크로 받은 데이터를 필터 배열에 저장//
                            
                            self.location_table.reloadData() //뷰를 재로드//
                            
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
    
    //스토리보드 이동(Modal방식,Push방식)//
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        //이동할 스토리보드의 id저장.값이 변할 수 있는 것은 가변타입(var)로 한다. 고정값(상수)이면 let//
        var segue_id : String = ""
        segue_id = segue.identifier!
        
        //identifier값으로 비교한다.//
        print("segue id : [",segue_id+"] id")
        
        //스토리보드의 id값을 가지고 이동할 스토리보드를 선택한다.//
        if(segue_id == "mapview")
        {
            let button = sender as? UIButton //현재 UIButton의 프로토콜로 왔으니 sender를 UIButton으로 캐스팅한다.//
            let cell_position = button?.tag //버튼의 tag값을 가져온다.(tag: 선택된 셀의 row값)//
            
            //UINavigation에서의 값 전달도 일반적으로 destination을 설정해서 한다.//
            let destination = segue.destination as! MapView //이동할 스토리보드를 정의//
            
            print("move sotryboard...")
            
            //이동할 스토리보드에 있는 값을 받을 변수설정(안드로이드에서는 해당 기능을 인텐트로 구현)//
            //필터링 배열을 가지고 이용//
            destination.location_name = self.filteredData[cell_position!]
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        load_location_data();
    }
    
    /** SearchBar 관련 메소드 **/
    // This method updates filteredData based on the text in the Search Box
    func searchBar(_ searchbar: UISearchBar, textDidChange searchText: String) {
        // When there is no text, filteredData is the same as the original data
        // When user has entered text into the search box
        // Use the filter method to iterate over all items in the data array
        // For each item, return true if the item should be included and false if the
        // item should NOT be included
        filteredData = searchText.isEmpty ? location_name_array : location_name_array.filter({(dataString: String) -> Bool in
            // If dataItem matches the searchText, return true to include it
            return dataString.range(of: searchText, options: .caseInsensitive) != nil
        })
        
        location_table.reloadData() //필터링 된 데이터를 기준으로 다시 테이블뷰를 설정//
    }
    
    func searchBarTextDidBeginEditing(_ searchbar: UISearchBar) {
        self.searchbar.showsCancelButton = true //취소버튼 보이기//
    }
    
    //취소버튼 클릭 시 키보드 닫히기, 검색어 초기화//
    func searchBarCancelButtonClicked(_ searchbar: UISearchBar) {
        self.searchbar.showsCancelButton = false
        self.searchbar.text = ""
        self.searchbar.resignFirstResponder()
    }
}
