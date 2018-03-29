//
//  RoomCommentFrameModel.swift
//  WYP
//
//  Created by ShuYan Feng on 2017/5/25.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

class RoomCommentFrameModel: NSObject {

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
    
    // 回复数的frame
    var replyCountF: CGRect?
    
    // 回复按钮的frame
    var replyButtonF: CGRect?
    
    // 单元格的高度
    var cellHeight: CGFloat?
    
    // 数据模型
    var comment: CommentModel! {
        willSet {
            headImgUrlF = CGRect(x: 13, y: 17.5, width: 40, height: 40)
            
            nickNameF = CGRect(x: (headImgUrlF?.maxX)! + 14, y: 29, width: 150, height: 11)
            
            starCountF = CGRect(x: kScreen_width - 65, y: 24, width: 65, height: 15)
            
            // 计算content的Frame
            let contentSize = String().stringSize(text: (newValue.content)!, font: UIFont.systemFont(ofSize: 14), maxSize: CGSize(width: kScreen_width - 40 - 32 - 25, height: 500))
            
            contentF = CGRect(x: (headImgUrlF?.maxX)! + 15, y: (nickNameF?.maxY)! + 10, width: contentSize.width, height: contentSize.height)
            
            timeF = CGRect(x: (contentF?.minX)!, y: (contentF?.maxY)! + 10, width: 65, height: 10.5)
            
            replyCountF = CGRect(x: kScreen_width - 100, y: (contentF?.maxY)! + 10, width: 80, height: 10.5)
            
//            replyButtonF = CGRect(x: kScreen_width - 45, y: (contentF?.maxY)! + 10, width: 30, height: 10.5)
            replyButtonF = CGRect.zero
            
            cellHeight = (timeF?.maxY)! + 20
        }
    }
    
    override init() {
        super.init()
    }
}
