//
//  SynCollectionViewCell.swift
//  WYP
//
//  Created by aLaDing on 2018/3/20.
//  Copyright © 2018年 NGeLB. All rights reserved.
//

import UIKit

class SynCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var imageVIew: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var selectedImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        imageVIew.layer.masksToBounds = true
        imageVIew.layer.cornerRadius = 30
        
        selectedImg.isHidden = true
    }
    
    
    var synRoomModel: SynRoomModel? {
        willSet {
            let imageUrl = URL(string: newValue?.path ?? "")
            imageVIew.kf.setImage(with: imageUrl)
            titleLabel.text = newValue?.title
        }
    }
    
    var synGroupModel: SynGroupModel? {
        willSet {
            let imageUrl = URL(string: newValue?.photo ?? "")
            imageVIew.kf.setImage(with: imageUrl)
            titleLabel.text = newValue?.title
        }
    }
   
}
