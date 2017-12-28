//
//  MemberCollectionReusableView.swift
//  WYP
//
//  Created by ShuYan Feng on 2017/5/17.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

protocol MemberCollectionReusableViewDelegate: NSObjectProtocol {
    func applyToEnterGroup(sender: UIButton)
//    func ignoreEnterGroup(sender: UIButton)
}

class MemberCollectionReusableView: UICollectionReusableView {
    
    weak var delegate: MemberCollectionReusableViewDelegate?
    
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
        self.addSubview(groupMarkLabel)
        self.addSubview(groupIntroduceLabel)
        self.addSubview(applyToGroupButton)
        self.addSubview(agreeButton)
        self.addSubview(ignoreButton)
    }
    func layoutPageSubviews() {
        groupMarkLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(30)
            make.top.equalTo(self).offset(20)
            make.height.equalTo(15)
        }
        groupIntroduceLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(30)
            make.right.equalTo(self).offset(-30)
            make.top.equalTo(groupMarkLabel.snp.bottom).offset(23)
        }
        applyToGroupButton.snp.makeConstraints { (make) in
            make.top.equalTo(groupIntroduceLabel.snp.bottom).offset(66)
            make.centerX.equalTo(self)
            make.size.equalTo(CGSize(width: kScreen_width - 60, height: 47))
        }
        
        // 推荐的情况下
        agreeButton.snp.makeConstraints { (make) in
            make.top.equalTo(groupIntroduceLabel.snp.bottom).offset(66)
            make.left.equalTo(self).offset(62 * width_height_ratio)
            make.size.equalTo(CGSize(width: 90 * width_height_ratio, height: 46 * width_height_ratio))
        }
        ignoreButton.snp.makeConstraints { (make) in
            make.top.equalTo(groupIntroduceLabel.snp.bottom).offset(66)
            make.right.equalTo(self).offset(-62 * width_height_ratio)
            make.size.equalTo(CGSize(width: 90 * width_height_ratio, height: 46 * width_height_ratio))
        }
    }
    
    // MARK: - event response
    func applyAddGroup(sender: UIButton) {
        delegate?.applyToEnterGroup(sender: sender)
    }
    func ignoreEnterGroup(sender: UIButton) {
        self.viewController()?.navigationController?.popViewController(animated: false)
    }
    
    // MARK: - setter and getter
    lazy var groupMarkLabel: UILabel = {
        let groupMarkLabel = UILabel()
        groupMarkLabel.text = "群组介绍"
        groupMarkLabel.font = UIFont.systemFont(ofSize: 15)
        return groupMarkLabel
    }()
    
    lazy var groupIntroduceLabel: UILabel = {
        let groupIntroduceLabel = UILabel()
        groupIntroduceLabel.font = UIFont.systemFont(ofSize: 15)
        groupIntroduceLabel.textColor = UIColor.init(hexColor: "b3b4b8")
        groupIntroduceLabel.numberOfLines = 0
        
        return groupIntroduceLabel
    }()
    
    lazy var applyToGroupButton: UIButton = {
        let applyToGroupButton = UIButton()
        applyToGroupButton.setTitle("申请入群", for: .normal)
        applyToGroupButton.setTitleColor(UIColor.white, for: .normal)
        var image = UIImage(named: "common_backgroundColor_button_normal_iPhone")
        image = image?.resizableImage(withCapInsets: UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1), resizingMode: .tile)
        applyToGroupButton.setBackgroundImage(image, for: .normal)
        applyToGroupButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        applyToGroupButton.addTarget(self, action: #selector(applyAddGroup(sender:)), for: .touchUpInside)
        applyToGroupButton.layer.cornerRadius = 8.0
        applyToGroupButton.layer.masksToBounds = true
        return applyToGroupButton
    }()
    
    lazy var agreeButton: UIButton = {
        let agreeButton = UIButton()
        agreeButton.setTitle("同意", for: .normal)
        agreeButton.setTitleColor(UIColor.white, for: .normal)
        var image = UIImage(named: "common_backgroundColor_button_normal_iPhone")
        image = image?.resizableImage(withCapInsets: UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1), resizingMode: .tile)
        agreeButton.setBackgroundImage(image, for: .normal)
        agreeButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        agreeButton.addTarget(self, action: #selector(applyAddGroup(sender:)), for: .touchUpInside)
        agreeButton.layer.cornerRadius = 8.0
        agreeButton.layer.masksToBounds = true
        return agreeButton
    }()
    
    lazy var ignoreButton: UIButton = {
        let ignoreButton = UIButton()
        ignoreButton.setTitle("忽略", for: .normal)
        ignoreButton.setTitleColor(UIColor.white, for: .normal)
        var image = UIImage(named: "common_backgroundColor_button_normal_iPhone")
        image = image?.resizableImage(withCapInsets: UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1), resizingMode: .tile)
        ignoreButton.setBackgroundImage(image, for: .normal)
        ignoreButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        ignoreButton.addTarget(self, action: #selector(ignoreEnterGroup(sender:)), for: .touchUpInside)
        ignoreButton.layer.cornerRadius = 8.0
        ignoreButton.layer.masksToBounds = true
        return ignoreButton
    }()
}
