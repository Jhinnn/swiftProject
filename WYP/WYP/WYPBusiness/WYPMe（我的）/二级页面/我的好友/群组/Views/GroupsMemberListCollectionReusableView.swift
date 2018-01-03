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
    func putGroupNote()
    func noDisturbing(sender: UISwitch)
    func codeImageViewClicked()
    func chatRecordBtnClicked()
    func managerGroupBtnClicked()
}

class GroupsMemberListCollectionReusableView: UICollectionReusableView {
    
    weak var delegate: GroupsMemberListCollectionDelegate?
    
//    var : (() -> Void)?
    
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
        self.addSubview(settingView)
        self.addSubview(grayLine)
        self.addSubview(grayLine2)
        self.addSubview(grayLine3)
        self.addSubview(noDisturbingLabel)
//        self.addSubview(switchBtn)
        self.addSubview(grayLine1)
        self.addSubview(quitGroupButton)
        self.addSubview(groupNote)
        self.addSubview(groupNoteButton)
        self.addSubview(groupNoteConten)
        self.addSubview(Chatrecord)
        self.addSubview(grayLine4)
        self.addSubview(groupDetal)
        self.addSubview(groupNoteConten)
        self.addSubview(grayLine5)
        self.addSubview(groupDetalConten)
        self.addSubview(chatRecordBtn)
    }
    func layoutPageSubviews() {
        settingView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(self)
            make.height.equalTo(47)
        }
        
        grayLine.snp.makeConstraints { (make) in
            make.top.equalTo(settingView.snp.bottom)
            make.left.right.equalTo(self)
            make.height.equalTo(10)
        }
     
        groupNote.snp.makeConstraints { (make) in
            make.right.equalTo(grayLine)
            make.left.equalTo(self).offset(13)
            make.top.equalTo(grayLine.snp.bottom).offset(13)
            make.height.equalTo(15)
        }
        
        groupNoteButton.snp.makeConstraints { (make) in
            make.size.equalTo(groupNote)
            make.centerY.equalTo(groupNote)
            
        }
     
        
        groupNoteConten.snp.makeConstraints { (make) in
            make.top.equalTo(groupNote.snp.bottom).offset(20)
            make.left.equalTo(self).offset(100)
            make.right.equalTo(self).offset(-30)
            make.height.equalTo(60)
        }
        
        grayLine4.snp.makeConstraints { (make) in
            make.top.equalTo(groupNoteConten.snp.bottom).offset(13)
            make.height.equalTo(1)
            make.left.right.equalTo(self)
            
        }
        
        Chatrecord.snp.makeConstraints { (make) in
            make.top.equalTo(grayLine4.snp.bottom).offset(13)
            make.right.equalTo(self)
            make.left.equalTo(self).offset(13)
            make.height.equalTo(0)
        }

        chatRecordBtn.snp.makeConstraints { (make) in
            make.size.equalTo(Chatrecord)
            make.centerY.equalTo(Chatrecord)
        }
        
        grayLine3.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.top.equalTo(Chatrecord.snp.bottom).offset(13)
            make.height.equalTo(0)
        }

        noDisturbingLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(13)
            make.top.equalTo(grayLine3.snp.bottom).offset(13)
            make.size.equalTo(CGSize(width: 100, height: 0))
        }
