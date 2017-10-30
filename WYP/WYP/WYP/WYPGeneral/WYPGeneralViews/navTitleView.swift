//
//  navTitleView.swift
//  WYP
//
//  Created by ShuYan Feng on 2017/9/25.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit
protocol navTitleViewDelegate: NSObjectProtocol {
    func searchYouWant()
}

// 自定义titleView
class navTitleView: UIView {
    // 重写title的约束
    override var intrinsicContentSize: CGSize {
        return UILayoutFittingExpandedSize
    }
    
    var tap: UITapGestureRecognizer?
    weak var delegate: navTitleViewDelegate?
    
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
        // 添加手势
        tap = UITapGestureRecognizer(target: self, action: #selector(search(tap:)))
        tap?.numberOfTapsRequired = 1
        tap?.numberOfTouchesRequired = 1
        searchView.addGestureRecognizer(tap!)
        
        self.addSubview(searchView)
        self.addSubview(logoImageView)
    }
    
    func layoutPageSubviews() {
        searchView.snp.makeConstraints { (make) in
            make.right.equalTo(self)
            make.centerY.equalTo(self)
            make.size.equalTo(CGSize(width: 230 * width_height_ratio , height: 30))
        }
        logoImageView.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(self).offset(10 * width_height_ratio)
            make.size.equalTo(CGSize(width: 60, height: 34))
        }
    }
    
    func search(tap: UITapGestureRecognizer) {
        delegate?.searchYouWant()
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
    
    // logo
    lazy var logoImageView: UIImageView = {
        let logoImageView = UIImageView()
        logoImageView.image = UIImage(named: "aladdiny_logo")
        
        return logoImageView
    }()
}

