//
//  DeleteHeaderCollectionReusableView.swift
//  WYP
//
//  Created by aLaDing on 2017/12/22.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

class DeleteHeaderCollectionReusableView: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setUIFrame()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI() {
        self.addSubview(numLabel)
    }
    
    func setUIFrame() {
        numLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(12)
        }
    }
    
    lazy var numLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.init(hexColor: "333333")
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
}
