//
//  ContentViewController.swift
//  Swift_sample_app
//
//  Created by apple on 2016. 11. 3..
//  Copyright © 2016년 apple. All rights reserved.
//

import Foundation
import UIKit

class ContentViewController: UIViewController {
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var left_indicator_image: UIImageView!
    @IBOutlet weak var right_indicator_image: UIImageView!
    
    
    var pageIndex : Int!
    var titleText : String!
    var imageFile : String!
    var left_image : String!
    var right_image : String!
    
    @IBAction func back_button(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imageView.image = UIImage(named: self.imageFile)
        self.left_indicator_image.image = UIImage(named: self.left_image)
        self.right_indicator_image.image = UIImage(named: self.right_image)
        
        self.labelTitle.text = self.titleText
    }
    
}
