//
//  ShowroomMemberCell.swift
//  WYP
//
//  Created by 你个LB on 2017/4/21.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

class ShowroomMemberCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var portrayLabel: UILabel!
    
    @IBOutlet weak var followedNumLabel: UILabel!
    
    @IBOutlet weak var followButton: UIButton!
    
    
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
            followedNumLabel.text = String.init(format: "%@ 粉丝", newValue!.memberFans!)
            
            if newValue?.isFllow == "1" {
                followButton.setBackgroundImage(UIImage(named: "showRoom_alreadyAttentionRed_button_normal_iPhone"), for: .normal)
                followButton.isSelected = true
            } else {
                followButton.setBackgroundImage(UIImage(named: "showRoom_attentionRed_button_normal_iPhone"), for: .normal)
                followButton.isSelected = false
            }
        }
    }
    
    
}
