//
//  GroupsMemberListCollectionReusableView.swift
//  WYP
//
//  Created by ShuYan Feng on 2017/6/1.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

protocol GroupsMemberListCollectionDelegate: NSObjectProtocol {
    
    func quiteGroup()
    func noDisturbing(sender: UISwitch)
    
}

class GroupsMemberListCollectionReusableView: UICollectionReusableView {
    
    weak var delegate: GroupsMemberListCollectionDelegate?
    
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
        self.addSubview(grayLine)
        self.addSubview(noDisturbingLabel)
        self.addSubview(switchBtn)
        self.addSubview(grayLine1)
        self.addSubview(quitGroupButton)
    }
    func layoutPageSubviews() {
        grayLine.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(self)
            make.height.equalTo(10)
        }
        noDisturbingLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(13)
            make.top.equalTo(grayLine.snp.bottom).offset(13)
            make.size.equalTo(CGSize(width: 100, height: 15))
        }
        switchBtn.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(-13)
            make.top.equalTo(grayLine.snp.bottom).offset(10)
            make.size.equalTo(CGSize(width: 50, height: 20))
        }
        grayLine1.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.top.equalTo(noDisturbingLabel.snp.bottom).offset(13)
            make.height.equalTo(10)
        }
        quitGroupButton.snp.makeConstraints { (make) in
            make.top.equalTo(grayLine1.snp.bottom).offset(66)
            make.centerX.equalTo(self)
            make.size.equalTo(CGSize(width: 276.5, height: 47))
        }
    }
    
    // MARK: - event response
    func quiteGroup(sender: UIButton) {
        delegate?.quiteGroup()
    }
    func noDisturbing(sender: UISwitch) {
        delegate?.noDisturbing(sender: sender)
    }
    
    // MARK: - setter and getter
    lazy var grayLine: UIView = {
        let grayLine = UIView()
        grayLine.backgroundColor = UIColor.vcBgColor
        return grayLine
    }()
    lazy var grayLine1: UIView = {
        let grayLine = UIView()
        grayLine.backgroundColor = UIColor.vcBgColor
        return grayLine
    }()
    
    lazy var noDisturbingLabel: UILabel = {
        let noDisturbingLabel = UILabel()
        noDisturbingLabel.font = UIFont.systemFont(ofSize: 15)
        noDisturbingLabel.textColor = UIColor.init(hexColor: "333333")
        noDisturbingLabel.text = "开启免打扰"
        return noDisturbingLabel
    }()
    
    lazy var switchBtn: UISwitch = {
        let switchBtn = UISwitch()
        switchBtn.onTintColor = UIColor.themeColor
        switchBtn.addTarget(self, action: #selector(noDisturbing(sender:)), for: .valueChanged)
        return switchBtn
    }()
    
    lazy var quitGroupButton: UIButton = {
        let quitGroupButton = UIButton()
        quitGroupButton.setTitle("删除并退出", for: .normal)
        quitGroupButton.setTitleColor(UIColor.white, for: .normal)
        var image = UIImage(named: "common_backgroundColor_button_normal_iPhone")
        image = image?.resizableImage(withCapInsets: UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1), resizingMode: .tile)
        quitGroupButton.setBackgroundImage(image, for: .normal)
        quitGroupButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        quitGroupButton.addTarget(self, action: #selector(quiteGroup(sender:)), for: .touchUpInside)
        quitGroupButton.layer.cornerRadius = 8.0
        quitGroupButton.layer.masksToBounds = true
        return quitGroupButton
    }()
}
