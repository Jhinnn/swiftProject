//
//  TopicsFrameModel.swift
//  WYP
//
//  Created by 你个LB on 2017/3/20.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

class TopicsFrameModel: NSObject {
    
    // 头像的frame
    var headImgUrlF: CGRect?
    
    // 昵称的frame
    var nickNameF: CGRect?
    
    // 内容的frame
    var contentF: CGRect?
    
    // 类型的frame
    var typeF: CGRect?
    
    // 时间的frame
    var timeF: CGRect?
    
    // 观看数
    var seeCountF: CGRect?
    
    // 回复数
    var commentCountF: CGRect?
    
    // 点赞数
    var starCountF: CGRect?
    
    // 单元格的高度
    var cellHeight: CGFloat?
    
    // 数据模型
    var topics: TopicsModel! {
        willSet {
            headImgUrlF = CGRect(x: 20, y: 10, width: 40, height: 40)
            
            nickNameF = CGRect(x: (headImgUrlF?.maxX)! + 18, y: 10, width: 100, height: 20)
            
            starCountF = CGRect(x: kScreen_width - 65, y: 10, width: 65, height: 30)
            
            // 计算content的Frame
            let contentSize = String().stringSize(text: (newValue.content)!, font: UIFont.systemFont(ofSize: 14), maxSize: CGSize(width: kScreen_width - 45 - 20 - 10 - 20, height: 500))
            
            contentF = CGRect(x: (headImgUrlF?.maxX)! + 18, y: (nickNameF?.maxY)! + 10, width: contentSize.width, height: contentSize.height)
            
            typeF = CGRect(x: (contentF?.minX)!, y: (contentF?.maxY)! + 10, width: 38, height: 10.5)
            
            timeF = CGRect(x: (typeF?.maxX)! + 20, y: (typeF?.minY)!, width: 100, height: 10.5)
            
            seeCountF = CGRect(x: kScreen_width - 60, y: (typeF?.minY)!, width: 60, height: 10.5)
            
            commentCountF = CGRect(x: (seeCountF?.minX)! - 60 - 15, y: (typeF?.minY)!, width: 70, height: 10.5)
            
            
            cellHeight = (typeF?.maxY)! + 20
        }
    }
    
    override init() {
        super.init()
    }
}
