//
//  MyAnswerHeadCell.swift
//  WYP
//
//  Created by aLaDing on 2018/3/19.
//  Copyright © 2018年 NGeLB. All rights reserved.
//

import UIKit

class MyAnswerHeadCell: UITableViewCell {
    
    
    @IBOutlet weak var readLabel: UILabel!
    @IBOutlet weak var monthReadLabel: UILabel!
    
    
    @IBOutlet weak var zanLabel: UILabel!
    @IBOutlet weak var monthZanLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
