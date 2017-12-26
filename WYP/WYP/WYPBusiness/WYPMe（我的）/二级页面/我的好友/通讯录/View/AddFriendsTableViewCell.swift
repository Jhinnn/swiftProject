//
//  AddFriendsTableViewCell.swift
//  WYP
//
//  Created by ShuYan Feng on 2017/4/4.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

protocol AddFriendsTableViewCellDelegate: NSObjectProtocol {
    func applyAddFriends(sender: UIButton)
}

class AddFriendsTableViewCell: UITableViewCell {

    weak var delegate: AddFriendsTableViewCellDelegate?
    
    // MARK: - life cycle
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        viewConfig()
        layoutPageSubviews()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    // MARK: - private method
    func viewConfig() {
        contentView.addSubview(friendsImageView)
        contentView.addSubview(friendsTitleLabel)
        contentView.addSubview(addAttentionButton)
    }
    func layoutPageSubviews() {
        friendsImageView.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(13.5)
            make.centerY.equalTo(contentView)
            make.size.equalTo(CGSize(width: 40, height: 40))
        }
        addAttentionButton.snp.makeConstraints { (make) in
            make.right.equalTo(contentView).offset(-13.5)
            make.size.equalTo(CGSize(width: 60, height: 25))
            make.centerY.equalTo(contentView)
        }
        friendsTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(friendsImageView.snp.right).offset(25)
            make.right.equalTo(addAttentionButton.snp.left).offset(-10)
            make.centerY.equalTo(contentView)
            make.height.equalTo(20)
        }
        
    }
    
    // MARK: - event response
    func applyAddFriends(sender: UIButton) {
        delegate?.applyAddFriends(sender: sender)
    }
    
    // MARK: - setter and getter
    // 群组头像
    lazy var friendsImageView: UIImageView = {
        let friendsImageView = UIImageView()
        friendsImageView.backgroundColor = UIColor.init(hexColor: "f1f2f4")
        friendsImageView.layer.cornerRadius = 20
        friendsImageView.layer.masksToBounds = true
        
        return friendsImageView
    }()
    lazy var friendsTitleLabel: UILabel = {
        let friendsTitleLabel = UILabel()
        friendsTitleLabel.font = UIFont.systemFont(ofSize: 15)
        return friendsTitleLabel
    }()
    lazy var addAttentionButton: UIButton = {
        let addAttentionButton = UIButton(type: .custom)
        addAttentionButton.layer.cornerRadius = 5
        addAttentionButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        addAttentionButton.setTitle("添加", for: .normal)
        addAttentionButton.backgroundColor = UIColor.naviColor
//        addAttentionButton.setImage(UIImage(named: "mine_add_button_normal_iPhone"), for: .normal)
//        addAttentionButton.setImage(UIImage(named: "mine_add_button_selected_iPhone"), for: .selected)
        addAttentionButton.addTarget(self, action: #selector(applyAddFriends(sender:)), for: .touchUpInside)
        return addAttentionButton
    }()

    var addModel: AttentionPeopleModel? {
        willSet {
            let imageUrl = URL(string: newValue?.icon ?? "")
            friendsImageView.kf.setImage(with: imageUrl)
            friendsTitleLabel.text = newValue?.nickName
            if newValue?.isFollow == "1" {
                addAttentionButton.setImage(UIImage(named: "mine_add_button_selected_iPhone"), for: .selected)
            }
        }
    }
    
}
