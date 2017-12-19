//
//  RecordsTableViewCell.swift
//  WYP
//
//  Created by ShuYan Feng on 2017/5/9.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

class RecordsTableViewCell: UITableViewCell {
    
    var records: RecordModel? {
        willSet {
            contentLabel.text = newValue?.recordTitle
            timeLabel.text = String().timeStampToString(timeStamp: newValue?.recordTime ?? "0")
        }
    }
    
    // MARK: - Lifecycle
    
    // 指定初始化方法
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    
    // 设置视图
    func setupUI() {
        
        contentView.addSubview(contentLabel)
        contentView.addSubview(timeLabel)
        
        setupUIFrame()
    }
    
    func setupUIFrame() {
        
        contentLabel.snp.makeConstraints { (make) in
            make.top.equalTo(contentView).offset(10)
            make.left.equalTo(contentView).offset(13)
            make.right.equalTo(contentView).offset(-13)
            make.height.equalTo(16)
        }
        
        timeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(contentLabel.snp.bottom).offset(8)
            make.left.equalTo(contentView).offset(13)
            make.right.equalTo(contentView).offset(-13)
            make.height.equalTo(13)
        }
    }
    

    
    // 通知内容
    lazy var contentLabel: UILabel = {
        let contentLabel = UILabel()
        contentLabel.font = UIFont.systemFont(ofSize: 15)
        contentLabel.textColor = UIColor.init(hexColor: "#333333")
        
        return contentLabel
    }()
    
    // 通知时间
    lazy var timeLabel: UILabel = {
        let timeLabel = UILabel()
        timeLabel.font = UIFont.systemFont(ofSize: 13)
        timeLabel.textColor = UIColor.init(hexColor: "#87898f")
        
        return timeLabel
    }()
    
    // MARK: - IBActions
    
    
    // MARK: - Getter
    
    
    // MARK: - Setter
}
