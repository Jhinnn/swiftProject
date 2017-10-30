//
//  AttentionPeopleTableViewCell.swift
//  WYP
//
//  Created by ShuYan Feng on 2017/3/20.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

class AttentionPeopleTableViewCell: UITableViewCell {
    
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
        contentView.addSubview(peopleImageView)
        contentView.addSubview(peopleTitleLabel)
        contentView.addSubview(peopleSignatureLabel)
    }
    func layoutPageSubviews() {
        peopleImageView.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(13.5)
            make.centerY.equalTo(contentView)
            make.size.equalTo(CGSize(width: 45, height: 45))
        }
        peopleTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(peopleImageView.snp.right).offset(20)
            make.top.equalTo(contentView).offset(9.5)
            make.right.equalTo(contentView).offset(-50)
            make.height.equalTo(20)
        }
        peopleSignatureLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(contentView).offset(-20)
            make.left.equalTo(peopleImageView.snp.right).offset(20)
            make.right.equalTo(contentView).offset(-10)
            make.height.equalTo(10)
        }
    }
    
    
    // MARK: - setter
    // 群组头像
    lazy var peopleImageView: UIImageView = {
        let groupImageView = UIImageView()
        groupImageView.backgroundColor = UIColor.init(hexColor: "f1f2f4")
        groupImageView.layer.masksToBounds = true
        groupImageView.layer.cornerRadius = 21.5
        return groupImageView
    }()
    lazy var peopleTitleLabel: UILabel = {
        let groupTitleLabel = UILabel()
        groupTitleLabel.font = UIFont.systemFont(ofSize: 13)
        return groupTitleLabel
    }()
    lazy var peopleSignatureLabel: UILabel = {
        let groupSignatureLabel = UILabel()
        groupSignatureLabel.font = UIFont.systemFont(ofSize: 10)
        return groupSignatureLabel
    }()
    
    // MARK: - getter
    var peoplesModel: AttentionPeopleModel? {
        willSet {
            let imageUrl = URL(string: newValue?.icon ?? "")
            peopleImageView.kf.setImage(with: imageUrl)
            peopleTitleLabel.text = newValue?.realName
            peopleSignatureLabel.text = newValue?.signature
        }
    }
}
