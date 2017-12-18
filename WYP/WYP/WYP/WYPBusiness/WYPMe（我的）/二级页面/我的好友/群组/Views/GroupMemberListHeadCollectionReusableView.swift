//
//  GroupMemberListHeadCollectionReusableView.swift
//  WYP
//
//  Created by 曾雪峰 on 2017/12/15.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

class GroupMemberListHeadCollectionReusableView: UICollectionReusableView {
    
      weak var delegate: GroupsMemberListCollectionDelegate?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        viewConfig()
        layoutPageSubviews()
    }
    
    // MARK: - private method
    func viewConfig() {
        
      
        
        self.addSubview(HeaderView)
        self.addSubview(headerImgView)
        self.addSubview(groupNumb)
        self.addSubview(codeImgView)
        self.addSubview(grayLine)
        
    
    }
    lazy var grayLine: UIView = {
        let grayLine = UIView()
        grayLine.backgroundColor = UIColor.vcBgColor
        return grayLine
    }()
    
    lazy var HeaderView: UIImageView = {
        let HeaderView = UIImageView(frame: CGRect(x: 0, y: 0, width: kScreen_width, height: 140))
        HeaderView.backgroundColor = UIColor.yellow
        HeaderView.image = UIImage(named: "grzy_porfile_bg")

        return HeaderView
    }()

    
    lazy var headerImgView: UIImageView = {
        let headerImgView = UIImageView()
        headerImgView.layer.cornerRadius = 37.5
        headerImgView.layer.masksToBounds = true
        headerImgView.backgroundColor = UIColor.init(hexColor: "a1a1a1")

        return headerImgView
    }()
    lazy var groupNumb: UILabel = {
        let groupNumb = UILabel()
        groupNumb.textColor = UIColor.black
        groupNumb.font = UIFont.systemFont(ofSize: 15)
        groupNumb.sizeToFit()
        groupNumb.text = "群编号:10000000"

        return groupNumb
    }()


    lazy var codeImgView: UIImageView = {
        let codeImgView = UIImageView()
        codeImgView.sizeToFit()
        codeImgView.image = UIImage(named: "datum_icon_dimension_normal")

        return codeImgView
    }()
    
    
    
    
    func layoutPageSubviews() {
        
        headerImgView.snp.makeConstraints { (make) in
            
            make.centerY.equalTo(HeaderView.snp.bottom)
            make.centerX.equalTo(HeaderView.snp.centerX)
            make.size.equalTo(75)
        }
        
        groupNumb.snp.makeConstraints { (make) in
            make.top.equalTo(headerImgView.snp.bottom).offset(10)
            make.centerX.equalTo(HeaderView.snp.centerX)
            
        }
        

        codeImgView.snp.makeConstraints { (make) in
            make.top.equalTo(HeaderView.snp.bottom).offset(10)
            make.right.equalTo(HeaderView.snp.right).offset(-10)
            
        }
        grayLine.snp.makeConstraints { (make) in
            make.top.equalTo(groupNumb.snp.bottom).offset(20)
            make.right.left.equalTo(self)
            make.height.equalTo(10)
        }
        
        
    }
    
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
}
