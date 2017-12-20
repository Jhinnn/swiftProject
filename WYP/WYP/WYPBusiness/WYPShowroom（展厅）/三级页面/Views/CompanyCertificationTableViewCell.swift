//
//  CompanyCertificationTableViewCell.swift
//  WYP
//
//  Created by ShuYan Feng on 2017/4/18.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

class CompanyCertificationTableViewCell: UITableViewCell {

    public var companyFrame: CompanyCertificationFrameModel? {
        willSet {
            titleNameLabel.text = newValue?.companyModel.title
            contentLabel.text = newValue?.companyModel.content
            setUpFrame(companyFrame: newValue!)
        }
    }
    
    // MARK: - life cycle
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        viewConfig()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - private method
    func viewConfig() {
        contentView.addSubview(titleNameLabel)
        contentView.addSubview(contentLabel)
    }
    func setUpFrame(companyFrame: CompanyCertificationFrameModel) {
        titleNameLabel.frame = companyFrame.titleFrame!
        contentLabel.frame = companyFrame.contentFrame!
    }

    // 名称
    lazy var titleNameLabel: UILabel = {
        let titleNameLabel = UILabel()
        titleNameLabel.textColor = UIColor.init(hexColor: "7a7a7a")
        titleNameLabel.font = UIFont.systemFont(ofSize: 13)
        titleNameLabel.numberOfLines = 0
        return titleNameLabel
    }()
    // 内容
    lazy var contentLabel: UILabel = {
        let contentLabel = UILabel()
        contentLabel.textColor = UIColor.init(hexColor: "7a7a7a")
        contentLabel.font = UIFont.systemFont(ofSize: 13)
        contentLabel.numberOfLines = 0
        return contentLabel
    }()

}

class CertificationTableViewCell: UITableViewCell {
    
    // MARK: - life cycle
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
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
            make.center.equalTo(contentView)
            make.size.equalTo(CGSize(width: 245, height: 175))
        }
    }
    
    lazy var certificationImageView: UIImageView = {
        let certificationImageView = UIImageView()
//        certificationImageView.image = UIImage(named: "common_certification_icon_normal_iPhone")
        certificationImageView.backgroundColor = UIColor.groupTableViewBackground
        return certificationImageView
    }()
}
