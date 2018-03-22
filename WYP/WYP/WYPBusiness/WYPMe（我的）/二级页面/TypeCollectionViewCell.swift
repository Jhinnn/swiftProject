//
//  TypeCollectionViewCell.swift
//  WYP
//
//  Created by aLaDing on 2018/3/21.
//  Copyright © 2018年 NGeLB. All rights reserved.
//

import UIKit

class TypeCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var typeButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        typeButton.titleLabel?.numberOfLines = 2
        typeButton.titleLabel?.textAlignment = NSTextAlignment.center
        typeButton.layer.masksToBounds = true
        typeButton.layer.borderColor = UIColor.lightGray.cgColor
        typeButton.layer.borderWidth = 0.8
        typeButton.layer.cornerRadius = 22
        
        
        
        typeButton.isUserInteractionEnabled = false
        
        typeButton.setTitleColor(UIColor.black, for: .normal)
        typeButton.setTitleColor(UIColor.white, for: .selected)
        
        typeButton.setBackgroundImage(UIImage.init(named: "theme_icon_option_pitch"), for: .selected)
        typeButton.setBackgroundImage(UIImage.init(named: ""), for: .normal)
    }
    
    var synTypeModel: SynTypeModel? {
        willSet {
            typeButton.setTitle(newValue?.class_name, for: .normal)
            
        }
    }

}
