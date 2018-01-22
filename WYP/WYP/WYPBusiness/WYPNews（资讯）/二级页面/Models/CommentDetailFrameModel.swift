//
//  RoomCommentFrameModel.swift
//  WYP
//
//  Created by ShuYan Feng on 2017/5/25.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

class CommentDetailFrameModel: NSObject {

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
            
            nickNameF = CGRect(x: (headImgUrlF?.maxX)! + 14, y: 17, width: 100, height: 11)
            
            starCountF = CGRect(x: kScreen_width - 65, y: 24, width: 65, height: 15)
            
            // 计算content的Frame
            let contentSize = String().stringSize(text: (newValue.content)!, font: UIFont.systemFont(ofSize: 14), maxSize: CGSize(width: kScreen_width - 40 - 32 - 25, height: 500))
            
            contentF = CGRect(x: (headImgUrlF?.maxX)! + 15, y: (nickNameF?.maxY)! + 14, width: contentSize.width, height: contentSize.height)
            
            let timeStr = Int(newValue!.createTime!)?.getTimeString()
            let labelW = getLabWidth(labelStr: timeStr!, font: UIFont.systemFont(ofSize: 12), height: 10.5)
            
            
            timeF = CGRect(x: (contentF?.minX)!, y: (contentF?.maxY)! + 14, width: labelW, height: 10.5)
            
            
            replyCountF = CGRect(x: (timeF?.maxX)! + 15, y: (contentF?.maxY)! + 9, width: 50, height: 20)
            
            replyButtonF = CGRect(x: kScreen_width - 65, y: (contentF?.maxY)! + 9, width: 65, height: 20)
            
            cellHeight = (timeF?.maxY)! + 20
        }
    }
    
    override init() {
        super.init()
    }
    
    func getLabWidth(labelStr:String,font:UIFont,height:CGFloat) -> CGFloat {
        
        let statusLabelText: String = labelStr
        
        let size = CGSize(width: 900, height: height)
        
        let dic = NSDictionary(object: font, forKey: NSFontAttributeName as NSCopying)
        
        let strSize = statusLabelText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic as? [String : AnyObject], context: nil).size
        
        return strSize.width
        
    }
}
