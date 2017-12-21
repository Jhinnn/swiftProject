//
//  ChatRecordTableViewCell.swift
//  WYP
//
//  Created by aLaDing on 2017/12/21.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

class ChatRecordTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.red
        setUI()
        setUIFrame()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func setUI() {
        contentView.addSubview(headImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(contentLabel)
    }
    
    func setUIFrame() {
        headImageView.snp.makeConstraints { (make) in
            make.top.equalTo(11)
            make.size.equalTo(43)
            make.left.equalTo(12)
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.height.equalTo(15)
            make.top.equalTo(18)
            make.left.equalTo(headImageView.snp.right).offset(20)
        }
        
        timeLabel.snp.makeConstraints { (make) in
            make.right.equalTo(-9)
            make.centerY.equalTo(nameLabel)
        }
        
        contentLabel.snp.makeConstraints { (make) in
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
            make.bottom.equalTo(-18)
            make.left.equalTo(nameLabel)
            make.right.equalTo(timeLabel.snp.left).offset(-10)
        }
    }
    
    lazy var headImageView: UIImageView = {
        let headImageView = UIImageView()
       headImageView.layer.cornerRadius = 21.5
        headImageView.layer.masksToBounds = true
        return headImageView
    }()
    
    lazy var nameLabel : UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = UIFont.systemFont(ofSize: 13)
        nameLabel.textColor = UIColor.init(hexColor: "333333")
        return nameLabel
    }()
    
    lazy var contentLabel : UILabel = {
        let contentLabel = UILabel()
        contentLabel.font = UIFont.systemFont(ofSize: 11)
        contentLabel.textColor = UIColor.init(hexColor: "999999")
        return contentLabel
    }()
    
    lazy var timeLabel : UILabel = {
        let timeLabel = UILabel()
        timeLabel.font = UIFont.systemFont(ofSize: 11)
        timeLabel.textColor = UIColor.init(hexColor: "666666")
        return timeLabel
    }()

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
