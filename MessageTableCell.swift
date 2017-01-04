//
//  MessageTableCell.swift
//  Swift_sample_app
//
//  Created by apple on 2017. 1. 4..
//  Copyright © 2017년 apple. All rights reserved.
//

import Foundation
import UIKit

class MessageTableCell : UITableViewCell{
    @IBOutlet weak var profileimageview: UIImageView!
    @IBOutlet weak var name_label: UILabel!
    @IBOutlet weak var message_label: UILabel!
    @IBOutlet weak var message_date_label: UILabel!
    
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
