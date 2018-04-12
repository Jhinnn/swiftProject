//
//  VideoInfoTableViewCell.swift
//  InfoView
//
//  Created by ShuYan Feng on 2017/3/16.
//  Copyright © 2017年 ShuYan Feng. All rights reserved.
//

import UIKit

class TalkVideoInfoTableViewCell: UITableViewCell {
    
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
        contentView.addSubview(infoTitleLabel)
        //        contentView.addSubview(infoSourceLabel)
        contentView.addSubview(infoImageView)
        //        infoImageView.addSubview(playImageView)
        //        infoImageView.addSubview(infoLabel)
        
        //        contentView.addSubview(adButton)
        //        contentView.addSubview(topButton)
        
        //        contentView.addSubview(infoTimeLabel)
        //        contentView.addSubview(infoLookLabel)
        contentView.addSubview(infoCommentLabel)
        contentView.addSubview(delButton)
        contentView.addSubview(line)
    }
    private func layoutPageSubviews() {
        
        infoTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(contentView).offset(15)
            make.left.equalTo(contentView).offset(13)
            make.right.equalTo(contentView).offset(-13)
        }
        
        infoImageView.snp.makeConstraints { (make) in
            make.top.equalTo(infoTitleLabel.snp.bottom).offset(12)
            make.left.equalTo(contentView).offset(13)
            make.right.equalTo(contentView).offset(-13)
            make.height.equalTo(194 * width_height_ratio)
        }
        
        
        infoCommentLabel.snp.makeConstraints { (make) in
            make.left.equalTo(infoImageView.snp.left)
            make.top.equalTo(infoImageView.snp.bottom).offset(10)
            make.height.equalTo(10)
        }
        
        
        delButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(infoCommentLabel.snp.centerY)
            make.right.equalTo(infoTitleLabel)
            make.width.equalTo(20)
            make.height.equalTo(14)
        }
        
        
        
        line.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(13)
            make.right.equalTo(contentView).offset(-13)
            make.bottom.equalTo(contentView)
            make.height.equalTo(0.8)
        }
    }
    
    
    //MARK: - setter and getter
    lazy var infoTitleLabel: UILabel = {
        let infoTitleLabel = UILabel()
        infoTitleLabel.numberOfLines = 2
        infoTitleLabel.font = UIFont.systemFont(ofSize: 16)
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
        //        playImageView.image = UIImage(named: "info_play_button_normal_iPhone")
        return playImageView
    }()
    lazy var infoLabel: UILabel = {
        let infoLabel = UILabel()
        infoLabel.alpha = 0.7
        infoLabel.backgroundColor = UIColor.clear
        infoLabel.textColor = UIColor.white
        infoLabel.font = UIFont.systemFont(ofSize: 12)
        infoLabel.textAlignment = .center
        infoLabel.layer.cornerRadius = 5.0
        infoLabel.layer.masksToBounds = true
        return infoLabel
    }()
    lazy var infoSourceLabel: UILabel = {
        let infoSourceLabel = UILabel()
        infoSourceLabel.text = "凤凰娱乐"
        infoSourceLabel.backgroundColor = UIColor.init(hexColor: "666666")
        infoSourceLabel.font = UIFont.systemFont(ofSize: 10)
        infoSourceLabel.layer.masksToBounds = true
        infoSourceLabel.layer.cornerRadius = 9
        infoSourceLabel.textAlignment = NSTextAlignment.center
        infoSourceLabel.textColor = UIColor.white
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
        infoCommentLabel.font = UIFont.systemFont(ofSize: 13)
        infoCommentLabel.textColor = UIColor.init(hexColor: "999999")
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
    
    //删除按钮
    lazy var delButton: UIButton = {
        let delButton = UIButton(type: .custom)
        delButton.setImage(UIImage(named: "topic_icon_disincline_normal"), for: .normal)
        return delButton
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
            if newValue?.topic == "13" {
                infoSourceLabel.text = "演出文化"
            }else if newValue?.topic == "14" {
                infoSourceLabel.text = "旅游文化"
            }else if newValue?.topic == "15" {
                infoSourceLabel.text = "体育文化"
            }else if newValue?.topic == "16" {
                infoSourceLabel.text = "电影文化"
            }else if newValue?.topic == "17" {
                infoSourceLabel.text = "会展文化"
            }else if newValue?.topic == "18" {
                infoSourceLabel.text = "饮食文化"
            }else {
                infoSourceLabel.text = "演出文化"
            }
            //            infoSourceLabel.text = newValue?.infoSource ?? "未知来源"
            infoTimeLabel.text = newValue?.infoTime?.getTimeString()
            //            infoLookLabel.text = String.init(format: "%@人回答", newValue?.infoLook ?? "0")
            infoCommentLabel.text = String.init(format: "%@回答", newValue?.infoComment ?? "0")
            let imageUrl = URL(string: newValue?.infoImageArr?[0] ?? "")
            infoImageView.kf.setImage(with: imageUrl)
            
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
                        infoLabel.text = String.init(format: "00:%d", newValue?.duration ?? 00)
                    } else if (newValue?.duration)! > 60 {
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
    
    //数据模型
    var mineTopicsModel: MineTopicsModel? {
        willSet {
            infoTitleLabel.text = newValue?.title
            
            infoSourceLabel.text = newValue?.category
            infoTimeLabel.text = newValue?.timestamp?.getTimeString()
            infoCommentLabel.text = String.init(format: "%@回答", newValue?.commentCount ?? "0")
            let imageUrl1 = URL(string: newValue?.cover_url?[0] ?? "")
            
            infoImageView.kf.setImage(with: imageUrl1)
            
            hotImageView.isHidden = true
            
        }
    }
    
    
    //数据模型
    var topicsModel: TopicsModel? {
        willSet {
            infoTitleLabel.text = newValue?.content ?? ""
            
            infoSourceLabel.text = newValue?.category
            infoTimeLabel.text = newValue?.timestamp?.getTimeString()
            infoCommentLabel.text = String.init(format: "%@回答", newValue?.commentCount ?? "0")
            
            hotImageView.isHidden = true
        }
    }
    
    var synTopicModel: SynTopicModel? {
        willSet {
            infoLabel.text = newValue?.title ?? ""
            if newValue?.topic == "13" {
                infoSourceLabel.text = "演出文化"
            }else if newValue?.topic == "14" {
                infoSourceLabel.text = "旅游文化"
            }else if newValue?.topic == "15" {
                infoSourceLabel.text = "体育文化"
            }else if newValue?.topic == "16" {
                infoSourceLabel.text = "电影文化"
            }else if newValue?.topic == "17" {
                infoSourceLabel.text = "会展文化"
            }else if newValue?.topic == "18" {
                infoSourceLabel.text = "饮食文化"
            }else {
                infoSourceLabel.text = "演出文化"
            }
            
            let imageUrl = URL(string: newValue?.cover_url?[0] ?? "")
            infoImageView.kf.setImage(with: imageUrl)
            
            infoCommentLabel.text = String.init(format: "%@人回答", newValue?.comment ?? "0")
            
            infoTimeLabel.text = Int((newValue?.create_time)!)?.getTimeString()
        }
    }
}

