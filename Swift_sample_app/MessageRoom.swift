//
//  MessageRoom.swift
//  Swift_sample_app
//
//  Created by apple on 2017. 1. 3..
//  Copyright © 2017년 apple. All rights reserved.
//

import Foundation
import UIKit

class MessageRoom : UIViewController{
    @IBOutlet weak var receiver_info_label: UILabel!
    @IBOutlet weak var sender_info_label: UILabel!
    
    var sender_id:String = ""
    var receiver_id:String = ""
    var sender_name:String = ""
    var receiver_name:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        print("sender id: ", sender_id)
        print("sender name: ", sender_name)
        print("receiver id: ", receiver_id)
        print("receiver name: ", receiver_name)
        
        sender_info_label.text = sender_id + "/" + sender_name
        receiver_info_label.text = receiver_id + "/" + receiver_name
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
