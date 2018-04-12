//
//  GambitSearchTableViewCell.swift
//  WYP
//
//  Created by aLaDing on 2018/4/2.
//  Copyright © 2018年 NGeLB. All rights reserved.
//

import UIKit

class GambitSearchTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet weak var commentCountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //数据模型
    var infoModel: SearchGambitModel? {
        willSet {
            contentLabel.text = newValue?.title ?? ""
            commentCountLabel.text = String.init(format: "%@个回答", newValue?.comment ?? "0")
        }
    }
    
}
