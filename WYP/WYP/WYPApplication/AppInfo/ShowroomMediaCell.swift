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
    
    
    @IBOutlet weak var infoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageView.layer.cornerRadius = 6
        imageView.layer.masksToBounds = true
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        
        
        infoLabel.alpha = 0.7
        infoLabel.backgroundColor = UIColor.black
        infoLabel.textColor = UIColor.white
        infoLabel.font = UIFont.systemFont(ofSize: 9)
        infoLabel.textAlignment = .center
        infoLabel.layer.cornerRadius = 5.0
        infoLabel.layer.masksToBounds = true
    }
    
    var mediaModel: MediaModel! {
        willSet {
            let imageUrl = URL(string: newValue.address ?? "")
            imageView.kf.setImage(with: imageUrl)
            
            if newValue.type == "1" {
                playIcon.isHidden = true
                infoLabel.isHidden = true
            } else {
                playIcon.isHidden = false
                infoLabel.isHidden = false
            }
            
            if newValue?.duration != nil {
                if (newValue?.duration)! < 60 {
                    infoLabel.text = String.init(format: "00:%02d", newValue?.duration ?? 00)
                } else if (newValue?.duration)! >= 60 {
                    infoLabel.text = String.init(format: "%02d:%02d", (newValue?.duration)!/60, (newValue?.duration)!%60)
                }
            }
        }
    }
}
