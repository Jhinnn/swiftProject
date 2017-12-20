//
//  CertificationCollectionReusableView.swift
//  WYP
//
//  Created by ShuYan Feng on 2017/4/17.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

class CertificationCollectionReusableView: UICollectionReusableView {
   
    // MARK: - life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        viewConfig(layout: layoutAttributes)
        layoutPageSubview(layout: layoutAttributes)
    }
    
    // MARK: - private method
    func viewConfig(layout: UICollectionViewLayoutAttributes) {
        if layout.indexPath.section == 0 {
            self.addSubview(sectionLabel)
        }
        self.addSubview(headerLabel)
    }
    func layoutPageSubview(layout: UICollectionViewLayoutAttributes) {
        if layout.indexPath.section == 0 {
            sectionLabel.snp.makeConstraints { (make) in
                make.top.equalTo(self).offset(23.5)
                make.left.right.equalTo(self)
                make.height.equalTo(15)
            }
        }
        headerLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(self).offset(-12)
            make.left.right.equalTo(self)
            make.height.equalTo(10)
        }
        
    }
    
    // MARK: - setter and getter
    lazy var sectionLabel: UILabel = {
        let sectionLabel = UILabel()
        sectionLabel.font = UIFont.systemFont(ofSize: 15)
        sectionLabel.textColor = UIColor.init(hexColor: "333333")
        sectionLabel.textAlignment = .center
        return sectionLabel
    }()
    
    lazy var headerLabel: UILabel = {
        let headerLabel = UILabel()
        headerLabel.font = UIFont.systemFont(ofSize: 13)
        headerLabel.textColor = UIColor.init(hexColor: "87898f")
        headerLabel.textAlignment = .center
        return headerLabel
    }()
    
}
