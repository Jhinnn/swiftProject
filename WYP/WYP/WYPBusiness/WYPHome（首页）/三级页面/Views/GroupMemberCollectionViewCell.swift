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
//        contentView.addSubview(chooseBtn)
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
//        chooseBtn.snp.makeConstraints { (make) in
//            make.centerX.equalTo(contentView)
//            make.top.equalTo(10)
//            make.size.equalTo(30)
//        }
    }
    
    // MARK: - setter and getter
    
    lazy var memberImageView: UIImageView = {
        let memberImageView = UIImageView()
        memberImageView.layer.cornerRadius = 27.5
        memberImageView.layer.masksToBounds = true
        memberImageView.backgroundColor = UIColor.init(hexColor: "a1a1a1")
        
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
    
//    lazy var chooseBtn : UIButton = {
//       let btn = UIButton()
//        btn.setImage(UIImage.init(named: "theme_icon_option_normal"), for: .normal)
//        btn.setImage(UIImage.init(named: "theme_icon_option_pitch"), for: .selected)
//        return btn
//    }()
//    // 判断是否显示选择的图标
//    var isChoose : Bool {
//        willSet {
//            self.chooseBtn.isHidden = isChoose
//        }
//    }
}
