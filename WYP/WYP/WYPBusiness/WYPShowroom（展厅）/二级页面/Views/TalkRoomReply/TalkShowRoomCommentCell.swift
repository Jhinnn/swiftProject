//
//  ShowRoomCommentCell.swift
//  WYP
//
//  Created by ShuYan Feng on 2017/5/25.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

protocol TalkShowRoomCommentCellDelegate: NSObjectProtocol {
    func commentReplyStarDidSelected(sender: UIButton, comments: CommentModel)
    func commentReplyButtonDidSelected(sender: UIButton)
    func commentFollowButtonDidSelected(sender: UIButton, comments: CommentModel)
}

class TalkShowRoomCommentCell: UITableViewCell {

    weak var delegate: TalkShowRoomCommentCellDelegate?
    
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
        contentView.addSubview(isFollowButton)
        contentView.addSubview(starCountButton)
        contentView.addSubview(replyCountLabel)
        contentView.addSubview(replyButton)
    }
    
    func setupUIFrame(replyFrame: TalkRoomCommentFrameModel) {
        headImgView.frame = (replyFrame.headImgUrlF)!
        nickNameLablel.frame = (replyFrame.nickNameF)!
        contentLabel.frame = (replyFrame.contentF)!
        timeLabel.frame = (replyFrame.timeF)!
        isFollowButton.frame = (replyFrame.followF)!
        starCountButton.frame = (replyFrame.starCountF)!
//        replyCountLabel.frame = (replyFrame.replyCountF)!
//        replyButton.frame = (replyFrame.replyButtonF)!
    }
    
    // MARK: - event response
    func clickStarButton(sender: UIButton) {
        delegate?.commentReplyStarDidSelected(sender: sender, comments: (commentFrame?.comment)!)
    }
    
    func clickReplyButton(sender: UIButton) {
        delegate?.commentReplyButtonDidSelected(sender: sender)
    }
    
    func clickFollowButton(sender: UIButton) {
        delegate?.commentFollowButtonDidSelected(sender: sender, comments: (commentFrame?.comment)!)
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
        nickNameLablel.textColor = UIColor.init(hexColor: "898989")
        nickNameLablel.font = UIFont.systemFont(ofSize: 14)
        
        return nickNameLablel
    }()
    
    // 内容
    lazy var contentLabel: UILabel = {
        let contentLabel = UILabel()
        contentLabel.font = UIFont.systemFont(ofSize: 14)
        contentLabel.numberOfLines = 0
        contentLabel.textColor = UIColor.init(hexColor: "333333")
        return contentLabel
    }()
    
    // 关注
    lazy var isFollowButton: UIButton = {
        let followButton = UIButton()
        followButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        followButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.right
        followButton.addTarget(self, action: #selector(clickFollowButton(sender:)), for: .touchUpInside)
        return followButton
    }()
    
    // 时间
    lazy var timeLabel: UILabel = {
        let timeLabel = UILabel()
        timeLabel.font = UIFont.systemFont(ofSize: 12)
        timeLabel.textAlignment = NSTextAlignment.right
        timeLabel.textColor = UIColor.init(hexColor: "BDBDBD")
        return timeLabel
    }()
    
    // 点赞
    lazy var starCountButton: UIButton = {
        let starCountButton = UIButton(type: .custom)
        starCountButton.setImage(UIImage(named: "common_grayStar_button_normal_iPhone"), for: .normal)
        starCountButton.setImage(UIImage(named: "common_zan_button_selected_iPhone"), for: .selected)
        starCountButton.setTitleColor(UIColor.init(hexColor: "999999"), for: .normal)
        starCountButton.titleLabel?.font = UIFont.systemFont(ofSize: 11)
        starCountButton.addTarget(self, action: #selector(clickStarButton(sender:)), for: .touchUpInside)
        return starCountButton
    }()
    
    // 回复
    lazy var replyCountLabel: UILabel = {
        let replyCountLabel = UILabel()
        replyCountLabel.text = "回复数：5"
        replyCountLabel.font = UIFont.systemFont(ofSize: 10)
        replyCountLabel.textColor = UIColor.init(hexColor: "afafaf")
        return replyCountLabel
    }()
    
    // 回复按钮
    lazy var replyButton: UIButton = {
        let replyButton = UIButton()
        replyButton.setTitle("回复", for: .normal)
        replyButton.setTitleColor(UIColor.init(hexColor: "afafaf"), for: .normal)
        replyButton.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        replyButton.addTarget(self, action: #selector(clickReplyButton(sender:)), for: .touchUpInside)
        return replyButton
    }()
    
    public var commentFrame: TalkRoomCommentFrameModel? {
        willSet {
            
            let imageUrl = URL(string: newValue?.comment.userPhoto ?? "")
            headImgView.kf.setImage(with: imageUrl, for: .normal)
            nickNameLablel.text = newValue?.comment.nickName ?? ""
            
            if newValue?.comment.is_follow == 0 {  //未关注
                
                if newValue?.comment.uid == AppInfo.shared.user?.userId {
                    isFollowButton.isHidden = true
                }else {
                    isFollowButton.isHidden = false
                    isFollowButton.setTitle("关注", for: .normal)
                    isFollowButton.setTitleColor(UIColor.init(hexColor: "DC3A20"), for: .normal)
                }
            }else {
                isFollowButton.isHidden = false
                isFollowButton.setTitle("已关注", for: .normal)
                isFollowButton.setTitleColor(UIColor.init(hexColor: "898989"), for: .normal)
            }
            contentLabel.text = newValue?.comment.content ?? ""
            timeLabel.text = Int(newValue!.comment!.createTime!)?.getTimeString()
            replyCountLabel.text = "回复数：\(newValue?.comment.replyCount ?? 0)"
            starCountButton.setTitle(" \(newValue?.comment.zanNumber ?? "0")", for: .normal)
            if newValue?.comment.isStar == "1" {
                starCountButton.isSelected = true
                starCountButton.setImage(UIImage(named: "common_zan_button_selected_iPhone"), for: .selected)
            } else {
                starCountButton.isSelected = false
            }
            
            setupUIFrame(replyFrame: newValue!)
        }
    }

}
