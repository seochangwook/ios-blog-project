//
//  MemberListViewTableCell.swift
//  Swift_sample_app
//
//  Created by apple on 2016. 9. 17..
//  Copyright © 2016년 apple. All rights reserved.
//

import UIKit

//UITableView의 하나의 셀을 설정하기 위한 클래스//
class MemberListViewTableCell : UITableViewCell
{
    /** Cell에 활용될 변수 **/
    @IBOutlet weak var user_image_imageview: UIImageView!
    @IBOutlet weak var user_name_label: UILabel!
    @IBOutlet weak var user_id_label: UILabel!
    @IBOutlet weak var user_info_more_button: UIButton!
    
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
