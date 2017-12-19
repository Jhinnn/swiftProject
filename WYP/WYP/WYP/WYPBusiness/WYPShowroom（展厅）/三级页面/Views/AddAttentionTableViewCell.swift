//
//  AddAttentionTableViewCell.swift
//  InfoView
//
//  Created by ShuYan Feng on 2017/3/28.
//  Copyright © 2017年 ShuYan Feng. All rights reserved.
//

import UIKit

protocol AddAttentionTableViewCellDelegate: NSObjectProtocol {
    func addAttention(sender: UIButton)
}

class AddAttentionTableViewCell: UITableViewCell {

    weak var delegate: AddAttentionTableViewCellDelegate?
    
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
        contentView.addSubview(userIconImageView)
        contentView.addSubview(userNameLabel)
        contentView.addSubview(portrayLabel)
        contentView.addSubview(fansNumberLabel)
        contentView.addSubview(addAttentionButton)
    }
    func layoutPageSubviews() {
        userIconImageView.snp.makeConstraints { (make) in
            make.top.equalTo(contentView).offset(10)
            make.left.equalTo(contentView).offset(10)
            make.size.equalTo(CGSize(width: 75, height: 75))
        }
        userNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(contentView).offset(10)
            make.left.equalTo(userIconImageView.snp.right).offset(20)
            make.height.equalTo(20)
        }
        portrayLabel.snp.makeConstraints { (make) in
            make.top.equalTo(userNameLabel.snp.bottom).offset(10)
            make.left.equalTo(userIconImageView.snp.right).offset(20)
            make.right.equalTo(contentView).offset(-10)
            make.height.equalTo(20)
        }
        fansNumberLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(contentView).offset(-10)
            make.left.equalTo(userIconImageView.snp.right).offset(20)
            make.right.equalTo(contentView).offset(-10)
            make.height.equalTo(15)
        }
        addAttentionButton.snp.makeConstraints { (make) in
            make.right.equalTo(contentView).offset(-15)
            make.centerY.equalTo(contentView)
            make.size.equalTo(CGSize(width: 80, height: 35))
        }
        
    }
    
    // MARK: - event response
    func clickAddAttention(sender: UIButton) {
        delegate?.addAttention(sender: sender)
    }
    
    // MARK: - setter and getter
    lazy var userIconImageView: UIImageView = {
        let userIconImageView = UIImageView()
        userIconImageView.backgroundColor = UIColor.cyan
        userIconImageView.layer.masksToBounds = true
        userIconImageView.layer.cornerRadius = 37.0
        return userIconImageView
    }()
    lazy var userNameLabel: UILabel = {
        let userNameLabel = UILabel()
        userNameLabel.font = UIFont.systemFont(ofSize: 15)
        return userNameLabel
    }()
    lazy var portrayLabel: UILabel = {
        let portrayLabel = UILabel()
        portrayLabel.font = UIFont.systemFont(ofSize: 11)
        return portrayLabel
    }()
    lazy var fansNumberLabel: UILabel = {
        let fansNumberLabel = UILabel()
        fansNumberLabel.font = UIFont.systemFont(ofSize: 11)
        return fansNumberLabel
    }()
    lazy var addAttentionButton: UIButton = {
        let addAttentionButton = UIButton(type: .custom)
        addAttentionButton.setImage(UIImage(named: "showRoom_addAttention_button_normal_iPhone"), for: .normal)
        addAttentionButton.setImage(UIImage(named: "showRoom_addAttention_button_selected_iPhone"), for: .selected)
        addAttentionButton.addTarget(self, action: #selector(clickAddAttention(sender:)), for: .touchUpInside)
        return addAttentionButton
    }()

    // 数据源
    var memberModel: MemberModel? {
        willSet {
            let imageUrl = URL(string: newValue?.memberPhoto ?? "")
            userIconImageView.kf.setImage(with: imageUrl)
            userNameLabel.text = newValue!.realName
            // 职业
            if newValue?.profession == "饰演" {
                portrayLabel.text = String.init(format: "%@: %@", newValue!.profession!, newValue!.portray!)
            } else {
                portrayLabel.text = newValue!.profession
            }
            fansNumberLabel.text = String.init(format: "%@ 粉丝", newValue!.memberFans!)
            if newValue?.isFllow == "1" {
                addAttentionButton.setImage(UIImage(named: "showRoom_alreadyAttention_button_normal_iPhone"), for: .normal)
            }
        }
    }
}
