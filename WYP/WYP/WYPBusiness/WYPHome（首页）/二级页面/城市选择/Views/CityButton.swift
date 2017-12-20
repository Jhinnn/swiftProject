//
//  CityButton.swift
//  CityListDemo
//
//  Created by ShuYan Feng on 2017/3/29.
//  Copyright © 2017年 ShuYan Feng. All rights reserved.
//

import UIKit

class CityButton: UIButton {

    // 索引
    var index: NSInteger?
    var cityItem: String? {
        willSet {
            titleName?.text = newValue
        }
    }

    private var container: UIView?
    private var titleName: UILabel?
    
    // MARK: - life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        viewConfig()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        container?.frame = CGRect(x: 0, y: 0, width: self.frame.size.width
            , height: self.frame.size.height)
        titleName?.frame = CGRect(x: 0, y: 0, width: (container?.frame.size.width)!, height: (container?.frame.size.height)!)
    }
    
    // MARK: - private method
    func viewConfig() {
        self.backgroundColor = UIColor.white
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 5
        self.layer.borderColor = UIColor.init(hexColor: "c9caca").cgColor
        self.layer.borderWidth = 1
        
        setUpViews()
    }
    
    func setUpViews() {
        container = UIView()
        container?.isUserInteractionEnabled = false
        container?.backgroundColor = UIColor.clear
        
        titleName = UILabel()
        titleName?.font = UIFont.systemFont(ofSize: 15)
        titleName?.textColor = UIColor.init(hexColor: "333333")
        titleName?.textAlignment = .center
        
        container?.addSubview(titleName!)
    }
}
