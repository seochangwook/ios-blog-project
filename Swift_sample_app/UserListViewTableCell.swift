//
//  UserListViewTableCell.swift
//  Swift_sample_app
//
//  Created by apple on 2017. 1. 2..
//  Copyright © 2017년 apple. All rights reserved.
//

import Foundation
import UIKit

class UserListViewTableCell : UITableViewCell{
    @IBOutlet weak var profile_imageview: UIImageView!
    @IBOutlet weak var user_id_label: UILabel!
    @IBOutlet weak var user_name_label: UILabel!
    @IBOutlet weak var user_email_label: UILabel!
    @IBOutlet weak var user_gender_label: UILabel!
    
    @IBOutlet weak var chatting_button: UIButton!
    
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
