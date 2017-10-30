//
//  GroupMemberCollectionViewCell.swift
//  WYP
//
//  Created by ShuYan Feng on 2017/4/11.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

class GroupMemberCollectionViewCell: UICollectionViewCell {
    
    // MARK: - life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        viewConfig()
        layoutPageSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - private method
    func viewConfig() {
        contentView.addSubview(memberImageView)
        contentView.addSubview(memberNameLabel)
    }
    func layoutPageSubviews() {
        memberImageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(contentView)
            make.top.equalTo(contentView).offset(2)
            make.size.equalTo(CGSize(width: 55, height: 55))
        }
        memberNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(memberImageView.snp.bottom).offset(7.5)
            make.left.equalTo(contentView).offset(4)
            make.right.equalTo(contentView).offset(-4)
            make.height.equalTo(12)
        }
    }
    
    // MARK: - setter and getter
    lazy var memberImageView: UIImageView = {
        let memberImageView = UIImageView()
        return memberImageView
    }()
    lazy var memberNameLabel: UILabel = {
        let memberNameLabel = UILabel()
        memberNameLabel.text = "大脸猫"
        memberNameLabel.textAlignment = .center
        memberNameLabel.font = UIFont.systemFont(ofSize: 10)
        return memberNameLabel
    }()
    
    var groupModel: PersonModel? {
        willSet {
            memberNameLabel.text = newValue?.name ?? ""
            let imageUrl = URL(string: newValue?.userImage ?? "")
            memberImageView.kf.setImage(with: imageUrl)
        }
    }
}
