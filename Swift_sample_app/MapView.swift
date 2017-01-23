//
//  MapView.swift
//  Swift_sample_app
//
//  Created by apple on 2017. 1. 23..
//  Copyright © 2017년 apple. All rights reserved.
//

import Foundation
import UIKit

class MapView : UIViewController{
    var location_name : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        print("location name : ", location_name)
    }
}
