//
//  AttentionRoomTableViewCell.swift
//  WYP
//
//  Created by ShuYan Feng on 2017/4/12.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

protocol AttentionRoomTableViewCellDelegate: NSObjectProtocol {
    func robTicketImmediately(sender: UIButton)
}

class AttentionRoomTableViewCell: UITableViewCell {

//    weak var delegate: AttentionRoomTableViewCellDelegate?
    
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
        contentView.addSubview(roomImageView)
        contentView.addSubview(roomTitleLabel)
        contentView.addSubview(roomInfoLabel)
        contentView.addSubview(roomMemberLabel)
//        contentView.addSubview(ticketButton)
    }
    func layoutPageSubviews() {
        roomImageView.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(13)
            make.centerY.equalTo(contentView)
            make.size.equalTo(CGSize(width: 60, height: 80))
        }
        roomTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(contentView).offset(19)
            make.left.equalTo(roomImageView.snp.right).offset(8)
            make.right.equalTo(contentView).offset(-13)
            make.height.equalTo(15)
        }
        roomInfoLabel.snp.makeConstraints { (make) in
            make.top.equalTo(roomTitleLabel.snp.bottom).offset(17)
            make.left.equalTo(roomImageView.snp.right).offset(8)
            make.right.equalTo(contentView).offset(-13)
            make.height.equalTo(13)
        }
        roomMemberLabel.snp.makeConstraints { (make) in
            make.top.equalTo(roomInfoLabel.snp.bottom).offset(10.5)
            make.left.equalTo(roomImageView.snp.right).offset(8)
            make.right.equalTo(contentView).offset(-13)
            make.height.equalTo(13)
        }
//        ticketButton.snp.makeConstraints { (make) in
//            make.right.equalTo(contentView).offset(-17)
//            make.bottom.equalTo(contentView).offset(-10)
//            make.size.equalTo(CGSize(width: 43, height: 29.5))
//        }
    }
    
    // MARK: - event response
//    func robTicketImmediately(sender: UIButton) {
//        delegate?.robTicketImmediately(sender: sender)
//    }
    
    // MARK: - setter and getter
    lazy var roomImageView: UIImageView = {
        let roomImageView = UIImageView()
        roomImageView.image = UIImage(named: "lottery_cellIcon_icon_normal_iPhone")
        return roomImageView
    }()
    lazy var roomTitleLabel: UILabel = {
        let roomTitleLabel = UILabel()
        roomTitleLabel.text = "五一欢乐季 大型神话"
        roomTitleLabel.font = UIFont.systemFont(ofSize: 15)
        roomTitleLabel.textColor = UIColor.init(hexColor: "323035")
        return roomTitleLabel
    }()
    lazy var roomInfoLabel: UILabel = {
        let roomInfoLabel = UILabel()
        roomInfoLabel.text = "攻克幽灵终唤醒，人机合体处未来"
        roomInfoLabel.font = UIFont.systemFont(ofSize: 13)
        roomInfoLabel.textColor = UIColor.init(hexColor: "696969")
        return roomInfoLabel
    }()
    lazy var roomMemberLabel: UILabel = {
        let roomMemberLabel = UILabel()
        roomMemberLabel.text = "刘德华/周晓明/王劫/番多拉..."
        roomMemberLabel.font = UIFont.systemFont(ofSize: 13)
        roomMemberLabel.textColor = UIColor.init(hexColor: "b0b0b0")
        return roomMemberLabel
    }()
//    lazy var ticketButton: UIButton = {
//        let ticketButton = UIButton()
//        ticketButton.setImage(UIImage(named: "lottery_getTicket_button_normal_iPhone"), for: .normal)
//        ticketButton.addTarget(self, action: #selector(robTicketImmediately(sender:)), for: .touchUpInside)
//        return ticketButton
//    }()
    
    var roomModel: AttentionRoomModel? {
        willSet {
            let imageUrl = URL(string: newValue?.logo ?? "")
            roomImageView.kf.setImage(with: imageUrl)
            roomTitleLabel.text = newValue?.roomTitle ?? ""
            roomInfoLabel.text = newValue?.roomDetail ?? ""
            roomMemberLabel.text = newValue?.roomMember ?? ""
            
//            // 判断是否有活动
//            if newValue?.roomActivity == "无最新活动" {
//                ticketButton.setImage(UIImage(named: "lottery_getTicket_button_gray_iPhone"), for: .normal)
//            } else {
//                ticketButton.setImage(UIImage(named: "lottery_getTicket_button_normal_iPhone"), for: .normal)
//                ticketButton.isEnabled = false
//            }
        }
    }
}
