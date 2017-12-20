//
//  UIButton+Extension.swift
//  WYP
//
//  Created by ShuYan Feng on 2017/6/1.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import Foundation
import UIKit

class SYButton: UIButton {

    // MARK: - life cycle
    
    // MARK: - private method
    func changeBadgeViewColor(color: UIColor) {
        badgeView.backgroundColor = color
        badgeLabel.backgroundColor = color
    }
    
    lazy var badgeView: UIView = {
        let badgeView = UIView()
        badgeView.layer.cornerRadius = 5
        badgeView.layer.masksToBounds = true
        badgeView.backgroundColor = UIColor.themeColor

        return badgeView
    }()
    
    lazy var badgeLabel: UILabel = {
        let badgeLabel = UILabel()
        badgeLabel.layer.cornerRadius = 4
        badgeLabel.layer.masksToBounds = true
        badgeLabel.backgroundColor = UIColor.themeColor
        badgeLabel.font = UIFont.systemFont(ofSize: 8)
        badgeLabel.textColor = UIColor.white
        badgeLabel.textAlignment = .center
        
        return badgeLabel
    }()
}
