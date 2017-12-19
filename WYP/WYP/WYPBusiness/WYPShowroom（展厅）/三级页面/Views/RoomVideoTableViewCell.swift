//
//  RoomVideoTableViewCell.swift
//  WYP
//
//  Created by ShuYan Feng on 2017/4/10.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

class RoomVideoTableViewCell: UITableViewCell {

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
        contentView.addSubview(videoImageView)
        contentView.addSubview(videoTitleLabel)
    }
    func layoutPageSubviews() {
        videoImageView.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(13)
            make.centerY.equalTo(contentView)
            make.size.equalTo(CGSize(width: 140.5, height: 90.5))
        }
        videoTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(videoImageView.snp.right).offset(21.5)
            make.top.equalTo(contentView).offset(27.5)
            make.right.equalTo(contentView).offset(-13)
        }
    }
    
    // MARK: - setter and getter
    lazy var videoImageView: UIImageView = {
        let videoImageView = UIImageView()
        videoImageView.backgroundColor = UIColor.init(hexColor: "a1a1a1")
        return videoImageView
    }()
    lazy var videoTitleLabel: UILabel = {
        let videoTitleLabel = UILabel()
        videoTitleLabel.textColor = UIColor.init(hexColor: "676767")
        videoTitleLabel.font = UIFont.systemFont(ofSize: 15)
        videoTitleLabel.numberOfLines = 0
        videoTitleLabel.text = "《速度与激情》定档预告范迪塞尔背弃家庭"
        return videoTitleLabel
    }()
    
    // 数据
    var videoPlay: VideoInfoModel? {
        willSet {
            let imageUrl = URL(string: newValue?.videoPic ?? "")
            self.videoImageView.kf.setImage(with: imageUrl)
            self.videoTitleLabel.text = newValue?.videoTitle ?? ""
        }
    }
}
