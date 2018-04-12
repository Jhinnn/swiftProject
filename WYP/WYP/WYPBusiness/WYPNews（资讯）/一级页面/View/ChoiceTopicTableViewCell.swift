//
//  ChoiceTopicTableViewCell.swift
//  WYP
//
//  Created by aLaDing on 2018/4/8.
//  Copyright © 2018年 NGeLB. All rights reserved.
//

import UIKit

class ChoiceTopicTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var zanLabel: UILabel!
    
    @IBOutlet weak var imageV: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //数据模型
    var choiceTopicData: ChoiceTopicModel? {
        willSet {
            titleLabel.text = newValue?.title ?? ""
            answerLabel.text = String.init(format: "%@个回答", newValue?.comment ?? "0")
            imageV.kf.setImage(with: URL.init(string: newValue?.avatar128 ?? ""), placeholder: UIImage.init(named: "place_image"), options: nil, progressBlock: nil, completionHandler: nil)
            contentLabel.text = newValue?.choiceTopicReplyModel?.content_text
            nameLabel.text = newValue?.choiceTopicReplyModel?.nickname
            zanLabel.text = String.init(format: "%@赞", newValue?.choiceTopicReplyModel?.fabulous_number ?? "0")
        }
    }
}
