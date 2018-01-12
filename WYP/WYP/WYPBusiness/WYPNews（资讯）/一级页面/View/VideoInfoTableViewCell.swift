//
//  VideoInfoTableViewCell.swift
//  InfoView
//
//  Created by ShuYan Feng on 2017/3/16.
//  Copyright © 2017年 ShuYan Feng. All rights reserved.
//

import UIKit

class VideoInfoTableViewCell: UITableViewCell {
    
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
    private func viewConfig() {
        contentView.addSubview(infoImageView)
        infoImageView.addSubview(playImageView)
        infoImageView.addSubview(infoLabel)
        contentView.addSubview(infoTitleLabel)
        contentView.addSubview(adButton)
        contentView.addSubview(topButton)
        contentView.addSubview(infoSourceLabel)
//        contentView.addSubview(infoTimeLabel)
        contentView.addSubview(infoLookLabel)
        contentView.addSubview(infoCommentLabel)
        contentView.addSubview(hotImageView)
        contentView.addSubview(line)
        line.isHidden = true
    }
    private func layoutPageSubviews() {
        
        adButton.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(13)
            make.bottom.equalTo(contentView).offset(-17)
            make.size.equalTo(CGSize(width: 20, height: 12))
        }
        topButton.snp.makeConstraints { (make) in
            make.left.equalTo(adButton.snp.right).offset(3)
            make.bottom.equalTo(contentView).offset(-17)
            make.size.equalTo(CGSize(width: 20, height: 12))
        }
        infoSourceLabel.snp.makeConstraints { (make) in
            make.left.equalTo(topButton.snp.right).offset(2)
            make.bottom.equalTo(contentView).offset(-17)
            make.height.equalTo(10)
        }
//        infoTimeLabel.snp.makeConstraints { (make) in
//            make.left.equalTo(infoSourceLabel.snp.right).offset(22)
//            make.bottom.equalTo(contentView).offset(-17)
//            make.height.equalTo(10)
//        }
        infoCommentLabel.snp.makeConstraints { (make) in
            make.left.equalTo(infoSourceLabel.snp.right).offset(10)
            make.bottom.equalTo(contentView).offset(-17)
            make.height.equalTo(10)
        }
        infoLookLabel.snp.makeConstraints { (make) in
            make.left.equalTo(infoCommentLabel.snp.right).offset(10)
            make.bottom.equalTo(contentView).offset(-17)
            make.height.equalTo(10)
        }
        infoImageView.snp.makeConstraints { (make) in
            make.bottom.equalTo(infoSourceLabel.snp.top).offset(-15)
            make.left.equalTo(contentView).offset(13)
            make.right.equalTo(contentView).offset(-13)
            make.height.equalTo(194 * width_height_ratio)
        }
        playImageView.snp.makeConstraints { (make) in
            make.center.equalTo(infoImageView)
            make.size.equalTo(CGSize(width: 37.5 * width_height_ratio, height: 37.5 * width_height_ratio))
        }
        infoLabel.snp.makeConstraints { (make) in
            make.right.equalTo(infoImageView).offset(-13)
            make.bottom.equalTo(infoImageView).offset(-10)
            make.size.equalTo(CGSize(width: 50, height: 20))
        }
        infoTitleLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(infoImageView.snp.top).offset(-6)
            make.left.equalTo(contentView).offset(13)
            make.right.equalTo(contentView).offset(-36.5)
        }
        hotImageView.snp.makeConstraints { (make) in
            make.bottom.equalTo(infoImageView.snp.top).offset(-6)
            make.right.equalTo(contentView).offset(-13)
            make.width.equalTo(23.5)
            make.height.equalTo(14)
        }
        line.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(15)
            make.right.equalTo(contentView).offset(-15)
            make.bottom.equalTo(contentView)
            make.height.equalTo(0.5)
        }
    }
    
    
    //MARK: - setter and getter
    lazy var infoTitleLabel: UILabel = {
        let infoTitleLabel = UILabel()
        infoTitleLabel.font = UIFont.systemFont(ofSize: 15)
        infoTitleLabel.textColor = UIColor.init(hexColor: "333333")
        return infoTitleLabel
    }()
    lazy var infoImageView: UIImageView = {
        let infoImageView = UIImageView()
        infoImageView.contentMode = .scaleAspectFill
        infoImageView.layer.masksToBounds = true
        infoImageView.backgroundColor = UIColor.init(hexColor: "f1f2f4")
        return infoImageView
    }()
    lazy var playImageView: UIImageView = {
        let playImageView = UIImageView()
        playImageView.image = UIImage(named: "info_play_button_normal_iPhone")
        return playImageView
    }()
    lazy var infoLabel: UILabel = {
        let infoLabel = UILabel()
        infoLabel.alpha = 0.7
        infoLabel.backgroundColor = UIColor.black
        infoLabel.textColor = UIColor.white
        infoLabel.font = UIFont.systemFont(ofSize: 12)
        infoLabel.textAlignment = .center
        infoLabel.layer.cornerRadius = 5.0
        infoLabel.layer.masksToBounds = true
        return infoLabel
    }()
    lazy var infoSourceLabel: UILabel = {
        let infoSourceLabel = UILabel()
        infoSourceLabel.font = grayTextFont
        infoSourceLabel.textColor = UIColor.viewGrayColor
        return infoSourceLabel
    }()
    lazy var infoTimeLabel: UILabel = {
        let infoTimeLabel = UILabel()
        infoTimeLabel.font = grayTextFont
        infoTimeLabel.textColor = UIColor.viewGrayColor
        return infoTimeLabel
    }()
    lazy var infoLookLabel: UILabel = {
        let infoLookLabel = UILabel()
        infoLookLabel.textAlignment = .right
        infoLookLabel.font = grayTextFont
        infoLookLabel.textColor = UIColor.viewGrayColor
        return infoLookLabel
    }()
    lazy var infoCommentLabel: UILabel = {
        let infoCommentLabel = UILabel()
        infoCommentLabel.textAlignment = .right
        infoCommentLabel.font = grayTextFont
        infoCommentLabel.textColor = UIColor.viewGrayColor
        return infoCommentLabel
    }()
    lazy var adButton: UIButton = {
        let adButton = UIButton(type: .custom)
        adButton.setImage(UIImage(named: "common_ad_icon_normal_iPhone"), for: .normal)
        return adButton
    }()
    lazy var topButton: UIButton = {
        let adButton = UIButton(type: .custom)
        adButton.setImage(UIImage(named: "common_top_icon_normal_iPhone"), for: .normal)
        return adButton
    }()
    lazy var hotImageView: UIImageView = {
        let hotImageView = UIImageView()
        hotImageView.image = UIImage(named: "common_hot_icon_normal_iPhone")
        return hotImageView
    }()
    lazy var line: UIView = {
        let line = UIView()
        line.backgroundColor = UIColor.init(hexColor: "e4e4e4")
        return line
    }()
    
    //数据模型
    var infoModel: InfoModel? {
        willSet {
            infoTitleLabel.text = newValue?.infoTitle ?? ""
            infoSourceLabel.text = newValue?.infoSource ?? "未知来源"
//            infoTimeLabel.text = newValue?.infoTime?.getTimeString()
            infoLookLabel.text = String.init(format: "%@人评论", newValue?.infoComment ?? "0")
            infoCommentLabel.text = String.init(format: "%@人浏览", newValue?.infoLook ?? "0")
            if newValue?.infoImageArr?.count != 0 {
                let imageUrl = URL(string: newValue?.infoImageArr?[0] ?? "")
                infoImageView.kf.setImage(with: imageUrl)
            }
            
            
            switch newValue?.infoType ?? 2  {
            case 4:
                var imageUrl: URL?
                if newValue?.photosCover == "" {
                    imageUrl = URL(string: newValue?.infoImageArr?[0] ?? "")
                } else {
                    imageUrl = URL(string: newValue?.photosCover ?? "")
                }
                infoImageView.kf.setImage(with: imageUrl)
                playImageView.isHidden = true
                infoLabel.text = String.init(format: "%d图", newValue?.infoImageArr?.count ?? 0)
                
                break
            case 2:
                let imageUrl = URL(string: newValue?.infoImageArr?[0] ?? "")
                infoImageView.kf.setImage(with: imageUrl)
                if newValue?.duration != nil {
                    if (newValue?.duration)! < 60 {
                        infoLabel.text = String.init(format: "00:%02d", newValue?.duration ?? 00)
                    } else if (newValue?.duration)! >= 60 {
                        infoLabel.text = String.init(format: "%02d:%02d", (newValue?.duration)!/60, (newValue?.duration)!%60)
                    }
                }
                break
            default:
                break
            }
            
            if newValue?.isTop == "1" {
                topButton.snp.updateConstraints({ (make) in
                    make.width.equalTo(20)
                })
            } else {
                topButton.snp.updateConstraints({ (make) in
                    make.width.equalTo(0)
                })
            }
            if newValue?.isAd == "1" {
                adButton.snp.updateConstraints({ (make) in
                    make.width.equalTo(20)
                })
            } else {
                adButton.snp.updateConstraints({ (make) in
                    make.width.equalTo(0)
                })
            }
            if newValue?.isHot == "1" {
                hotImageView.isHidden = false
            } else {
                hotImageView.isHidden = true
            }

        }
    }
}

