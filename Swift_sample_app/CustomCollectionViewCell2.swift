//
//  CustomCollectionViewCell2.swift
//  Swift_sample_app
//
//  Created by apple on 2016. 11. 18..
//  Copyright © 2016년 apple. All rights reserved.
//

import Foundation
import UIKit

class CustomCollectionViewCell2 : UICollectionViewCell
{
    
    @IBOutlet weak var image_cell2: UIImageView!
    
    @IBAction func button_cell2(_ sender: UIButton) {
        print("select setting")
    }
}
