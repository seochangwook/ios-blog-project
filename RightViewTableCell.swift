//
//  RightViewTableCell.swift
//  Swift_sample_app
//
//  Created by apple on 2017. 1. 25..
//  Copyright © 2017년 apple. All rights reserved.
//

import Foundation
import UIKit

class RightViewTableCell : UITableViewCell{
   
    @IBOutlet weak var menu_imageview: UIImageView!
    @IBOutlet weak var menu_label: UILabel!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        //Initialization code//
    }
    
    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
        
        //Configure the view for the selected state//
        
    }
}
