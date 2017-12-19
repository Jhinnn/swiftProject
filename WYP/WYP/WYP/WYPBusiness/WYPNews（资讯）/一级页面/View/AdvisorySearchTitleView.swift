//
//  AdvisorySearchTitleView.swift
//  WYP
//
//  Created by 赵玉忠 on 2017/11/7.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

class AdvisorySearchTitleView: navTitleView {
    
    // MARK: - life cycle
    override func viewConfig(){
        // 添加手势
        tap = UITapGestureRecognizer(target: self, action: #selector(search(tap:)))
        tap?.numberOfTapsRequired = 1
        tap?.numberOfTouchesRequired = 1
        searchView.addGestureRecognizer(tap!)
        self.addSubview(searchView)
        self.addSubview(logoImageView)
    }
    
    override func layoutPageSubviews(){
        searchView.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(-22)
            make.centerY.equalTo(self)
            make.size.equalTo(CGSize(width: 230 * width_height_ratio , height: 30))
        }
        logoImageView.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(self).offset(10 * width_height_ratio)
            make.size.equalTo(CGSize(width: 60, height: 34))
        }
        
    }
    
}
