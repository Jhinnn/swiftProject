//
//  OnePictureTableViewCell.swift
//  InfoView
//
//  Created by ShuYan Feng on 2017/3/16.
//  Copyright © 2017年 ShuYan Feng. All rights reserved.
//

import UIKit

class TalkOnePictureTableViewCell: UITableViewCell {
    
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
        contentView.addSubview(infoLabel)
        contentView.addSubview(hotImageView)
        contentView.addSubview(infoSourceLabel)
        contentView.addSubview(infoTimeLabel)
        contentView.addSubview(infoCommentLabel)
        contentView.addSubview(infoLookLabel)
        contentView.addSubview(adButton)
        contentView.addSubview(topButton)
        contentView.addSubview(hotImageView)
        contentView.addSubview(line)
        line.isHidden = true
        hotImageView.isHidden = true
    }
    private func layoutPageSubviews() {
        infoImageView.snp.makeConstraints { (make) in
            make.top.equalTo(contentView).offset(9.5)
            make.right.equalTo(contentView).offset(-13)
            make.width.equalTo(114 * width_height_ratio)
            make.height.equalTo(74 * width_height_ratio)
        }
        infoLabel.snp.makeConstraints { (make) in
            make.top.equalTo(infoImageView.snp.top)
            make.left.equalTo(contentView).offset(13)
            make.right.equalTo(infoImageView.snp.left).offset(-36.5)
        }
        hotImageView.snp.makeConstraints { (make) in
            make.top.equalTo(infoImageView.snp.top).offset(2)
            make.left.equalTo(infoLabel.snp.right).offset(5)
            make.width.equalTo(23.5)
            make.height.equalTo(14)
        }
        adButton.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(13)
            make.bottom.equalTo(contentView).offset(-20 * width_height_ratio)
            make.size.equalTo(CGSize(width: 20, height: 12))
        }
        topButton.snp.makeConstraints { (make) in
            make.left.equalTo(adButton.snp.right).offset(3)
            make.bottom.equalTo(contentView).offset(-20 * width_height_ratio)
            make.size.equalTo(CGSize(width: 20, height: 12))
        }
        infoSourceLabel.snp.makeConstraints { (make) in
            make.left.equalTo(infoLabel.snp.left)
            make.bottom.equalTo(contentView).offset(-13)
            make.height.equalTo(18)
            make.width.equalTo(50)
        }
        infoTimeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(infoSourceLabel.snp.right).offset(8.5)
            make.bottom.equalTo(contentView).offset(-17)
            make.height.equalTo(10)
        }
        infoLookLabel.snp.makeConstraints { (make) in
            make.left.equalTo(infoSourceLabel.snp.right).offset(10)
            make.bottom.equalTo(contentView).offset(-20 * width_height_ratio)
            make.height.equalTo(10)
        }
        infoCommentLabel.snp.makeConstraints { (make) in
            make.left.equalTo(infoTimeLabel.snp.right).offset(4)
            make.centerY.equalTo(infoTimeLabel.snp.centerY)
            make.height.equalTo(10)
        }
        line.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(15)
            make.right.equalTo(contentView).offset(-15)
            make.bottom.equalTo(contentView)
            make.height.equalTo(0.5)
        }
        
    }
    
    //MARK: - setter and getter
    lazy var infoImageView: UIImageView = {
        let infoImageView = UIImageView()
        infoImageView.contentMode = .scaleAspectFill
        infoImageView.layer.masksToBounds = true
        infoImageView.backgroundColor = UIColor.init(hexColor: "f1f2f4")
        
        return infoImageView
    }()
    lazy var infoLabel: UILabel = {
        let infoLabel = UILabel()
        infoLabel.numberOfLines = 2
        infoLabel.font = UIFont.systemFont(ofSize: 15)
        infoLabel.textColor = UIColor.init(hexColor: "#333333")
        return infoLabel
    }()
    lazy var infoSourceLabel: UILabel = {
        let infoSourceLabel = UILabel()
        infoSourceLabel.font = grayTextFont
        infoSourceLabel.font = UIFont.systemFont(ofSize: 10)
        infoSourceLabel.backgroundColor = UIColor.init(hexColor: "666666")
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
    lazy var infoCommentLabel: UILabel = {
        let infoCommentLabel = UILabel()
        infoCommentLabel.textAlignment = .right
        infoCommentLabel.font = grayTextFont
        infoCommentLabel.textColor = UIColor.init(hexColor: "507BAB")
        return infoCommentLabel
    }()
    lazy var infoLookLabel: UILabel = {
        let infoLookLabel = UILabel()
        infoLookLabel.textAlignment = .right
        infoLookLabel.font = grayTextFont
        infoLookLabel.textColor = UIColor.viewGrayColor
        return infoLookLabel
    }()
    
    lazy var adButton: UIButton = {
        let adButton = UIButton(type: .custom)
//        adButton.setImage(UIImage(named: "common_ad_icon_normal_iPhone"), for: .normal)
        return adButton
    }()
    
    lazy var topButton: UIButton = {
        let adButton = UIButton(type: .custom)
//        adButton.setImage(UIImage(named: "common_top_icon_normal_iPhone"), for: .normal)
        return adButton
    }()
    lazy var hotImageView: UIImageView = {
        let hotImageView = UIImageView()
//        hotImageView.image = UIImage(named: "common_hot_icon_normal_iPhone")
        return hotImageView
    }()
    lazy var line: UIView = {
        let line = UIView()
        line.backgroundColor = UIColor.init(hexColor: "e4e4e4")
        return line
    }()
    
    // 数据模型
    var infoModel: InfoModel? {
        willSet {
            
           
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
            
            
            infoLabel.text = newValue?.infoTitle ?? ""
            
          
//            infoTimeLabel.text = newValue?.infoTime?.getTimeString()

            
            infoTimeLabel.text = newValue?.infoTime?.getTimeString()
            infoCommentLabel.text = String.init(format: "%@个回答", newValue?.infoComment ?? "0")
//            infoLookLabel.text = String.init(format: "%@浏览", newValue?.infoLook ?? "0")
            let imageUrl = URL(string: newValue?.infoImageArr?[0] ?? "")
            infoImageView.kf.setImage(with: imageUrl)
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
            if newValue?.isHot == "0" {
                hotImageView.isHidden = true
            } else {
                hotImageView.isHidden = false
            }
        }
        
        
    }
    
    
    //数据模型
    var mineTopicsModel: MineTopicsModel? {
        willSet {
            infoLabel.text = newValue?.content ?? ""
            
            infoSourceLabel.text = newValue?.category
            infoTimeLabel.text = newValue?.timestamp?.getTimeString()
            infoCommentLabel.text = String.init(format: "%@人回答", newValue?.commentCount ?? "0")
            let imageUrl1 = URL(string: newValue?.cover_url?[0] ?? "")
           
            infoImageView.kf.setImage(with: imageUrl1)
           
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
