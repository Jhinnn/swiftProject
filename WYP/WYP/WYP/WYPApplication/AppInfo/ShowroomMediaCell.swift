//
//  ShowroomMediaCell.swift
//  WYP
//
//  Created by 你个LB on 2017/4/21.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

class ShowroomMediaCell: UICollectionViewCell {
        
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var playIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
    }
    
    var mediaModel: MediaModel! {
        willSet {
            let imageUrl = URL(string: newValue.address ?? "")
            imageView.kf.setImage(with: imageUrl)
            
            if newValue.type == "1" {
                playIcon.isHidden = true
            } else {
                playIcon.isHidden = false
            }
        }
    }
}
