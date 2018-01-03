//
//  SearchTitleView.swift
//  WYP
//
//  Created by ShuYan Feng on 2017/9/25.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

class SearchTitleView: UIView {

    // 重写title的约束
    override var intrinsicContentSize: CGSize {
        return UILayoutFittingExpandedSize
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        viewConfig()
        layoutPageSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func viewConfig() {
        self.addSubview(backView)
        backView.addSubview(searchTextField)
        backView.addSubview(searchImageView)
    }
    
    func layoutPageSubviews() {
        backView.snp.makeConstraints { (make) in
            make.center.equalTo(self)
            make.size.equalTo(CGSize(width: kScreen_width - 130, height: 30))
        }
        searchImageView.snp.makeConstraints { (make) in
            make.right.equalTo(backView).offset(-10)
            make.centerY.equalTo(backView)
            make.size.equalTo(CGSize(width: 15, height: 15))
        }
        searchTextField.snp.makeConstraints { (make) in
            make.left.equalTo(backView).offset(20)
            make.right.equalTo(searchImageView.snp.left).offset(-10)
            make.centerY.equalTo(backView)
            make.height.equalTo(30)
        }
    }
    
    lazy var backView: UIView = {
        let backView = UIView(frame: .zero)
        backView.backgroundColor = UIColor.white
        backView.layer.masksToBounds = true
        backView.layer.cornerRadius = 5.0
        return backView
    }()
    // 设置导航条上的搜索框
    lazy var searchTextField: UITextField = {
        let searchTextField = UITextField()
        searchTextField.backgroundColor = UIColor.white
        searchTextField.placeholder = "可输入关键字进行信息搜索"
        searchTextField.font = UIFont.systemFont(ofSize: 14)
        searchTextField.tintColor = UIColor.lightGray
        searchTextField.returnKeyType = .search
        let attributeString = NSMutableAttributedString(string: searchTextField.placeholder!)
        attributeString.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 14),range: NSMakeRange(0,(searchTextField.placeholder?.characters.count)!))
        searchTextField.attributedPlaceholder = attributeString
        return searchTextField
    }()
    lazy var searchImageView: UIImageView = {
        let searchImageView = UIImageView()
        searchImageView.image = UIImage(named: "common_search_button_normal_iPhone")
        return searchImageView
    }()
}
