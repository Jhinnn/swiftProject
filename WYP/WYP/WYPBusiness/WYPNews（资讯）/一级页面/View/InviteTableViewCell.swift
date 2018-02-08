//
//  InviteTableViewCell.swift
//  WYP
//
//  Created by Arthur on 2018/2/2.
//  Copyright © 2018年 NGeLB. All rights reserved.
//

import UIKit

protocol InviteTableViewCellDelegate {
    func inviteActionCell(_ IntelligentCell: InviteTableViewCell, intelligentModel model: IntelligentModel)
    
    func pushToPersonInfo(_ IntelligentCell: InviteTableViewCell, intelligentModel model: IntelligentModel)
}

class InviteTableViewCell: UITableViewCell {
    
    var delegate: InviteTableViewCellDelegate?
    
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet weak var inviteButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imgView.layer.masksToBounds = true
        imgView.layer.cornerRadius = imgView.width / 2
        
        inviteButton.layer.masksToBounds = true
        inviteButton.layer.cornerRadius = 6
        
        inviteButton.setTitleColor(UIColor.themeColor, for: .normal)
        inviteButton.setBackgroundImage(UIImage(), for: .normal)
        inviteButton.setTitle("已邀请", for: .normal)
        
        inviteButton.setTitleColor(UIColor.white, for: .selected)
        inviteButton.setBackgroundImage(UIImage.init(named: "common_backgroundColor_button_normal_iPhone"), for: .selected)
        inviteButton.setTitle("邀请回答", for: .selected)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(pushToPerson))
        imgView.isUserInteractionEnabled = true
        imgView.addGestureRecognizer(tap)
        
    }
    
    var model: IntelligentModel? {
        willSet {
            
            imgView.kf.setImage(with: URL(string: (newValue?.avatar)!))
            titleLabel.text = newValue?.nickname
            contentLabel.text = newValue?.signature
    
            if newValue?.is_invite == "1" {  //已经邀请
                inviteButton.isSelected = false
            }else {  //未邀请
                inviteButton.isSelected = true
            }
        }
    }
    
    

    @IBAction func inviteAction(_ sender: Any) {
        if model?.is_invite == "0" {
            delegate?.inviteActionCell(self, intelligentModel: model!)
        }
        
    }
    
    func pushToPerson() {
        delegate?.pushToPersonInfo(self, intelligentModel: model!)
    }
    
    
}
