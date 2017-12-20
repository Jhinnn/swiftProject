//
//  TheaterGroupTableViewCell.swift
//  WYP
//
//  Created by ShuYan Feng on 2017/4/5.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

class TheaterGroupTableViewCell: UITableViewCell {
    
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
    private func viewConfig() {
        contentView.addSubview(groupImageView)
        groupImageView.addSubview(groupTypeLabel)
        contentView.addSubview(groupNameLabel)
        contentView.addSubview(vipImageView)
        contentView.addSubview(groupIconImageView)
        contentView.addSubview(groupNumberLabel)
    }
    private func layoutPageSubviews() {
        groupImageView.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(14)
            make.centerY.equalTo(contentView)
            make.size.equalTo(CGSize(width: 75, height: 75))
        }
        groupTypeLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(groupImageView)
            make.bottom.equalTo(groupImageView).offset(-2)
            make.height.equalTo(10)
        }
        groupNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(contentView).offset(30)
            make.left.equalTo(groupImageView.snp.right).offset(20)
            make.right.equalTo(contentView).offset(-10)
            make.height.equalTo(15)
        }
        vipImageView.snp.makeConstraints { (make) in
            make.left.equalTo(groupNameLabel.snp.right).offset(10)
            make.top.equalTo(contentView).offset(30)
            make.size.equalTo(CGSize(width: 15, height: 15))
        }
        groupIconImageView.snp.makeConstraints { (make) in
            make.top.equalTo(groupNameLabel.snp.bottom).offset(15)
            make.left.equalTo(groupImageView.snp.right).offset(20)
            make.size.equalTo(CGSize(width: 15, height: 15))
        }
        groupNumberLabel.snp.makeConstraints { (make) in
            make.top.equalTo(groupNameLabel.snp.bottom).offset(15)
            make.left.equalTo(groupIconImageView.snp.right).offset(10)
            make.right.equalTo(contentView).offset(-84.5)
            make.height.equalTo(15)
        }
    }
    
    // MARK: - setter and getter
    lazy var groupImageView: UIImageView = {
        let groupImageView = UIImageView()
        groupImageView.backgroundColor = UIColor.init(hexColor: "a1a1a1")
        groupImageView.layer.masksToBounds = true
        groupImageView.layer.cornerRadius = 37.0
        return groupImageView
    }()
    lazy var groupTypeLabel: UILabel = {
        let groupTypeLabel = UILabel()
        groupTypeLabel.backgroundColor = UIColor.black
        groupTypeLabel.alpha = 0.5
        groupTypeLabel.textColor = UIColor.white
        groupTypeLabel.textAlignment = .center
        groupTypeLabel.text = "话剧类型"
        groupTypeLabel.font = UIFont.systemFont(ofSize: 7)
        return groupTypeLabel
    }()
    lazy var groupNameLabel: UILabel = {
        let groupNameLabel = UILabel()
        groupNameLabel.font = UIFont.systemFont(ofSize: 15)
        groupNameLabel.textColor = UIColor.init(hexColor: "333333")
        groupNameLabel.text = "北京曲剧龙须沟-粉丝群"
        return groupNameLabel
    }()
    lazy var vipImageView: UIImageView = {
        let vipImageView = UIImageView()
        vipImageView.image = UIImage(named: "showRoom_vip_icon_normal_iPhone")
        return vipImageView
    }()
    lazy var groupIconImageView: UIImageView = {
        let groupIconImageView = UIImageView()
        groupIconImageView.image = UIImage(named: "home_group_icon_normal_iPhone")
        return groupIconImageView
    }()
    lazy var groupNumberLabel: UILabel = {
        let groupNumberLabel = UILabel()
        groupNumberLabel.font = UIFont.systemFont(ofSize: 12)
        groupNumberLabel.textColor = UIColor.init(hexColor: "87898f")
        groupNumberLabel.text = "300/1000"
        return groupNumberLabel
    }()
    
    // 数据源
    var groupModel: TheaterGroupModel? {
        willSet {
            let imageUrl = URL(string: newValue!.groupPhoto ?? "")
            groupImageView.kf.setImage(with: imageUrl)
            groupTypeLabel.text = newValue?.groupRoomType
            if (newValue?.roomName?.characters.count)! > 10 {
                let subIndex: String.Index = (newValue?.roomName!.index((newValue?.roomName!.startIndex)!, offsetBy: 11))!
                let roomName = newValue?.roomName?.substring(to: subIndex)
                groupNameLabel.text = String.init(format: "%@... - %@", roomName!, newValue!.groupName!)
            } else {
                groupNameLabel.text = String.init(format: "%@ - %@", newValue!.roomName!, newValue!.groupName!)
            }
            groupNumberLabel.text = String.init(format: "%@/%@", newValue!.groupCount!, newValue!.peopleNumber!)
            if newValue?.isVip == "0" {
                vipImageView.isHidden = true
            }
        }
    }
}
