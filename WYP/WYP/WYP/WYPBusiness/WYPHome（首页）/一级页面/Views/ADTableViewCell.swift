//
//  ADTableViewCell.swift
//  WYP
//
//  Created by ShuYan Feng on 2017/4/5.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

protocol ADTableViewCellDelegate: NSObjectProtocol {
    func adTableViewDidSeletedImageView1()
    func adTableViewDidSeletedImageView2()
}

class ADTableViewCell: UITableViewCell {

    weak var delegate: ADTableViewCellDelegate?
    
    // MARK: - life cyele
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        viewConfig()
        layoutPageSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - private method
    private func viewConfig() {
        contentView.addSubview(adImageView1)
        contentView.addSubview(adImageView2)
        contentView.addSubview(adImageView)
        
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(didSelectedImageView1(tap:)))
        tap1.numberOfTapsRequired = 1
        tap1.numberOfTouchesRequired = 1
        adImageView1.addGestureRecognizer(tap1)
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(didSelectedImageView2(tap:)))
        tap2.numberOfTapsRequired = 1
        tap2.numberOfTouchesRequired = 1
        adImageView2.addGestureRecognizer(tap2)
    }
    private func layoutPageSubviews() {
        adImageView1.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(13)
            make.top.equalTo(contentView).offset(2)
            make.size.equalTo(CGSize(width: (kScreen_width - 28) / 2, height: 52 * width_height_ratio))
        }
        adImageView2.snp.makeConstraints { (make) in
            make.right.equalTo(contentView).offset(-13)
            make.top.equalTo(contentView).offset(2)
            make.size.equalTo(CGSize(width: (kScreen_width - 28) / 2, height: 52 * width_height_ratio))
        }
        adImageView.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(13)
            make.top.equalTo(adImageView1.snp.bottom).offset(6)
            make.size.equalTo(CGSize(width: 20, height: 10))
        }
    }
    
    func didSelectedImageView1(tap: UITapGestureRecognizer) {
        delegate?.adTableViewDidSeletedImageView1()
    }
    func didSelectedImageView2(tap: UITapGestureRecognizer) {
        delegate?.adTableViewDidSeletedImageView2()
    }
    
    // MARK: - setter and getter
    lazy var adImageView1: UIImageView = {
        let adImageView1 = UIImageView()
        adImageView1.backgroundColor = UIColor.vcBgColor
        adImageView1.contentMode = .scaleAspectFill
        adImageView1.isUserInteractionEnabled = true
        adImageView1.image = UIImage(named: "home_guanggao_img01")
        adImageView1.layer.masksToBounds = true
        adImageView1.layer.cornerRadius = 4.0
        return adImageView1
    }()
    lazy var adImageView2: UIImageView = {
        let adImageView2 = UIImageView()
        adImageView2.backgroundColor = UIColor.vcBgColor
        adImageView2.contentMode = .scaleAspectFill
        adImageView2.isUserInteractionEnabled = true
        adImageView2.image = UIImage(named: "home_guanggao_img01")
        adImageView2.layer.masksToBounds = true
        adImageView2.layer.cornerRadius = 4.0
        return adImageView2
    }()
    lazy var adImageView: UIImageView = {
        let adImageView = UIImageView()
        adImageView.image = UIImage(named: "common_ad_icon_normal_iPhone")
        return adImageView
    }()
}
