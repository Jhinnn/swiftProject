//
//  GroupsTableViewCell.swift
//  WYP
//
//  Created by ShuYan Feng on 2017/3/20.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

class GroupsTableViewCell: UITableViewCell {
    
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
        contentView.addSubview(groupImageView)
        contentView.addSubview(groupTitleLabel)
    }
    func layoutPageSubviews() {
        groupImageView.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(13.5)
            make.centerY.equalTo(contentView)
            make.size.equalTo(CGSize(width: 35, height: 35))
        }
        groupTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(groupImageView.snp.right).offset(20)
            make.right.equalTo(contentView).offset(-13)
            make.centerY.equalTo(contentView)
            make.height.equalTo(20)
        }
    }

    
    // MARK: - setter
    // 群组头像
    lazy var groupImageView: UIImageView = {
        let groupImageView = UIImageView()
        groupImageView.backgroundColor = UIColor.init(hexColor: "afafafa")
        groupImageView.layer.masksToBounds = true
        groupImageView.layer.cornerRadius = 18.0
        return groupImageView
    }()
    lazy var groupTitleLabel: UILabel = {
        let groupTitleLabel = UILabel()
        groupTitleLabel.font = UIFont.systemFont(ofSize: 13)
        return groupTitleLabel
    }()
    
    // MARK: - getter
    var groupsModel: GroupsModel? {
        willSet {
            let imageUrl = URL(string: newValue?.groupIconName ?? "")
            groupImageView.kf.setImage(with: imageUrl)
            groupTitleLabel.text = String.init(format: "%@ - %@", newValue?.roomName ?? "", newValue?.groupTitleName ?? "")
        }
    }
}
