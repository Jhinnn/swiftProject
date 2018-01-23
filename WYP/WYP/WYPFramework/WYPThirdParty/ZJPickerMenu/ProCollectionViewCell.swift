//
//  ProCollectionViewCell.swift
//  商城属性
//
//  Created by zj on 2017/12/7.
//  Copyright © 2017年 zj. All rights reserved.
//

import UIKit

class ProCollectionViewCell: UICollectionViewCell
{
    lazy var button: UIButton =
        {
        var button = UIButton()
            button.isUserInteractionEnabled = false
        button.setBackgroundImage(UIImage.init(named: "normal"), for: UIControlState.normal)
        button.setBackgroundImage(UIImage.init(named: "selected"), for: UIControlState.selected)
//        button.backgroundColor = UIColor.menuColor
        button.setTitleColor(UIColor.black, for: UIControlState.normal)
        button.setTitleColor(UIColor.white, for: UIControlState.selected)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 4
        return button
    }()
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        self.addSubview(self.button)
        
    }
    override func layoutSubviews()
    {
        super.layoutSubviews()
        self.button.frame = self.bounds
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
