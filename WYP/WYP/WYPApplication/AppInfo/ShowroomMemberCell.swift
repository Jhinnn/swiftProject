//
//  ShowroomMemberCell.swift
//  WYP
//
//  Created by 你个LB on 2017/4/21.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

protocol ShowroomMemberAttentionDelegate {
    func attentionActionCell(_ IntelligentCell: ShowroomMemberCell, intelligentModel model: MemberModel)
}

class ShowroomMemberCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var portrayLabel: UILabel!
    
    var delegate: ShowroomMemberAttentionDelegate?
    
    @IBOutlet weak var followButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageView.layer.cornerRadius = 34
        imageView.layer.masksToBounds = true
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        followButton.backgroundColor = UIColor.themeColor
        followButton.layer.masksToBounds = true
        followButton.layer.cornerRadius = followButton.height / 2
        
    }
    
    @IBAction func followAction(_ sender: Any) {
        let token = AppInfo.shared.user?.token ?? ""
        if token == "" {
            GeneralMethod.alertToLogin(viewController: self.viewController!)
            return
        } else {
            delegate?.attentionActionCell(self, intelligentModel: memberModel!)
        }
    }
    
    
    var memberModel: MemberModel? {
        willSet {
            let imageUrl = URL(string: newValue?.memberPhoto ?? "")
            imageView.kf.setImage(with: imageUrl)
            nameLabel.text = newValue?.realName
            // 职业
            if newValue?.profession == "饰演" {
                portrayLabel.text = String.init(format: "%@: %@", newValue!.profession!, newValue!.portray!)
            } else {
                portrayLabel.text = newValue!.profession
            }
//            followedNumLabel.text = String.init(format: "%@ 粉丝", newValue!.memberFans!)
            
            if newValue?.isFllow == "1" {  //已经关注
                followButton.setTitle("已关注", for: .normal)
                followButton.setTitleColor(UIColor.themeColor, for: .normal)
                followButton.backgroundColor = UIColor.white
            }else {  //未关注
                followButton.setTitle("关注", for: .normal)
                followButton.setTitleColor(UIColor.white, for: .normal)
                followButton.backgroundColor = UIColor.themeColor
            }
            
            
//            if newValue?.isFllow == "1" {
//                followButton.setBackgroundImage(UIImage(named: "showRoom_alreadyAttentionRed_button_normal_iPhone"), for: .normal)
//                followButton.isSelected = true
//            } else {
//                followButton.setBackgroundImage(UIImage(named: "showRoom_attentionRed_button_normal_iPhone"), for: .normal)
//                followButton.isSelected = false
//            }
        }
    }
    
    
}
