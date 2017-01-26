//
//  MasterViewController.swift
//  Swift_sample_app
//
//  Created by apple on 2017. 1. 25..
//  Copyright © 2017년 apple. All rights reserved.
//

import Foundation
import UIKit

class MasterViewController : UIViewController{
    var location_name : String = ""
    
    @IBOutlet weak var location_name_label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        location_name_label.text = location_name
    }
}
