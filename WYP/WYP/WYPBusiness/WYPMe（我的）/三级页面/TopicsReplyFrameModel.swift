//
//  TopicsReplyFrameModel.swift
//  InfoView
//
//  Created by ShuYan Feng on 2017/3/23.
//  Copyright © 2017年 ShuYan Feng. All rights reserved.
//

import UIKit

class TopicsReplyFrameModel: NSObject {
    // 头像的frame
    var headImgUrlF: CGRect?
    
    // 昵称的frame
    var nickNameF: CGRect?
    
    // 点赞数
    var starCountF: CGRect?
    
    // 内容的frame
    var contentF: CGRect?
    
    // 时间的frame
    var timeF: CGRect?
    
    // 单元格的高度
    var cellHeight: CGFloat?
    
    // 数据模型
    var topics: CommentModel! {
        willSet {
            headImgUrlF = CGRect(x: 34.5, y: 17.5, width: 40, height: 40)
            
            nickNameF = CGRect(x: (headImgUrlF?.maxX)! + 14, y: 29, width: 100, height: 11)
            
            starCountF = CGRect(x: kScreen_width - 65, y: 17.5, width: 65, height: 15)
            
            // 计算content的Frame
            let contentSize = String().stringSize(text: (newValue.content)!, font: UIFont.systemFont(ofSize: 14), maxSize: CGSize(width: kScreen_width - 40 - 32 - 25, height: 500))
            
            contentF = CGRect(x: (headImgUrlF?.maxX)! + 15, y: (nickNameF?.maxY)! + 10, width: contentSize.width, height: contentSize.height)
            
            timeF = CGRect(x: (contentF?.minX)!, y: (contentF?.maxY)! + 10, width: 65, height: 10.5)
            
            cellHeight = (timeF?.maxY)! + 20
        }
    }
    
    override init() {
        super.init()
    }
}
