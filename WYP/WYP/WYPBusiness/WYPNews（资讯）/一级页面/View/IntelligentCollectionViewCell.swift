//
//  IntelligentCollectionViewCell.swift
//  WYP
//
//  Created by Arthur on 2018/2/1.
//  Copyright © 2018年 NGeLB. All rights reserved.
//

import UIKit

protocol IntelligentAttentionDelegate {
    func attentionActionCell(_ IntelligentCell: IntelligentCollectionViewCell, intelligentModel model: IntelligentModel)
}

class IntelligentCollectionViewCell: UICollectionViewCell {
    
    var delegate: IntelligentAttentionDelegate?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var attentionButton: UIButton!
    @IBOutlet weak var isAttentionImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = imageView.width / 2
        
        attentionButton.backgroundColor = UIColor.themeColor
        attentionButton.layer.masksToBounds = true
        attentionButton.layer.cornerRadius = attentionButton.height / 2
    }
    
    var model: IntelligentModel? {
        willSet {
            imageView.kf.setImage(with: URL(string: (newValue?.avatar)!))
            nameLabel.text = newValue?.nickname
            contentLabel.text = newValue?.signature
            
            if newValue?.is_v == "1" {
                isAttentionImage.isHidden = false
            }else {
                isAttentionImage.isHidden = true
            }
            
            if newValue?.is_follow == "1" {  //已经关注
                attentionButton.setTitle("已关注", for: .normal)
                attentionButton.setTitleColor(UIColor.themeColor, for: .normal)
                attentionButton.backgroundColor = UIColor.white
            }else {  //未关注
                attentionButton.setTitle("关注", for: .normal)
                attentionButton.setTitleColor(UIColor.white, for: .normal)
                attentionButton.backgroundColor = UIColor.themeColor
            }
        }
    }
    
    @IBAction func attentionAction(_ sender: UIButton) {
        
        let token = AppInfo.shared.user?.token ?? ""
        if token == "" {
            GeneralMethod.alertToLogin(viewController: self.viewController!)
            return
        } else {
            delegate?.attentionActionCell(self, intelligentModel: model!)
        }
        
        
    }
    
    
    
}
