//
//  CompanyCertificationFrameModel.swift
//  WYP
//
//  Created by ShuYan Feng on 2017/4/18.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

class CompanyCertificationFrameModel: NSObject {

    // 名称的frame
    var titleFrame: CGRect?
    // 内容的frame
    var contentFrame: CGRect?
    // 单元格的高度
    var cellHeight: CGFloat?
    
    var companyModel: CompanyCertificationModel! {
        willSet {
            let titleSize = String().stringSize(text: (newValue.title)!, font: UIFont.systemFont(ofSize: 13), maxSize: CGSize(width: kScreen_width, height: 13))
            titleFrame = CGRect(x: 13, y: 10.5, width: titleSize.width, height: titleSize.height)
            
            let contentSize = String().stringSize(text: (newValue.content)!, font: UIFont.systemFont(ofSize: 13), maxSize: CGSize(width: kScreen_width - titleFrame!.maxX - 26, height: 200))
            contentFrame = CGRect(x: 13 + titleFrame!.maxX, y: 10.5, width: contentSize.width, height: contentSize.height)
            
            cellHeight = (contentFrame?.maxY)! + 13.5
        }
    }
    
    override init() {
        super.init()
    }

}
