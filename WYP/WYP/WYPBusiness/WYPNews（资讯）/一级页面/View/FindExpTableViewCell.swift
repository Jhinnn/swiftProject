//
//  FindExpTableViewCell.swift
//  WYP
//
//  Created by aLaDing on 2018/4/4.
//  Copyright © 2018年 NGeLB. All rights reserved.
//

import UIKit

protocol FindExpAttentionDelegate {
    func attentionActionCell(_ findExpTableViewCell: FindExpTableViewCell, expertModel model: ExpertModel)
}


class FindExpTableViewCell: UITableViewCell {
    
    var delegate: FindExpAttentionDelegate?

   
    @IBOutlet weak var imageview: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet weak var attentionBtn: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        attentionBtn.setTitleColor(UIColor.themeColor, for: .normal)
        attentionBtn.setBackgroundImage(UIImage(), for: .normal)
        attentionBtn.setTitle("已关注", for: .normal)
        
        attentionBtn.setTitleColor(UIColor.white, for: .selected)
        attentionBtn.setBackgroundImage(UIImage.init(named: "common_backgroundColor_button_normal_iPhone"), for: .selected)
        attentionBtn.setTitle("关注", for: .selected)
        
        imageview.layer.masksToBounds = true
        imageview.layer.cornerRadius = 25
        
        attentionBtn.layer.masksToBounds = true
        attentionBtn.layer.cornerRadius = 5
        
    }

    @IBAction func attentionAction(_ sender: Any) {
        let token = AppInfo.shared.user?.token ?? ""
        if token == "" {
            GeneralMethod.alertToLogin(viewController: self.viewController!)
            return
        } else {
            delegate?.attentionActionCell(self, expertModel: expertModel!)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    //数据模型
    var expertModel: ExpertModel? {
        willSet {
            imageview.kf.setImage(with: URL.init(string: newValue?.avatar ?? ""), placeholder: UIImage.init(named: "place_image"), options: nil, progressBlock: nil, completionHandler: nil)
            titleLabel.text = newValue?.nickname ?? ""
            contentLabel.text = newValue?.v_info ?? ""
            
            if newValue?.is_follow == "1" {  //已关注
                attentionBtn.isSelected = false
            }else {  //未关注
                attentionBtn.isSelected = true
            }
        }
    }
}
