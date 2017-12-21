//
//  GroupNoteTableViewCell.swift
//  WYP
//
//  Created by 曾雪峰 on 2017/12/17.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

class GroupNoteTableViewCell: UITableViewCell {
    
    var imageUrls : [String]? {
        didSet {
            if self.imageUrls != nil {
                for urlStr in self.imageUrls! {
                    let index = imageUrls?.index(of: urlStr)
                    let imageView = UIImageView()
                    imageView.layer.cornerRadius = 1 < (self.imageUrls?.count)! ? 5 : 10
                    imageView.layer.masksToBounds = true
//                    imageView.backgroundColor = UIColor.red
                    imageView.sd_setImage(with: URL.init(string: kApi_baseUrl(path: urlStr)))
                    contentView.addSubview(imageView)
                    let size_width = 1 < (self.imageUrls?.count)! ? 63 : 140
                    imageView.snp.makeConstraints({ (make) in
                        make.left.equalTo(12 + 80 * index!)
                        make.top.equalTo(contentLabel.snp.bottom).offset(10)
                        make.size.equalTo(size_width)
                        make.bottom.equalTo(-10)
                    })
                }
            }else {
                contentLabel.snp.updateConstraints({ (make) in
                    make.bottom.equalTo(-10)
                })
            }
        }
    }
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
        setUIFrame()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupUI(){
        contentView.addSubview(noteTitle)
        contentView.addSubview(moreBtn)
        contentView.addSubview(people)
        contentView.addSubview(pubTime)
        contentView.addSubview(line)
        contentView.addSubview(contentLabel)
        contentView.addSubview(numberLabel)
        
    }
    
    func setUIFrame(){
        noteTitle.snp.makeConstraints { (make) in
            make.left.equalTo(12)
            make.top.equalTo(17)
        }
        
        moreBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(noteTitle)
            make.right.equalTo(-11)
        }
        
        people.snp.makeConstraints { (make) in
            make.top.equalTo(noteTitle.snp.bottom).offset(17)
            make.left.equalTo(12)
        }
        
        pubTime.snp.makeConstraints { (make) in
            make.centerY.equalTo(people)
            make.left.equalTo(61.6)
        }
        
        numberLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(pubTime)
            make.right.equalTo(-10)
        }
        
        line.snp.makeConstraints { (make) in
            make.top.equalTo(people.snp.bottom).offset(14)
            make.left.equalTo(12)
            make.right.equalTo(0)
            make.height.equalTo(0.3)
        }
        
        contentLabel.snp.makeConstraints { (make) in
            make.left.equalTo(12)
            make.top.equalTo(line.snp.bottom).offset(17)
            make.right.equalTo(20.6)
        }
        
    }
    
    //标题
    lazy var noteTitle: UILabel = {
        let noteTitle = UILabel()
        noteTitle.textColor = UIColor.init(hexColor: "333333")
        noteTitle.font = UIFont.systemFont(ofSize: 14)
        return noteTitle
    }()
    
    lazy var moreBtn: UIButton = {
        let moreBtn = UIButton()
        moreBtn.setImage(UIImage.init(named: "notice_icon_more_normal"), for: .normal)
        return moreBtn
    }()
    
    //发布人
    lazy var people: UILabel = {
        let people = UILabel()
        people.font = UIFont.systemFont(ofSize: 10)
        people.textColor = UIColor.init(hexColor: "333333")
        people.alpha = 0.6
        return people
    }()
    
    lazy var pubTime: UILabel = {
        let pubTime = UILabel()
        pubTime.font = UIFont.systemFont(ofSize: 10)
        pubTime.textColor = UIColor.init(hexColor: "333333")
        pubTime.alpha = 0.6
        return pubTime
    }()
    
    lazy var numberLabel : UILabel = {
        let numberLabel = UILabel()
        numberLabel.font = UIFont.systemFont(ofSize: 10)
        numberLabel.textColor = UIColor.init(hexColor: "333333")
        numberLabel.alpha = 0.6
        return numberLabel
    }()
    
    lazy var line : UIView = {
        let line = UIView()
        line.backgroundColor = UIColor.init(hexColor: "e8e8e8")
        return line
    }()
    
    lazy var contentLabel: UILabel = {
        let contentLabel = UILabel()
        contentLabel.numberOfLines = 0
        contentLabel.alpha = 0.8
        contentLabel.textColor = UIColor.init(hexColor: "333333")
        contentLabel.font = UIFont.systemFont(ofSize: 13)
        return contentLabel
    }()
    
    
    
}

