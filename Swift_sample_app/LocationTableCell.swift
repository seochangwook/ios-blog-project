//
//  LocationTableCell.swift
//  Swift_sample_app
//
//  Created by apple on 2017. 1. 22..
//  Copyright © 2017년 apple. All rights reserved.
//

import Foundation
import UIKit

class LocationTableCell : UITableViewCell{
    
    @IBOutlet weak var location_name_label: UILabel!
    @IBOutlet weak var location_view_button: UIButton!
    
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
