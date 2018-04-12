//
//  SearchView.swift
//  WYP
//
//  Created by ShuYan Feng on 2017/5/24.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

class SearchView: UIView {
    
    // MARK: - life cycle
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
        self.addSubview(searchLabel)
        self.addSubview(searchImage)
    }
    
    func layoutPageSubviews() {
        searchLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(14.5)
            make.centerY.equalTo(self)
            make.height.equalTo(13)
        }
        
        searchImage.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(-10)
            make.centerY.equalTo(self)
            make.size.equalTo(CGSize(width: 15, height: 15))
        }
    }
    
    // MARK: - setter and getter
    lazy var searchLabel: UILabel = {
        let searchLabel = UILabel()
        searchLabel.textColor = UIColor.init(hexColor: "cbcbcb")
        searchLabel.font = UIFont.systemFont(ofSize: 15)
        return searchLabel
    }()
    
    lazy var searchImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "common_search_button_normal_iPhone")
        return image
    }()
}


class QuesSearchView: UIView {
    
    // MARK: - life cycle
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
        self.addSubview(searchLabel)
        self.addSubview(searchImage)
    }
    
    func layoutPageSubviews() {
        searchLabel.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(-10)
            make.centerY.equalTo(self)
            make.height.equalTo(13)
            make.left.equalTo(searchImage.snp.right).offset(6)
        }
        
        searchImage.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(6)
            make.centerY.equalTo(self)
            make.size.equalTo(CGSize(width: 13, height: 13))
        }
    }
    
    // MARK: - setter and getter
    lazy var searchLabel: UILabel = {
        let searchLabel = UILabel()
        searchLabel.textColor = UIColor.init(hexColor: "999999")
        searchLabel.font = UIFont.systemFont(ofSize: 13)
        return searchLabel
    }()
    
    lazy var searchImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "common_search_button_normal_iPhone")
        return image
    }()
}

class QuessSearchView: UIView {
    
    // MARK: - life cycle
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
        self.addSubview(searchLabel)
        self.addSubview(searchImage)
    }
    
    func layoutPageSubviews() {
        searchLabel.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(-10)
            make.centerY.equalTo(self)
            make.height.equalTo(13)
            make.left.equalTo(searchImage.snp.right).offset(6)
        }
        
        searchImage.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(6)
            make.centerY.equalTo(self)
            make.size.equalTo(CGSize(width: 13, height: 13))
        }
    }
    
    // MARK: - setter and getter
    lazy var searchLabel: UITextField = {
        let searchLabel = UITextField()
        searchLabel.textColor = UIColor.black
        searchLabel.placeholder = "请输入关键字"
        searchLabel.font = UIFont.systemFont(ofSize: 13)
        return searchLabel
    }()
    
    lazy var searchImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "common_search_button_normal_iPhone")
        return image
    }()
}

class commonSearchView: UIView {
    
    // 重写title的约束
    override var intrinsicContentSize: CGSize {
        return UILayoutFittingExpandedSize
    }
    

    // MARK: - life cycle
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
        self.addSubview(searchView)
    }
    
    func layoutPageSubviews() {
        searchView.snp.makeConstraints { (make) in
            make.center.equalTo(self)
            make.size.equalTo(CGSize(width: 235 * width_height_ratio , height: 30))
        }
    }
    
    // MARK: - setter and getter
    lazy var searchView: SearchView = {
        let searchView = SearchView()
        searchView.backgroundColor = UIColor.white
        searchView.layer.cornerRadius = 5.0
        searchView.layer.masksToBounds = true
        searchView.searchLabel.text = "搜索内容..."
        
        return searchView
    }()
    
}

class qusesearchView: UIView {
    
    // 重写title的约束
    override var intrinsicContentSize: CGSize {
        return UILayoutFittingExpandedSize
    }
    
    
    // MARK: - life cycle
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
        self.addSubview(searchView)
    }
    
    func layoutPageSubviews() {
        searchView.snp.makeConstraints { (make) in
            make.center.equalTo(self)
            make.size.equalTo(CGSize(width: kScreen_width - 60, height: 28))
        }
    }
    
    // MARK: - setter and getter
    lazy var searchView: QuesSearchView = {
        let searchView = QuesSearchView()
        searchView.backgroundColor = UIColor.white
        searchView.layer.cornerRadius = 5.0
        searchView.layer.masksToBounds = true
        
        searchView.searchLabel.text = "搜一搜你想问的问题"
        searchView.backgroundColor = UIColor.init(hexColor: "F4F5F7")
        return searchView
    }()
    
}


class quseesearchView: UIView {
    
    // 重写title的约束
    override var intrinsicContentSize: CGSize {
        return UILayoutFittingExpandedSize
    }
    
    
    // MARK: - life cycle
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
        self.addSubview(searchView)
    }
    
    func layoutPageSubviews() {
        searchView.snp.makeConstraints { (make) in
            make.center.equalTo(self)
            make.size.equalTo(CGSize(width: kScreen_width - 120, height: 28))
        }
    }
    
    // MARK: - setter and getter
    lazy var searchView: QuessSearchView = {
        let searchView = QuessSearchView()
        searchView.backgroundColor = UIColor.white
        searchView.layer.cornerRadius = 5.0
        searchView.layer.masksToBounds = true
        
        searchView.backgroundColor = UIColor.init(hexColor: "F4F5F7")
        return searchView
    }()
    
}
