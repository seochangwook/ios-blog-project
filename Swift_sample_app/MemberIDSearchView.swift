//
//  MemberIDSearchView.swift
//  Swift_sample_app
//
//  Created by apple on 2016. 10. 16..
//  Copyright © 2016년 apple. All rights reserved.
//

import UIKit //ios에서 코코아 프레임워크를 사용하기 위한 것//
import Foundation

class MemberIDSearchView : UIViewController
{
    @IBOutlet weak var info_label: UILabel!
    
    //넘겨받을 값을 저장할 변수 저장//
    var info_label_str : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        info_label.text = info_label_str
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
