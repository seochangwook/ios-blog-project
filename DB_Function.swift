//
//  DB_Function.swift
//  Swift_sample_app
//
//  Created by apple on 2016. 7. 17..
//  Copyright © 2016년 apple. All rights reserved.
//

//해당 파일은 UI를 만들려는 것이 아닌 DB관련 리소스를 담당하는 것이기에 기본적인 Foundation만 impoert한다.//
//Foundation을 import하는 이유는 Object-C관련 기본적인 라이브러리나 타입을 사용하기 위해서이다.//
import Foundation

class DB_Func //클래스 정의.//
{
    init() //생성자//
    {
        print("생성자 호출")
        
    }
    
    //파괴자는 생성자와는 달리 메소드 형태가 아니다. 따라서 ()인 매개변수 표시를 할 수 없다.
    //대게 프로그래밍 방식에서 프로그래머가 직접적으로 파괴자를 호출 할 수 없는 구조로 되어있기 때문.//
    //스위프트는 ARC(자동 메모리 관리 : 자바의 Garbage Collection과 같은 개념)기반에 있기에 구지 파괴자는 필요없다.//
    deinit //파괴자 정의.//
    {
        print("파괴자 호출")
        
        //필요한 작업을 한다. 하지만 구지 필요는 없다.//
    }
    
