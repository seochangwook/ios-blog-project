//
//  DBController.m
//  Swift_sample_app
//
//  Created by apple on 2016. 7. 17..
//  Copyright © 2016년 apple. All rights reserved.
//

#import "DBController.h"
#import <sqlite3.h> //C의 API로 구성된 sqlite3라이브러리 모듈 적재//

@implementation DBController
{
    //후에 파싱등으로 배열을 하나로 만들 수 있다.//
    NSMutableArray *Name_Result; //이름 배열
    NSMutableArray *id_Result; //아이디 배열
    NSMutableArray *email_Result; //이메일 배열
    NSMutableArray *tel_Result; //전화번호 배열
    NSMutableArray *address_Result; //주소 배열
    NSMutableArray *image_Result; //이미지 배열
    NSMutableArray *success_Result; //승점 배열//
    NSMutableArray *lose_Result; //실점 배열//
    
    /** 정렬관련 배열 **/
    NSMutableArray *desc_memberlist; //내림차순 정렬배열//
    NSMutableArray *asc_memberlist; //내림차순 정렬배열//
    
    /** 문자열 **/
    NSMutableString *info_str;
    NSMutableString *info_str_password;
}

- (BOOL)DB_Connect_func
{
    BOOL is_check = false; //처음은 오픈에 실패했다고 가정.//
    
    //데이터베이스 작업을 위해서 먼저 디비파일의 경로를 불러오고 개방 후 작업을 하고 다시 개방되어 있는것을 닫는다.//
    
    //도큐먼트 디렉터리 위치 구하기//
    NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    //도큐먼트 위치에 db.sqlite 파일명으로 경로 설정//
    NSString *filePath = [documentDirectory stringByAppendingPathComponent:@"db.sqlite"];
    
    //파일이 존재하는지 확인//
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if([fileManager fileExistsAtPath:filePath])
    {
        //NSLog(@"file path : %@", filePath);
        
        //return ;
    }
    
    NSLog(@"file path : %@", filePath);
    
    //데이터베이스 연결//
    //해당 위치에 데이터베이스 없을 경우에 생성해서 연결//
    sqlite3 *database; //sqlite3 데이터베이스 선언. 데이터베이스 핸들러 정의//
    
    char *error_msg = nil; //에러메시지를 받을 문자열 변수//
    
    //모든 데이터베이스관련 작업이 정상적으로 수행되었는지 확인하기 위해서 SQLITE_OK상수랑 비교해준다.//
    //현재 작업할려는 sqlite3의 참조변수인 database에 기존에 설정해준 filePath를 이용해서 연결해준다.//
    if(sqlite3_open([filePath UTF8String], &database) != SQLITE_OK)
    {
        //strcpy(error_msg, "DB Open ERROR");
        
        sqlite3_close(database);
        
        NSLog(@"QUERY RESULT MSG : [ERROR] DB Open ERROR");
    }
    
    else
    {
        NSLog(@"QUERY RESULT MSG : [SUCCESS] DB Open Success!!");
        
        is_check = true;
    }
    
    return is_check;
}
///////////////////
- (BOOL)DB_Table_Create
{
    BOOL is_check = false; //처음은 오픈에 실패했다고 가정.//
    //데이터베이스 작업을 위해서 먼저 디비파일의 경로를 불러오고 개방 후 작업을 하고 다시 개방되어 있는것을 닫는다.//
    
    //도큐먼트 디렉터리 위치 구하기//
    NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    //도큐먼트 위치에 db.sqlite 파일명으로 경로 설정//
    NSString *filePath = [documentDirectory stringByAppendingPathComponent:@"db.sqlite"];
    
    //파일이 존재하는지 확인//
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if([fileManager fileExistsAtPath:filePath])
    {
        //NSLog(@"file path : %@", filePath);
        
        //return ;
    }
    
    NSLog(@"file path : %@", filePath);
    
    //데이터베이스 연결//
    //해당 위치에 데이터베이스 없을 경우에 생성해서 연결//
    sqlite3 *database; //sqlite3 데이터베이스 선언. 데이터베이스 핸들러 정의//
    
    char *error_msg = nil; //에러메시지를 받을 문자열 변수//
    
    //모든 데이터베이스관련 작업이 정상적으로 수행되었는지 확인하기 위해서 SQLITE_OK상수랑 비교해준다.//
    //현재 작업할려는 sqlite3의 참조변수인 database에 기존에 설정해준 filePath를 이용해서 연결해준다.//
    if(sqlite3_open([filePath UTF8String], &database) != SQLITE_OK)
    {
        //strcpy(error_msg, "DB Open ERROR");
        
        sqlite3_close(database);
        
        //NSLog(@"QUERY RESULT MSG : [ERROR] DB Open ERROR");
    }
    
    else
    {
        //NSLog(@"QUERY RESULT MSG : [SUCCESS] DB Open Success!!");
    }
    
    //테이블 생성문(C언어 라이브러리이기에 NSString *이 아닌 char *로 사용한다.)//
    //no 속성은 정수타입이고 기본키이고 널을 허용하지 않는다는 제약조건을 가지고 있다.//
    char *sql = "CREATE TABLE game_member (no INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, member_id CHAR, member_password CHAR, member_email_address CHAR, member_tel CHAR, member_address CHAR, member_name CHAR, member_profile_image CHAR, member_success_count CHAR, member_lose_count CHAR)";
    
    //sqlite3_exec 쿼리문을 실행 할 수 있다.마지막 인자로 에러메시지를 받을 문자열을 넣어준다.//
    if(sqlite3_exec(database, sql, nil, nil, &error_msg) != SQLITE_OK)
    {
        //에러가 난 경우는 이미 해당 테이블이 만들어진 경우이다.//
        sqlite3_close(database); //만약 수행할 수 없다면(쿼리문 에러) 개방했던 데이터베이스를 닫는다.//
        
        NSLog(@"QUERY RESULT MSG : [ERROR] %s", error_msg);
    }
    
    else
    {
        NSLog(@"QUERY RESULT MSG : [SUCCESS] query ok");
        
        is_check = true;
    }
    
    sqlite3_close(database); //오픈된 데이터베이스를 닫는다. 해당 핸들러를 사용하지 않는다.//
    
    NSLog(@"QUERY RESULT MSG : [SUCCESS] DB Close Success!!");
    
    return is_check;
}
////////////////
- (BOOL)DB_Search_id:(NSString *)search_id
{
    BOOL search_check = false; //처음엔 없다고 가정.//
    
    //검색할려는 id를 보존하기 위해서 임시변수에 저장//
    NSString *search_temp_id = search_id;
    
    NSLog(@"db search id : %@", search_temp_id);
    
    //검색//
    //데이터베이스에서 조건을 주어서 탐색한다.//
    //도큐먼트 디렉터리 위치 구하기//
    NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    //도큐먼트 위치에 db.sqlite 파일명으로 경로 설정//
    NSString *filePath = [documentDirectory stringByAppendingPathComponent:@"db.sqlite"];
    
    //파일이 존재하는지 확인//
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if([fileManager fileExistsAtPath:filePath])
    {
        //NSLog(@"file path : %@", filePath);
        
        //return ;
    }
    
    NSLog(@"file path : %@", filePath);
    
    //데이터베이스 연결//
    //해당 위치에 데이터베이스 없을 경우에 생성해서 연결//
    sqlite3 *database; //sqlite3 데이터베이스 선언. 데이터베이스 핸들러 정의//
    
    char *error_msg = nil; //에러메시지를 받을 문자열 변수//
    
    //모든 데이터베이스관련 작업이 정상적으로 수행되었는지 확인하기 위해서 SQLITE_OK상수랑 비교해준다.//
    //현재 작업할려는 sqlite3의 참조변수인 database에 기존에 설정해준 filePath를 이용해서 연결해준다.//
    if(sqlite3_open([filePath UTF8String], &database) != SQLITE_OK)
    {
        //strcpy(error_msg, "DB Open ERROR");
        
        sqlite3_close(database);
        
        NSLog(@"QUERY RESULT MSG : [ERROR] DB Open ERROR");
    }
    
    else
    {
        NSLog(@"QUERY RESULT MSG : [SUCCESS] DB Open Success!!");
    }
    
    //컬럼들을 돌면서 검색//
    sqlite3 *select_stmt;
    
    char *select_sql = "SELECT member_id FROM game_member"; //현재 게임앱에 등록된 모든 사용자의 id를 추출//
    int ret;
    int searchid = [search_id intValue]; //탐색할려는 id를 정수형으로 변경//
    
    //데이터베이스 작업을 하기 위해서 준비작업 진행(PrepareStatement)
    ret = sqlite3_prepare_v2(database, select_sql, -1, &select_stmt, NULL);
    
    if(ret == SQLITE_OK) //준비작업에 성공한 경우//
    {
        NSLog(@"<GAME ID Searching...>");
        
        //'?'가 없기에 따로 bind할 필요가 없다.//
        while(sqlite3_step(select_stmt) == SQLITE_ROW) //step을 이용해서 튜플을 하나씩 이동(SQLITE_ROW).//
        {
            //0번째 컴럼의 값을 가져온다. CHAR이기에 sqlite3_column_text를 이용한다. stringWithFormat으로 정수형으로 변경.//
            NSString *get_id = [NSString stringWithFormat:@"%s", sqlite3_column_text(select_stmt, 0)];
            
            NSLog(@"search id: %@", search_id);
            NSLog(@"get id: %@", get_id);
            
            //비교 후 같은 id가 하나롣 있으면 반복을 종료.//
            if([search_id isEqualToString:get_id])
            {
                search_check = true; //id가 존재하면 true를 반환.//
                
                break;
            }
        }
    }
    
    else
    {
        NSLog(@"QUERY RESULT MSG : [ERROR] DB Prepare ERROR");
    }
    
    //다 수행했으면 데이터베이스를 다시 닫아준다.//
    sqlite3_finalize(select_stmt);
    sqlite3_close(database); //오픈된 데이터베이스를 닫는다. 해당 핸들러를 사용하지 않는다.//
    
    return search_check;
}
///////////////
- (BOOL)DB_Insert_User_info:(NSString *)input_id
             input_password:(NSString *)input_password
                input_email:(NSString *)input_email
                  input_tel:(NSString *)input_tel
              input_address:(NSString *)input_address
                 input_name:(NSString *)input_name
                input_image:(NSString *)input_image
              input_success:(NSString *)input_success
                 input_lose:(NSString *)input_lose;
{
    BOOL insert_user_info_check = false; //정상적으로 저장하지 못했다는걸로 가정//
    
    NSLog(@"enroll is success:", insert_user_info_check);
    
    //우선적으로 데이터베이스를 개방한다.//
    //도큐먼트 디렉터리 위치 구하기//
    NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    //도큐먼트 위치에 db.sqlite 파일명으로 경로 설정//
    NSString *filePath = [documentDirectory stringByAppendingPathComponent:@"db.sqlite"];
    
    //파일이 존재하는지 확인//
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if([fileManager fileExistsAtPath:filePath])
    {
        //NSLog(@"file path : %@", filePath);
        
        //return ;
    }
    
    NSLog(@"file path : %@", filePath);
    
    sqlite3 *database;
    
    char *error_msg = nil;
    
    if(sqlite3_open([filePath UTF8String],&database) != SQLITE_OK)
    {
        //strcpy(error_msg, "DB Open ERROR");
        
        sqlite3_close(database);
        
        NSLog(@"QUERY RESULT MSG : [ERROR] DB Open ERROR");
    }
    
    else
    {
        NSLog(@"QUERY RESULT MSG : [SUCCESS] DB Open Success!!");
    }
    
    //INSERT 작업//
    sqlite3_stmt *insert_sql;
    
    char *sql = "INSERT INTO game_member(member_id, member_password, member_email_address, member_tel, member_address, member_name, member_profile_image,member_success_count,member_lose_count) VALUES(?,?,?,?,?,?,?,?,?)";
    
    if(sqlite3_prepare_v2(database, sql, -1, &insert_sql, NULL) == SQLITE_OK)
    {
        //bind로 '?'에 값을 할당해준다. PrepareStatement방식 적용//
        sqlite3_bind_text(insert_sql, 1, [input_id UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(insert_sql, 2, [input_password UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(insert_sql, 3, [input_email UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(insert_sql, 4, [input_tel UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(insert_sql, 5, [input_address UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(insert_sql, 6, [input_name UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(insert_sql, 7, [input_image UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(insert_sql, 8, [input_success UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(insert_sql, 9, [input_lose UTF8String], -1, SQLITE_TRANSIENT);
        
        if(sqlite3_step(insert_sql) != SQLITE_DONE)
        {
            strcpy(error_msg, "INSERT ERROR");
            
            NSLog(@"QUERY RESULT MSG : [ERROR] %s", error_msg);
        }
        
        else
        {
            NSLog(@"QUERY RESULT MSG : [SUCCESS] query ok");
            
            insert_user_info_check = true;
        }
    }
    
    //데이터베이스 사용이 끝나면 할당되어 있던 참조를 제거//
    sqlite3_close(database);
    
    NSLog(@"QUERY RESULT MSG : [SUCCESS] DB Close Success!!");
    
    return insert_user_info_check;
}
/////////////////
- (NSMutableArray *)DB_Select_User_Name:(NSString *)flag
{
    //검색//
    //데이터베이스에서 조건을 주어서 탐색한다.//
    //도큐먼트 디렉터리 위치 구하기//
    NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    //도큐먼트 위치에 db.sqlite 파일명으로 경로 설정//
    NSString *filePath = [documentDirectory stringByAppendingPathComponent:@"db.sqlite"];
    
    //파일이 존재하는지 확인//
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if([fileManager fileExistsAtPath:filePath])
    {
        //NSLog(@"file path : %@", filePath);
        
        //return ;
    }
    
    NSLog(@"file path : %@", filePath);
    
    //데이터베이스 연결//
    //해당 위치에 데이터베이스 없을 경우에 생성해서 연결//
    sqlite3 *database; //sqlite3 데이터베이스 선언. 데이터베이스 핸들러 정의//
    
    char *error_msg = nil; //에러메시지를 받을 문자열 변수//
    
    //모든 데이터베이스관련 작업이 정상적으로 수행되었는지 확인하기 위해서 SQLITE_OK상수랑 비교해준다.//
    //현재 작업할려는 sqlite3의 참조변수인 database에 기존에 설정해준 filePath를 이용해서 연결해준다.//
    if(sqlite3_open([filePath UTF8String], &database) != SQLITE_OK)
    {
        //strcpy(error_msg, "DB Open ERROR");
        
        sqlite3_close(database);
        
        NSLog(@"QUERY RESULT MSG : [ERROR] DB Open ERROR");
    }
    
    else
    {
        NSLog(@"QUERY RESULT MSG : [SUCCESS] DB Open Success!!");
    }
    
    //저장할 배열을 선언. 초기용량은 0으로 한다.//
    Name_Result = [NSMutableArray arrayWithCapacity:0];
    
    //데이터 출력//
    sqlite3_stmt *select_stmt;
    char *select_sql; //쿼리문//
    
    //플래그에 따라 쿼리문을 변경해준다.//
    if([flag isEqualToString:@"2"])
    {
        select_sql = "SELECT member_name FROM game_member";
    }
    
    else if([flag isEqualToString:@"0"]) //내림차순//
    {
        select_sql = "SELECT member_name FROM game_member ORDER BY member_success_count DESC";
    }
    
    else if([flag isEqualToString:@"1"]) //오름차순//
    {
        select_sql = "SELECT member_name FROM game_member ORDER BY member_success_count ASC";
    }
    
    int ret;
    
    ret = sqlite3_prepare_v2(database, select_sql, -1, &select_stmt, NULL);
    
    if(ret == SQLITE_OK)
    {
        NSLog(@"<GAME LOG PRINT>");
        
        //sqlite3_bind_int(select_stmt, 1, 2); //조건절에 대한 변수 바인딩//
        
        while(sqlite3_step(select_stmt) == SQLITE_ROW) //각 튜플들을 모두 탐색//
        {
            //Mutable은 변경가능하다는 뜻//
            NSMutableString *result_string = [[NSMutableString alloc]init]; //할당//
            
            //한글 인코딩 변환 필요(stringWithUTF8String)//
            [result_string appendString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(select_stmt, 0)]];
            
            //결과문자열을 배열에 저장//
            [Name_Result addObject:result_string];
        }
    }
    
    NSLog(@"array count : %ld\n", [Name_Result count]);
    
    for(int i=0; i<[Name_Result count]; i++)
    {
        //NSLog(@"%@", [Name_Result objectAtIndex:i]);
    }
    
    sqlite3_finalize(select_stmt); //검색을 다 했으면 종료//
    
    sqlite3_close(database); //오픈된 데이터베이스를 닫는다. 해당 핸들러를 사용하지 않는다.//
    
    NSLog(@"QUERY RESULT MSG : [SUCCESS] DB Close Success!!");
    
    return Name_Result;
}
////////////////////
- (NSMutableArray *)DB_Select_User_id:(NSString *)flag
{
    //검색//
    //데이터베이스에서 조건을 주어서 탐색한다.//
    //도큐먼트 디렉터리 위치 구하기//
    NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    //도큐먼트 위치에 db.sqlite 파일명으로 경로 설정//
    NSString *filePath = [documentDirectory stringByAppendingPathComponent:@"db.sqlite"];
    
    //파일이 존재하는지 확인//
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if([fileManager fileExistsAtPath:filePath])
    {
        //NSLog(@"file path : %@", filePath);
        
        //return ;
    }
    
    NSLog(@"file path : %@", filePath);
    
    //데이터베이스 연결//
    //해당 위치에 데이터베이스 없을 경우에 생성해서 연결//
    sqlite3 *database; //sqlite3 데이터베이스 선언. 데이터베이스 핸들러 정의//
    
    char *error_msg = nil; //에러메시지를 받을 문자열 변수//
    
    //모든 데이터베이스관련 작업이 정상적으로 수행되었는지 확인하기 위해서 SQLITE_OK상수랑 비교해준다.//
    //현재 작업할려는 sqlite3의 참조변수인 database에 기존에 설정해준 filePath를 이용해서 연결해준다.//
    if(sqlite3_open([filePath UTF8String], &database) != SQLITE_OK)
    {
        //strcpy(error_msg, "DB Open ERROR");
        
        sqlite3_close(database);
        
        NSLog(@"QUERY RESULT MSG : [ERROR] DB Open ERROR");
    }
    
    else
    {
        NSLog(@"QUERY RESULT MSG : [SUCCESS] DB Open Success!!");
    }
    
    //저장할 배열을 선언. 초기용량은 0으로 한다.//
    id_Result = [NSMutableArray arrayWithCapacity:0];
    
    //데이터 출력//
    sqlite3_stmt *select_stmt;
    char *select_sql; //쿼리문//
    
    //플래그에 따라 쿼리문을 변경해준다.//
    if([flag isEqualToString:@"2"])
    {
        select_sql = "SELECT member_id FROM game_member";
    }
    
    else if([flag isEqualToString:@"0"]) //내림차순//
    {
        select_sql = "SELECT member_id FROM game_member ORDER BY member_success_count DESC";
    }
    
    else if([flag isEqualToString:@"1"]) //오름차순//
    {
        select_sql = "SELECT member_id FROM game_member ORDER BY member_success_count ASC";
    }
    
    int ret;
    
    ret = sqlite3_prepare_v2(database, select_sql, -1, &select_stmt, NULL);
    
    if(ret == SQLITE_OK)
    {
        NSLog(@"<GAME LOG PRINT>");
        
        //sqlite3_bind_int(select_stmt, 1, 2); //조건절에 대한 변수 바인딩//
        
        while(sqlite3_step(select_stmt) == SQLITE_ROW) //각 튜플들을 모두 탐색//
        {
            //Mutable은 변경가능하다는 뜻//
            NSMutableString *result_string = [[NSMutableString alloc]init]; //할당//
            
            [result_string appendString:[NSString stringWithFormat:@"%s", sqlite3_column_text(select_stmt, 0)]];
            
            //결과문자열을 배열에 저장//
            [id_Result addObject:result_string];
        }
    }
    
    NSLog(@"array count : %ld\n", [id_Result count]);
    
    for(int i=0; i<[id_Result count]; i++)
    {
        //NSLog(@"%@", [Name_Result objectAtIndex:i]);
    }
    
    sqlite3_finalize(select_stmt); //검색을 다 했으면 종료//
    
    sqlite3_close(database); //오픈된 데이터베이스를 닫는다. 해당 핸들러를 사용하지 않는다.//
    
    NSLog(@"QUERY RESULT MSG : [SUCCESS] DB Close Success!!");
    
    return id_Result;
}
////////////////
- (NSMutableArray *)DB_Select_User_image:(NSString *)flag
{
    //검색//
    //데이터베이스에서 조건을 주어서 탐색한다.//
    //도큐먼트 디렉터리 위치 구하기//
    NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    //도큐먼트 위치에 db.sqlite 파일명으로 경로 설정//
    NSString *filePath = [documentDirectory stringByAppendingPathComponent:@"db.sqlite"];
    
    //파일이 존재하는지 확인//
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if([fileManager fileExistsAtPath:filePath])
    {
        //NSLog(@"file path : %@", filePath);
        
        //return ;
    }
    
    NSLog(@"file path : %@", filePath);
    
    //데이터베이스 연결//
    //해당 위치에 데이터베이스 없을 경우에 생성해서 연결//
    sqlite3 *database; //sqlite3 데이터베이스 선언. 데이터베이스 핸들러 정의//
    
    char *error_msg = nil; //에러메시지를 받을 문자열 변수//
    
    //모든 데이터베이스관련 작업이 정상적으로 수행되었는지 확인하기 위해서 SQLITE_OK상수랑 비교해준다.//
    //현재 작업할려는 sqlite3의 참조변수인 database에 기존에 설정해준 filePath를 이용해서 연결해준다.//
    if(sqlite3_open([filePath UTF8String], &database) != SQLITE_OK)
    {
        //strcpy(error_msg, "DB Open ERROR");
        
        sqlite3_close(database);
        
        NSLog(@"QUERY RESULT MSG : [ERROR] DB Open ERROR");
    }
    
    else
    {
        NSLog(@"QUERY RESULT MSG : [SUCCESS] DB Open Success!!");
    }
    
    //저장할 배열을 선언. 초기용량은 0으로 한다.//
    image_Result = [NSMutableArray arrayWithCapacity:0];
    
    //데이터 출력//
    sqlite3_stmt *select_stmt;
    char *select_sql; //쿼리문//
    
    //플래그에 따라 쿼리문을 변경해준다.//
    if([flag isEqualToString:@"2"])
    {
        select_sql = "SELECT member_profile_image FROM game_member";
    }
    
    else if([flag isEqualToString:@"0"]) //내림차순//
    {
        select_sql = "SELECT member_profile_image FROM game_member ORDER BY member_success_count DESC";
    }
    
    else if([flag isEqualToString:@"1"]) //오름차순//
    {
        select_sql = "SELECT member_profile_image FROM game_member ORDER BY member_success_count ASC";
    }
    
    int ret;
    
    ret = sqlite3_prepare_v2(database, select_sql, -1, &select_stmt, NULL);
    
    if(ret == SQLITE_OK)
    {
        NSLog(@"<GAME LOG PRINT>");
        
        //sqlite3_bind_int(select_stmt, 1, 2); //조건절에 대한 변수 바인딩//
        
        while(sqlite3_step(select_stmt) == SQLITE_ROW) //각 튜플들을 모두 탐색//
        {
            //Mutable은 변경가능하다는 뜻//
            NSMutableString *result_string = [[NSMutableString alloc]init]; //할당//
            
            [result_string appendString:[NSString stringWithFormat:@"%s", sqlite3_column_text(select_stmt, 0)]];
            
            //결과문자열을 배열에 저장//
            [image_Result addObject:result_string];
        }
    }
    
    NSLog(@"array count : %ld\n", [image_Result count]);
    
    for(int i=0; i<[image_Result count]; i++)
    {
        //NSLog(@"%@", [Name_Result objectAtIndex:i]);
    }
    
    sqlite3_finalize(select_stmt); //검색을 다 했으면 종료//
    
    sqlite3_close(database); //오픈된 데이터베이스를 닫는다. 해당 핸들러를 사용하지 않는다.//
    
    NSLog(@"QUERY RESULT MSG : [SUCCESS] DB Close Success!!");
    
    return image_Result;
}
///////////////////
- (NSMutableArray *)db_Select_User_address:(NSString *)flag
{
    //검색//
    //데이터베이스에서 조건을 주어서 탐색한다.//
    //도큐먼트 디렉터리 위치 구하기//
    NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    //도큐먼트 위치에 db.sqlite 파일명으로 경로 설정//
    NSString *filePath = [documentDirectory stringByAppendingPathComponent:@"db.sqlite"];
    
    //파일이 존재하는지 확인//
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if([fileManager fileExistsAtPath:filePath])
    {
        //NSLog(@"file path : %@", filePath);
        
        //return ;
    }
    
    NSLog(@"file path : %@", filePath);
    
    //데이터베이스 연결//
    //해당 위치에 데이터베이스 없을 경우에 생성해서 연결//
    sqlite3 *database; //sqlite3 데이터베이스 선언. 데이터베이스 핸들러 정의//
    
    char *error_msg = nil; //에러메시지를 받을 문자열 변수//
    
    //모든 데이터베이스관련 작업이 정상적으로 수행되었는지 확인하기 위해서 SQLITE_OK상수랑 비교해준다.//
    //현재 작업할려는 sqlite3의 참조변수인 database에 기존에 설정해준 filePath를 이용해서 연결해준다.//
    if(sqlite3_open([filePath UTF8String], &database) != SQLITE_OK)
    {
        //strcpy(error_msg, "DB Open ERROR");
        
        sqlite3_close(database);
        
        NSLog(@"QUERY RESULT MSG : [ERROR] DB Open ERROR");
    }
    
    else
    {
        NSLog(@"QUERY RESULT MSG : [SUCCESS] DB Open Success!!");
    }
    
    //저장할 배열을 선언. 초기용량은 0으로 한다.//
    address_Result = [NSMutableArray arrayWithCapacity:0];
    
    //데이터 출력//
    sqlite3_stmt *select_stmt;
    char *select_sql; //쿼리문//
    
    //플래그에 따라 쿼리문을 변경해준다.//
    if([flag isEqualToString:@"2"])
    {
        select_sql = "SELECT member_address FROM game_member";
    }
    
    else if([flag isEqualToString:@"0"]) //내림차순//
    {
        select_sql = "SELECT member_address FROM game_member ORDER BY member_success_count DESC";
    }
    
    else if([flag isEqualToString:@"1"]) //오름차순//
    {
        select_sql = "SELECT member_address FROM game_member ORDER BY member_success_count ASC";
    }
    
    int ret;
    
    ret = sqlite3_prepare_v2(database, select_sql, -1, &select_stmt, NULL);
    
    if(ret == SQLITE_OK)
    {
        NSLog(@"<GAME LOG PRINT>");
        
        //sqlite3_bind_int(select_stmt, 1, 2); //조건절에 대한 변수 바인딩//
        
        while(sqlite3_step(select_stmt) == SQLITE_ROW) //각 튜플들을 모두 탐색//
        {
            //Mutable은 변경가능하다는 뜻//
            NSMutableString *result_string = [[NSMutableString alloc]init]; //할당//
            
            [result_string appendString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(select_stmt, 0)]];
            
            //결과문자열을 배열에 저장//
            [address_Result addObject:result_string];
        }
    }
    
    NSLog(@"array count : %ld\n", [image_Result count]);
    
    for(int i=0; i<[address_Result count]; i++)
    {
        //NSLog(@"%@", [Name_Result objectAtIndex:i]);
    }
    
    sqlite3_finalize(select_stmt); //검색을 다 했으면 종료//
    
    sqlite3_close(database); //오픈된 데이터베이스를 닫는다. 해당 핸들러를 사용하지 않는다.//
    
    NSLog(@"QUERY RESULT MSG : [SUCCESS] DB Close Success!!");
    
    return address_Result;
}
//////////////////////
- (NSMutableArray *)db_Select_User_phonenumber:(NSString *)flag
{
    //검색//
    //데이터베이스에서 조건을 주어서 탐색한다.//
    //도큐먼트 디렉터리 위치 구하기//
    NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    //도큐먼트 위치에 db.sqlite 파일명으로 경로 설정//
    NSString *filePath = [documentDirectory stringByAppendingPathComponent:@"db.sqlite"];
    
    //파일이 존재하는지 확인//
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if([fileManager fileExistsAtPath:filePath])
    {
        //NSLog(@"file path : %@", filePath);
        
        //return ;
    }
    
    NSLog(@"file path : %@", filePath);
    
    //데이터베이스 연결//
    //해당 위치에 데이터베이스 없을 경우에 생성해서 연결//
    sqlite3 *database; //sqlite3 데이터베이스 선언. 데이터베이스 핸들러 정의//
    
    char *error_msg = nil; //에러메시지를 받을 문자열 변수//
    
    //모든 데이터베이스관련 작업이 정상적으로 수행되었는지 확인하기 위해서 SQLITE_OK상수랑 비교해준다.//
    //현재 작업할려는 sqlite3의 참조변수인 database에 기존에 설정해준 filePath를 이용해서 연결해준다.//
    if(sqlite3_open([filePath UTF8String], &database) != SQLITE_OK)
    {
        //strcpy(error_msg, "DB Open ERROR");
        
        sqlite3_close(database);
        
        NSLog(@"QUERY RESULT MSG : [ERROR] DB Open ERROR");
    }
    
    else
    {
        NSLog(@"QUERY RESULT MSG : [SUCCESS] DB Open Success!!");
    }
    
    //저장할 배열을 선언. 초기용량은 0으로 한다.//
    tel_Result = [NSMutableArray arrayWithCapacity:0];
    
    //데이터 출력//
    sqlite3_stmt *select_stmt;
    char *select_sql; //쿼리문//
    
    //플래그에 따라 쿼리문을 변경해준다.//
    if([flag isEqualToString:@"2"])
    {
        select_sql = "SELECT member_tel FROM game_member";
    }
    
    else if([flag isEqualToString:@"0"]) //내림차순//
    {
        select_sql = "SELECT member_tel FROM game_member ORDER BY member_success_count DESC";
    }
    
    else if([flag isEqualToString:@"1"]) //오름차순//
    {
        select_sql = "SELECT member_tel FROM game_member ORDER BY member_success_count ASC";
    }
    
    int ret;
    
    ret = sqlite3_prepare_v2(database, select_sql, -1, &select_stmt, NULL);
    
    if(ret == SQLITE_OK)
    {
        NSLog(@"<GAME LOG PRINT>");
        
        //sqlite3_bind_int(select_stmt, 1, 2); //조건절에 대한 변수 바인딩//
        
        while(sqlite3_step(select_stmt) == SQLITE_ROW) //각 튜플들을 모두 탐색//
        {
            //Mutable은 변경가능하다는 뜻//
            NSMutableString *result_string = [[NSMutableString alloc]init]; //할당//
            
            [result_string appendString:[NSString stringWithFormat:@"%s", sqlite3_column_text(select_stmt, 0)]];
            
            //결과문자열을 배열에 저장//
            [tel_Result addObject:result_string];
        }
    }
    
    NSLog(@"array count : %ld\n", [tel_Result count]);
    
    for(int i=0; i<[tel_Result count]; i++)
    {
        //NSLog(@"%@", [Name_Result objectAtIndex:i]);
    }
    
    sqlite3_finalize(select_stmt); //검색을 다 했으면 종료//
    
    sqlite3_close(database); //오픈된 데이터베이스를 닫는다. 해당 핸들러를 사용하지 않는다.//
    
    NSLog(@"QUERY RESULT MSG : [SUCCESS] DB Close Success!!");
    
    return tel_Result;
}
////////////////////////
- (NSMutableArray *)db_Select_User_emailaddress:(NSString *)flag
{
    //검색//
    //데이터베이스에서 조건을 주어서 탐색한다.//
    //도큐먼트 디렉터리 위치 구하기//
    NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    //도큐먼트 위치에 db.sqlite 파일명으로 경로 설정//
    NSString *filePath = [documentDirectory stringByAppendingPathComponent:@"db.sqlite"];
    
    //파일이 존재하는지 확인//
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if([fileManager fileExistsAtPath:filePath])
    {
        //NSLog(@"file path : %@", filePath);
        
        //return ;
    }
    
    NSLog(@"file path : %@", filePath);
    
    //데이터베이스 연결//
    //해당 위치에 데이터베이스 없을 경우에 생성해서 연결//
    sqlite3 *database; //sqlite3 데이터베이스 선언. 데이터베이스 핸들러 정의//
    
    char *error_msg = nil; //에러메시지를 받을 문자열 변수//
    
    //모든 데이터베이스관련 작업이 정상적으로 수행되었는지 확인하기 위해서 SQLITE_OK상수랑 비교해준다.//
    //현재 작업할려는 sqlite3의 참조변수인 database에 기존에 설정해준 filePath를 이용해서 연결해준다.//
    if(sqlite3_open([filePath UTF8String], &database) != SQLITE_OK)
    {
        //strcpy(error_msg, "DB Open ERROR");
        
        sqlite3_close(database);
        
        NSLog(@"QUERY RESULT MSG : [ERROR] DB Open ERROR");
    }
    
    else
    {
        NSLog(@"QUERY RESULT MSG : [SUCCESS] DB Open Success!!");
    }
    
    //저장할 배열을 선언. 초기용량은 0으로 한다.//
    email_Result = [NSMutableArray arrayWithCapacity:0];
    
    //데이터 출력//
    sqlite3_stmt *select_stmt;
    char *select_sql; //쿼리문//
    
    //플래그에 따라 쿼리문을 변경해준다.//
    if([flag isEqualToString:@"2"])
    {
        select_sql = "SELECT member_email_address FROM game_member";
    }
    
    else if([flag isEqualToString:@"0"]) //내림차순//
    {
        select_sql = "SELECT member_email_address FROM game_member ORDER BY member_success_count DESC";
    }
    
    else if([flag isEqualToString:@"1"]) //오름차순//
    {
        select_sql = "SELECT member_email_address FROM game_member ORDER BY member_success_count ASC";
    }
    
    int ret;
    
    ret = sqlite3_prepare_v2(database, select_sql, -1, &select_stmt, NULL);
    
    if(ret == SQLITE_OK)
    {
        NSLog(@"<GAME LOG PRINT>");
        
        //sqlite3_bind_int(select_stmt, 1, 2); //조건절에 대한 변수 바인딩//
        
        while(sqlite3_step(select_stmt) == SQLITE_ROW) //각 튜플들을 모두 탐색//
        {
            //Mutable은 변경가능하다는 뜻//
            NSMutableString *result_string = [[NSMutableString alloc]init]; //할당//
            
            [result_string appendString:[NSString stringWithFormat:@"%s", sqlite3_column_text(select_stmt, 0)]];
            
            //결과문자열을 배열에 저장//
            [email_Result addObject:result_string];
        }
    }
    
    NSLog(@"array count : %ld\n", [email_Result count]);
    
    for(int i=0; i<[email_Result count]; i++)
    {
        //NSLog(@"%@", [Name_Result objectAtIndex:i]);
    }
    
    sqlite3_finalize(select_stmt); //검색을 다 했으면 종료//
    
    sqlite3_close(database); //오픈된 데이터베이스를 닫는다. 해당 핸들러를 사용하지 않는다.//
    
    NSLog(@"QUERY RESULT MSG : [SUCCESS] DB Close Success!!");
    
    return email_Result;
}
/////////////////////////
- (NSMutableArray *)db_Select_User_success:(NSString *)flag
{
    //검색//
    //데이터베이스에서 조건을 주어서 탐색한다.//
    //도큐먼트 디렉터리 위치 구하기//
    NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    //도큐먼트 위치에 db.sqlite 파일명으로 경로 설정//
    NSString *filePath = [documentDirectory stringByAppendingPathComponent:@"db.sqlite"];
    
    //파일이 존재하는지 확인//
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if([fileManager fileExistsAtPath:filePath])
    {
        //NSLog(@"file path : %@", filePath);
        
        //return ;
    }
    
    NSLog(@"file path : %@", filePath);
    
    //데이터베이스 연결//
    //해당 위치에 데이터베이스 없을 경우에 생성해서 연결//
    sqlite3 *database; //sqlite3 데이터베이스 선언. 데이터베이스 핸들러 정의//
    
    char *error_msg = nil; //에러메시지를 받을 문자열 변수//
    
    //모든 데이터베이스관련 작업이 정상적으로 수행되었는지 확인하기 위해서 SQLITE_OK상수랑 비교해준다.//
    //현재 작업할려는 sqlite3의 참조변수인 database에 기존에 설정해준 filePath를 이용해서 연결해준다.//
    if(sqlite3_open([filePath UTF8String], &database) != SQLITE_OK)
    {
        //strcpy(error_msg, "DB Open ERROR");
        
        sqlite3_close(database);
        
        NSLog(@"QUERY RESULT MSG : [ERROR] DB Open ERROR");
    }
    
    else
    {
        NSLog(@"QUERY RESULT MSG : [SUCCESS] DB Open Success!!");
    }
    
    //저장할 배열을 선언. 초기용량은 0으로 한다.//
    success_Result = [NSMutableArray arrayWithCapacity:0];
    
    //데이터 출력//
    sqlite3_stmt *select_stmt;
    char *select_sql; //쿼리문//
    
    //플래그에 따라 쿼리문을 변경해준다.//
    if([flag isEqualToString:@"2"])
    {
        select_sql = "SELECT member_success_count FROM game_member";
    }
    
    else if([flag isEqualToString:@"0"]) //내림차순//
    {
        select_sql = "SELECT member_success_count FROM game_member ORDER BY member_success_count DESC";
    }
    
    else if([flag isEqualToString:@"1"]) //오름차순//
    {
        select_sql = "SELECT member_success_count FROM game_member ORDER BY member_success_count ASC";
    }
    
    int ret;
    
    ret = sqlite3_prepare_v2(database, select_sql, -1, &select_stmt, NULL);
    
    if(ret == SQLITE_OK)
    {
        NSLog(@"<GAME LOG PRINT>");
        
        //sqlite3_bind_int(select_stmt, 1, 2); //조건절에 대한 변수 바인딩//
        
        while(sqlite3_step(select_stmt) == SQLITE_ROW) //각 튜플들을 모두 탐색//
        {
            //Mutable은 변경가능하다는 뜻//
            NSMutableString *result_string = [[NSMutableString alloc]init]; //할당//
            
            [result_string appendString:[NSString stringWithFormat:@"%s", sqlite3_column_text(select_stmt, 0)]];
            
            //결과문자열을 배열에 저장//
            [success_Result addObject:result_string];
        }
    }
    
    NSLog(@"array count : %ld\n", [success_Result count]);
    
    for(int i=0; i<[success_Result count]; i++)
    {
        //NSLog(@"%@", [Name_Result objectAtIndex:i]);
    }
    
    sqlite3_finalize(select_stmt); //검색을 다 했으면 종료//
    
    sqlite3_close(database); //오픈된 데이터베이스를 닫는다. 해당 핸들러를 사용하지 않는다.//
    
    NSLog(@"QUERY RESULT MSG : [SUCCESS] DB Close Success!!");
    
    return success_Result;
}
////////////////////////
- (NSMutableArray *)db_Select_User_fail:(NSString *)flag
{
    //검색//
    //데이터베이스에서 조건을 주어서 탐색한다.//
    //도큐먼트 디렉터리 위치 구하기//
    NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    //도큐먼트 위치에 db.sqlite 파일명으로 경로 설정//
    NSString *filePath = [documentDirectory stringByAppendingPathComponent:@"db.sqlite"];
    
    //파일이 존재하는지 확인//
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if([fileManager fileExistsAtPath:filePath])
    {
        //NSLog(@"file path : %@", filePath);
        
        //return ;
    }
    
    NSLog(@"file path : %@", filePath);
    
    //데이터베이스 연결//
    //해당 위치에 데이터베이스 없을 경우에 생성해서 연결//
    sqlite3 *database; //sqlite3 데이터베이스 선언. 데이터베이스 핸들러 정의//
    
    char *error_msg = nil; //에러메시지를 받을 문자열 변수//
    
    //모든 데이터베이스관련 작업이 정상적으로 수행되었는지 확인하기 위해서 SQLITE_OK상수랑 비교해준다.//
    //현재 작업할려는 sqlite3의 참조변수인 database에 기존에 설정해준 filePath를 이용해서 연결해준다.//
    if(sqlite3_open([filePath UTF8String], &database) != SQLITE_OK)
    {
        //strcpy(error_msg, "DB Open ERROR");
        
        sqlite3_close(database);
        
        NSLog(@"QUERY RESULT MSG : [ERROR] DB Open ERROR");
    }
    
    else
    {
        NSLog(@"QUERY RESULT MSG : [SUCCESS] DB Open Success!!");
    }
    
    //저장할 배열을 선언. 초기용량은 0으로 한다.//
    lose_Result = [NSMutableArray arrayWithCapacity:0];
    
    //데이터 출력//
    sqlite3_stmt *select_stmt;
    char *select_sql; //쿼리문//
    
    //플래그에 따라 쿼리문을 변경해준다.//
    if([flag isEqualToString:@"2"])
    {
        select_sql = "SELECT member_lose_count FROM game_member";
    }
    
    else if([flag isEqualToString:@"0"]) //내림차순//
    {
        select_sql = "SELECT member_lose_count FROM game_member ORDER BY member_success_count DESC";
    }
    
    else if([flag isEqualToString:@"1"]) //오름차순//
    {
        select_sql = "SELECT member_lose_count FROM game_member ORDER BY member_success_count ASC";
    }
    
    int ret;
    
    ret = sqlite3_prepare_v2(database, select_sql, -1, &select_stmt, NULL);
    
    if(ret == SQLITE_OK)
    {
        NSLog(@"<GAME LOG PRINT>");
        
        //sqlite3_bind_int(select_stmt, 1, 2); //조건절에 대한 변수 바인딩//
        
        while(sqlite3_step(select_stmt) == SQLITE_ROW) //각 튜플들을 모두 탐색//
        {
            //Mutable은 변경가능하다는 뜻//
            NSMutableString *result_string = [[NSMutableString alloc]init]; //할당//
            
            [result_string appendString:[NSString stringWithFormat:@"%s", sqlite3_column_text(select_stmt, 0)]];
            
            //결과문자열을 배열에 저장//
            [lose_Result addObject:result_string];
        }
    }
    
    NSLog(@"array count : %ld\n", [lose_Result count]);
    
    for(int i=0; i<[lose_Result count]; i++)
    {
        //NSLog(@"%@", [Name_Result objectAtIndex:i]);
    }
    
    sqlite3_finalize(select_stmt); //검색을 다 했으면 종료//
    
    sqlite3_close(database); //오픈된 데이터베이스를 닫는다. 해당 핸들러를 사용하지 않는다.//
    
    NSLog(@"QUERY RESULT MSG : [SUCCESS] DB Close Success!!");
    
    return lose_Result;
}
//////////////////////
- (NSString *)db_Select_User_Info:(NSString *)inputname
{
    //검색//
    //데이터베이스에서 조건을 주어서 탐색한다.//
    //도큐먼트 디렉터리 위치 구하기//
    NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    //도큐먼트 위치에 db.sqlite 파일명으로 경로 설정//
    NSString *filePath = [documentDirectory stringByAppendingPathComponent:@"db.sqlite"];
    
    //파일이 존재하는지 확인//
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if([fileManager fileExistsAtPath:filePath])
    {
        //NSLog(@"file path : %@", filePath);
        
        //return ;
    }
    
    NSLog(@"file path : %@", filePath);
    
    //데이터베이스 연결//
    //해당 위치에 데이터베이스 없을 경우에 생성해서 연결//
    sqlite3 *database; //sqlite3 데이터베이스 선언. 데이터베이스 핸들러 정의//
    
    char *error_msg = nil; //에러메시지를 받을 문자열 변수//
    
    //모든 데이터베이스관련 작업이 정상적으로 수행되었는지 확인하기 위해서 SQLITE_OK상수랑 비교해준다.//
    //현재 작업할려는 sqlite3의 참조변수인 database에 기존에 설정해준 filePath를 이용해서 연결해준다.//
    if(sqlite3_open([filePath UTF8String], &database) != SQLITE_OK)
    {
        //strcpy(error_msg, "DB Open ERROR");
        
        sqlite3_close(database);
        
        NSLog(@"QUERY RESULT MSG : [ERROR] DB Open ERROR");
    }
    
    else
    {
        NSLog(@"QUERY RESULT MSG : [SUCCESS] DB Open Success!!");
    }
    
    info_str = [[NSMutableString alloc]initWithString:@""];
    
    sqlite3_stmt *select_stmt;
    char *select_sql; //쿼리문//
    
    select_sql = "SELECT member_id,member_email_address FROM game_member WHERE member_name = ?";
    
    if(sqlite3_prepare_v2(database, select_sql, -1, &select_stmt, NULL) == SQLITE_OK)
    {
        //bind로 '?'에 값을 할당해준다. PrepareStatement방식 적용//
        sqlite3_bind_text(select_stmt, 1, [inputname UTF8String], -1, SQLITE_TRANSIENT);
        
        //반복은 한번만 돈다//
        while(sqlite3_step(select_stmt) == SQLITE_ROW) //각 튜플들을 모두 탐색//
        {
            //Mutable은 변경가능하다는 뜻//
            NSMutableString *result_string = [[NSMutableString alloc]init]; //할당//
            
            [result_string appendString:[NSString stringWithFormat:@"%s", sqlite3_column_text(select_stmt, 0)]];
            [result_string appendString:[NSString stringWithFormat:@" "]];
            [result_string appendString:[NSString stringWithFormat:@"%s", sqlite3_column_text(select_stmt, 1)]];
            
            //결과문자열을 배열에 저장//
            [info_str setString:result_string];
        }
    }
    
    sqlite3_finalize(select_stmt); //검색을 다 했으면 종료//
    
    sqlite3_close(database); //오픈된 데이터베이스를 닫는다. 해당 핸들러를 사용하지 않는다.//
    
    NSLog(@"QUERY RESULT MSG : [SUCCESS] DB Close Success!!");
    
    return info_str;
}
////////////////////
- (NSString *)db_Select_User_Info_password:(NSString *)inputname input_id:(NSString *)input_id
{
    //검색//
    //데이터베이스에서 조건을 주어서 탐색한다.//
    //도큐먼트 디렉터리 위치 구하기//
    NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    //도큐먼트 위치에 db.sqlite 파일명으로 경로 설정//
    NSString *filePath = [documentDirectory stringByAppendingPathComponent:@"db.sqlite"];
    
    //파일이 존재하는지 확인//
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if([fileManager fileExistsAtPath:filePath])
    {
        //NSLog(@"file path : %@", filePath);
        
        //return ;
    }
    
    NSLog(@"file path : %@", filePath);
    
    //데이터베이스 연결//
    //해당 위치에 데이터베이스 없을 경우에 생성해서 연결//
    sqlite3 *database; //sqlite3 데이터베이스 선언. 데이터베이스 핸들러 정의//
    
    char *error_msg = nil; //에러메시지를 받을 문자열 변수//
    
    //모든 데이터베이스관련 작업이 정상적으로 수행되었는지 확인하기 위해서 SQLITE_OK상수랑 비교해준다.//
    //현재 작업할려는 sqlite3의 참조변수인 database에 기존에 설정해준 filePath를 이용해서 연결해준다.//
    if(sqlite3_open([filePath UTF8String], &database) != SQLITE_OK)
    {
        //strcpy(error_msg, "DB Open ERROR");
        
        sqlite3_close(database);
        
        NSLog(@"QUERY RESULT MSG : [ERROR] DB Open ERROR");
    }
    
    else
    {
        NSLog(@"QUERY RESULT MSG : [SUCCESS] DB Open Success!!");
    }
    
    info_str_password = [[NSMutableString alloc]initWithString:@""];
    
    sqlite3_stmt *select_stmt;
    char *select_sql; //쿼리문//
    
    select_sql = "SELECT member_password,member_email_address FROM game_member WHERE member_name = ? AND member_id = ?";
    
    if(sqlite3_prepare_v2(database, select_sql, -1, &select_stmt, NULL) == SQLITE_OK)
    {
        //bind로 '?'에 값을 할당해준다. PrepareStatement방식 적용//
        sqlite3_bind_text(select_stmt, 1, [inputname UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(select_stmt, 2, [input_id UTF8String], -1, SQLITE_TRANSIENT);
        
        //반복은 한번만 돈다//
        while(sqlite3_step(select_stmt) == SQLITE_ROW) //각 튜플들을 모두 탐색//
        {
            //Mutable은 변경가능하다는 뜻//
            NSMutableString *result_string = [[NSMutableString alloc]init]; //할당//
            
            [result_string appendString:[NSString stringWithFormat:@"%s", sqlite3_column_text(select_stmt, 0)]];
            [result_string appendString:[NSString stringWithFormat:@" "]];
            [result_string appendString:[NSString stringWithFormat:@"%s", sqlite3_column_text(select_stmt, 1)]];
            
            //결과문자열을 배열에 저장//
            [info_str_password setString:result_string];
        }
    }
    
    sqlite3_finalize(select_stmt); //검색을 다 했으면 종료//
    
    sqlite3_close(database); //오픈된 데이터베이스를 닫는다. 해당 핸들러를 사용하지 않는다.//
    
    NSLog(@"QUERY RESULT MSG : [SUCCESS] DB Close Success!!");
    
    return info_str_password;
}

@end
