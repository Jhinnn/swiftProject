//
//  UITableViewCell+Extension.swift
//  WYP
//
//  Created by 你个LB on 2017/5/31.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import Foundation

extension UITableViewCell {
    
    open override var frame: CGRect {
        willSet {
            self.selectionStyle = .none
        }
    }
}
