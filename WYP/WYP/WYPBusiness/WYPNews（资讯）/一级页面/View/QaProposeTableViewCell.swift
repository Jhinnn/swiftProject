//
//  QaProposeTableViewCell.swift
//  WYP
//
//  Created by aLaDing on 2018/4/2.
//  Copyright © 2018年 NGeLB. All rights reserved.
//

import UIKit

class QaProposeTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet weak var shenheLabel: UILabel!
    
    @IBOutlet weak var commentLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    //数据模型
    var infoModel: MineTopicsModel? {
        willSet {
            
            contentLabel.text = newValue?.title ?? ""
            commentLabel.text = String.init(format: "%@回答", newValue?.commentCount ?? "0")
            
            if newValue?.status == "3" { //审核未通过
                commentLabel.isHidden = true
                shenheLabel.isHidden = false
                shenheLabel.text = "审核未通过"
            }else {
                shenheLabel.isHidden = true
                commentLabel.isHidden = false
            }
            
        }
    }
}