    func DB_Connection() -> Bool //데이터베이스 연결 함수//
    {
        let class_db_connect = DBController() //우선 let방식으로 Object-C클래스 선언//
        
        var db_connection_check : Bool = true //처음엔 실패했다고 가정//
    
        //디비 연결(브리징-헤더방식이용)//
        db_connection_check = class_db_connect.db_Connect_func()
        
        return db_connection_check
    }
    ////////////
    func DB_Table_Create() -> Bool //테이블 생성함수. 이 메소드에서 필요한 테이블들을 생성한다.//
    {
        let class_db_table_set = DBController()
        
        var db_table_create_check : Bool = false //처음엔 실패했다고 가정//
        
        //테이블 생성//
        db_table_create_check = class_db_table_set.db_Table_Create()
        
        return db_table_create_check
    }
    ////////////
    func DB_Search_id(_ search_id:String) -> Bool //id검색 메소드//
    {
        let class_db_search = DBController();
        
        var id_check : Bool = false //처음엔 없다고 가정. 따라서 검색결과에 따라 검색에 성공을 하면(아이디가 이미 존재 시) true하고
        //검색루프를 끝내는 구조//
    
        print("db func search id : "+search_id)
        
        //id를 탐색//
        id_check = class_db_search.db_Search_id(search_id)
        
        if(id_check == false)
        {
            print("id use ok!!");
        }
        
        else if(id_check == true)
        {
            print("id is not use!!");
        }
    
        //해당 아이디가 존재 시 true, 없으면 false를 반환//
        return id_check
    }
    /////////////
    //유저정보 등록 함수//
    func DB_Enroll_user_info(_ user_id:String, user_password:String, user_email:String,
                             user_tel:String, user_address:String, user_name:String, user_image:String,
                             user_success:String, user_lose:String) -> Bool
    {
        var is_enroll_check = false; //실패했다고 가정.//
        
        //브릿징 헤더로 등록//
        let db_controll = DBController();
        
        is_enroll_check = db_controll.db_Insert_User_info(user_id, input_password: user_password, input_email: user_email, input_tel: user_tel, input_address: user_address,input_name: user_name,
        input_image: user_image, input_success: user_success, input_lose: user_lose);
    
        return is_enroll_check;
    }
    /////////////
    //멤버의 이름들을 반환하는 메소드//
    func DB_Select_user_name(flag:String) -> [String]
    {
        var member_name = [String]()
        
        let db_control = DBController();
        
        //이름 데이터를 불러온다. (NSMutableArray <-> String[])//
        member_name = db_control.db_Select_User_Name(flag) as! [String]

        print("array size:", member_name.count)
        
        for name_value in member_name
        {
            print("member name:", name_value)
        }
        
        return member_name
    }
    /////////////
    //멤버의 id들을 반환하는 메소드//
    func DB_Select_user_id(flag:String) -> [String]
    {
        var member_id = [String]()
        
        let db_control = DBController();
        
        //이름 데이터를 불러온다. (NSMutableArray <-> String[])//
        member_id = db_control.db_Select_User_id(flag) as! [String]
        
        print("array size:", member_id.count)
        
        for id_value in member_id
        {
            print("member id:", id_value)
        }
        
        return member_id
    }
    //////////////
    //멤버의 이미지들을 반환하는 메소드//
    func DB_Select_user_image(flag:String) -> [String]
    {
        var member_image = [String]()
        
        let db_control = DBController()
        
        //이미지 데이터를 불러온다.//
        member_image = db_control.db_Select_User_image(flag) as! [String]
        
        print("array size:", member_image.count)
        
        for image_value in member_image
        {
            print("member image:", image_value)
        }

        return member_image
    }
    ////////////////
    //멤버의 주소들을 반환하는 메소드//
    func DB_Select_user_address(flag:String) -> [String]
    {
        var member_address = [String]()
        
        let db_control = DBController()
        
        //이미지 데이터를 불러온다.//
        member_address = db_control.db_Select_User_address(flag) as! [String]
        
        print("array size:", member_address.count)
        
        for address_value in member_address
        {
            print("member image:", address_value)
        }
        
        return member_address
    }
    /////////////////
    //멤버의 전화번호들을 반환하는 메소드//
    func DB_Select_user_phonenumber(flag:String) -> [String]
    {
        var phonenumber = [String]()
        
        let db_control = DBController()
        
        //이미지 데이터를 불러온다.//
        phonenumber = db_control.db_Select_User_phonenumber(flag) as! [String]
        
        print("array size:", phonenumber.count)
        
        for phonenumber_value in phonenumber
        {
            print("member image:", phonenumber_value)
        }
        
        return phonenumber
    }
    /////////////////
    //멤버의 이메일 주소들을 반환하는 메소드//
    func DB_Select_user_emailaddress(flag:String) -> [String]
    {
        var emailaddress = [String]()
        
        let db_control = DBController()
        
        //이미지 데이터를 불러온다.//
        emailaddress = db_control.db_Select_User_emailaddress(flag) as! [String]
        
        print("array size:", emailaddress.count)
        
        for emailaddress_value in emailaddress
        {
            print("member image:", emailaddress_value)
        }
        
        return emailaddress
    }
    //////////////////
    //멤버의 승률을 반환하는 메소드//
    func DB_Select_user_success(flag:String) -> [String]
    {
        var success = [String]()
        
        let db_control = DBController()
        
        //이미지 데이터를 불러온다.//
        success = db_control.db_Select_User_success(flag) as! [String]
        
        print("array size:", success.count)
        
        for success_value in success
        {
            print("member image:", success_value)
        }
        
        return success
    }
    ////////////////////
    //멤버의 실점을 반환하는 메소드//
    func DB_Select_user_fail(flag:String) -> [String]
    {
        var fail = [String]()
        
        let db_control = DBController()
        
        //이미지 데이터를 불러온다.//
        fail = db_control.db_Select_User_fail(flag) as! [String]
        
        print("array size:", fail.count)
        
        for fail_value in fail
        {
            print("member image:", fail_value)
        }
        
        return fail
    }
    ////////////////////
    //멤버의 정보를 가져온다.//
    func DB_Select_user_info(inputname:String) -> String
    {
        var user_info = String()
        
        let db_control = DBController()
        
        user_info = db_control.db_Select_User_Info(inputname) as String
        
        print("member info: ", user_info)
        
        return user_info
    }
    ////////////////////
    //멤버의 패스워드 정보를 가져온다.//
    func DB_Select_user_info_password(inputname:String, input_id:String) -> String
    {
        var user_info = String()
        
        let db_control = DBController()
        
        user_info = db_control.db_Select_User_Info_password(inputname, input_id: input_id) as String
        
        print("member info: ", user_info)
        
        return user_info
    }
    ////////////////////
    //멤버의 정보를 지운다.//
    func DB_user_delete(input_id:String) -> Bool
    {
        var user_info = Bool()
        
        let db_control = DBController()
        
        user_info = db_control.db_Select_User_Info_password(input_id) as Bool
        
        print("member info: ", user_info)
        
        return user_info
    }

}
////////////