//        switchBtn.snp.makeConstraints { (make) in
//            make.right.equalTo(self).offset(-13)
//            make.top.equalTo(grayLine3.snp.bottom).offset(6)
//            make.size.equalTo(CGSize(width: 50, height: 0))
//        }
        grayLine1.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.top.equalTo(noDisturbingLabel.snp.bottom).offset(13)
            make.height.equalTo(0)
        }
        groupDetal.snp.makeConstraints { (make) in
            make.right.equalTo(self)
            make.left.equalTo(self).offset(13)
            make.top.equalTo(grayLine1.snp.bottom).offset(13)
            make.height.equalTo(24)
        }
        groupDetalConten.snp.makeConstraints { (make) in
            make.top.equalTo(groupDetal.snp.bottom).offset(20)
            make.left.equalTo(self).offset(100)
            make.right.equalTo(self).offset(-30)
            make.height.equalTo(60)
            
            
        }
        
        grayLine5.snp.makeConstraints { (make) in
            make.top.equalTo(groupDetalConten.snp.bottom).offset(13)
            make.height.equalTo(10)
            make.left.right.equalTo(self)
            
        }
        
        quitGroupButton.snp.makeConstraints { (make) in
            make.top.equalTo(grayLine5.snp.bottom).offset(66)
            make.centerX.equalTo(self)
            make.size.equalTo(CGSize(width: 276.5, height: 47))
        }
        
        
    }
    
    // MARK: - event response
    func quiteGroup(sender: UIButton) {
        delegate?.quiteGroup()
    }
    func putGroupNote(sender: UIButton) {
        delegate?.putGroupNote()
    }
    func noDisturbing(sender: UISwitch) {
        delegate?.noDisturbing(sender: sender)
    }
    
    // MARK: - setter and getter
    lazy var settingView: UIView = {
        let setting = UIView()
        setting.backgroundColor = UIColor.white
        let line = UIView()
        line.backgroundColor = UIColor.vcBgColor
        setting.addSubview(line)
        line.snp.makeConstraints({ (make) in
            make.left.top.right.equalTo(setting)
            make.height.equalTo(1)
        })
        let imageView = UIImageView.init(image: UIImage.init(named: "cluster_icon_install_normalmore"))
        setting.addSubview(imageView)
        imageView.snp.makeConstraints({ (make) in
            make.centerY.equalTo(setting)
            make.left.equalTo(12)
            make.size.equalTo(20)
        })
        let label = UILabel()
        label.text = "管理群"
        label.textColor = UIColor.init(hexColor: "333333")
        label.font = UIFont.systemFont(ofSize: 13)
        setting.addSubview(label)
        label.snp.makeConstraints({ (make) in
            make.left.equalTo(imageView.snp.right).offset(11)
            make.centerY.equalTo(imageView)
        })
        let btn = UIButton()
        btn.setImage(UIImage(named: "chat_icon_advance_normalmore"), for: .normal)
        btn.addTarget(self, action: #selector(managerGroupBtnClicked(sender:)), for: UIControlEvents.touchUpInside)
        setting.addSubview(btn)
        btn.snp.makeConstraints({ (make) in
            make.right.equalTo(setting.snp.right)
            make.size.equalTo(label)
            make.centerY.equalTo(label)
        })
        return setting
    }()
    
    func managerGroupBtnClicked(sender: UIButton) {
        delegate?.managerGroupBtnClicked()
    }
    
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
    
    lazy var grayLine3: UIView = {
        let grayLine = UIView()
        grayLine.backgroundColor = UIColor.vcBgColor
        return grayLine
    }()
    
    lazy var grayLine2: UIView = {
        let grayLine = UIView()
        grayLine.backgroundColor = UIColor.vcBgColor
        return grayLine
    }()
    
    lazy var grayLine4: UIView = {
        let grayLine4 = UIView()
        grayLine4.backgroundColor = UIColor.vcBgColor
        return grayLine4
    }()
    
    
    //群公告
    lazy var groupNote: UILabel = {
        let groupNote = UILabel()
        groupNote.font = UIFont.systemFont(ofSize: 15)
        groupNote.textColor = UIColor.init(hexColor: "333333")
        groupNote.text = "群公告"
        return groupNote
    }()
    lazy var grayLine5: UIView = {
        let grayLine5 = UIView()
        grayLine5.backgroundColor = UIColor.vcBgColor
        return grayLine5
    }()
    
    //群公告内容
    lazy var groupNoteConten: UILabel = {
        let groupNoteConten = UILabel()
        groupNoteConten.numberOfLines = 3
        groupNoteConten.textColor = UIColor.init(hexColor: "333333")
        groupNoteConten.font = UIFont.systemFont(ofSize: 12)
        groupNoteConten.text = "不得在群内骂人斗嘴等具有人身攻击性质行为，可私下单挑解决。如被暴打请拨打110或向管理员求助，但管理员不负责替你出头。"
        
        
        
        return groupNoteConten
    }()
    
    lazy var groupNoteButton: UIButton = {
        let groupNoteButton = UIButton()
        groupNoteButton.setImage(UIImage(named: "chat_icon_advance_normalmore"), for: .normal)
        groupNoteButton.imageEdgeInsets = UIEdgeInsetsMake(0, kScreen_width - 30, 0, 0)
        groupNoteButton.addTarget(self, action: #selector(putGroupNote(sender:)), for: UIControlEvents.touchUpInside)
        return groupNoteButton
    }()

    //聊天记录
    lazy var Chatrecord: UILabel = {
        let Chatrecord = UILabel()
        Chatrecord.textColor = UIColor.init(hexColor: "333333")
        Chatrecord.font  = UIFont.systemFont(ofSize: 15)
        Chatrecord.text = "聊天记录"
        return Chatrecord

    }()

    lazy var chatRecordBtn: UIButton = {
        let chatRecordBtn = UIButton()
        chatRecordBtn.setImage(UIImage(named: "chat_icon_advance_normalmore"), for: .normal)
        chatRecordBtn.imageEdgeInsets = UIEdgeInsetsMake(0, kScreen_width - 30, 0, 0)
        chatRecordBtn.addTarget(self, action: #selector(chatRecordBtnClicked(sender:)), for: .touchUpInside)
        return chatRecordBtn
    }()

    func chatRecordBtnClicked(sender: UIButton) {
        delegate?.chatRecordBtnClicked()
    }

    lazy var noDisturbingLabel: UILabel = {
        let noDisturbingLabel = UILabel()
        noDisturbingLabel.font = UIFont.systemFont(ofSize: 15)
        noDisturbingLabel.textColor = UIColor.init(hexColor: "333333")
        noDisturbingLabel.text = "开启免打扰"
        return noDisturbingLabel
    }()

//    lazy var switchBtn: UISwitch = {
//        let switchBtn = UISwitch()
//        switchBtn.onTintColor = UIColor.themeColor
//        switchBtn.addTarget(self, action: #selector(noDisturbing(sender:)), for: .valueChanged)
//        return switchBtn
//    }()
    
    //群介绍
    lazy var groupDetal: UILabel = {
        let groupDetal = UILabel()
        groupDetal.font = UIFont.systemFont(ofSize: 15)
        groupDetal.textColor = UIColor.init(hexColor: "333333")
        groupDetal.text = "群介绍"
        return groupDetal
    }()
    
    //群简介
    lazy var groupDetalConten: UILabel = {
        let groupDetalConten = UILabel()
        groupDetalConten.numberOfLines = 3
        groupDetalConten.textColor = UIColor.init(hexColor: "333333")
        groupDetalConten.font = UIFont.systemFont(ofSize: 12)
        groupDetalConten.text = "不得在群内骂人斗嘴等具有人身攻击性质行为，可私下单挑解决。如被暴打请拨打110或向管理员求助，但管理员不负责替你出头。"
        
        return groupDetalConten
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
