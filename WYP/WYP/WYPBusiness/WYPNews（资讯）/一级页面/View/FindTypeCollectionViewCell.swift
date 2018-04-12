//
//  FindTypeCollectionViewCell.swift
//  WYP
//
//  Created by aLaDing on 2018/4/3.
//  Copyright © 2018年 NGeLB. All rights reserved.
//

import UIKit

class FindTypeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var typeBtn: UIButton!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        typeBtn.layer.masksToBounds = true
        typeBtn.layer.cornerRadius = 6
    }

    
    //数据模型
    var gambitModel: GimbitModel? {
        willSet {
            typeBtn.setTitle(newValue?.class_name, for: .normal)
        }
    }
    
    
    @IBAction func typeButtonAction(_ sender: Any) {
        
        
    }
}
