//
//  ShowroomCell.swift
//  WYP
//
//  Created by 你个LB on 2017/3/17.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

class ShowroomCell: UITableViewCell {

    var isTopWidth: CGFloat = 26
    
    //MARK: - life cycle
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        viewConfig()
        layoutPageSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - private method
    func viewConfig() {
        contentView.addSubview(topButton)
        contentView.addSubview(showRoomTitleLabel)
        contentView.addSubview(hotImageView)
        contentView.addSubview(showRoomImageView)
        showRoomImageView.addSubview(roomTypeLabel)
        contentView.addSubview(roomCertificationImageView)
        contentView.addSubview(companyCertificationImageView)
        contentView.addSubview(showRoomGroupImageView)
        contentView.addSubview(showRoomGroupNumberlabel)
        contentView.addSubview(showRoomCommentImageView)
        contentView.addSubview(showRoomCommentLabel)
        contentView.addSubview(showRoomAttentionImageView)
        contentView.addSubview(showRoomAttentionLabel)
        contentView.addSubview(showRoomFansImageView)
        contentView.addSubview(showRoomFansLabel)
    }
    func layoutPageSubviews() {
        topButton.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(13)
            make.top.equalTo(contentView).offset(19.5)
            make.size.equalTo(CGSize(width: isTopWidth, height: 13))
        }
        showRoomTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(topButton.snp.right).offset(5)
            make.top.equalTo(contentView).offset(18)
            make.height.equalTo(17)
            make.right.equalTo(contentView).offset(-36.5)
        }
        hotImageView.snp.makeConstraints { (make) in
            make.top.equalTo(contentView).offset(19.5)
            make.right.equalTo(contentView).offset(-13)
            make.width.equalTo(23.5)
            make.height.equalTo(14)
        }
        showRoomImageView.snp.makeConstraints { (make) in
            make.left.equalTo(contentView)
            make.top.equalTo(showRoomTitleLabel.snp.bottom).offset(10)
            make.right.equalTo(contentView)
            make.height.equalTo(225 * width_height_ratio)
        }
        roomTypeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(showRoomImageView)
            make.left.equalTo(showRoomImageView).offset(13)
            make.size.equalTo(CGSize(width: 52.5, height: 17))
        }
        companyCertificationImageView.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(13)
            make.top.equalTo(showRoomImageView.snp.bottom).offset(10.5)
            make.size.equalTo(CGSize(width: 50, height: 17))
        }
        roomCertificationImageView.snp.makeConstraints { (make) in
            make.left.equalTo(companyCertificationImageView.snp.right).offset(9.5)
            make.top.equalTo(showRoomImageView.snp.bottom).offset(10.5)
            make.size.equalTo(CGSize(width: 50, height: 17))
        }
        showRoomGroupImageView.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(13)
            make.top.equalTo(companyCertificationImageView.snp.bottom).offset(9)
            make.width.equalTo(15)
        }
        showRoomGroupNumberlabel.snp.makeConstraints { (make) in
            make.left.equalTo(showRoomGroupImageView.snp.right).offset(3)
            make.top.equalTo(companyCertificationImageView.snp.bottom).offset(9)
        }
        showRoomCommentImageView.snp.makeConstraints { (make) in
            make.left.equalTo(showRoomGroupNumberlabel.snp.right).offset(10)
            make.top.equalTo(companyCertificationImageView.snp.bottom).offset(9)
            make.width.equalTo(15)
        }
        showRoomCommentLabel.snp.makeConstraints { (make) in
            make.left.equalTo(showRoomCommentImageView.snp.right).offset(3)
            make.top.equalTo(companyCertificationImageView.snp.bottom).offset(9)
        }
        showRoomAttentionImageView.snp.makeConstraints { (make) in
            make.left.equalTo(showRoomCommentLabel.snp.right).offset(10)
            make.top.equalTo(companyCertificationImageView.snp.bottom).offset(9)
            make.width.equalTo(15)
        }
        showRoomAttentionLabel.snp.makeConstraints { (make) in
            make.left.equalTo(showRoomAttentionImageView.snp.right).offset(3)
            make.top.equalTo(companyCertificationImageView.snp.bottom).offset(9)
        }
        showRoomFansImageView.snp.makeConstraints { (make) in
            make.left.equalTo(showRoomAttentionLabel.snp.right).offset(10)
            make.top.equalTo(companyCertificationImageView.snp.bottom).offset(9)
            make.width.equalTo(15)
        }
        showRoomFansLabel.snp.makeConstraints { (make) in
            make.left.equalTo(showRoomFansImageView.snp.right).offset(3)
            make.top.equalTo(companyCertificationImageView.snp.bottom).offset(9)
        }
    }
    
    //MARK: - setter and gatter
    lazy var showRoomImageView: UIImageView = {
        let showRoomImageView = UIImageView()
        showRoomImageView.contentMode = .scaleAspectFill
        showRoomImageView.layer.masksToBounds = true
        showRoomImageView.backgroundColor = UIColor.init(hexColor: "f1f2f4")
        return showRoomImageView
    }()
    lazy var roomTypeLabel: UILabel = {
        let roomTypeLabel = UILabel()
        roomTypeLabel.textColor = UIColor.white
        roomTypeLabel.textAlignment = .center
        roomTypeLabel.font = UIFont.systemFont(ofSize: 9)
        roomTypeLabel.backgroundColor = UIColor.black
        roomTypeLabel.alpha = 0.5
        return roomTypeLabel
    }()
    lazy var topButton: UIImageView = {
        let topButton = UIImageView()
        topButton.image = UIImage(named: "common_top_icon_normal_iPhone")
        return topButton
    }()
    lazy var showRoomTitleLabel: UILabel = {
        let showRoomTitleLabel = UILabel()
        showRoomTitleLabel.font = UIFont.systemFont(ofSize: 15)
        return showRoomTitleLabel
    }()
    lazy var roomCertificationImageView: UIImageView = {
        let roomCertification = UIImageView()
        roomCertification.image = UIImage(named: "showRoom_roomCertification_button_normal_iPhone")
        roomCertification.contentMode = .scaleAspectFit
        return roomCertification
    }()
    lazy var companyCertificationImageView: UIImageView = {
        let companyImageView = UIImageView()
        companyImageView.image = UIImage(named: "showRoom_company_button_normal_iPhone")
        companyImageView.contentMode = .scaleAspectFit
        return companyImageView
    }()
    lazy var showRoomGroupImageView: UIImageView = {
        let showRoomGroupImageView = UIImageView()
        showRoomGroupImageView.image = UIImage(named: "find_icon_cluster_normal")
        showRoomGroupImageView.contentMode = .scaleAspectFit
        return showRoomGroupImageView
    }()
    lazy var showRoomGroupNumberlabel: UILabel = {
        let showRoomGroupNumberlabel = UILabel()
        showRoomGroupNumberlabel.font = grayTextFont
        showRoomGroupNumberlabel.textColor = UIColor.viewGrayColor
        return showRoomGroupNumberlabel
    }()
    lazy var showRoomCommentImageView: UIImageView = {
        let showRoomCommentImageView = UIImageView()
        showRoomCommentImageView.image = UIImage(named: "find_icon_information_normal")
        showRoomCommentImageView.contentMode = .scaleAspectFit
        return showRoomCommentImageView
    }()
    lazy var showRoomCommentLabel: UILabel = {
        let showRoomCommentLabel = UILabel()
        showRoomCommentLabel.font = grayTextFont
        showRoomCommentLabel.textColor = UIColor.viewGrayColor
        return showRoomCommentLabel
    }()
    lazy var showRoomAttentionImageView: UIImageView = {
        let showRoomAttentionImageView = UIImageView()
        showRoomAttentionImageView.image = UIImage(named: "find_icon_follow_normal")
        showRoomAttentionImageView.contentMode = .scaleAspectFit
        return showRoomAttentionImageView
    }()
    lazy var showRoomAttentionLabel: UILabel = {
        let showRoomAttentionLabel = UILabel()
        showRoomAttentionLabel.font = grayTextFont
        showRoomAttentionLabel.textColor = UIColor.viewGrayColor
        return showRoomAttentionLabel
    }()
    lazy var showRoomFansImageView: UIImageView = {
        let showRoomFansImageView = UIImageView()
        showRoomFansImageView.image = UIImage(named: "find_icon_follower_normal")
        showRoomFansImageView.contentMode = .scaleAspectFit
        return showRoomFansImageView
    }()
    lazy var showRoomFansLabel: UILabel = {
        let showRoomFansLabel = UILabel()
        showRoomFansLabel.font = grayTextFont
        showRoomFansLabel.textColor = UIColor.viewGrayColor
        return showRoomFansLabel
    }()
    lazy var hotImageView: UIImageView = {
        let hotImageView = UIImageView()
        hotImageView.image = UIImage(named: "common_hot_icon_normal_iPhone")
        return hotImageView
    }()
    
    // 数据
    var showRoomModel: ShowroomModel? {
        willSet {
            let imageUrl = URL(string: newValue?.background ?? "" )
            showRoomImageView.kf.setImage(with: imageUrl)
            showRoomGroupNumberlabel.text = String.init(format: "群组(%@)", newValue!.groupCount!)
            showRoomCommentLabel.text = String.init(format: "%@评论", newValue!.contentCount!)
            showRoomAttentionLabel.text = String.init(format: "%@关注", newValue!.groupFollow!)
            showRoomFansLabel.text = String.init(format: "%@粉丝", newValue!.fensiCount!)
            roomTypeLabel.text = newValue!.groupTypeName
            showRoomTitleLabel.text = newValue!.title
            // 置顶
            if newValue?.isTop == "0" {
                topButton.snp.updateConstraints({ (make) in
                    make.width.equalTo(0)
                })
//                showRoomTitleLabel.snp.makeConstraints({ (make) in
//                    make.left.equalTo(contentView).offset(13)
//                })
            } else {
                topButton.snp.updateConstraints({ (make) in
                    make.width.equalTo(isTopWidth)
                })
//                showRoomTitleLabel.snp.makeConstraints({ (make) in
//                    make.left.equalTo(topButton.snp.right).offset(5)
//                })
            }
            // 热度
            if newValue?.isHot == "0" {
                hotImageView.isHidden = true
            } else {
                hotImageView.isHidden = false
            }
            if newValue?.isFree == "0" {
                companyCertificationImageView.image = UIImage(named: "showRoom_noAttention_button_normal_iPhone")
                roomCertificationImageView.isHidden = true
            } else if newValue?.isFree == "1" {
                roomCertificationImageView.isHidden = false
                // 项目认证
                roomCertificationImageView.image = UIImage(named: "showRoom_roomCertification_button_normal_iPhone")
                // 企业认证
                companyCertificationImageView.image = UIImage(named: "showRoom_company_button_normal_iPhone")
            }
        }
    }
}
