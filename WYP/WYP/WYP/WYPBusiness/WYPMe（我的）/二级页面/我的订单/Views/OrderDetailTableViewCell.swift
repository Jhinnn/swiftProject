//
//  OrderDetailTableViewCell.swift
//  WYP
//
//  Created by ShuYan Feng on 2017/8/7.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

class OrderDetailTableViewCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        viewConfig()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func viewConfig() {
        contentView.addSubview(orderLabel)
        contentView.addSubview(orderTextField)
        
        orderLabel.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(13)
            make.centerY.equalTo(contentView)
            make.size.equalTo(CGSize(width: 90, height: 16))
            
        }
        orderTextField.snp.makeConstraints { (make) in
            make.left.equalTo(orderLabel.snp.right).offset(10)
            make.right.equalTo(contentView).offset(-13)
            make.centerY.equalTo(contentView)
            make.height.equalTo(16)
        }
    }
    
    // MARK: - setter and getter
    lazy var orderLabel: UILabel = {
        let orderLabel = UILabel()
        orderLabel.textColor = UIColor.init(hexColor: "333333")
        orderLabel.font = UIFont.systemFont(ofSize: 16)
        return orderLabel
    }()
    
    lazy var orderTextField: UITextField = {
        let orderTextField = UITextField()
        orderTextField.textColor = UIColor.init(hexColor: "a1a1a1")
        orderTextField.font = UIFont.systemFont(ofSize: 15)
        orderTextField.textAlignment = .left
        orderTextField.borderStyle = .none
        orderTextField.isUserInteractionEnabled = false
        return orderTextField
    }()
}
