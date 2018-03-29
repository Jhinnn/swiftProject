//
//  ShowroomGroupCell.swift
//  WYP
//
//  Created by 你个LB on 2017/4/21.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

class ShowroomGroupCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var groupTitleLabel: UILabel!
    
    @IBOutlet weak var personNumLabel: UILabel!
    
    @IBOutlet weak var vipImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageView.layer.cornerRadius = 34
        imageView.layer.masksToBounds = true
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
    }
    
    
    var groupModel: TheaterGroupModel? {
        willSet {
            let imageUrl = URL(string: newValue?.groupPhoto ?? "")
            imageView.kf.setImage(with: imageUrl)
            groupTitleLabel.text = newValue?.groupName
            personNumLabel.text = String.init(format: "%@人", newValue!.groupCount!)
            if newValue?.isVip == "0" {
                vipImageView.isHidden = true
            }
        }
    }
}
