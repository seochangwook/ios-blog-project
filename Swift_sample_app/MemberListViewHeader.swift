//
//  MemberListViewHeader.swift
//  Swift_sample_app
//
//  Created by apple on 2016. 10. 9..
//  Copyright © 2016년 apple. All rights reserved.
//

import UIKit
import Foundation

class MemberListViewHeader : UITableViewCell
{
    @IBOutlet weak var totalmembercount_label: UILabel!
    @IBOutlet weak var bestmember_label: UILabel!
    @IBOutlet weak var winpoint_label: UILabel!
    @IBOutlet weak var winpeopleimageview: UIImageView!
    
    
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
