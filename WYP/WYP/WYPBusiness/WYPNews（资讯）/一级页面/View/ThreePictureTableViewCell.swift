//
//  ThreePictureTableViewCell.swift
//  InfoView
//
//  Created by ShuYan Feng on 2017/3/16.
//  Copyright © 2017年 ShuYan Feng. All rights reserved.
//

import UIKit

class ThreePictureTableViewCell: UITableViewCell {
    
    var cellHeight: CGFloat?
    
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
    
        contentView.addSubview(infoImageView1)
        contentView.addSubview(infoImageView2)
        contentView.addSubview(infoImageView3)
        contentView.addSubview(infoLabel)
        contentView.addSubview(adButton)
        contentView.addSubview(topButton)
        contentView.addSubview(infoSourceLabel)
        contentView.addSubview(infoTimeLabel)
        contentView.addSubview(infoLookLabel)
        contentView.addSubview(infoCommentLabel)
        contentView.addSubview(hotImageView)
        contentView.addSubview(line)
        line.isHidden = true
    }
    private func layoutPageSubviews() {

        adButton.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(13)
            make.bottom.equalTo(contentView).offset(-14)
            make.size.equalTo(CGSize(width: 20, height: 12))
        }
        topButton.snp.makeConstraints { (make) in
            make.left.equalTo(adButton.snp.right).offset(3)
            make.bottom.equalTo(contentView).offset(-14)
            make.size.equalTo(CGSize(width: 20, height: 12))
        }
        infoSourceLabel.snp.makeConstraints { (make) in
            make.left.equalTo(topButton.snp.right).offset(2)
            make.bottom.equalTo(contentView).offset(-10)
            make.height.equalTo(16)
            make.width.equalTo(50)
        }
        infoTimeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(infoSourceLabel.snp.right).offset(20)
            make.bottom.equalTo(contentView).offset(-14)
            make.height.equalTo(10)
        }
        infoCommentLabel.snp.makeConstraints { (make) in
            make.right.equalTo(self.contentView).offset(-18)
            make.bottom.equalTo(contentView).offset(-14)
            make.height.equalTo(10)
        }
        infoLookLabel.snp.makeConstraints { (make) in
            make.left.equalTo(infoCommentLabel.snp.right).offset(10)
            make.bottom.equalTo(contentView).offset(-14)
            make.height.equalTo(10)
        }
        infoImageView1.snp.makeConstraints { (make) in
            make.bottom.equalTo(adButton.snp.top).offset(-10)
            make.left.equalTo(contentView).offset(13)
            make.size.equalTo(CGSize(width: (kScreen_width-44)/3, height: 80 * width_height_ratio))
        }
        infoImageView2.snp.makeConstraints { (make) in
            make.bottom.equalTo(adButton.snp.top).offset(-10)
            make.left.equalTo(infoImageView1.snp.right).offset(6)
            make.size.equalTo(CGSize(width: (kScreen_width-44)/3, height: 80 * width_height_ratio))
        }
        infoImageView3.snp.makeConstraints { (make) in
            make.bottom.equalTo(adButton.snp.top).offset(-10)
            make.left.equalTo(infoImageView2.snp.right).offset(6)
            make.size.equalTo(CGSize(width: (kScreen_width-44)/3, height: 80 * width_height_ratio))
        }
        infoLabel.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(13)
            make.bottom.equalTo(infoImageView1.snp.top).offset(-12)
            make.right.equalTo(contentView).offset(-36.5)
            make.height.equalTo(15)
        }
        hotImageView.snp.makeConstraints { (make) in
            make.bottom.equalTo(infoImageView1.snp.top).offset(-12)
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
    lazy var infoImageView1: UIImageView = {
        let infoImageView = UIImageView()
        infoImageView.contentMode = .scaleAspectFill
        infoImageView.layer.masksToBounds = true
        infoImageView.backgroundColor = UIColor.init(hexColor: "f1f2f4")
        
        return infoImageView
    }()
    lazy var infoImageView2: UIImageView = {
        let infoImageView = UIImageView()
        infoImageView.contentMode = .scaleAspectFill
        infoImageView.layer.masksToBounds = true
        infoImageView.backgroundColor = UIColor.init(hexColor: "f1f2f4")
        
        return infoImageView
    }()
    lazy var infoImageView3: UIImageView = {
        let infoImageView = UIImageView()
        infoImageView.contentMode = .scaleAspectFill
        infoImageView.layer.masksToBounds = true
        infoImageView.backgroundColor = UIColor.init(hexColor: "f1f2f4")
        
        return infoImageView
    }()
    lazy var infoLabel: UILabel = {
        let infoLabel = UILabel()
        infoLabel.text = "这布吐槽局实在有毒，笑得我吃不下饭"
        infoLabel.numberOfLines = 2
        infoLabel.font = UIFont.systemFont(ofSize: 15)
        infoLabel.textColor = UIColor.init(hexColor: "333333")
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
        infoTimeLabel.text = "8小时前"
        infoTimeLabel.font = grayTextFont
        infoTimeLabel.textColor = UIColor.viewGrayColor
        return infoTimeLabel
    }()
    lazy var infoLookLabel: UILabel = {
        let infoLookLabel = UILabel()
//        infoLookLabel.text = "6666浏览"
        infoLookLabel.textAlignment = .right
        infoLookLabel.font = grayTextFont
        infoLookLabel.textColor = UIColor.viewGrayColor
        return infoLookLabel
    }()
    lazy var infoCommentLabel: UILabel = {
        let infoCommentLabel = UILabel()
        infoCommentLabel.text = "11111评论"
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
            infoLabel.text = newValue?.infoTitle ?? ""
            
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
//            infoSourceLabel.text = newValue?.infoSource ?? "未知来源"
//            infoTimeLabel.text = newValue?.infoTime?.getTimeString()
//            infoLookLabel.text = String.init(format: "%@人评论", newValue?.infoComment ?? "0")
            infoCommentLabel.text = String.init(format: "%@人回答", newValue?.infoLook ?? "0")
            let imageUrl1 = URL(string: newValue?.infoImageArr?[0] ?? "")
            let imageUrl2 = URL(string: newValue?.infoImageArr?[1] ?? "")
            let imageUrl3 = URL(string: newValue?.infoImageArr?[2] ?? "")
            infoImageView1.kf.setImage(with: imageUrl1)
            infoImageView2.kf.setImage(with: imageUrl2)
            infoImageView3.kf.setImage(with: imageUrl3)
            
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
}
