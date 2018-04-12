//
//  TravelTableViewCell.swift
//  InfoView
//
//  Created by ShuYan Feng on 2017/3/21.
//  Copyright © 2017年 ShuYan Feng. All rights reserved.
//

import UIKit

class TalkTravelTableViewCell: UITableViewCell {
    
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
    private func viewConfig() {
        contentView.addSubview(travelTitleLabel)
        //        contentView.addSubview(hotImageView)
        //        contentView.addSubview(adButton)
        //        contentView.addSubview(topButton)
        //        contentView.addSubview(infoSourceLabel)
        //        contentView.addSubview(infoTimeLabel)
        //        contentView.addSubview(infoLookLabel)
        contentView.addSubview(infoCommentLabel)
        contentView.addSubview(delButton)
        contentView.addSubview(line)
    }
    private func layoutPageSubviews() {
        travelTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(contentView).offset(15)
            make.left.equalTo(contentView).offset(13)
            make.right.equalTo(contentView).offset(-13)
            
        }
        //        hotImageView.snp.makeConstraints { (make) in
        //            make.top.equalTo(contentView).offset(12)
        //            make.left.equalTo(travelTitleLabel.snp.right).offset(5)
        //            make.width.equalTo(23.5)
        //            make.height.equalTo(14)
        //        }
        //        adButton.snp.makeConstraints { (make) in
        //            make.left.equalTo(contentView).offset(13)
        //            make.bottom.equalTo(contentView).offset(-17)
        //            make.size.equalTo(CGSize(width: 20, height: 12))
        //        }
        //        topButton.snp.makeConstraints { (make) in
        //            make.left.equalTo(adButton.snp.right).offset(3)
        //            make.bottom.equalTo(contentView).offset(-17)
        //            make.size.equalTo(CGSize(width: 20, height: 12))
        //        }
        //        infoSourceLabel.snp.makeConstraints { (make) in
        //            make.left.equalTo(travelTitleLabel.snp.left)
        //            make.bottom.equalTo(contentView).offset(-13)
        //            make.height.equalTo(18)
        //            make.width.equalTo(50)
        //        }
        //        infoTimeLabel.snp.makeConstraints { (make) in
        //            make.left.equalTo(infoSourceLabel.snp.right).offset(10)
        //            make.bottom.equalTo(contentView).offset(-17)
        //            make.height.equalTo(10)
        //        }
        //
        //        infoLookLabel.snp.makeConstraints { (make) in
        //            make.left.equalTo(infoCommentLabel.snp.right).offset(10)
        //            make.bottom.equalTo(contentView).offset(-17)
        //            make.height.equalTo(10)
        //        }
        //
        infoCommentLabel.snp.makeConstraints { (make) in
            make.left.equalTo(travelTitleLabel)
            make.top.equalTo(travelTitleLabel.snp.bottom).offset(10)
            make.height.equalTo(10)
        }
        
        delButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(infoCommentLabel)
            make.right.equalTo(travelTitleLabel)
            make.width.equalTo(20)
            make.height.equalTo(14)
        }
        
        line.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(15)
            make.right.equalTo(contentView).offset(-15)
            make.bottom.equalTo(contentView)
            make.height.equalTo(0.5)
        }
        
    }
    
    
    // MARK: - setter and getter
    lazy var travelTitleLabel: UILabel = {
        let travelTitleLabel = UILabel()
        travelTitleLabel.font = UIFont.systemFont(ofSize: 16)
        travelTitleLabel.numberOfLines = 2
        travelTitleLabel.textColor = UIColor.init(hexColor: "333333")
        travelTitleLabel.text = ""
        return travelTitleLabel
    }()
    lazy var hotImageView: UIImageView = {
        let hotImageView = UIImageView()
        hotImageView.image = UIImage(named: "common_hot_icon_normal_iPhone")
        return hotImageView
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
        infoTimeLabel.text = "2017/03/16"
        infoTimeLabel.font = grayTextFont
        infoTimeLabel.textColor = UIColor.viewGrayColor
        return infoTimeLabel
    }()
    lazy var infoLookLabel: UILabel = {
        let infoLookLabel = UILabel()
        //        infoLookLabel.text = "6666人浏览"
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
            travelTitleLabel.text = newValue?.infoTitle ?? ""
            //            ["演出文化","旅游文化","体育文化","电影文化","会展文化","饮食文化"]
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
            
            infoTimeLabel.text = newValue?.infoTime?.getTimeString()
            infoCommentLabel.text = String.init(format: "%@回答", newValue?.infoComment ?? "0")
            
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
    var topicsModel: TopicsModel? {
        willSet {
            travelTitleLabel.text = newValue?.content ?? ""
            
            infoSourceLabel.text = newValue?.category
            infoTimeLabel.text = newValue?.timestamp?.getTimeString()
            infoCommentLabel.text = String.init(format: "%@回答", newValue?.commentCount ?? "0")
            
            hotImageView.isHidden = true
        }
    }
    
    
    
    //数据模型
    var mineTopicsModel: MineTopicsModel? {
        willSet {
            travelTitleLabel.text = newValue?.content ?? ""
            
            infoSourceLabel.text = newValue?.category
            infoTimeLabel.text = newValue?.timestamp?.getTimeString()
            infoCommentLabel.text = String.init(format: "%@回答", newValue?.commentCount ?? "0")
            
            hotImageView.isHidden = true
        }
    }
    
    var synTopicModel: SynTopicModel? {
        willSet {
            travelTitleLabel.text = newValue?.title ?? ""
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
            
            infoCommentLabel.text = String.init(format: "%@人回答", newValue?.comment ?? "0")
            
            infoTimeLabel.text = Int((newValue?.create_time)!)?.getTimeString()
        }
    }
}
