//
//  TopicsCell.swift
//  WYP
//
//  Created by 你个LB on 2017/3/20.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

protocol TopicsCellDelegate: NSObjectProtocol {
    func starDidSelected(sender: UIButton, topics: TopicsModel)
}

class TopicsCell: UITableViewCell {

    weak var delegate: TopicsCellDelegate?
    
    public var topicsFrame: TopicsFrameModel? {
        willSet {
            
            
            let imageUrl = URL(string: newValue?.topics.headImgUrl ?? "" )

            headImgView.kf.setImage(with: imageUrl, for: .normal)
            
            nickNameLablel.text = newValue?.topics.nickName ?? ""
            
            contentLabel.text = String.init(format: "%@",  newValue?.topics.content ?? "")
            
            typeLabel.text = newValue?.topics.type ?? ""
        
            timeLabel.text = newValue?.topics?.timestamp?.getTimeString()
            
            seeCountLabel.text = String.init(format: "%@ 浏览", newValue?.topics.seeCount ?? "-")
            
            commentCountLabel.text = String.init(format: "%@ 评论", newValue?.topics.commentCount ?? "-")
            
            starCountButton.setTitle(" \(newValue?.topics.starCount ?? "0")", for: .normal)
            if newValue?.topics.isStar == "1" {
                starCountButton.isSelected = true
            } else {
                starCountButton.isSelected = false
            }
            
            setupUIFrame(topicsFrame: newValue!)
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
        contentView.addSubview(headImgView)
        contentView.addSubview(nickNameLablel)
        contentView.addSubview(starCountButton)
        contentView.addSubview(contentLabel)
        contentView.addSubview(typeLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(seeCountLabel)
        contentView.addSubview(commentCountLabel)
    }
    
    func setupUIFrame(topicsFrame: TopicsFrameModel) {
        headImgView.frame = (topicsFrame.headImgUrlF)!
        nickNameLablel.frame = (topicsFrame.nickNameF)!
        starCountButton.frame = (topicsFrame.starCountF)!
        contentLabel.frame = (topicsFrame.contentF)!
        typeLabel.frame = (topicsFrame.typeF)!
        timeLabel.frame = (topicsFrame.timeF)!
        seeCountLabel.frame = (topicsFrame.seeCountF)!
        commentCountLabel.frame = (topicsFrame.commentCountF)!
    }
    
    // MARK: - event response
    func clickStarButton(sender: UIButton) {
        delegate?.starDidSelected(sender: sender, topics: (topicsFrame?.topics)!)
    }
    
    func clickHeadImageView(sender: UIButton) {
        let community = MyCommunityViewController()
        community.title = "个人主页"
        community.userId = topicsFrame?.topics.peopleId ?? ""
        community.headImageUrl = topicsFrame?.topics.headImgUrl ?? ""
        community.nickName = topicsFrame?.topics.nickName ?? ""
        community.fansCount = String.init(format: "粉丝:%@人", topicsFrame?.topics.peopleFans ?? "")
        community.friendsCountLabel.text = String.init(format: "好友:%@人", topicsFrame?.topics.peopleFriends ?? "")
        community.type = "2"
        if topicsFrame?.topics.peopleId == AppInfo.shared.user?.userId {
            community.userType = "200"
        }
        // 判断是否关注
        if topicsFrame?.topics.isFollow == "0" {
            community.isFollowed = false
        } else if topicsFrame?.topics.isFollow == "1" {
            community.isFollowed = true
        }
        self.viewController()?.navigationController?.pushViewController(community, animated: true)
    }
    
    // 头像
    lazy var headImgView: UIButton = {
        let headImgView = UIButton()
        headImgView.backgroundColor = UIColor.init(hexColor: "f1f2f4")
        headImgView.layer.masksToBounds = true
        headImgView.layer.cornerRadius = 19.5
        headImgView.addTarget(self, action: #selector(clickHeadImageView(sender:)), for: .touchUpInside)
        
        return headImgView
    }()
    
    // 昵称
    lazy var nickNameLablel: UILabel = {
        let nickNameLablel = UILabel()
        nickNameLablel.textColor = UIColor.init(hexColor: "#507bab")
        nickNameLablel.font = UIFont.systemFont(ofSize: 11)
        
        return nickNameLablel
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
    
    // 内容
    lazy var contentLabel: UILabel = {
        let contentLabel = UILabel()
        contentLabel.numberOfLines = 0
        contentLabel.font = UIFont.systemFont(ofSize: 14)
        
        return contentLabel
    }()
    
    // 类型
    lazy var typeLabel: UILabel = {
        let typeLabel = UILabel()
        typeLabel.font = UIFont.systemFont(ofSize: 8)
        typeLabel.textColor = UIColor.init(hexColor: "a1a1a1")
        typeLabel.textAlignment = .center
        typeLabel.layer.cornerRadius = 5
        typeLabel.layer.borderWidth = 1
        typeLabel.layer.borderColor = UIColor.init(hexColor: "a1a1a1").cgColor
        
        return typeLabel
    }()
    
    // 时间
    lazy var timeLabel: UILabel = {
        let timeLabel = UILabel()
        timeLabel.font = UIFont.systemFont(ofSize: 10)
        timeLabel.textColor = UIColor.init(hexColor: "a1a1a1")
        
        return timeLabel
    }()
    
    // 浏览数
    lazy var seeCountLabel: UILabel = {
        let seeCountLabel = UILabel()
        seeCountLabel.font = UIFont.systemFont(ofSize: 10)
        seeCountLabel.textColor = UIColor.init(hexColor: "a1a1a1")
        
        return seeCountLabel
    }()
    
    // 回复数
    lazy var commentCountLabel: UILabel = {
        let commentCountLabel = UILabel()
        commentCountLabel.textAlignment = .right
        commentCountLabel.font = UIFont.systemFont(ofSize: 10)
        commentCountLabel.textColor = UIColor.init(hexColor: "a1a1a1")
        
        return commentCountLabel
    }()

}
