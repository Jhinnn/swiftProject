//
//  ProjectCertificationCollectionViewCell.swift
//  WYP
//
//  Created by ShuYan Feng on 2017/4/17.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

class ProjectCertificationCollectionViewCell: UICollectionViewCell {
    
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
        contentView.addSubview(certificationImageView)
    }
    func layoutPageSubviews() {
        certificationImageView.snp.makeConstraints { (make) in
            make.top.equalTo(contentView).offset(10)
            make.centerX.equalTo(contentView)
            make.size.equalTo(CGSize(width: 166.5, height: 113.5))
        }
    }
    // MARK: - setter and getter
    lazy var certificationImageView: UIImageView = {
        let certificationImageView = UIImageView()
//        certificationImageView.
        certificationImageView.image = UIImage(named: "common_certification_icon_normal_iPhone")
        return certificationImageView
    }()
}
