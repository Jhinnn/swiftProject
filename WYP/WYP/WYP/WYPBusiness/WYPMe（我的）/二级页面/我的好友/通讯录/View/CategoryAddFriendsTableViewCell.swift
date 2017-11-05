//
//  CategoryAddFriendsTableViewCell.swift
//  WYP
//
//  Created by 赵玉忠 on 2017/11/5.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

class CategoryAddFriendsTableViewCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        viewConfig()
        layoutPageSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func viewConfig() {
         contentView.addSubview(leftImageView)
         contentView.addSubview(labelUp)
         contentView.addSubview(labelDown)
         contentView.addSubview(rightImageView)
    }
    func layoutPageSubviews() {
        leftImageView.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(15)
            make.centerY.equalTo(contentView)
            make.width.height.equalTo(30)
        }
        labelUp.snp.makeConstraints { (make) in
            make.left.equalTo(leftImageView.snp.right).offset(15)
            make.top.equalTo(leftImageView.snp.top)
        }
        labelDown.snp.makeConstraints { (make) in
            make.left.equalTo(labelUp.snp.left)
            make.top.equalTo(labelUp.snp.bottom)
        }
        rightImageView.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView)
            make.right.equalTo(contentView).offset(-15)
            make.width.height.equalTo(12)
        }
    }
    
    lazy var leftImageView:UIImageView = {
       let leftImageView = UIImageView()
       return leftImageView
    }()
    lazy var labelUp:UILabel = {
        let labelUp = UILabel()
        labelUp.textColor = UIColor.black
        labelUp.font = UIFont.systemFont(ofSize: 15)
        return labelUp
    }()
    lazy var labelDown:UILabel = {
        let labelDown = UILabel()
        labelDown.textColor = UIColor(red: 192/250, green: 192/250, blue: 192/250, alpha: 1)
        labelDown.font = UIFont.systemFont(ofSize: 12)
        return labelDown
    }()
    lazy var rightImageView:UIImageView = {
        let rightImageView = UIImageView()
        return rightImageView
    }()


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
