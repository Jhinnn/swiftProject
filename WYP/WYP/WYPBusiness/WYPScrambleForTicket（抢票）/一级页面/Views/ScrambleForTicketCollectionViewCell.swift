//
//  ScrambleForTicketCollectionViewCell.swift
//  WYP
//
//  Created by ShuYan Feng on 2017/4/17.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

class ScrambleForTicketCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        viewConfig()
        layoutPageSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - private method
    func viewConfig() {
        
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.init(hexColor: "f1f2f4").cgColor
        
        contentView.addSubview(lotteryImageView)
        contentView.addSubview(categoryImageView)
        contentView.addSubview(categoryTitleLabel)
        contentView.addSubview(ticketNumberLabel)
    }
    func layoutPageSubviews() {
        lotteryImageView.snp.makeConstraints { (make) in
            make.left.top.equalTo(contentView)
            make.size.equalTo(CGSize(width: 18, height: 16))
        }
        categoryImageView.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(10)
            make.centerY.equalTo(contentView)
            make.size.equalTo(CGSize(width: 40.5, height: 40.5))
        }
        categoryTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(categoryImageView.snp.right).offset(8)
            make.top.equalTo(contentView).offset(20.5)
            make.height.equalTo(15)
        }
        ticketNumberLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(contentView).offset(-18.5)
            make.left.equalTo(categoryImageView.snp.right).offset(8)
            make.height.equalTo(10)
        }
    }
    
    // 抢票
    lazy var lotteryImageView: UIImageView = {
        let lotteryImageView = UIImageView()
        lotteryImageView.image = UIImage(named: "lottery_lottery_icon_normal_iPhone")
        return lotteryImageView
    }()
    // 圆图标
    lazy var categoryImageView: UIImageView = {
        let categoryImageView = UIImageView()
        return categoryImageView
    }()
    // 类型
    lazy var categoryTitleLabel: UILabel = {
        let categoryTitleLabel = UILabel()
        categoryTitleLabel.font = UIFont.systemFont(ofSize: 15)
        categoryTitleLabel.textColor = UIColor.init(hexColor: "333333")
        return categoryTitleLabel
    }()
    // 票数
    lazy var ticketNumberLabel: UILabel = {
        let ticketNumberLabel = UILabel()
        ticketNumberLabel.font = grayTextFont
        ticketNumberLabel.textColor = UIColor.viewGrayColor
        return ticketNumberLabel
    }()
}
