//
//  RecordsDetailTableViewCell.swift
//  WYP
//
//  Created by ShuYan Feng on 2017/5/12.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

class RecordsDetailTableViewCell: UITableViewCell {

    // MARK: - life cycle
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        viewConfig()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - private method
    func viewConfig() {
        contentView.addSubview(headerImageView)
        contentView.addSubview(nickNameLablel)
        contentView.addSubview(contentLabel)
        contentView.addSubview(timeLabel)
    }
    func setupUIFrame(recordFrame: RecordsDetailFrameModel) {
        headerImageView.frame = recordFrame.userImageF!
        nickNameLablel.frame = recordFrame.nickNameF!
        contentLabel.frame = recordFrame.contentF!
        timeLabel.frame = recordFrame.timeF!
    }
    
    public var recordDetailFrame: RecordsDetailFrameModel? {
        willSet {
            let imageUrl = URL(string: newValue?.recordModel?.userImage ?? "")
            headerImageView.kf.setImage(with: imageUrl)
            nickNameLablel.text = newValue?.recordModel?.userNickName ?? ""
            contentLabel.text = newValue?.recordModel?.content ?? ""
            timeLabel.text = String().timeStampToString(timeStamp: newValue?.recordModel?.createTime ?? "0")
            
            setupUIFrame(recordFrame: newValue!)
        }
    }

    // MARK: - seter and getter
    lazy var headerImageView: UIImageView = {
        let headImgView = UIImageView()
        headImgView.backgroundColor = UIColor.lightGray
        headImgView.layer.cornerRadius = 18.0
        headImgView.layer.masksToBounds = true
        return headImgView
    }()
    // 昵称
    lazy var nickNameLablel: UILabel = {
        let nickNameLablel = UILabel()
        nickNameLablel.textColor = UIColor.init(hexColor: "#507bab")
        nickNameLablel.textAlignment = .center
        nickNameLablel.font = UIFont.systemFont(ofSize: 11)
        
        return nickNameLablel
    }()
    // 内容
    lazy var contentLabel: UILabel = {
        let contentLabel = UILabel()
        contentLabel.numberOfLines = 0
        contentLabel.font = UIFont.systemFont(ofSize: 14)
        
        return contentLabel
    }()
    // 时间
    lazy var timeLabel: UILabel = {
        let timeLabel = UILabel()
        timeLabel.font = UIFont.systemFont(ofSize: 10)
        timeLabel.textColor = UIColor.init(hexColor: "a1a1a1")
        timeLabel.textAlignment = .right
        
        return timeLabel
    }()
}
