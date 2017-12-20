//
//  HotTheaterGroupCell.swift
//  WYP
//
//  Created by 你个LB on 2017/3/30.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

class HotTheaterGroupCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var TitleLabel: UILabel!
    
    @IBOutlet weak var roomTypeLabel: UILabel!
    
    @IBOutlet weak var groupTypeLabel: UILabel!
    
    @IBOutlet weak var VipIconView: UIImageView!
    
    @IBOutlet weak var fanNumberLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageView.addSubview(roomTypeLabel)
    }
    
    var groupModel: TheaterGroupModel? {
        willSet {
            let imageUrl = URL(string: newValue?.groupPhoto ?? "")
            imageView.kf.setImage(with: imageUrl)
            TitleLabel.text = newValue?.roomName
            roomTypeLabel.text = newValue?.groupRoomType
            groupTypeLabel.text = newValue?.groupName
            if newValue?.isVip == "0" {
                VipIconView.isHidden = true
            }
            fanNumberLabel.text = String.init(format: "%@人", newValue!.groupCount!)
        }
    }
}
