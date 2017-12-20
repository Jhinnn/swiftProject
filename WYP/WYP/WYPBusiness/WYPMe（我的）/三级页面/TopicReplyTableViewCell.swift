//
//  TopicReplyTableViewCell.swift
//  InfoView
//
//  Created by ShuYan Feng on 2017/3/23.
//  Copyright © 2017年 ShuYan Feng. All rights reserved.
//

import UIKit

protocol TopicReplyTableViewCellDelegate: NSObjectProtocol {
    func replyStarDidSelected(sender: UIButton, commentReply: CommentModel)
}

class TopicReplyTableViewCell: UITableViewCell {

    weak var delegate: TopicReplyTableViewCellDelegate?
    
    // MARK: - life cycle
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        initBaseViewLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - private method
    func initBaseViewLayout() {
        contentView.addSubview(headImgView)
        contentView.addSubview(nickNameLablel)
        contentView.addSubview(contentLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(starCountButton)
    }
    
    func setupUIFrame(topicsFrame: TopicsReplyFrameModel) {
        headImgView.frame = (topicsFrame.headImgUrlF)!
        nickNameLablel.frame = (topicsFrame.nickNameF)!
        contentLabel.frame = (topicsFrame.contentF)!
        timeLabel.frame = (topicsFrame.timeF)!
        starCountButton.frame = (topicsFrame.starCountF)!
    }
    
    // MARK: - event response
    func clickStarButton(sender: UIButton) {
        delegate?.replyStarDidSelected(sender: sender, commentReply: (topicsFrame?.topics)!)
    }
    
    // MARK: - setter and getter
    // 头像
    lazy var headImgView: UIButton = {
        let headImgView = UIButton()
        headImgView.backgroundColor = UIColor.init(hexColor: "f1f2f4")
        headImgView.layer.masksToBounds = true
        headImgView.layer.cornerRadius = 19.5
        
        return headImgView
    }()
    
    // 昵称
    lazy var nickNameLablel: UILabel = {
        let nickNameLablel = UILabel()
        nickNameLablel.textColor = UIColor.init(hexColor: "#507bab")
        nickNameLablel.font = UIFont.systemFont(ofSize: 11)
        
        return nickNameLablel
    }()
    
    // 内容
    lazy var contentLabel: UILabel = {
        let contentLabel = UILabel()
        contentLabel.font = UIFont.systemFont(ofSize: 14)
        contentLabel.numberOfLines = 0
        
        return contentLabel
    }()
    
    // 时间
    lazy var timeLabel: UILabel = {
        let timeLabel = UILabel()
        timeLabel.font = UIFont.systemFont(ofSize: 10)
        
        return timeLabel
    }()
    
    // 点赞
    lazy var starCountButton: UIButton = {
        let starCountButton = UIButton(type: .custom)
        starCountButton.setImage(UIImage(named: "common_grayStar_button_normal_iPhone"), for: .normal)
        starCountButton.setImage(UIImage(named: "common_zan_button_selected_iPhone"), for: .selected)
        starCountButton.setTitleColor(UIColor.black, for: .normal)
        starCountButton.titleLabel?.font = UIFont.systemFont(ofSize: 11)
        starCountButton.addTarget(self, action: #selector(clickStarButton(sender:)), for: .touchUpInside)
        return starCountButton
    }()
    
    public var topicsFrame: TopicsReplyFrameModel? {
        willSet {
            
            let imageUrl = URL(string: newValue?.topics.userPhoto ?? "")
            headImgView.kf.setImage(with: imageUrl, for: .normal)
            nickNameLablel.text = newValue?.topics.nickName ?? ""
            contentLabel.text = newValue?.topics.content ?? ""
            timeLabel.text = Int(newValue!.topics!.createTime!)?.getTimeString()
            starCountButton.setTitle(" \(newValue?.topics.zanNumber ?? "0")", for: .normal)
            if newValue?.topics.isStar == "1" {
                starCountButton.isSelected = true
                starCountButton.setImage(UIImage(named: "common_zan_button_selected_iPhone"), for: .selected)
            } else {
                starCountButton.isSelected = false
            }
            
            setupUIFrame(topicsFrame: newValue!)
        }
    }

}
