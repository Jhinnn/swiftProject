//
//  RecommendTableViewCell.swift
//  WYP
//
//  Created by ShuYan Feng on 2017/6/1.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

protocol RecommendTableViewCellDelegate: NSObjectProtocol {
    func chooseFriends(sender: UIButton)
}

class RecommendTableViewCell: UITableViewCell {

    weak var delegate: RecommendTableViewCellDelegate?
    
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
        contentView.addSubview(userImageView)
        contentView.addSubview(userNameLabel)
        contentView.addSubview(recommendBtn)
    }
    func layoutPageSubviews() {
        userImageView.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(13.5)
            make.centerY.equalTo(contentView)
            make.size.equalTo(CGSize(width: 35, height: 35))
        }
        userNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(userImageView.snp.right).offset(25)
            make.right.equalTo(contentView).offset(-50)
            make.centerY.equalTo(contentView)
            make.height.equalTo(20)
        }
        recommendBtn.snp.makeConstraints { (make) in
            make.right.equalTo(contentView).offset(-13)
            make.centerY.equalTo(contentView)
            make.size.equalTo(30)
        }
    }
    
    // MARK: - response event
    func recommendToFriends(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        delegate?.chooseFriends(sender: sender)
    }
    
    // MARK: - setter
    // 群组头像
    lazy var userImageView: UIImageView = {
        let groupImageView = UIImageView()
        groupImageView.backgroundColor = UIColor.init(hexColor: "afafafa")
        groupImageView.layer.masksToBounds = true
        groupImageView.layer.cornerRadius = 18.0
        return groupImageView
    }()
    lazy var userNameLabel: UILabel = {
        let groupTitleLabel = UILabel()
        groupTitleLabel.font = UIFont.systemFont(ofSize: 13)
        return groupTitleLabel
    }()
    lazy var recommendBtn: UIButton = {
        let recommendBtn = UIButton()
        recommendBtn.setImage(UIImage(named: "mine_choose_button_normal_iPhone"), for: .normal)
        recommendBtn.setImage(UIImage(named: "mine_choose_button_selected_iPhone"), for: .selected)
        recommendBtn.addTarget(self, action: #selector(recommendToFriends(sender:)), for: .touchUpInside)
        return recommendBtn
    }()

    
    var friendsModel: PersonModel? {
        willSet {
            let imageUrl = URL(string: newValue?.userImage ?? "")
            userImageView.kf.setImage(with: imageUrl)
            userNameLabel.text = newValue?.name
        }
    }
}
