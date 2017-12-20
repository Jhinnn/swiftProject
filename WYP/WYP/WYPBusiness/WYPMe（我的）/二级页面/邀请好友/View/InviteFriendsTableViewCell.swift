//
//  InviteFriendsTableViewCell.swift
//  InfoView
//
//  Created by ShuYan Feng on 2017/3/21.
//  Copyright © 2017年 ShuYan Feng. All rights reserved.
//

import UIKit

protocol InviteFriendsTableViewCellDelegate: NSObjectProtocol {
    func exchangeToTicketOrInviteFriends(sender: UIButton)
}

class InviteFriendsTableViewCell: UITableViewCell {
    
    weak var delegate: InviteFriendsTableViewCellDelegate?
    
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
        contentView.addSubview(ticketImageView)
        contentView.addSubview(activeNameLabel)
        contentView.addSubview(activeTypeLabel)
        contentView.addSubview(attentionLabel)
        contentView.addSubview(inviteButton)
        contentView.addSubview(activityInfo)
    }
    func layoutPageSubviews() {
        ticketImageView.snp.makeConstraints { (make) in
            make.top.equalTo(contentView).offset(10)
            make.left.equalTo(contentView).offset(10)
            make.bottom.equalTo(contentView).offset(-10)
            make.width.equalTo(100)
        }
        activeNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(contentView).offset(10)
            make.left.equalTo(ticketImageView.snp.right).offset(10)
            make.right.equalTo(contentView).offset(-10)
            make.height.equalTo(20)
        }
        activeTypeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(activeNameLabel.snp.bottom).offset(10)
            make.left.equalTo(ticketImageView.snp.right).offset(10)
            make.right.equalTo(contentView).offset(-10)
            make.height.equalTo(15)
        }
        attentionLabel.snp.makeConstraints { (make) in
            make.left.equalTo(ticketImageView.snp.right).offset(10)
            make.top.equalTo(activeTypeLabel.snp.bottom).offset(25)
            make.right.equalTo(contentView).offset(-100)
            make.height.equalTo(15)
        }
        activityInfo.snp.makeConstraints { (make) in
            make.left.equalTo(ticketImageView.snp.right).offset(10)
            make.bottom.equalTo(contentView).offset(-10)
            make.height.equalTo(14) 
        }
        if deviceTypeIphone5() || deviceTypeIPhone4() {
            inviteButton.snp.makeConstraints { (make) in
                make.bottom.equalTo(contentView).offset(-10)
                make.right.equalTo(contentView).offset(-10)
                make.height.equalTo(25 * width_height_ratio)
                make.width.equalTo(70 * width_height_ratio)
            }
        } else {
            inviteButton.snp.makeConstraints { (make) in
                make.bottom.equalTo(contentView).offset(-10)
                make.right.equalTo(contentView).offset(-5)
                make.height.equalTo(28 * width_height_ratio)
                make.width.equalTo(80 * width_height_ratio)
            }
        }
        
    }
    
    // MARK: - event response
    func exchangeToTicketOrInviteFriends(sender: UIButton) {
        delegate?.exchangeToTicketOrInviteFriends(sender: sender)
    }
    
    
    // MARK: - setter and getter
    lazy var ticketImageView: UIImageView = {
        let ticketImageView = UIImageView()
        ticketImageView.image = UIImage(named: "lottery_cellIcon_icon_normal_iPhone")
        return ticketImageView
    }()
    lazy var activeNameLabel: UILabel = {
        let activeNameLabel = UILabel()
        activeNameLabel.font = UIFont.systemFont(ofSize: 15)
        return activeNameLabel
    }()
    lazy var activeTypeLabel: UILabel = {
        let activeTypeLabel = UILabel()
        activeTypeLabel.font = UIFont.systemFont(ofSize: 12)
        activeTypeLabel.text = "活动类型：投票"
        return activeTypeLabel
    }()
    lazy var attentionLabel: UILabel = {
        let attentionLabel = UILabel()
        attentionLabel.font = UIFont.init(name: "FZJZJW--GB1-0", size: 15)
        attentionLabel.textColor = UIColor.gray
        attentionLabel.text = "一起阿拉丁"
        return attentionLabel
    }()
    lazy var activityInfo: UILabel = {
        let activityInfo = UILabel()
        activityInfo.text = "集齐五张可兑换演出票"
        activityInfo.textColor = UIColor.themeColor
        if deviceTypeIphone5() || deviceTypeIPhone4() {
            activityInfo.font = UIFont.systemFont(ofSize: 12)
        } else {
            activityInfo.font = UIFont.systemFont(ofSize: 14)
        }
        return activityInfo
    }()
    lazy var inviteButton: UIButton = {
        let inviteButton = UIButton(type: .custom)
        inviteButton.setTitle("邀请好友", for: .normal)
        inviteButton.setTitleColor(UIColor.white, for: .normal)
        inviteButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        inviteButton.backgroundColor = UIColor.themeColor
        inviteButton.layer.cornerRadius = 8.0
        inviteButton.layer.masksToBounds = true
        inviteButton.addTarget(self, action: #selector(exchangeToTicketOrInviteFriends(sender:)), for: .touchUpInside)
        return inviteButton
    }()
    
    var inviteModel: InviteFriendsModel? {
        willSet {
            let imageUrl = URL(string: newValue?.ticketImage ?? "")
            ticketImageView.kf.setImage(with: imageUrl)
            activeNameLabel.text = newValue?.ticketTitle ?? ""
            // 字体标红
            var ranStr: String!
            var attrstring: NSMutableAttributedString!
            let font = UIFont.init(name: "FZJZJW--GB1-0", size: 15)
            if newValue?.ticketNumber == 1 {
                ranStr = "一"
                attrstring = NSMutableAttributedString(string: attentionLabel.text!)
                let str = NSString(string: attentionLabel.text!)
                let theRange = str.range(of: ranStr)
                attrstring.addAttribute(NSForegroundColorAttributeName, value: UIColor.themeColor, range: theRange)
                attrstring.addAttribute(NSFontAttributeName, value: font ?? "", range: theRange)
                attentionLabel.attributedText = attrstring
            } else if newValue?.ticketNumber == 2 {
                ranStr = "一起"
                attrstring = NSMutableAttributedString(string: attentionLabel.text!)
                let str = NSString(string: attentionLabel.text!)
                let theRange = str.range(of: ranStr)
                attrstring.addAttribute(NSForegroundColorAttributeName, value: UIColor.themeColor, range: theRange)
                attrstring.addAttribute(NSFontAttributeName, value: font ?? "", range: theRange)
                attentionLabel.attributedText = attrstring
            } else if newValue?.ticketNumber == 3 {
                ranStr = "一起阿"
                attrstring = NSMutableAttributedString(string: attentionLabel.text!)
                let str = NSString(string: attentionLabel.text!)
                let theRange = str.range(of: ranStr)
                attrstring.addAttribute(NSForegroundColorAttributeName, value: UIColor.themeColor, range: theRange)
                attrstring.addAttribute(NSFontAttributeName, value: font ?? "", range: theRange)
                attentionLabel.attributedText = attrstring
            } else if newValue?.ticketNumber == 4 {
                ranStr = "一起阿拉"
                attrstring = NSMutableAttributedString(string: attentionLabel.text!)
                let str = NSString(string: attentionLabel.text!)
                let theRange = str.range(of: ranStr)
                attrstring.addAttribute(NSForegroundColorAttributeName, value: UIColor.themeColor, range: theRange)
                attrstring.addAttribute(NSFontAttributeName, value: font ?? "", range: theRange)
                attentionLabel.attributedText = attrstring
            } else if (newValue?.ticketNumber)! > 4 {
                ranStr = "一起阿拉丁"
                attrstring = NSMutableAttributedString(string: attentionLabel.text!)
                let str = NSString(string: attentionLabel.text!)
                let theRange = str.range(of: ranStr)
                attrstring.addAttribute(NSForegroundColorAttributeName, value: UIColor.themeColor, range: theRange)
                attrstring.addAttribute(NSFontAttributeName, value: font ?? "", range: theRange)
                attentionLabel.attributedText = attrstring
                
                //按钮
                inviteButton.setTitle("兑换", for: .normal)
            }
            
            // 活动类型
            switch "\(newValue?.activityType ?? "")" {
            case "1":
                activeTypeLabel.text = "活动类型：问答"
                break
            case "2":
                activeTypeLabel.text = "活动类型：投票"
                break
            case "3":
                activeTypeLabel.text = "活动类型：抽奖"
                break
            default:
                break
            }
            
            // 是否过期
            let currentStemp = Double(String().getCurrentDate())
            if newValue?.ticketEndTime != nil {
                if currentStemp > Double((newValue?.ticketEndTime)!) {
                    var image = UIImage(named: "common_grayBack_icon_normal_iPhone")
                    image = image?.resizableImage(withCapInsets: UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1), resizingMode: .tile)
                    inviteButton.setBackgroundImage(image, for: .normal)
                    inviteButton.setTitle("抢票截止", for: .normal)
                    inviteButton.isUserInteractionEnabled = false
                }
            }
            
            if newValue?.isExchange == 1 {
                var image = UIImage(named: "common_grayBack_icon_normal_iPhone")
                image = image?.resizableImage(withCapInsets: UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1), resizingMode: .tile)
                inviteButton.setBackgroundImage(image, for: .normal)
                inviteButton.setTitle("已兑换", for: .normal)
                inviteButton.isUserInteractionEnabled = false
            }
        }
    }
}
