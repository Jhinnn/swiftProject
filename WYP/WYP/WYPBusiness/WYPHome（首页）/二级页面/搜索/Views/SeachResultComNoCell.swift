//
//  SeachResultComNoCell.swift
//  WYP
//
//  Created by Arthur on 2018/1/11.
//  Copyright © 2018年 NGeLB. All rights reserved.
//

import UIKit

class SeachResultComNoCell: UITableViewCell {
    
    @IBOutlet weak var imageheadView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var contentLabel: UILabel!
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //数据模型
    var newValue: CommunityModel? {
        willSet {
            
            imageheadView.layer.masksToBounds = true
            imageheadView.layer.cornerRadius = 20
            
            var imageUrl: URL?
            imageUrl = URL(string: newValue?.path ?? "")
            imageheadView.kf.setImage(with: imageUrl)
            
            
            nameLabel.text = newValue?.nickname ?? ""
            timeLabel.text = newValue?.create_time ?? ""
            contentLabel.text = newValue?.content ?? ""
            
            
          
            
            
            
            
            
        }
    }
    
}
