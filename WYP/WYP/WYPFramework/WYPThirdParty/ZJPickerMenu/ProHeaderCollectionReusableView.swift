//
//  ProHeaderCollectionReusableView.swift
//  商城属性
//
//  Created by zj on 2017/12/8.
//  Copyright © 2017年 zj. All rights reserved.
//

import UIKit

class ProHeaderCollectionReusableView: UICollectionReusableView
{
    lazy var label: UILabel =
        {
            var label = UILabel()
            label.textAlignment = .left
            label.text = ""
            label.textColor = UIColor.gray
            label.font = UIFont.systemFont(ofSize: 15)
            return label
    }()
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        self.addSubview(self.label)
    }
    override func layoutSubviews()
    {
        super.layoutSubviews()
        self.label.frame = CGRect(x: 14, y: 0, width: self.bounds.width - 20 , height: self.bounds.height)
    }
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
}
