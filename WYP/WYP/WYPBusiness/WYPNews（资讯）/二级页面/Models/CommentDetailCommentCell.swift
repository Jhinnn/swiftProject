//
//  ShowRoomCommentCell.swift
//  WYP
//
//  Created by ShuYan Feng on 2017/5/25.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

protocol CommentDetailCommentCellDelegate: NSObjectProtocol {
    func commentReplyStarDidSelected(sender: UIButton, comments: CommentModel)
    func commentReplyButtonDidSelected(sender: UIButton, comments: CommentModel)
    func commentPushButtonDidSelected(sender: UIButton, comments: CommentModel)
}

class CommentDetailCommentCell: UITableViewCell {

    weak var delegate: CommentDetailCommentCellDelegate?
    
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
        contentView.addSubview(replyCountLabel)
        contentView.addSubview(replyButton)
    }
    
    func setupUIFrame(replyFrame: CommentDetailFrameModel) {
        headImgView.frame = (replyFrame.headImgUrlF)!
        nickNameLablel.frame = (replyFrame.nickNameF)!
        contentLabel.frame = (replyFrame.contentF)!
        timeLabel.frame = (replyFrame.timeF)!
        starCountButton.frame = (replyFrame.starCountF)!
        replyCountLabel.frame = (replyFrame.replyCountF)!
        replyButton.frame = (replyFrame.replyButtonF)!
    }
    
    // MARK: - event response
    func clickStarButton(sender: UIButton) {
        delegate?.commentReplyStarDidSelected(sender: sender, comments: (commentFrame?.comment)!)
    }
    
    func clickDeleteButton(sender: UIButton) {
        delegate?.commentReplyButtonDidSelected(sender: sender,comments: (commentFrame?.comment)!)
    }
    
    func clickClickButton(sender: UIButton) {
        delegate?.commentPushButtonDidSelected(sender: sender, comments: (commentFrame?.comment)!)
    }
    
    // MARK: - setter and getter
    // 头像
    lazy var headImgView: UIButton = {
        let headImgView = UIButton()
        headImgView.backgroundColor = UIColor.init(hexColor: "f1f2f4")
        headImgView.layer.masksToBounds = true
        headImgView.layer.cornerRadius = 19.5
        headImgView.addTarget(self, action: #selector(clickClickButton(sender:)), for: .touchUpInside)
        return headImgView
    }()
    
    // 昵称
    lazy var nickNameLablel: UILabel = {
        let nickNameLablel = UILabel()
        nickNameLablel.textColor = UIColor.init(hexColor: "#507bab")
        nickNameLablel.font = UIFont.systemFont(ofSize: 14)
        
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
        timeLabel.font = UIFont.systemFont(ofSize: 12)
        timeLabel.textColor = UIColor.init(hexColor: "afafaf")
        return timeLabel
    }()
    
    // 点赞
    lazy var starCountButton: UIButton = {
        let starCountButton = UIButton(type: .custom)
        starCountButton.setImage(UIImage(named: "sq_icon_dz_normal"), for: .normal)
        starCountButton.setImage(UIImage(named: "sq_icon_dz_select"), for: .selected)
        starCountButton.setTitleColor(UIColor.init(red: 194/255.0, green: 192/255.0, blue: 194/255.0, alpha: 1), for: .normal)
        starCountButton.setTitleColor(UIColor.themeColor, for: .selected)
        starCountButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        starCountButton.addTarget(self, action: #selector(clickStarButton(sender:)), for: .touchUpInside)
        return starCountButton
    }()
    
    // 回复
    lazy var replyCountLabel: UILabel = {
        let replyCountLabel = UILabel()
        replyCountLabel.text = ""
        replyCountLabel.font = UIFont.systemFont(ofSize: 12)
        replyCountLabel.textColor = UIColor.init(hexColor: "afafaf")
        return replyCountLabel
    }()
    
    // 回复按钮  //删除按钮
    lazy var replyButton: UIButton = {
        let replyButton = UIButton()
        replyButton.setTitle("删除", for: .normal)
        replyButton.setTitleColor(UIColor.init(hexColor: "afafaf"), for: .normal)
        replyButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
//        replyButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.right
        replyButton.addTarget(self, action: #selector(clickDeleteButton(sender:)), for: .touchUpInside)
        return replyButton
    }()
    
    public var commentFrame: CommentDetailFrameModel? {
        willSet {
            
            let imageUrl = URL(string: newValue?.comment.userPhoto ?? "")
            headImgView.kf.setImage(with: imageUrl, for: .normal)
            nickNameLablel.text = newValue?.comment.nickName ?? ""
            contentLabel.text = newValue?.comment.content ?? ""
            timeLabel.text = Int(newValue!.comment!.createTime!)?.getTimeString()
            
            let str = newValue?.comment.comment_num
            
            if str == "0"  {
                replyCountLabel.text = "回复"
                replyCountLabel.textAlignment = .left
            }else {
                replyCountLabel.text = "\(newValue?.comment.comment_num ?? "")回复"
                replyCountLabel.backgroundColor = UIColor.init(red: 194/255.0, green: 192/255.0, blue: 194/255.0, alpha: 1)
                replyCountLabel.font = UIFont.systemFont(ofSize: 10)
                replyCountLabel.textAlignment = .center
                replyCountLabel.textColor = .white
                replyCountLabel.layer.masksToBounds = true
                replyCountLabel.layer.cornerRadius = 10
            }
            
//            AppInfo.shared.user?.userId
            
            if AppInfo.shared.user?.userId == newValue?.comment.uid {
                replyButton.isHidden = false
            }else {
                replyButton.isHidden = true
            }
            

        
            starCountButton.setTitle(" \(newValue?.comment.zanNumber ?? "0")", for: .normal)
            if newValue?.comment.isStar == "1" {
                starCountButton.isSelected = true
                starCountButton.setImage(UIImage(named: "sq_icon_dz_select"), for: .selected)
            } else {
                starCountButton.isSelected = false
                starCountButton.setTitleColor(UIColor.init(red: 194/255.0, green: 192/255.0, blue: 194/255.0, alpha: 1), for: .normal)
            }
            
            setupUIFrame(replyFrame: newValue!)
        }
    }

}
