//
//  GameTabjsondata.swift
//  Swift_sample_app
//
//  Created by apple on 2016. 12. 8..
//  Copyright © 2016년 apple. All rights reserved.
//

import Foundation
import JSONJoy

//{"method":"GET","data":{"text1":"test","text2":"sss"}}//
struct Data_str : JSONJoy
{
    let text1 : String
    let text2 : String
    let question : String
    
    init(_ decoder: JSONDecoder) throws {
        text1 = try decoder["text1"].get()
        text2 = try decoder["text2"].get()
        question = try decoder["question"].get()
    }
}
///////////////////////
struct Request : JSONJoy
{
    let method : String
    let data : Data_str
    
    init(_ decoder: JSONDecoder) throws {
        method = try decoder["method"].get()
        data = try Data_str(decoder["data"])
    }
}
