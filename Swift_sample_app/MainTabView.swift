//
//  MainTabView.swift
//  Swift_sample_app
//
//  Created by apple on 2016. 10. 29..
//  Copyright © 2016년 apple. All rights reserved.
//

import Foundation
import UIKit

class MainTabView : UIViewController{
    var info_str : String = ""
    
    @IBOutlet weak var info_textlabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func back_buton(_ sender: UIBarButtonItem) {
         dismiss(animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        print("tab1 view")
        
        info_textlabel.text = self.info_str
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
