//
//  QaCollectionTableViewCell.swift
//  WYP
//
//  Created by aLaDing on 2018/3/30.
//  Copyright © 2018年 NGeLB. All rights reserved.
//

import UIKit

class QaCollectionTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contView: UILabel!
    
    @IBOutlet weak var answerLabel: UILabel!
    
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
    var infoModel: NewTopicModel? {
        willSet {
            
            titleLabel.text = newValue?.description ?? ""
            answerLabel.text = String.init(format: "%@回答", newValue?.comment ?? "0")
            contView.text = newValue?.content ?? ""
            if newValue?.cover_url?.count == 0 {
                
            }else {
                let imageUrl = URL(string: newValue?.cover_url?[0] ?? "")
                imageV.kf.setImage(with: imageUrl)
            }
        }
    }
    
    //数据模型
    var infoModels: MineTopicsModel? {
        willSet {
            
            titleLabel.text = newValue?.title ?? ""
            answerLabel.text = String.init(format: "%@赞·%@回答", newValue?.reply?.fabulous_number ?? "0",newValue?.reply?.view ?? "0")
            contView.text = newValue?.reply?.content_text
            if newValue?.reply?.content_img?.count == 0 {
                
            }else {
                let imageUrl = URL(string: newValue?.reply?.content_img?[0] ?? "")
                imageV.kf.setImage(with: imageUrl)
            }
            
        }
    }
}
