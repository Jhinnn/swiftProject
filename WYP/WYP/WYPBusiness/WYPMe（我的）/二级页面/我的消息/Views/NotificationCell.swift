//
//  NotificationCell.swift
//  WYP
//
//  Created by 你个LB on 2017/3/20.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

class NotificationCell: UITableViewCell {

    public var notification: NotificationModel? {
        willSet { //1.添加好友 2.推荐好友入群 3.抢票活动/兑换票务 4.订单消息 5.通过群组审核 6.通过好友审核 7.被踢出群组
            if newValue?.type == "2" || newValue?.type == "5" || newValue?.type == "6" || newValue?.type == "7" {
                typeLabel.text = "群组消息"
                iconImageView.image = UIImage(named: "mine_notificationGroup_icon_normal_iPhone")
            }else if newValue?.type == "1" {
                typeLabel.text = "好友消息"
                iconImageView.image = UIImage(named: "mine_notificationActive_icon_normal_iPhone")
            } else if newValue?.type == "3" {
                typeLabel.text = "活动消息"
                iconImageView.image = UIImage(named: "mine_notificationActive_icon_normal_iPhone")
            } else if newValue?.type == "4" {
                typeLabel.text = "订单消息"
                iconImageView.image = UIImage(named: "mine_notificationOrder_icon_normal_iPhone")
            }
            
            contentLabel.text = newValue?.content
            timeLabel.text = newValue?.timestamp?.getTimeString()
        }
    }
    
    // MARK: - Lifecycle
    
    // 指定初始化方法
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods

    
    
    // MARK: - Private Methods
    
    // 设置视图
    func setupUI() {
        contentView.addSubview(iconImageView)
        contentView.addSubview(typeLabel)
        contentView.addSubview(contentLabel)
        contentView.addSubview(timeLabel)
        
        setupUIFrame()
    }
    
    func setupUIFrame() {
        
        iconImageView.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(13)
            make.centerY.equalTo(contentView)
            make.size.equalTo(CGSize(width: 45, height: 45))
        }
        
        typeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(contentView).offset(14)
            make.left.equalTo(iconImageView.snp.right).offset(20)
            make.width.equalTo(120)
            make.height.equalTo(16)
        }
        
        contentLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(contentView).offset(-18)
            make.left.equalTo(typeLabel)
            make.right.equalTo(contentView).offset(-10)
        }
        
        timeLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(typeLabel.snp.centerY)
            make.right.equalTo(contentView).offset(-10)
            make.width.equalTo(120)
            make.height.equalTo(16)
        }
    }
    
    // MARK: - setter and getter
    // 图标
    lazy var iconImageView: UIImageView = {
        let iconImageView = UIImageView()
        return iconImageView
    }()
    
    // 通知类型
    lazy var typeLabel: UILabel = {
        let typeLabel = UILabel()
        typeLabel.font = UIFont.systemFont(ofSize: 15)
        typeLabel.textColor = UIColor.themeColor
        
        return typeLabel
    }()
    
    // 通知内容
    lazy var contentLabel: UILabel = {
        let contentLabel = UILabel()
        contentLabel.numberOfLines = 2
        contentLabel.font = UIFont.systemFont(ofSize: 15)
        contentLabel.textColor = UIColor.init(hexColor: "#87898f")
        
        return contentLabel
    }()
    
    // 通知时间
    lazy var timeLabel: UILabel = {
        let timeLabel = UILabel()
        timeLabel.textAlignment = .right
        timeLabel.font = UIFont.systemFont(ofSize: 14)
        timeLabel.textColor = UIColor.init(hexColor: "#87898f")
        
        return timeLabel
    }()
    
    // MARK: - IBActions
    
    
    // MARK: - Getter
    
    
    // MARK: - Setter
}
