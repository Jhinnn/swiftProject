//
//  IntelligentListTableViewCell.swift
//  WYP
//
//  Created by Arthur on 2018/2/2.
//  Copyright © 2018年 NGeLB. All rights reserved.
//

import UIKit

protocol IntellListTabelViewDelegate {
    func attentionActionCell(_ IntelligentCell: IntelligentListTableViewCell, intelligentModel model: IntelligentModel)
    
     func pushToPersonInfo(_ IntelligentCell: IntelligentListTableViewCell, intelligentModel model: IntelligentModel)
}


class IntelligentListTableViewCell: UITableViewCell {
    
    var delegate: IntellListTabelViewDelegate?
    
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet weak var attentionButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imgView.layer.masksToBounds = true
        imgView.layer.cornerRadius = imgView.width / 2
        
        attentionButton.layer.masksToBounds = true
        attentionButton.layer.cornerRadius = 6
        
        attentionButton.setTitleColor(UIColor.themeColor, for: .normal)
        attentionButton.setBackgroundImage(UIImage(), for: .normal)
        attentionButton.setTitle("已关注", for: .normal)
    
        attentionButton.setTitleColor(UIColor.white, for: .selected)
        attentionButton.setBackgroundImage(UIImage.init(named: "common_backgroundColor_button_normal_iPhone"), for: .selected)
        attentionButton.setTitle("关注", for: .selected)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(pushToPerson))
        imgView.isUserInteractionEnabled = true
        imgView.addGestureRecognizer(tap)
        
    }
    

    var model: IntelligentModel? {
        willSet {
            imgView.kf.setImage(with: URL(string: (newValue?.avatar)!))
            nameLabel.text = newValue?.nickname
            contentLabel.text = newValue?.signature
   
            
            if newValue?.is_follow == "1" {  //已经关注
                attentionButton.isSelected = false
            }else {  //未关注
                attentionButton.isSelected = true
            }
        }
    }
    

    
    @IBAction func attAction(_ sender: Any) {
        delegate?.attentionActionCell(self, intelligentModel: model!)
    }
    
    func pushToPerson() {
        delegate?.pushToPersonInfo(self, intelligentModel: model!)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
