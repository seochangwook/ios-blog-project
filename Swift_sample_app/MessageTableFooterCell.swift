//
//  MessageTableFooterCell.swift
//  Swift_sample_app
//
//  Created by apple on 2017. 1. 4..
//  Copyright © 2017년 apple. All rights reserved.
//

import Foundation
import UIKit

class MessageTableFooterCell : UITableViewCell{
    @IBOutlet weak var more_button: UIButton!
    
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
