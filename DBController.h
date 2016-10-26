//
//  DBController.h
//  Swift_sample_app
//
//  Created by apple on 2016. 7. 17..
//  Copyright © 2016년 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBController : NSObject

- (BOOL)DB_Connect_func; //디비 연결확인//
- (BOOL)DB_Table_Create; //디비 테이블 생성//
- (BOOL)DB_Search_id:(NSString *)search_id; //디비 아이디 검색//
- (BOOL)DB_Insert_User_info:(NSString *)input_id
                            input_password:(NSString *)input_password
                            input_email:(NSString *)input_email
                            input_tel:(NSString *)input_tel
                            input_address:(NSString *)input_address
                            input_name:(NSString *)input_name
                            input_image:(NSString *)input_image
                            input_success:(NSString *)input_success
                            input_lose:(NSString *)input_lose;
                            //사용자 정보 저장//
- (NSMutableArray *)DB_Select_User_Name:(NSString *)flag; //사용자 이름 정보 추출//
- (NSMutableArray *)DB_Select_User_id:(NSString *)flag; //사용자 아이디 정보 추출//
- (NSMutableArray *)DB_Select_User_image:(NSString *)flag; //사용자 이미지 정보 추출//
- (NSMutableArray *)db_Select_User_address:(NSString *)flag; //사용자 주소 정보 추출//
- (NSMutableArray *)db_Select_User_phonenumber:(NSString *)flag; //사용자 전화번호 정보 추출//
- (NSMutableArray *)db_Select_User_emailaddress:(NSString *)flag; //사용자 이메일 정보 추출//
- (NSMutableArray *)db_Select_User_success:(NSString *)flag; //사용자 승률 정보 추출//
- (NSMutableArray *)db_Select_User_fail:(NSString *)flag; //사용자 실점 정보 추출//
- (NSString *)db_Select_User_Info:(NSString *)inputname; //정보추출//
- (NSString *)db_Select_User_Info_password:(NSString *)inputname input_id:(NSString *)input_id;

@end
