//
//  WYPTableView.swift
//  WYP
//
//  Created by ShuYan Feng on 2017/5/31.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import Foundation

class WYPTableView: UITableView {
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        
        self.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15)
        // iOS11问题
        self.estimatedRowHeight = 0
        self.estimatedSectionFooterHeight = 0
        self.estimatedSectionHeaderHeight = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
