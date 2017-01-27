//
//  TableViewCell.swift
//  FocusStartIOS
//
//  Created by Родион Баглай on 23.01.17.
//  Copyright © 2017 Родион Баглай. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var labelOne: UILabel!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelType: UILabel!
    
    //  @IBOutlet weak var backgroundLabel: UILabel!
    @IBOutlet weak var labelContent: UILabel!
    @IBOutlet weak var imageSource: UIImageView!
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageSource.layer.cornerRadius = 35
         
    }
    
}
