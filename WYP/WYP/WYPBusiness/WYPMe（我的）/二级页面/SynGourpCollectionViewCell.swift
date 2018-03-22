
//
//  SynnCollectionViewCell.swift
//  WYP
//
//  Created by aLaDing on 2018/3/21.
//  Copyright © 2018年 NGeLB. All rights reserved.
//

import UIKit

class SynGourpCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    
    @IBOutlet weak var selectedImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 30
        
        selectedImg.isHidden = true
        
    }

    var synGroupModel: SynGroupModel? {
        willSet {
            let imageUrl = URL(string: newValue?.photo ?? "")
            imageView.kf.setImage(with: imageUrl)
            titleLabel.text = newValue?.title
        }
    }
}
